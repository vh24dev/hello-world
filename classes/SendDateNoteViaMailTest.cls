@isTest
public class SendDateNoteViaMailTest {
    private static Opportunity createOpp(string legalname) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity o = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        return o;
    }

    /* * * * * * * * * 
     * Dieselskandal *
     * * * * * * * * */

    @isTest
    private static void testDieselSkandalNoRec() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo'
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertEquals(null, pr);
        System.assertEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);
    }

    @isTest
    private static void testDieselSkandalJCLegal() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalLeCom() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalCllb() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /* * * * * * * * * 
     * Finanzierung  *
     * * * * * * * * */

    @isTest
    private static void testFinanzierungJCLegal() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungLeCom() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungCllb() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzKainzLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /* * * * * * * * * * * *
     * Lebensversicherung  *
     * * * * * * * * * * * */

    @isTest
    private static void testLebensversicherungJCLegal() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzieruntestLebensversicherungLeCom() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvLeComLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungCllb() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Claim__c c = new Claim__c(
        	Opportunity__c = o.Id
        );
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Date__c = System.today().addDays(2),
            Subject__c = 'foo',
            Representative__c = o.Contact__c
        );
        insert d;
        Date_Notification__c dn = new Date_Notification__c(
            Date__c = d.Id
        );
        insert dn;

        Apexpages.StandardController sc = new Apexpages.standardController(dn);
        SendDateNoteViaMail oe = new SendDateNoteViaMail(sc);

        // Act
        PageReference pr = oe.renderPage();

		System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateNotification)));
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}