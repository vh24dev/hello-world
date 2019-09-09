@isTest
public class SendExampleCalculationFZTest {
    private static Opportunity createOpp(string accname) {
        PageReference p = Page.SendExampleCalculationFZ;
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
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculationFZ oe = new SendExampleCalculationFZ(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24');
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculationFZ oe = new SendExampleCalculationFZ(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVR24() {
        Opportunity o = createOpp('VR24');
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SendExampleCalculationFZ oe = new SendExampleCalculationFZ(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}