@isTest
public class SetClaimClarificationTest {
    private static Claim__c createClaim(string legalname) {
        ClaimTriggerhandler.Deactivate = true;
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Account la = TestData.createAccount();
        la.name = legalname;
        insert la;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = la.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void TestJCLegal() {
        Claim__c c = createClaim('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimClarification oe = new SetClaimClarification(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void Test21Legal() {
        Claim__c c = createClaim('21Legal GmbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimClarification oe = new SetClaimClarification(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestCLLB() {
        Claim__c c = createClaim('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimClarification oe = new SetClaimClarification(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestLachmair() {
        Claim__c c = createClaim('Lachmair');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimClarification oe = new SetClaimClarification(sc);

        // Act
        PageReference pr = oe.renderPage();
    }
}