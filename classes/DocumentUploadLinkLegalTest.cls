@isTest
public class DocumentUploadLinkLegalTest {
    private static Opportunity createOpp() {
        PageReference p = Page.DocumentUploadLinkLegal;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        return TestData.createOpportunity(a.ID, 'On Hold');
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('einen Kontakt im Feld "Kunde"', oe.errorMsg);
    }

    @isTest
    private static void testNoBackoffice() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('einen Backoffice Mitarbeiter ein', oe.errorMsg);
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

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
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDieselSkandalJCLegal() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        o.Legal_Account__c = a.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

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
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

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
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testFinanzierungJCLegal() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        o.Legal_Account__c = a.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Automatisches_Follow_up_2__c FROM Opportunity WHERE Id = :o.Id];
        System.assertNotEquals(true, o.Automatisches_Follow_up_2__c);
    }

    @isTest
    private static void testCount() {
        Opportunity o = createOpp();
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        insert c;
        o.Contact__c = c.Id;
        o.Follow_up_Count__c = 2;
        Account a = new Account(Name = 'J & C Anwälte');
        insert a;
        o.Legal_Account__c = a.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DocumentUploadLinkLegal oe = new DocumentUploadLinkLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals('', oe.errorMsg, 'unexpected error message');
        o = [SELECT Id, Automatisches_Follow_up_2__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(true, o.Automatisches_Follow_up_2__c);
    }
}