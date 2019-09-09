@isTest
public class ContinueClaimProcessTest {
    private static Claim__c createClaim(string record) {
        TriggerConfiguration.allInactive = true;
        Claim__c c;
        System.runAs(TestData.bypassUser()) {
            ClaimTriggerhandler.Deactivate = true;
            Account a = TestData.createAccount();
            a.name = 'VH24';
            a.Type = 'Lebensversicherung';
            insert a;
            User u = TestData.legalUser();
            insert u;
            Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
            o.Account__c = a.Id;
            o.Backoffice__c = u.Id;
            o.Insurance__c = a.Id;
            RecordType rt = [SELECT Id FROM RecordType WHERE Name = :record AND sObjectType = 'Opportunity'];
            o.RecordTypeId = rt.Id;
            insert o;
            c = new Claim__c(
                Opportunity__c = o.Id,
                Clerk__c = u.Id,
                Legal__c = u.Id
            );
        }
        return c;
    }

    @isTest
    private static void TestDieselSkandalProcessing() {
        Claim__c c = createClaim('Dieselskandal');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Processing', res.Stage__c);
    }

    @isTest
    private static void TestDieselSkandalDeclinedLetter() {
        Claim__c c = createClaim('Dieselskandal');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Claim Letter';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Lawsuit', res.Stage__c);
    }

    @isTest
    private static void TestDieselSkandalDeclinedLawsuit() {
        Claim__c c = createClaim('Dieselskandal');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Lawsuit';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Appeal', res.Stage__c);
    }

    @isTest
    private static void TestDieselSkandalDeclinedAppeal() {
        Claim__c c = createClaim('Dieselskandal');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Processing', res.Stage__c);
    }

    @isTest
    private static void TestLebensVersicherungDeclinedCOpposition() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Customers Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Legal Opposition', res.Stage__c);
    }

    @isTest
    private static void TestLebensVersicherungDeclinedLOpposition() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Legal Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
		List<Correspondence__c> res = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Anwalt'];
        System.assertEquals(1, res.size());
    }

    @isTest
    private static void TestLebensVersicherungDeclinedLOppositionWiderspruch() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Legal Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // TODO: add assertions for task creations:
        //  - create tasks
        //  - count created tasks on claim
        //  - run tests
        //  - count tasks agian and expect all tasks to be closed

        // pre test
        // Task t = Utilities.createTask('Weiterfürung entscheiden', 'foo bar', sObject parentObject, User owner, Date activityDate, Boolean checkExisting, Boolean isFollowUpTask){

        // c.getSObjects('Tasks').size();

        // Act
        PageReference pr = oe.renderPage();

        // test
		// List <Task> res = [SELECT Id FROM Task WHERE Subject = 'Weiterführung entscheiden' AND OwnerId = :c.Id];
        // System.assertEquals(0, res.size());
    }

    @isTest
    private static void TestLebensVersicherungDeclinedLOppositionWiderspruchNoDraft() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Legal Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Sent' // not draft
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestLebensVersicherungDeclinedLawsuit() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Lawsuit';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Sent' // not draft
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestLebensVersicherungDeclinedLawsuitKlage() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Lawsuit';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Klageschrift',
            Stage__c = 'Sent' // not draft
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

   @isTest
    private static void TestLebensVersicherungDeclinedLawsuitKlageDraft() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Lawsuit';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Klageschrift',
            Stage__c = 'Draft'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    //

    @isTest
    private static void TestLebensVersicherungDeclinedAppeal() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Sent' // not draft
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestLebensVersicherungDeclinedAppealReplik() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Replik',
            Stage__c = 'Sent' // not draft
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

   @isTest
    private static void TestLebensVersicherungDeclinedAppealReplikDraft() {
        Claim__c c = createClaim('Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Declined';
        c.Stage__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Replik',
            Stage__c = 'Draft'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();
    }

   @isTest
    private static void TestLebensVersicherungArrangement() {
        Claim__c c = createClaim('Lebensversicherung');
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Replik'
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Result__c = 'Arrangement';
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ContinueClaimProcess oe = new ContinueClaimProcess(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Processing', res.Stage__c);
    }
}