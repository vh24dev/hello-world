@isTest
public class SendWelcomeLetterViaEmailTest {
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

    @isTest
    private static void testDieselSkandalJCLegalNoContact() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        o.Contact__c = null;
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(pr, null);
        System.assertEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testDieselSkandalJCLegal() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselJaegerBackofficeSendWelcomeLetter)), 'template not found');
        System.assertEquals('', oe.errorMsg);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalLegal21() {
        Opportunity o = createOpp('21Legal GmbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalBackofficeSendWelcomeLetter)), 'template not found');

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselKainzBackofficeSendWelcomeLetter)), 'template not found');

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /*
    @isTest
    private static void testDieselSkandalLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselLeComBackofficeSendWelcomeLetter)), 'template not found');

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
    */

    @isTest
    private static void testDieselSkandalLachmair() {
        Opportunity o = createOpp('Rechtsanwälte Lachmair & Kollegen');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Welcome_Letter__c w = new Welcome_Letter__c(
        	Opportunity__c = o.Id
        );
        insert w;

        Apexpages.StandardController sc = new Apexpages.standardController(w);
        SendWelcomeLetterViaEmail oe = new SendWelcomeLetterViaEmail(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselLachmairBackofficeSendWelcomeLetter)), 'template not found');

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}