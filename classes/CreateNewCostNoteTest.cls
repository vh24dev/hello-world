@isTest
public class CreateNewCostNoteTest {
    public static Opportunity createOpp(Id accountId, String stageName) {
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity opp = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountId,
            CloseDate = System.today(),
            StageName = stageName,
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        return opp;
    }

    @isTest
    private static void testCreate() {
        // Setup
        Account la = TestData.createAccount();
        la.name = 'VR24';
        insert la;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert cn;
        Cancellation__c can = new Cancellation__c(
            Cost_Note__c = cn.Id
        );
        insert can;

        Apexpages.StandardController sc = new Apexpages.standardController(can);
        CreateNewCostNote oe = new CreateNewCostNote(sc);

        // Act
        PageReference pr = oe.renderPage();
        Id newCnId = Id.valueOf(pr.getUrl().removeStart('/'));
        Cost_Note__c newCn = [
            SELECT Id,
            Claim__c,
            Subject__c,
            Type__c,
            Stage__c,
            Recipient__c
            FROM Cost_Note__c
            WHERE Id = :newCnId
        ];

        // Assert
        System.assertEquals(cn.Subject__c, newCn.Subject__c);
        System.assertEquals('Draft', newCn.Stage__c);
        System.assertEquals(cn.Type__c, newCn.Type__c);
        System.assertEquals(cn.Recipient__c, newCn.Recipient__c);
        System.assertEquals(cl.Id, newCn.Claim__c);
    }
}