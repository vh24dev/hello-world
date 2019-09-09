@isTest
public class ResendContractTest {
    private static Opportunity createOpp(string accname) {
        TriggerConfiguration.allInactive = true;
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        return o;
    }

    @isTest
    private static void testVH4() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        ResendContract oe = new ResendContract(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvCallcenterResendContractVh24)));
    }

    @isTest
    private static void testVR4() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        ResendContract oe = new ResendContract(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvCallcenterResendContractVr24)));
    }
}