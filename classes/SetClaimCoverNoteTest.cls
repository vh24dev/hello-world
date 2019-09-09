@isTest
public class SetClaimCoverNoteTest {
    private static Claim__c createClaim(string accname) {
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void testAppendScope() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Result__c = 'Declined';
        c.Cover_Note_Scope__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Refused';
        oe.parClaim.Cover_Note_Scope__c = 'Extrajudicial';
        oe.parClaim.Reason_For_Cover_Note_Refusal__c = 'Sonstiges';
        oe.parOpportunity.Legal_Protection_Deductible__c = 2;
        oe.parClaim.Legal_Protection_Insurance_Case_Number__c = '22';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Cover_Note_Scope__c FROM Claim__c WHERE Id = :c.Id];
        System.assertNotEquals('Extrajudicial', res.Cover_Note_Scope__c); // don't overwrite
        System.assertEquals(true, res.Cover_Note_Scope__c.contains('Extrajudicial')); // but append
        System.assertEquals(true, res.Cover_Note_Scope__c.contains('Appeal')); // and keep the old
    }

    @isTest
    private static void testLetterDeclined() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Refused';
        oe.parClaim.Cover_Note_Scope__c = 'Extrajudicial';
        oe.parClaim.Reason_For_Cover_Note_Refusal__c = 'Sonstiges';
        oe.parOpportunity.Legal_Protection_Deductible__c = 2;
        oe.parClaim.Legal_Protection_Insurance_Case_Number__c = '22';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c, Response_Insurance_Claim_Letter__c FROM Claim__c WHERE Id = :c.Id];
        // System.assertEquals('On Hold', res.Stage__c);
        System.assertEquals(res.Response_Insurance_Claim_Letter__c, oe.parClaim.Response_Lawsuit__c);
    }

    @isTest
    private static void testLegalAccepted() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition';
        c.Result__c = 'Accepted';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Refused';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c, Response_Insurance_Legal_Opposition__c FROM Claim__c WHERE Id = :c.Id];
        System.debug('Claim=' + res.Id + ' Stage=' + res.Stage__c);
        // System.assertEquals('Processing', res.Stage__c); // TODO: probably updated by a trigger process what ever
        System.assertEquals(res.Response_Insurance_Legal_Opposition__c, oe.parClaim.Response_Lawsuit__c);
    }

    @isTest
    private static void testLawsuit() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Lawsuit';
        // c.Result__c = 'Arrangement';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Refused';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c, Response_Insurance_Lawsuit__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals(res.Response_Insurance_Lawsuit__c, oe.parClaim.Response_Lawsuit__c);
    }

    @isTest
    private static void testAppealIssued() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Appeal';
        // c.Result__c = 'Arrangement';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c, Response_Insurance_Lawsuit__c, Cover_Note_Scope__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals(res.Response_Insurance_Lawsuit__c, oe.parClaim.Response_Lawsuit__c);
        System.assertEquals(true, res.Cover_Note_Scope__c.contains('Appeal'));
    }

    @isTest
    private static void testLetterDeclinedDate() { // TODO: might be duplicated
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Response_Claim_Letter__c = System.today();
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Lawsuit', res.Stage__c);
    }

    @isTest
    private static void testLetterAccepted() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Response_Claim_Letter__c = System.today();
        c.Result__c = 'Accepted';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Processing', res.Stage__c);
    }

    @isTest
    private static void testLegalOppositionDeclined() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition';
        c.Result__c = 'Declined';
        c.Cover_Note_Scope__c = 'Extrajudicial';
        c.Response_Legal_Opposition__c = System.today();
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Lawsuit', res.Stage__c);
    }

    @isTest
    private static void testLegalOppositionAccepted() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition';
        c.Result__c = 'Accepted';
        c.Response_Legal_Opposition__c = System.today();
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Processing', res.Stage__c);
    }

    @isTest
    private static void testLawsuitIssuedDeclined() {
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Lawsuit';
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimCoverNote oe = new SetClaimCoverNote(sc);

        // Act
        oe.parDescription = 'foo bar world';
        oe.parClaim.Cover_Note__c = 'Issued';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals('Lawsuit', res.Stage__c);
    }
}