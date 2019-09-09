@isTest
public class DateRecordSendMailTest {
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
    private static void testDieselSkandalJCLegalNoRec() {
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
            Representative__c = null
        );
        insert d;
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(pr, null);
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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.FzKainzLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungLeCom() {
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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvLeComLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

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
        Date_Record__c dr = new Date_Record__c(
            Date__c = d.Id
        );
        insert dr;

        Apexpages.StandardController sc = new Apexpages.standardController(dr);
        DateRecordSendMail oe = new DateRecordSendMail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateRecord)), 'template not found');
        System.assertNotEquals('einen "Terminsvertreter" auf dem Termin', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}