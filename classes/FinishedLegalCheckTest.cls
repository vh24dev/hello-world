@isTest
public class FinishedLegalCheckTest {
    private static Opportunity createOpp(string accname, string salestype) {
        PageReference p = Page.FinishedLegalCheck;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Sales_Type__c = salestype;
        return o;
    }

    @isTest
    private static void testCreateTask() {
        Opportunity o = createOpp('VR24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedLegalCheck oe = new FinishedLegalCheck(sc);

		List<Task> ts = [SELECT ID FROM Task WHERE Subject = 'Potential prüfen'];
        System.assertEquals(0, ts.size());

        PageReference pr = oe.renderPage();

        ts = [SELECT ID FROM Task WHERE Subject = 'Potential prüfen'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedLegalCheck oe = new FinishedLegalCheck(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVH24Partner() {
        Opportunity o = createOpp('VH24', 'Partner');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedLegalCheck oe = new FinishedLegalCheck(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
    
    @isTest
    private static void testVR24() {
        Opportunity o = createOpp('VR24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedLegalCheck oe = new FinishedLegalCheck(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}