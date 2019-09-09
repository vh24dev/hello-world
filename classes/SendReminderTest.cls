@isTest
public class SendReminderTest {
    private static Opportunity createOpp(string accname, string legalname, boolean isContact) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

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
        o.Legal_Account__c = la.Id;
        if (isContact) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testErrorMahnung() {
        Opportunity o = createOpp('VR24', 'Foo', false);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte tragen Sie einen Kontakt auf dem Feld "Kunde" ein (Mahnung).').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorInsurance() {
        Opportunity o = createOpp('VR24', 'Foo', false);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id,
            Recipient__c = 'Legal Protection Insurance'
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte tragen Sie eine Reschtsschutzversicherung auf der Anfrage ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFz() {
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar', Email = 'foo.bar@baz.com');
        insert con;
        Opportunity o = createOpp('VR24', 'Foo', false);
        o.recordTypeId = Opportunities.finanzierungRecordType();
        o.Contact__c = con.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + con.Id +
            '&tpl=' +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFzLeComContact() {
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar', Email = 'foo.bar@baz.com');
        insert con;
        Opportunity o = createOpp('VR24', 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', true);
        o.recordTypeId = Opportunities.finanzierungRecordType();
        o.Contact__c = con.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + con.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteReminderContact) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFzLeComLegalProtInsurance() {
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = createOpp('VR24', 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', true);
        o.recordTypeId = Opportunities.finanzierungRecordType();
        o.Legal_Protection_Insurance__c = a.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id,
            Recipient__c = 'Legal Protection Insurance'
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + a.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteReminderAccount) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLvLeComContact() {
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar', Email = 'foo.bar@baz.com');
        insert con;
        Opportunity o = createOpp('VR24', 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', false);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        o.Contact__c = con.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + con.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteReminderContact) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLvLeComLegalProtInsurance() {
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = createOpp('VR24', 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', false);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        o.Legal_Protection_Insurance__c = a.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + a.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteReminderAccount) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDieselLeComLegalProtInsurance() {
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = createOpp('VR24', 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH', false);
        o.recordTypeId = Opportunities.dieselskandalRecordType();
        o.Legal_Protection_Insurance__c = a.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id,
            Recipient__c = 'Legal Protection Insurance'
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + a.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteReminderAccount) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testSendMail() {
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar', Email = 'foo.bar@baz.com');
        insert con;
        Opportunity o = createOpp('VR24', 'Foo', false);
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        o.Contact__c = con.Id;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo',
            Type__c = 'Sonstiges'
        );
        insert cn;
        Cost_Note_Reminder__c cnr = new Cost_Note_Reminder__c(
            Cost_Note__c = cn.Id
        );
        insert cnr;

        Apexpages.StandardController sc = new Apexpages.standardController(cnr);
        SendReminder oe = new SendReminder(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);

        string url = page.sendMail.getUrl() +
            '?id=' + cnr.Id +
            '&recipient=' + con.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteReminderContact) +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
        System.assertNotEquals(null, eu);
        PageReference mailStatus = eu.sendButton();
        System.assertNotEquals(null, mailStatus);
        System.assertEquals(Errors.page('Anhang fehlt.', 'Bitte Anhang ergänzen und erneut versuchen.').getUrl(), mailStatus.getUrl());
        // System.assertEquals(Page.SuccessPage.getUrl(), mailStatus.getUrl());
    }
}