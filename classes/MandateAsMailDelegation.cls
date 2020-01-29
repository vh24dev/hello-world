global class MandateAsMailDelegation implements iVH24MailDelegation {
    // attachment 
    private String xlsString = 'empty';
    Opportunity opp;
    String currentGroupHeadline= 'not set';
    String mailAddress;
    String mailId;
    String objectId;
    
    // eMailTemplate
    private EMailMapping__mdt eMailMapping;
    private Map<String,String> mergeMappings;
    private String bn;
    private EmailTemplate template;
    private Id templateId;
    private string body;
    private string htmlBody;

    
    public MandateAsMailDelegation(VH24MailData data) {
        this.mailId = data.mailId;
        mailAddress = data.recipientAddress;
      	this.objectId = data.objectId;
        xlsString = 'Daten \n';
    }
    
    public MandateAsMailDelegation(String objectId, String address, String mailId) {
        this.mailId = mailId;
        mailAddress = address;
      	this.objectId = objectId;
        xlsString = 'Daten \n';
    }
    
    public void prepareMail() {
        try {
            // attachment
            List<Mandate_Mail_Object_Field_Mappings__mdt> fields = fetchObjectFields('Opportunity');
            string query =  buildQuery(objectId, fields, 'Opportunity', 'Id');
            List <sObject> genericObjects = executeQuery(query);
            this.opp = (Opportunity) genericObjects[0];
            xlsString = initParsingLoop(genericObjects, fields, xlsString);
            // template
            this.eMailMapping = fetchConfig(this.opp);
            this.template = fetchTemplate();
            buildBody();
            buildHtmlBody();
            prepareMergeMappings();
            mergeFields();
        }catch (Exception e){
        	processError(e.getMessage());
        }
    }
 
    // mail delegation
    public string getSubject() {
        return 'Mandatübergabe ' + opp.Number__c;
    }
        
    public EMailTemplate getMailTemplate() {
        return null;
    }
    
    public Id getSenderId() {
    	OrgWideEmailAddress orgWideEmailAddresses = [select Id, 
                                                     Address 
                                                     from OrgWideEmailAddress 
                                                     Where Address = 'lebensversicherung@verbraucherhilfe24.de' LIMIT 1];
        return (Id)orgWideEmailAddresses.Id;
    }
    
    public list<string> getAddresses(){
       	return new list<string> {mailAddress};
            
    }
    
    public string getPlainTextBody() {
        return this.body; 
    }
    
    public Messaging.EmailFileAttachment[] getAttachments() {
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
		blob csvBlob = Blob.valueOf(this.xlsString);
		string csvname= getTitleForCSV();
		csvAttc.setFileName(csvname);
		csvAttc.setBody(csvBlob);
        Messaging.EmailFileAttachment[] attachments = new List<Messaging.EmailFileAttachment>();
        attachments.add(csvAttc);
        return attachments;
    } 
    
    @TestVisible
    private String getTitleForCSV(){
		return 'Mandat ' + opp.Number__c + '.csv';       
    }
    
    public string getHtmlBody() {
        return this.htmlBody;
    }
        
    public boolean isEnabled() {
        return true;
    }
    
    public void processResult(Messaging.SendEmailResult [] r){
        String message = null;
    	if(r[0].success) {
            Opportunity oppUpdate = [Select Mandat_versandt_am__c FROM Opportunity Where Id =: opp.Id];
			oppUpdate.Mandat_versandt_am__c = Datetime.now();
            update oppUpdate;
            message = ' Successfully sent Mail for ' + opp.Number__c + ' to ' + mailAddress;
          	publishResultEvent(message, true);
        } else {
            message = ' Fehler bei Mailversand für ' + opp.Number__c + ' an Adresse ' + mailAddress + '.' +
                'Bitte prüfen Sie Ihre Eingaben. Folgende Fehlermeldung wurde erzeugt: ' + r[0].getErrors();
      		publishResultEvent(message, false);
        }
    }
    
    public void processError(String message){
        publishResultEvent(message,false);      
    }
    
    private void publishResultEvent( String message, boolean isSuccess) {
    	SendMailResult__e mailResult = new SendMailResult__e(
			Mail_Event_Type__c = 'MandateAsMail',
         	Result_Message__c = message,
            Mail_id__c = this.mailId,
            isSuccess__c = isSuccess
		);
        Database.SaveResult result = EventBus.publish(mailResult);
        system.debug('----publish result-----' + result.isSuccess());
    }

    // parsing to csv string
    @TestVisible
    private string initParsingLoop(List<sObject> genericObjects, 
                                   List<Mandate_Mail_Object_Field_Mappings__mdt> fields, 
                                   String xlsString) {
		for(sObject obj: genericObjects) {
        	xlsString = objectValuesToMap(obj, fields,xlsString );     
        } 
    	return xlsString;
    }
       
    @TestVisible
    private List<Mandate_Mail_Object_Field_Mappings__mdt> fetchObjectFields(String rootObject){
       List<Mandate_Mail_Object_Field_Mappings__mdt> fields;
       fields = [Select Grouping_Inner_Order__c, 
                 Grouping__c, 
                 Query_String__c, 
                 One_Object__c, 
                 Many_Object__c, 
                 IsOneObject__c, 
                 IsManyObject__c, 
                 IsField__c, Field__c, 
                 Identifier_Key__c, 
                 IsFilter__c,
                 Label
               	FROM Mandate_Mail_Object_Field_Mappings__mdt
               	WHERE Root_Object__c =: rootObject];
  	   fields = sortFields(fields); 
       return fields;
    }
            
    @TestVisible
    private List<sObject> executeQuery(String query) {
        try{
        	return Database.query(query);
        } catch(Exception e) {
            System.debug('SOQL Query resulted in Error: ' +e.getMessage());
            return null;    
        }
    }    
    
    @TestVisible
    private string buildQuery(String oppId, 
                              List<Mandate_Mail_Object_Field_Mappings__mdt> fields, 
                              String objectToQuery, 
                              String identifierKey) { 
        String queryString = 'Select ';
    	for(Mandate_Mail_Object_Field_Mappings__mdt field : fields) {
			if(field.IsOneObject__c || field.IsField__c ) {
        		queryString = queryString + field.Query_String__c + ', ';
			} 
        }
        queryString = queryString.removeEnd(', ');                                 
        queryString = queryString +' FROM ' + objectToQuery + ' WHERE ' + identifierKey + ' = \'' + oppId + '\''; 
        return queryString;          
    }
    
    @TestVisible
    private string objectValuesToMap(sObject rootObj,
                                            List<Mandate_Mail_Object_Field_Mappings__mdt> fields,
                                            String myXlsString) {
        for(Mandate_Mail_Object_Field_Mappings__mdt field: fields) {
            myXlsString =  checkAndSetGroupHeadline(field,myXlsString);
            String label = field.Label;
            if(field.IsOneObject__c) {
                myXlsString += (label + ' ; ' + getValueFromOneObject(rootObj,field)  + ' \n' ); // + ' \n'
            } else if(field.IsManyObject__c) {
                myXlsString = getValuesFromManyObjects(label,field.Many_Object__c, field.Identifier_Key__c, rootObj, myXlsString);
            } else {
                myXlsString = myXlsString + label + ' ; ' + getValueFromField(rootObj,field)  + ' \n'; // + ' \n'
         
            }
        }
        return myXlsString;
    }
    
    private String checkAndSetGroupHeadline(Mandate_Mail_Object_Field_Mappings__mdt field, string xlsString) {
        if(currentGroupHeadline.equals(field.Grouping__c)) {
        	return xlsString;
        } else {
           currentGroupHeadline = field.Grouping__c;
           xlsString = xlsString + '\n' + field.Grouping__c + '\n'; 
           return xlsString; 
        }
    }
    
    @TestVisible
    private string getValueFromField(sObject opp,
                                     Mandate_Mail_Object_Field_Mappings__mdt field) {
        try {
           String returnfield = fieldFromConcreteObject(opp, field.Field__c);
           return returnfield;
        } catch(Exception e) {
           return 'Fehler'; 
        }
    }
    
    @TestVisible
    private string getValueFromOneObject(sObject rootObject,
                                         Mandate_Mail_Object_Field_Mappings__mdt field) {
        try {
           String related = relatedFromConcreteObject(rootObject,field.One_Object__c,field.Field__c);
           System.debug('------------ return related ----- : ' + related);
           return related;
        } catch(Exception e) {
           System.debug('------------ error in getValueFromField : ' + e);
           return 'error'; 
        }
    }
    
    @TestVisible
    private String getValuesFromManyObjects(String label, 
                                            String objectToQuery,
                                            String identifierKey, 
                                            sObject rootObject, 
                                            String xlsString){
      	List<Mandate_Mail_Object_Field_Mappings__mdt> fields = fetchObjectFields(objectToQuery);
        string query =  buildQuery(rootObject.Id, fields, objectToQuery, identifierKey );
        List <sObject> retrievedObjects = executeQuery(query);
        List <sObject> filteredObjects = filterObjects(retrievedObjects,fields);                                       
        for(sObject obj: filteredObjects) {
        	xlsString = objectValuesToMap(obj,fields, xlsString);
        }
        return xlsString;
    } 
    
    @TestVisible
    private List <sObject> filterObjects(List <sObject> retrievedObjects, List<Mandate_Mail_Object_Field_Mappings__mdt> fields ) {
        List <sObject> filteredObjects = new List <sObject>();
        Mandate_Mail_Object_Field_Mappings__mdt fieldForFiltering = retrieveFilterfield(fields);
        if(fieldForFiltering == null) {
        	return retrievedObjects;    
        }
        for (sObject objectToCheck: retrievedObjects) {
            String BooleanAsString = getValueFromField(objectToCheck,fieldForFiltering);
            if(BooleanAsString.equals('true')) {
                filteredObjects.add(objectToCheck);
            }
        } 
        return filteredObjects;
    } 
    
    private Mandate_Mail_Object_Field_Mappings__mdt retrieveFilterfield(
        List<Mandate_Mail_Object_Field_Mappings__mdt> fields ) {
    	Mandate_Mail_Object_Field_Mappings__mdt fieldForFiltering = null;
            for(Mandate_Mail_Object_Field_Mappings__mdt field: fields) {
                if (field.isFilter__c) {
                    fieldForFiltering = field;
                } 
            }
        return  fieldForFiltering; 
    } 
    
    @TestVisible
    private String  fieldFromConcreteObject(sObject genericObject, String fieldName){
        if(genericObject instanceOf Opportunity) {
			Opportunity opp = (Opportunity) genericObject;
            return castObjectToString(
            		opp.get(fieldName)
            		);    
        } else if(genericObject instanceOf Document__c){
        	Document__c doc  = (Document__c) genericObject;
            return castObjectToString(
            		doc.get(fieldName)
            		);    
        } else {
            return 'concrete Object not registered';
        }
    }
    
    @TestVisible
    private String relatedFromConcreteObject(sObject genericObject,
                                             String relatedObject, 
                                             String fieldName){
        if(genericObject instanceOf Opportunity) {
			Opportunity opp = (Opportunity) genericObject;
            return castObjectToString(
            		opp.getSobject(relatedObject).get(fieldName)
            		);
        } else if(genericObject instanceOf Document__c){
        	Document__c doc  = (Document__c) genericObject;
			return castObjectToString(
            		doc.getSobject(relatedObject).get(fieldName)
            		);          	
        } else {
            return 'concrete Object not registered';
        }
    }
    
    @TestVisible
    private String castObjectToString(Object objToString){
           if(objToString == null) {
            return 'not set';
        }else if(objToString instanceOf Date) {
        	return String.valueOf(objToString);
        } else {
            return objToString + '';
        }
    }
    
    @TestVisible
    private String MapToXlsString (Map<String,Object> labelValues) {
        string header = 'Label; Value \n';
		string finalstr = header;	
		for(String label: labelValues.keySet()) {
			string entryString = label + '; ' + labelValues.get(label) + ' \n';
			finalstr = finalstr + entryString;
		}
        return '';
    }
    
    // sorting
    private static List<Mandate_Mail_Object_Field_Mappings__mdt> sortFields(
    	List<Mandate_Mail_Object_Field_Mappings__mdt> fields
    ){
		List <Mappings_Wrapper> wrappers = new List <Mappings_Wrapper>();
		for (Mandate_Mail_Object_Field_Mappings__mdt field : fields) { 
			Mappings_Wrapper wrapper = new Mappings_Wrapper(field);
            wrappers.add(wrapper);
		}
        wrappers.sort();
        List <Mandate_Mail_Object_Field_Mappings__mdt> sortedFields = 
            new List <Mandate_Mail_Object_Field_Mappings__mdt>();
        for (Mappings_Wrapper wrapper : wrappers) { 
            sortedFields.add(wrapper.mappings);
		}
        
        List <Inner_Sorter> innerSorters = new List <Inner_Sorter>();  
        for (Mandate_Mail_Object_Field_Mappings__mdt field  : sortedFields) { 
            Inner_Sorter sorter = new Inner_Sorter(field);
            innerSorters.add(sorter);
		}
		innerSorters.sort();
        sortedFields = 
            new List <Mandate_Mail_Object_Field_Mappings__mdt>();
        for (Inner_Sorter sorter : innerSorters) { 
            sortedFields.add(sorter.field);
		}
        
      	return sortedFields;
    } 
    
    global class Mappings_Wrapper implements Comparable {
		public Mandate_Mail_Object_Field_Mappings__mdt mappings;
    	public Mappings_Wrapper(Mandate_Mail_Object_Field_Mappings__mdt mapp) {
        	mappings = mapp;
    	}
    	global Integer compareTo(Object compareTo) {
            Mappings_Wrapper compareToMapping = (Mappings_Wrapper)compareTo;
            return mappings.Grouping__c.compareTo(compareToMapping.mappings.Grouping__c);
            /*
        	Mappings_Wrapper compareToMapping = (Mappings_Wrapper)compareTo;
          	Integer returnValue = 0;
        	if (!mappings.IsManyObject__c && compareToMapping.mappings.IsManyObject__c) {
            	returnValue = -1;
        	} else if (mappings.IsManyObject__c && !compareToMapping.mappings.IsManyObject__c) {
            	returnValue = 1;
        	}
        	return returnValue;
			*/
    	}
	}
    
    global class Inner_Sorter implements Comparable {
		public Mandate_Mail_Object_Field_Mappings__mdt field;    
        public Inner_Sorter(Mandate_Mail_Object_Field_Mappings__mdt fld) {
        	field = fld;
    	}
    	global Integer compareTo(Object compareTo) {
        	Inner_Sorter compareToMapping = (Inner_Sorter)compareTo;
            Integer returnValue = 0;
            if(field.Grouping__c.equals(compareToMapping.field.Grouping__c)) {
                if(field.Grouping_Inner_Order__c > compareToMapping.field.Grouping_Inner_Order__c ) {
                   returnValue = 1; 
                } else if(field.Grouping_Inner_Order__c < compareToMapping.field.Grouping_Inner_Order__c ) {
                   returnValue = -1; 
                }
            }
        	return returnValue;            
        }
    }
    
    // prepare MailTemplate 
    
    private EMailMapping__mdt fetchConfig(Opportunity opp){
        String product = opp.product__c;
        String uniqueName;
        if(product == 'Lebensversicherung') {
        	uniqueName = 'SendMandateAsMailLV';
        } else if(product == 'Finanzierung') {
            uniqueName = 'SendMandateAsMailFZ';
        } else if(product == 'Dieselskandal') {
        	uniqueName = 'SendMandateAsMailDS';
        }
        return [Select Attachment__c, 
                                  Template__c, 
                                  UniqueName__c,
                                  IsEnabled__c
                                  FROM  EMailMapping__mdt 
                                  WHERE UniqueName__c =: uniqueName LIMIT 1];
    }
    
    private EmailTemplate fetchTemplate(){
        return [SELECT Id,
                         Subject,
                         Body,
                         Name,
                         HtmlValue 
                         FROM EmailTemplate 
                         WHERE DeveloperName =: eMailMapping.Template__c];
        
    } 
    
    private void prepareMergeMappings(){
        this.mergeMappings = new Map<String,String>();
        if(this.opp.Number__c != null) {
        	this.mergeMappings.put('{!Opportunity.Number__c}', this.opp.Number__c);    
        }
        if(this.opp.Contact__r.Name != null) {
        	this.mergeMappings.put('{!Opportunity.Contact__r}', this.opp.Contact__r.Name);
        }   
    }
    
    private void mergeFields(){
        for (String key : this.mergeMappings.keySet()) {
            this.htmlBody = this.htmlBody.replace(key,this.mergeMappings.get(key));
            this.body = this.body.replace(key,this.mergeMappings.get(key));
		}
    }
    
    private void buildBody() {
         this.body = template.Body;
    }
    
    private void buildHtmlBody() { 
        this.htmlBody = template.HtmlValue.replace('{text_body}',body.replace('\n','<br/>'));
    }
    
    
}