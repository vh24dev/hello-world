@isTest
public class SetClaimResultTest {
    private static Claim__c createClaim(string record, string oppType, boolean hasInsurance) {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        if (hasInsurance) {
            o.Has_Legal_Protection_Insurance__c = false;
        }
        o.Assignment_Type__c = oppType;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = :record AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void TestCreateCorr() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        User bpu = TestData.bypassUser();
        System.runAs(bpu) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        o.Assignment_Type__c = 'Direkt';
        o.RecordTypeId = Opportunities.lebensversicherungRecordType();        
        System.runAs(bpu) {
            insert o;
        }

        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id,
            Stage__c = 'Legal Opposition'
        );
        c.recordTypeId = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'].ID;
        c.Stage__c = 'Legal Opposition';
        System.runAs(bpu) {
            insert c;
        }

        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        System.runAs(bpu) {
            insert corr;
        }

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        List<Correspondence__c> corrs = [
            SELECT ID, Text_Modules__c
            FROM Correspondence__c
            WHERE Text_Modules__c = 'SonstigesUebermittlungBankverbindungAnwaltswiderspruch'
        ];
        System.assertEquals(0, corrs.size());

        oe.parClaim.Result__c = 'Partial';
        PageReference pr;
        System.runAs(bpu) {
            pr = oe.renderPage();
        }

        corrs = [
            SELECT ID, Text_Modules__c
            FROM Correspondence__c
            WHERE Text_Modules__c = 'SonstigesUebermittlungBankverbindungAnwaltswiderspruch'
        ];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    private static void TestOnHold() {
        Claim__c c = createClaim('Dieselskandal', 'Share', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();
        oe.getResults();
        oe.getAppeal();
        oe.getAccepted();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.ID];
        System.assertEquals('On Hold', res.Stage__c);
    }

    @isTest
    private static void TestClaimLetterShare() {
        Claim__c c = createClaim('Dieselskandal', 'Share', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Customers Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.ID];
        System.assertEquals('Customers Opposition', res.Stage__c);
    }

    @isTest
    private static void TestClaimLetter() {
        Claim__c c = createClaim('Dieselskandal', 'RSV', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Customers Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.ID];
        System.assertEquals('Legal Opposition', res.Stage__c);
    }

    @isTest
    private static void TestLegalOpp() {
        Claim__c c = createClaim('Dieselskandal', 'Direkt', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestLegalOppRSVIssued() {
        Claim__c c = createClaim('Dieselskandal', 'RSV', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition';
        c.Cover_Note__c = 'Issued';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();

        // test
        Claim__c res = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :c.ID];
        System.assertEquals('Lawsuit', res.Stage__c);
    }

    @isTest
    private static void TestLawsuit() {
        Claim__c c = createClaim('Dieselskandal', 'Direkt', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Lawsuit';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void TestAppeal() {
        Claim__c c = createClaim('Dieselskandal', 'Direkt', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Appeal';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();
    }

    /*
    @isTest
    private static void TestLegalOppRSVRefused() {
        Claim__c c = createClaim('Dieselskandal', 'RSV', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Legal Opposition'; // is set to 'On Hold' when it reaches the if statement idk why
        c.Cover_Note__c = 'Refused';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetClaimResult oe = new SetClaimResult(sc);

        // Act
        oe.parClaim.Result__c = 'Declined';
        PageReference pr = oe.renderPage();
    }
	*/
}