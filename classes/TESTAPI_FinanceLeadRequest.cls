@isTest
public class TESTAPI_FinanceLeadRequest {
    @isTest
    public static void TestCreation() {
        TriggerConfiguration.allInactive = true;
        
        string req = '{"errors":{},"brand":"Audi","engine":"EA897","model":"Amarok","year":"Vor 2008","financed":"Ja","finance_type":"","other_finance_type":"","finance_amount":"","insurance":"Nein","state":"info","validation_context":null,"first_name":"Dylan","last_name":"Johnston","phone":"017662220934","email":"dj@salesfive.com","contact_preference":"E-Mail","gdpr":"1","tos":"1","auth":"1","salutation":"Herr"}';
        API_TestHelper.setRequest(req);
        API_FinanceLeadRequest.createLead();
        
        List<Lead> l = [
            SELECT Id
            FROM Lead
        ];
        
        System.assertEquals(1, l.size());
    }
    
     @isTest
    public static void TestDuplicateCreationWithSameUnique() {
        TriggerConfiguration.allInactive = true;
        
        string req = '{"errors":{},"unique": "test", "allow_duplicates": true, "brand":"Audi","engine":"EA897","model":"Amarok","year":"Vor 2008","financed":"Ja","finance_type":"","other_finance_type":"","finance_amount":"","insurance":"Nein","state":"info","validation_context":null,"first_name":"Dylan","last_name":"Johnston","phone":"017662220934","email":"dj@salesfive.com","contact_preference":"E-Mail","gdpr":"1","tos":"1","auth":"1","salutation":"Herr"}';
        API_TestHelper.setRequest(req);
        API_FinanceLeadRequest.createLead();
        boolean exceptionCaught = false;
        
        try {
            API_FinanceLeadRequest.createLead();
        } catch(Exception e) {
            exceptionCaught = true;
        }
        
        System.assertEquals(true, exceptionCaught);

        List<Lead> l = [
            SELECT Id
            FROM Lead
        ];
        
        System.assertEquals(1, l.size());
    }
    
    @isTest
    public static void TestDuplicateCreation() {
        TriggerConfiguration.allInactive = true;
        
        string req = '{"errors":{},"allow_duplicates": true, "brand":"Audi","engine":"EA897","model":"Amarok","year":"Vor 2008","financed":"Ja","finance_type":"","other_finance_type":"","finance_amount":"","insurance":"Nein","state":"info","validation_context":null,"first_name":"Dylan","last_name":"Johnston","phone":"017662220934","email":"dj@salesfive.com","contact_preference":"E-Mail","gdpr":"1","tos":"1","auth":"1","salutation":"Herr"}';
        API_TestHelper.setRequest(req);
        API_FinanceLeadRequest.createLead();

        try {
        	API_FinanceLeadRequest.createLead();
        } catch(Exception e) {}
        
        List<Lead> l = [
            SELECT Id
            FROM Lead
        ];
        
        System.assertEquals(2, l.size());
    }
    
    @isTest
    public static void TestCreationBrandNull() {
        TriggerConfiguration.allInactive = true;
        
        string req = '{"errors":{},"engine":"EA897","model":"Amarok","year":"Vor 2008","financed":"Nein","finance_type":"","other_finance_type":"","finance_amount":"","insurance":"Nein","state":"info","validation_context":null,"first_name":"Dylan","last_name":"Johnston","phone":"017662220934","email":"dj@salesfive.com","contact_preference":"E-Mail","gdpr":"1","tos":"1","auth":"1","salutation":"Herr"}';
        API_TestHelper.setRequest(req);
        
        try {
            API_FinanceLeadRequest.createLead();
        } catch(API_Exception e) {}
    }
    
    @isTest
    public static void TestCreationBodyNull() {
        TriggerConfiguration.allInactive = true;
        
        try {
            API_FinanceLeadRequest.createLead();
        } catch(Exception e) {}
    }
}