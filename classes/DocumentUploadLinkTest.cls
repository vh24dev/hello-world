@isTest
public class DocumentUploadLinkTest {
    private static Opportunity createOpp() {
        PageReference p = Page.DocumentUploadLink;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        return TestData.createOpportunity(a.ID, 'On Hold');
    }

    @isTest
    private static void testCount() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        Opportunity res;

        PageReference pr = oe.renderPage();
        res = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(1, res.Follow_up_Count__c);
        pr = oe.renderPage();
        res = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(2, res.Follow_up_Count__c);
        pr = oe.renderPage();
        res = [SELECT Id, Follow_up_Count__c, Automatisches_Follow_up_2__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(3, res.Follow_up_Count__c);
        System.assertEquals(true, res.Automatisches_Follow_up_2__c);
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        Account a = new Account(Name = 'VH24');
        insert a;
        o.Account__c = a.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testFinanzierungVR24() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testFinanzierungVH24() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        Account a = new Account(Name = 'VH24');
        insert a;
        o.Account__c = a.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLink oe = new DocumentUploadLink(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}