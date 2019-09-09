// wip: refactoring in progress
public class DGen_API /*implements LT_LeaseWebService*/ {
    public class ReadOnlyOrgException extends Exception {}
    public class GenerationFailedException extends Exception {
        public DGen_APIWebServiceError webServiceError;
    }
    
    public String requestDocGen(DGen_Request r) {
        System.debug('>> DGen_API :: requestDocGen :: DGen_Request: ' + r);
        return request('POST', '/gen', r);
    }
 
    private String request(String verb, String path, DGen_Request r) {
        // Fail if org is in Read-only mode
        if (System.getApplicationReadWriteMode() == ApplicationReadWriteMode.READ_ONLY) {
            // Prevent the callout
            throw new ReadOnlyOrgException('Read-only mode. Skipping callouts.');
        }
        
        HttpRequest req = buildRequest(verb, path, r);
        
        System.debug('Requesting ' + req.getEndpoint() + ' :: DGen_Request: ' + r);
        System.debug('Request ' + req);
        
        HttpResponse res;
        try {
            Http h = new Http();
            res = h.send(req);
        } catch (System.CalloutException ex) {
            System.debug('Doc generation Web Service failed due to CalloutException for endpoint ' + req.getEndpoint() + '. Exception: ' + ex);
            // todo: find a robust way to figure out if this is a timeout or something else e.g. "Uncommitted work(...)"
            // Salesforce code sample looks for a specific String..
            throw exceptionFromError(null, 0, true);
        }
                
        // Fail if status code is not success
        if (res.getStatusCode() != 200) {
            System.debug('Doc generation Web Service  failed to process lease on endpoint ' + req.getEndpoint() + '. Status code: ' + res.getStatusCode() + ' ' + res.getStatus() + '. ' + res.getBody());
            DGen_APIWebServiceError cwse = parseError(res.getBody());
            throw exceptionFromError(cwse, res.getStatusCode(), false);
        }
        
        String ret = res.getBody();
        System.debug('Got json response:' + ret);
        return ret;
    }

    private HttpRequest buildRequest(String verb, String path, DGen_Request r) {
        // todo: deal with invalid settings and/or parameters
        HttpRequest req = new HttpRequest();
        req.setEndpoint(baseURL() + path);
        req.setMethod(verb);
        req.setTimeout(35000);
        req.setHeader('Content-Type', 'application/json');
        addBasicAuthHeader(req);
        if (r != null) {
            String json = JSON.serialize(r);
            System.debug('got serialized json: ' + json);
            req.setBody(json);
        }

        return req;
    }
    
    private void addBasicAuthHeader(HttpRequest req) {
        BasicAuthHeader bAuthH = basicAuthHeader();
        if (bAuthH != null && !String.isBlank(bAuthH.key)) {                        
            req.setHeader(bAuthH.key, bAuthH.value);
        }
    }
    
    private BasicAuthHeader basicAuthHeader() {
        String username = DGen_APISettings.API_USERNAME != null ? DGen_APISettings.API_USERNAME : '';
        String password = DGen_APISettings.API_PWD != null ? DGen_APISettings.API_PWD : '';        
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(username + ':' + password));
                
        return new BasicAuthHeader('Authorization', authorizationHeader);
    }

    // Fetched from Custom Metadata Types
    private String baseURL() {
        return DGen_APISettings.API_BASE_URL;
        
        // todo: have dev, staging, and prod settings
        
        /*Calculation_Web_Service_Settings__mdt wsSettings = [
            SELECT  Dev_Base_URL__c,
                    Staging_Base_URL__c,
                    Production_Base_URL__c,
                    Environment__c
            FROM Calculation_Web_Service_Settings__mdt
        ];
        
        // todo: use a switch on API v.43        
        if (wsSettings.environment__c == 'Dev') {
            System.debug('Dev');
            return wsSettings.dev_Base_URL__c;
        }
        
        if (wsSettings.environment__c == 'Staging') {
            System.debug('Staging');
            return wsSettings.staging_Base_URL__c;
        }
        
        if (wsSettings.environment__c == 'Production') {
            System.debug('Prod');
            return wsSettings.production_Base_URL__c;
        }
                
        System.debug('Else - using prod');
        return wsSettings.production_Base_URL__c;  */              
    }
    
    private DGen_APIWebServiceError parseError(String jsonString) {                
        DGen_APIWebServiceError wse;
        try {
            wse = (DGen_APIWebServiceError)JSON.deserialize(jsonString, DGen_APIWebServiceError.class);
        } catch (System.JSONException e){
            String errorMsg = 'Failed to parse ApiError. Error: ' + e.getMessage();
            System.debug(errorMsg);
            return null;
        }

        return wse;
    }
    
    private GenerationFailedException exceptionFromError(DGen_APIWebServiceError e, Integer statusCode, Boolean isTimeout) {
        if (statusCode == 404 || statusCode == 502 || isTimeout) {
            GenerationFailedException ex = new GenerationFailedException('There was a problem communicating with the Doc generation Web Service. StatusCode: ' + statusCode);
            ex.webServiceError = e;
            return ex;
        }
        
        if (e == null) {
            return new GenerationFailedException('Doc generation Web Service failed to calculate lease. Unknown error.');
        }

        GenerationFailedException ex = new GenerationFailedException(e.userFriendlyMessage());
        ex.webServiceError = e;
        return ex;
    }
    
    public class BasicAuthHeader {
        String key {get; private set;}
        String value {get; private set;}
        
        public BasicAuthHeader(String key, String value) {
            this.key = key;
            this.value = value; 
        }
    }
}