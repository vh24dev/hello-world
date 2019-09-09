@isTest
public class OppCorrSendDocToPartnerTest {
    private static Opportunity createOpp(string legalname) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Account insuranceAcc = TestData.createAccount();
        insuranceAcc.Type = 'Lebensversicherung';
        insert insuranceAcc;
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Contact con = new Contact(LastName = 'Bar');
        insert con;
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
            Vehicle_Brand__c = vehicleBrand.Id,
            Bank__c = a.Id,
            Legal_Protection_Insurance__c = a.Id,
            Contact__c = con.Id,
            Insurance__c = insuranceAcc.Id
        );
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        return o;
    }

    /* * * * * * * * *
     * DIESELSKANDAL *
     * * * * * * * * */

    @isTest
    private static void testDieselSkandalJCVehicle() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Vehicle Brand'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Vehicle_Brand__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalCLLBBank() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Bank'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Bank__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalLeComRSV() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Legal Protection Insurance'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselLeComLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Legal_Protection_Insurance__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /* * * * * * * * *
     * FINANZIERUNG  *
     * * * * * * * * */

    @isTest
    private static void testFinanzierungJCInsurance() {
        Opportunity o = createOpp('J & C Anwälte');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Insurance'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzJaegerLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Insurance__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungCLLBCustomer() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Customer'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzKainzLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Contact__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungLeComRSV() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.FinanzierungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Legal Protection Insurance'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzLeComLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Legal_Protection_Insurance__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /* * * * * * * * * * * *
     * LEBENSVERSICHERUNG  *
     * * * * * * * * * * * */

    @isTest
    private static void testLebensversicherungJCInsurance() {
        Opportunity o = createOpp('J & C Anwälte');
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - LV';
        insert la;
        o.Legal_Account__c = la.Id;
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Insurance'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvJaegerLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Insurance__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungCLLBCustomer() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Customer'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvKainzLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Contact__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungLeComRSV() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        o.recordTypeId = Opportunities.LebensversicherungRecordType();
        insert o;
        Opportunity_Correspondence__c corr = new Opportunity_Correspondence__c(
            Opportunity__c = o.Id,
            Partner__c = 'Legal Protection Insurance'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        OppCorrSendDocToPartner oe = new OppCorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvLeComLegalAnfrageKorrespondenz)));
        System.assertEquals(true, pr.getUrl().contains(o.Legal_Protection_Insurance__c));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}