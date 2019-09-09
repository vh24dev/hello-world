@isTest
public class OppLinkToAGBTest {
    private static Opportunity createOpp(string accname, boolean isContact) {
        Account a = TestData.createAccount();
        a.name = accname;
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
        if (isContact) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VR24', false);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppLinkToAGB oe = new OppLinkToAGB(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde".').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Opportunity o = createOpp('VH24', true);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppLinkToAGB oe = new OppLinkToAGB(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVh24)));
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Opportunity o = createOpp('VR24', true);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppLinkToAGB oe = new OppLinkToAGB(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVr24)));
        EmailUtilities eu = new EmailUtilities();
    }


    @isTest
    private static void testFinanzierungVH24() {
        Opportunity o = createOpp('VH24', true);
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppLinkToAGB oe = new OppLinkToAGB(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVh24)));
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungVR24() {
        Opportunity o = createOpp('VR24', true);
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppLinkToAGB oe = new OppLinkToAGB(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVr24)));
        EmailUtilities eu = new EmailUtilities();
    }
}