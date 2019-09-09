@isTest
public class ClaimRequestDeductibleTest {
    private static Claim__c createClaim(string accname) {
        Account a = TestData.createAccount();
        a.name = accname;
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact co = new Contact(LastName = 'foo');
        insert co;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        o.Contact__c = co.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void testNoContact() {
		TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'J & C Anwälte';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Sonstiges'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Kunden auf der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testJC() {
		TriggerConfiguration.allInactive = true;
        Claim__c c = createClaim('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Sonstiges'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalClaimRequestDeductible)));
    }

    @isTest
    private static void testLegal21() {
		TriggerConfiguration.allInactive = true;
        Claim__c c = createClaim('21Legal GmbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Sonstiges'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalLegalClaimRequestDeductible)));
    }

    @isTest
    private static void testCLLB() {
		TriggerConfiguration.allInactive = true;
        Claim__c c = createClaim('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Sonstiges'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalClaimRequestDeductible)));
    }

    @isTest
    private static void testElse() {
		TriggerConfiguration.allInactive = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Sonstiges'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselLachmairLegalClaimRequestDeductible)));
    }
}