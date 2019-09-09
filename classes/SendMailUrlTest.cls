@isTest
public class SendMailUrlTest {
    private static Opportunity createOpp() {
        PageReference p = Page.SendMailUrl;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createAccount();
        vh24.name = 'VH24';
        Account vr24 = TestData.createAccount();
        vr24.name = 'VR24';
        insert new Account[]{vh24, vr24};

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        return TestData.createOpportunity(a.ID, 'On Hold');
    }

    @isTest
    private static void testDieselSkandal() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendMailUrl oe = new SendMailUrl(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testMaster() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendMailUrl oe = new SendMailUrl(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}