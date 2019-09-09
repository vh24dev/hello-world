// Note: in the future this functionality might be replaced by
// a call to the standard salesforce REST API.
@RestResource(urlMapping='/docgen/soql')
global without sharing class DGen_QueryService {
    @HttpGet
    global static void query() {
        Logger.debug('> DGen_QueryService :: query');
        
        if (RestContext.request.params.get('cs') != DGen_APISettings.SF_WEBHOOK_API_TOKEN) {
            Logger.debug('DGen_QueryService :: query :: invalid or no api token: ' + RestContext.request.params.get('cs'));
            RESTHelper.SetStatus(403);
            return;
        }
        
        String soqlQuery = RestContext.request.params.get('q');
        Logger.debug('DGen_QueryService :: query :: got q: ' + soqlQuery);
        
        processQuery(soqlQuery);
    }
    
    private static void error(String m) {
        Logger.debug(m);
        RESTHelper.RenderError(m);
        RESTHelper.SetStatus(400);
    }

    private static void processQuery(String qstr) {
        if (String.isBlank(qstr)) {
            error('DGen_QueryService :: query :: empty query');
            return;
        }
         
        SOQLQuery q = parseQuery(qstr);
        String[] ids = new String[]{};
        for (ID id: q.ids) {
            ids.add(String.valueOf(id));
        }
        String vq = String.format('SELECT {0} FROM {1} WHERE ID IN ({2})', new String[]{
                String.join(new List<String>(q.fields), ','),
                String.valueOf(q.sObjectType),
                '\'' + String.join(ids, '\',\'') + '\''
        });
        Logger.debug('DGen_QueryService :: query :: executing valid query: ' + vq);
        
        SObject[] res;
        try {
            res = Database.query(vq);
        } catch (System.QueryException qe) {
            error('DGen_QueryService :: query :: failed to execute query: ' + qe.getMessage());
            return;
        }
        
        // To make our lifes easier on the server side
        QueryResult qr = new QueryResult();
        qr.sObjectType = q.sObjectType;
        qr.records = new QueryRecord[]{};
        for (SObject o: res) {
            QueryRecord qrc = new QueryRecord();
            qrc.ID = o.ID;
            qrc.fieldValues = new Map<String, String>{};
            // Don't want all the fields from the object, only the ones requested and existing.
            for (String fld: q.fields) {
                Object v = o.get(fld);
                if (v != null) {
                    qrc.fieldValues.put(fld, String.valueOf(v));
                }
            }
            
            qr.records.add(qrc);
        }

        Logger.debug('DGen_QueryService :: query :: qr: ' + qr);

        RESTHelper.RenderJSON(qr);        
        RESTHelper.SetStatus(200);
    }
    
    private class SOQLQuery {
        Set<String> fields;
        String sObjectType;
        Set<ID> ids;
    }
    private static SOQLQuery parseQuery(String q) {
        // Skip the columns/fields which do not exist, instead of failing the whole query.
        // There has to be at least one valid ID in the WHERE clause.
        
        // Regex returns stack overflow for longer queries, even when breaking it down into parts.
        // For that reason we grab the columns/fields manually.
        //Pattern p = Pattern.compile('(?i)SELECT ((\\w|[, ]*)+) FROM (\\w+) WHERE ID IN \\(((\'\\w*\'[, ]*)+)\\)');

        String[] qParts = q.split('FROM');
        if (qParts.size() != 2) {
            error('DGen_QueryService :: query :: invalid format, got: ' + q);
            return null;
        }

        // Parse query fields        
        String selectStr = qParts[0].trim();
        System.debug('selectStr: ' + selectStr);        
        //Pattern selectP = Pattern.compile('(?i)SELECT ((\\w|[, ]*)+)');
        //Matcher selectM = selectP.matcher(selectStr);
        
        String[] qSelectParts = selectStr.split('SELECT');
        if (qSelectParts.size() != 2) {
            error('DGen_QueryService :: query :: invalid format, got: ' + q);
            return null;
        }
        String fieldStrs = qSelectParts[1].trim();
        String[] qFlds = fieldStrs.split(',');
        
        // Parse object type and ids
        String objIDsStr = qParts[1].trim();
        System.debug('objIDsStr: ' + objIDsStr);
        Pattern objIDsP = Pattern.compile('(?i)(\\w+) WHERE ID IN \\(((\'\\w*\'[, ]*)+)\\)');
        Matcher objIDsM = objIDsP.matcher(objIDsStr);
        if (!objIDsM.matches()) {
            error('DGen_QueryService :: query :: invalid format, got: ' + q);
            return null;
        }
        
        SOQLQuery res = new SOQLQuery();
        
        // Check if object type is valid
        String objTypeStr = objIDsM.group(1);
        System.debug('objTypeStr: ' + objTypeStr);
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objTypeStr);
        //Logger.debug('DGen_QueryService :: query :: queried fields: ' + qFlds + ' objectType: ' + String.valueOf(objType));

        if (objType == null) {
            error('DGen_QueryService :: query :: invalid objectype, got: ' + objTypeStr);
            return null;
        }
        res.sObjectType = objTypeStr;
        
        // Get all available fields for object type
        SObjectField[] objFlds = objType.getDescribe().fields.getMap().values();
        Set<String> availableFlds = new Set<String>();
        for (SObjectField o: objFlds) {
            availableFlds.add(String.valueOf(o));
        }
 
        // Filter out any queried fields which do not exist as available fields
        Set<String> validFlds = new Set<String>();
        for (String qf: qFlds) {
            qf = qf.trim();
            if (!availableFlds.contains(qf)) {
                Logger.debug('DGen_QueryService :: query :: queried field does not exist: ' + qf);
                continue;
            }
            
            validFlds.add(qf);
        }
        if (validFlds.size() == 0) {
            error('DGen_QueryService :: query :: no valid fields queried');
            return null;
        }
        validFlds.add('ID'); // ID is needed later on
        res.fields = validFlds;
        
        // Get filter IDs
        String idsStr = objIDsM.group(2);
        System.debug('idsStr: ' + idsStr);
        if (String.isBlank(idsStr)) {
            error('DGen_QueryService :: query :: at least on ID is mandatory in the WHERE condition');
            return null;
        }
        String[] idStrs = idsStr.split(',');
        if (idStrs.size() == 0) {
            error('DGen_QueryService :: query :: at least on ID is mandatory in the WHERE condition');
            return null;
        }
        
        // Check if IDs are valid
        res.ids = new Set<ID>{};
        for (String idStr: idStrs) {
            String s = idStr.remove('\'');
            ID id = ID.valueOf(s);
            if (id == null) {
                error('DGen_QueryService :: query :: invalid ID ' + s);
                return null;
            }
            res.ids.add(id);
        }
        
        return res;
    }

    private class QueryResult {
        String sObjectType;
        QueryRecord[] records;
    }
    
    private class QueryRecord {
        String ID;
        Map<String, String> fieldValues;
    }
}