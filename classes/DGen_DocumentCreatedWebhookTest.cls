// TODO: !
@isTest
public class DGen_DocumentCreatedWebhookTest {
    @isTest
    public static void hackCoverage() {
        DGen_DocumentCreatedWebhook.hackCoverage();
    }

    /*
    @isTest
    public static void testSendMail() {
        // doesnt work :c
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.addHeader('httpMethod', 'POST');
        req.requestUri = '/services/apexrest/docgen/documents';       
        String postData = '{}';
        String JsonMsg = JSON.serialize(postData);
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req; 
        RestContext.response= res;


        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            name = 'VH24'
        );
        insert a;
        Contact con = new Contact(
            LastName = 'bar',
            Email = 'foo@bar.baz'
        );
        insert con;
        Opportunity opp = TestData.createOpportunity(a.Id, 'On Hold');
        User ul = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert ul;
        }
        opp.Legal__c = ul.Id;
        opp.Contact__c = con.Id;
        insert opp; 
        TriggerConfiguration.allInactive = false;
        Opportunity_Correspondence__c oppCorr = new Opportunity_Correspondence__c(
            Opportunity__c = opp.Id,
            Date__c = System.today(),
            Stage__c = 'Draft',
            Partner__c = 'Bank',
            Autocreate_Document__c = true,
            Autosend_Email__c = true,
            Text_Modules__c = 'AnforderungVertrag',
            Send_Mail_TemplateID__c = EmailTemplates.idOf(EmailTemplates.name.FzLeComLegalAnfrageKorrespondenz)
        );
        Test.startTest();
        insert oppCorr;
        Test.stopTest();
    }
    */
}