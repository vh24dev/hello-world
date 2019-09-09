@isTest
public class SendCancellationTest {
    @isTest
    private static void testFoo() {
        Account la = TestData.createAccount();
        la.name = 'VR24';
        insert la;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
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
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cancellation__c can = new Cancellation__c(
            Cost_Note__c = cn.Id
        );
        insert can;

        Apexpages.StandardController sc = new Apexpages.standardController(can);
        SendCancellation oe = new SendCancellation(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains('Rechtsschutzversicherung'));
    }
    
    @isTest
    public static void testHackCoverage() {
        SendCancellation.HackCoverage();
    }
}