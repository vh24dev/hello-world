@isTest(SeeAllData=true)
public class MandateAsMailDelegationTest {

    @isTest
    private static void testBuildQuery() {
        MandateAsMailDelegation delegation = new MandateAsMailDelegation('1234567','irrelevant','irrelevant');     

        List<Mandate_Mail_Object_Field_Mappings__mdt> fields = 
            delegation.fetchObjectFields('Opportunity');
        
        String query = delegation.buildQuery('1234567', fields,'Opportunity','Id');
        for(Mandate_Mail_Object_Field_Mappings__mdt field : fields){
            if(field.Field__c != null) {
        		System.assert(query.indexOf(field.Field__c) != -1);
            } else if(field.One_Object__c != null) {
        		System.assert(query.indexOf(field.One_Object__c) != -1);                
            }
        }
	    System.assert(query.indexOf('1234567') != -1);    
    }
 	
    @isTest
    private static void testExecuteQuery() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        insert opp;
        MandateAsMailDelegation delegation = new MandateAsMailDelegation('1234567','irrelevant','irrelevant');     
        String query = 'SELECT Insurance__r.Name, Insurance_Type__c, Insurance_Rate__c FROM Opportunity WHERE Id = \'' + opp.Id + '\'';   
        List<Opportunity> oppFetched = delegation.executeQuery(query);
        System.assertEquals(accountInsurance.Name, oppFetched[0].Insurance__r.Name);
        System.assertEquals('Dummy-Tarifbezeichnung', oppFetched[0].Insurance_Rate__c);
        System.assertEquals('Rentenversicherung', oppFetched[0].Insurance_Type__c);
    }
 
    @isTest
    private static void objectValuesToMap() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        insert opp;
        
        Document__c doc1 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts1');
        Document__c doc2 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts2');
        insert doc1;
        insert doc2;
        String xlsString = 'test; test';

        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        List<Mandate_Mail_Object_Field_Mappings__mdt> fields = delegation.fetchObjectFields('Opportunity');
        String query = delegation.buildQuery(opp.Id, fields,'Opportunity','Id');
        List<sObject> oppFetched = delegation.executeQuery(query);
		Opportunity oppCasted = (Opportunity) oppFetched[0];
        String insuranceName = (String)oppCasted.getSobject('Insurance__r').get('Name');
        xlsString = delegation.objectValuesToMap(oppFetched[0],fields,xlsString);
        System.debug('------'+xlsString);
        System.assert(xlsString.indexOf('Rentenversicherung') != -1);      
        System.assert(xlsString.indexOf('Dummy-Tarifbezeichnung') != -1);   
        System.assert(xlsString.indexOf('http://google.com/ichtuhenichts2') != -1);      
        System.assert(xlsString.indexOf('http://google.com/ichtuhenichts1') != -1);                
    }
    
    @isTest
    private static void testAttachmentGenerationAsIntegrationTest(){
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
        
        Document__c doc1 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts1');
        Document__c doc2 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts2');
        insert doc1;
        insert doc2;
        String xlsString = 'test; test';

        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        delegation.prepareMail();
        Messaging.EmailFileAttachment[] attachments = delegation.getAttachments();
        String attachmentAsString = attachments[0].getBody().toString();
        System.assert(attachmentAsString.indexOf('Rentenversicherung') != -1);      
        System.assert(attachmentAsString.indexOf('Dummy-Tarifbezeichnung') != -1);   
        System.assert(attachmentAsString.indexOf('http://google.com/ichtuhenichts2') != -1);      
        System.assert(attachmentAsString.indexOf('http://google.com/ichtuhenichts1') != -1);                
    }
    
    @isTest
    private static void testGetTitleForCSV(){
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
 
        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        delegation.prepareMail();
        String titleRetrieved = delegation.getTitleForCSV();
          
        String titleAssert = 'Mandat ' + opp.Number__c + '.csv';
		System.assert(titleAssert.equals(titleRetrieved));    	
        
    }
   
    @isTest
    private static void testGetHtmlBody() {
        //return null;
        MandateAsMailDelegation delegation = new MandateAsMailDelegation('irrelevant','test@test.com','this is irrelevant'); 
		System.assert(null == delegation.getHtmlBody());    	        
    }
    
	@isTest    
    private static void testIsEnabled() {
        MandateAsMailDelegation delegation = new MandateAsMailDelegation('irrelevant','test@test.com','this is irrelevant'); 
		System.assert(delegation.isEnabled());    	        
    }
    
    @isTest
    private static void testGetSubject() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
        
        String subjectAssert = 'Mandatübergabe ' + opp.Number__c;
 
        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        delegation.prepareMail();
        String subjectRetrieved = delegation.getSubject();
		System.assert(subjectAssert.equals(subjectRetrieved));    	 
    }
    
    @isTest
    private static void testGetSenderId() {
    	MandateAsMailDelegation delegation = new MandateAsMailDelegation('irrelevant','test@test.com','irrelevant'); 
    	OrgWideEmailAddress orgWideEmailAddresses = [select Id, 
                                                     Address 
                                                     from OrgWideEmailAddress 
                                                     Where Address = 'lebensversicherung@verbraucherhilfe24.de' LIMIT 1];
        Id assertId = (Id)orgWideEmailAddresses.Id;
        ID senderIdRetrieved = delegation.getSenderId();
	    System.assert(assertId.equals(senderIdRetrieved));    	 
    }
    
    // getPlainTextBody
    @isTest
    private static void testGetPlainTextBody() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
		MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','irrelevant');
        delegation.prepareMail();
        String plainBodyRetrieved = delegation.getPlainTextBody();
        System.assert(plainBodyRetrieved.contains(opp.Number__c));  
    }
     
    // getAddresses
    @isTest
    private static void testGetAdresses() {
        
        String addressAssert = 'test@test.com';
        MandateAsMailDelegation delegation = new MandateAsMailDelegation('irrelevant','test@test.com','irrelevant');
        list<string> addressesRetrieved = delegation.getAddresses();
        System.assert(addressAssert.equals(addressesRetrieved[0]));  
    }
    
    // getAddresses
    @isTest
    private static void testFilterObjecsWithFilter() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        List<Mandate_Mail_Object_Field_Mappings__mdt> fields = delegation.fetchObjectFields('Document__c');
        Document__c doc1 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts1');
        Document__c doc2 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts2');
        doc1.IsAccessibleForLegal__c = true;
        doc2.IsAccessibleForLegal__c = false;
        insert doc1;
        insert doc2;
        List<Document__c> docs = new List<Document__c>();
        docs.add(doc1);
        docs.add(doc2);
        List<Document__c> filteredDocs = delegation.filterObjects(docs, fields );
        System.assert(filteredDocs.size() == 1);
    }
    
    // getAddresses
    @isTest
    private static void testFilterObjecsWithoutFilter() {
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Number__c ='BN123456';
        insert opp;
        MandateAsMailDelegation delegation = new MandateAsMailDelegation(opp.Id,'test@test.com','this is irrelevant'); 
        List<Mandate_Mail_Object_Field_Mappings__mdt> fields = delegation.fetchObjectFields('Document__c');
        List<Mandate_Mail_Object_Field_Mappings__mdt> fieldsWithoutFilter = new  List<Mandate_Mail_Object_Field_Mappings__mdt>();
        for(Mandate_Mail_Object_Field_Mappings__mdt field : fields){
            if(field.IsFilter__c == false) {
                fieldsWithoutFilter.add(field);
            }
        }
        Document__c doc1 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts1');
        Document__c doc2 = TestData.createDocument(opp.Id, 'http://google.com/ichtuhenichts2');
        doc1.IsAccessibleForLegal__c = true;
        doc2.IsAccessibleForLegal__c = false;
        insert doc1;
        insert doc2;
        List<Document__c> docs = new List<Document__c>();
        docs.add(doc1);
        docs.add(doc2);
        List<Document__c> filteredDocs = delegation.filterObjects(docs, fieldsWithoutFilter );
        System.assert(filteredDocs.size() == 2);
    }
     
}