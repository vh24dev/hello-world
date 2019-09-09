@isTest
public class SetOppRefundTest {
    @isTest
    private static void testRefundUpdate() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetOppRefund oe = new SetOppRefund(sc);

        // Act
        oe.parOpportunity.Refund__c = 4.20;
        PageReference pr = oe.renderPage();

        // test
        Opportunity res = [SELECT Id, Refund__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(4.20, res.Refund__c);
    }
}