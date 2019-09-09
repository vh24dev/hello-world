@isTest
public class ResendAuthorizationTest {
    private static Opportunity createOpp(string accname, string legalname, boolean isContact) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity o = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        if (isContact) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VR24', 'Foo', false);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testDieselSkandalVR24JCLegal() {
        Opportunity o = createOpp('VR24', 'J & C Anwälte', true);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Opportunity o = createOpp('VH24', 'Foo', true);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp('VR24', 'Foo', true);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testMasterVR24JCLegal() {
        Opportunity o = createOpp('VR24', 'J & C Anwälte', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testMasterVH24() {
        Opportunity o = createOpp('VH24', 'Foo', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testMasterVR24() {
        Opportunity o = createOpp('VR24', 'Foo', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        ResendAuthorization oe = new ResendAuthorization(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}