@isTest
public class ResponseAtCustomerTest {
    private static Claim__c createClaim(string legalname, string rtName) {
        Test.startTest();
        
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        o.Assignment_Type__c = 'RSV';
        o.Contact__c = con.Id;
        Account la = TestData.createAccount();
        la.Name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = :rtName AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        insert o;
        
        Test.stopTest();
        
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void TestNoContact() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        Account la = TestData.createAccount();
        la.Name = 'VH24';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finanzierung' AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void TestNoClerk() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        Account la = TestData.createAccount();
        la.Name = 'VH24';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finanzierung' AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        o.Contact__c = con.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Legal__c = u.Id
        );
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
        System.assertEquals('einen Sachbearbeiter auf dem Fall', oe.errorMsg);
    }

    @isTest
    private static void TestFzTaskErgebnis() {
        Claim__c c = createClaim('VH24', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Ergebnis des Kundenwiderspruchs dokumentieren'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    private static void TestFzTaskKredit() {
        Claim__c c = createClaim('VH24', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden'];
        System.assertEquals(0, ts.size());

        PageReference pr = oe.renderPage();

        ts = [SELECT Id FROM Task WHERE Subject = 'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    private static void TestDiesel() {
        Claim__c c = createClaim('VH24', 'Dieselskandal');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        // expext &tpl=& being empty
        // or &tpl= at end because salesforce magic reorders it
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzJaegerLegalAntwortBeimKunden)));
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvJaegerLegalAntwortBeimKunden)));
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvKainzLegalAntwortBeimKunden)));
    }

    @isTest
    private static void TestFz() {
        Claim__c c = createClaim('VH24', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        // expext &tpl=& being empty
        // or &tpl= at end because salesforce magic reorders it
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzJaegerLegalAntwortBeimKunden)));
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvJaegerLegalAntwortBeimKunden)));
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvKainzLegalAntwortBeimKunden)));
    }

	/* * * * * * * * * * *
	 * Finanzierung tpl  *
	 * * * * * * * * * * */

    @isTest
    private static void TestFzJc() {
        Claim__c c = createClaim('J & C Anwälte', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzJaegerLegalAntwortBeimKunden)));
    }

    @isTest
    private static void TestFzLeCom() {
        Claim__c c = createClaim('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzLeComLegalAntwortBeimKunden)));
    }

    @isTest
    private static void TestFzCllb() {
        Claim__c c = createClaim('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzKainzLegalAntwortBeimKunden)));
    }

    /* * * * * * * * * * * * * *
     * Lebensversicherung tpl  *
     * * * * * * * * * * * * * */

    @isTest
    private static void TestLVJc() {
        Claim__c c = createClaim('J & C Anwälte', 'Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LVJaegerLegalAntwortBeimKunden)));
    }

    @isTest
    private static void TestLVLeCom() {
        Claim__c c = createClaim('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', 'Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LVLeComLegalAntwortBeimKunden)));
    }

    @isTest
    private static void TestLVCllb() {
        Claim__c c = createClaim('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB', 'Lebensversicherung');
		RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        ResponseAtCustomer oe = new ResponseAtCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LVKainzLegalAntwortBeimKunden)));
    }
}