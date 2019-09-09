@isTest
public class SendOwnershipRequestTest {
    private static Claim__c createClaim(string legalname) {
        return createClaim(legalname, true);
    }
    private static Claim__c createClaim(string legalname, boolean iscontact) {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(LastName = 'foo');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        if (iscontact) {
            o.Contact__c = con.Id;
        }
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        o.Assignment_Type__c = 'RSV';
        Account la = TestData.createAccount();
        la.Name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Dieselskandal' AND sObjectType = 'Opportunity'];
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
    private static void TestNoContact() {
        Claim__c c = createClaim('VH24', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Stage__c = 'Draft',
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(null, pr);
        System.assertEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void TestDate() {
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);

        // test
        Correspondence__c res = [SELECT Id, Date_Link_Ownership__c FROM Correspondence__c WHERE Id = :corr.ID];
        System.assertEquals(System.today(), res.Date_Link_Ownership__c);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselLachmairLegalRequestOwnership)));
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

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Correspondence__c res = [SELECT Id, Date_Link_Ownership__c FROM Correspondence__c WHERE Id = :corr.ID];
        System.assertEquals(System.today(), res.Date_Link_Ownership__c);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselJaegerLegalRequestOwnership)));
    }

    @isTest
    private static void TestLeCom() {
        Claim__c c = createClaim('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Correspondence__c res = [SELECT Id, Date_Link_Ownership__c FROM Correspondence__c WHERE Id = :corr.ID];
        System.assertEquals(System.today(), res.Date_Link_Ownership__c);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselLeComLegalRequestOwnership)));
    }

    @isTest
    private static void TestLegal21() {
        Claim__c c = createClaim('21Legal GmbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Correspondence__c res = [SELECT Id, Date_Link_Ownership__c FROM Correspondence__c WHERE Id = :corr.ID];
        System.assertEquals(System.today(), res.Date_Link_Ownership__c);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.RequestOwnership.Diesel21LegalLegalRequestOwnership)));
    }

    @isTest
    private static void TestCllb() {
        Claim__c c = createClaim('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendOwnershipRequest oe = new SendOwnershipRequest(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Correspondence__c res = [SELECT Id, Date_Link_Ownership__c FROM Correspondence__c WHERE Id = :corr.ID];
        System.assertEquals(System.today(), res.Date_Link_Ownership__c);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselKainzLegalRequestOwnership)));
    }
}