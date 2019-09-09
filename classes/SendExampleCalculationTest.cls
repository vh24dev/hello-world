@isTest
public class SendExampleCalculationTest {
    private static Opportunity createOpp(string accname, boolean isContact) {
        PageReference p = Page.SendExampleCalculation;
        Test.setCurrentPage(p);

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
        if (isContact) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VR24', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp('VR24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Opportunity o = createOpp('VH24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testFinanzierungVR24() {
        Opportunity o = createOpp('VR24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testFinianzierungVH24() {
        Opportunity o = createOpp('VH24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testMasterVH24() {
        Opportunity o = createOpp('VH24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testMasterVR24() {
        Opportunity o = createOpp('VR24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Master' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculation oe = new SendExampleCalculation(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}