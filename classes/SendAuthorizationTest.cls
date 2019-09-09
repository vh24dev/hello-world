@isTest
public class SendAuthorizationTest {
    private static Opportunity createOpp(string legalname) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        Account a = TestData.createAccount();
        a.name = legalname; // dirty but works
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
    private static void testDieselSkandalNoContact() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        o.Contact__c = null;
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(null, pr);
        System.assertEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testDieselSkandalJCLegal() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        // System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselJaegerLegalAuthorization)), 'template not found');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationJaeger)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        // System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselJaegerLegalAuthorization)), 'template not found');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVh24)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        // System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselJaegerLegalAuthorization)), 'template not found');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVr24)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /*
    @isTest
    private static void testDieselSkandalLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselLeComLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandal21() {
        Opportunity o = createOpp('21Legal GmbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.Diesel21LegalLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselKainzLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalLachmair() {
        Opportunity o = createOpp('Rechtsanwälte Lachmair & Kollegen');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselLachmairLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
	*/

    /* * * * * * * * *
     * Finanzierung  *
     * * * * * * * * */

    @isTest
    private static void testFzNoContact() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        o.Contact__c = null;
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(null, pr);
        System.assertEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testFzLegal() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationJaeger)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFzVH24() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVh24)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFzSkandalVR24() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVr24)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /* * * * * * * * * * * *
     * Lebensversicherung  *
     * * * * * * * * * * * */

    /*
    @isTest
    private static void testLebensversicherungJCLegal() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvJaegerLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvLeComLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherung21() {
        Opportunity o = createOpp('21Legal GmbH');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.Lv21LegalLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        SendAuthorization oe = new SendAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvKainzLegalAuthorization)), 'template not found');
        System.assertNotEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
	*/
}