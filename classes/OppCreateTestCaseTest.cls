@isTest
public class OppCreateTestCaseTest {
    private static Opportunity createOpp(string accname) {
        PageReference p = Page.OppCreateTestCase;
        Test.setCurrentPage(p);

        User u = TestData.createUser();
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        insert u;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Backoffice__c = u.Id;
        insert o;
        return o;
    }

    @isTest
    private static void testStage() {
        Opportunity o = createOpp('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppCreateTestCase oe = new OppCreateTestCase(sc);

        // Act
        PageReference pr = oe.renderPage();

        Opportunity res = [SELECT ID, StageName FROM Opportunity LIMIT 1];
        System.assertEquals('Claim', res.StageName);
    }
}