@isTest
public class CorrLegalOppositionTest {
    private static Correspondence__c createCorr(boolean isClerk) {
        PageReference p = Page.CorrLegalOpposition;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv004';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        if (isClerk) {
            User u = TestData.createUser();
            insert u;
            claim.Clerk__c = u.Id;
        }
        insert claim;
        return TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
    }

    @isTest
    private static void testNoClerk() {
        Correspondence__c c = createCorr(false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalOpposition oe = new CorrLegalOpposition(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testMain() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr(true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalOpposition oe = new CorrLegalOpposition(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }

    @isTest
    private static void testNoInsurance() {
        TriggerConfiguration.allInactive = true;

        Account a = TestData.createAccount();
        a.name = 'Bla';
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv004';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalOpposition oe = new CorrLegalOpposition(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Es muss eine Versicherung auf der Anfrage vorhanden sein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testWrongInsurance() {
        TriggerConfiguration.allInactive = true;

        Account a = TestData.createAccount();
        a.name = 'Bla';
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'WRONG ID';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalOpposition oe = new CorrLegalOpposition(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Diese Aktion kann nur mit der Versicherung "Clerical Medical Investment Group Limited" ausgeführt werden.').getUrl(), pr.getUrl());
    }
}