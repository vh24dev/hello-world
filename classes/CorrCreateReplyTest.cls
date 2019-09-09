@isTest
public class CorrCreateReplyTest {
    private static Correspondence__c createCorr(boolean isAppeal) {
        PageReference p = Page.CorrCreateReply;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        if (isAppeal) {
			User u = TestData.createUser();
			insert u;
            claim.Clerk_Appeal__c = u.Id;
        }
        insert claim;
        return TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
    }

    @isTest
    private static void testNoAppeal() {
        Correspondence__c c = createCorr(false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrCreateReply oe = new CorrCreateReply(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testMain() {
        Correspondence__c c = createCorr(true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrCreateReply oe = new CorrCreateReply(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}