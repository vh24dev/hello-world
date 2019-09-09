@isTest
public class ClaimSendTemplateToCustomerTest {
    private static Claim__c createClaim(string prioId, integer termination, boolean clrk) {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        a.External_Id__c = prioId;
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        o.Termination_Date__c = System.today().addDays(termination);
        o.Expiration_Date__c = System.today().addDays(termination);
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        if (!clrk) c.Clerk__c = null;
        return c;
    }

    @isTest
    private static void testDGFail() {
        Claim__c c = createClaim('III', 2, true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSendTemplateToCustomer oe = new ClaimSendTemplateToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(pr, null);
    }

    @isTest
    private static void testPrioFail() {
        Claim__c c = createClaim('lv001', 2, true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSendTemplateToCustomer oe = new ClaimSendTemplateToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(pr, null);
    }

    @isTest
    private static void testStatusFail() {
        Claim__c c = createClaim('III', -2, true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSendTemplateToCustomer oe = new ClaimSendTemplateToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(pr, null);
    }

    @isTest
    private static void testClerkFail() {
        Claim__c c = createClaim('III', 2, false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSendTemplateToCustomer oe = new ClaimSendTemplateToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(pr, null);
    }

    @isTest
    private static void testTaskAndCorr() {
        Claim__c c = createClaim('III', 2, true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSendTemplateToCustomer oe = new ClaimSendTemplateToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(pr, null);
        System.assertEquals(pr.getUrl(), Page.SuccessPage.getUrl());

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsvorlage an Kunden versenden'];
        System.assertEquals(1, ts.size());
        List<Correspondence__c> crs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Kunden'];
        System.assertEquals(1, crs.size());
    }
}