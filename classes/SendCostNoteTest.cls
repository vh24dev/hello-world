@isTest
public class SendCostNoteTest {
    public static Opportunity createOpp(string legalName) {
        TriggerConfiguration.allInactive = true;
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Account a = new Account(Name = legalName, Department__c = 'Heinrich Jäger - DG & FZ', Type = 'Rechtsschutzversicherung');
        insert a;
        Contact con = new Contact(
            FirstName = 'Foo',
            LastName = 'Bar'
        );
        insert con;
        Opportunity opp = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = a.Id,
            Legal_Account__c = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Contact__c = con.Id,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id,
            Legal_Protection_Insurance__c = a.Id
        );
        return opp;
    }

    @isTest
    private static void testErrorContact() {
        Opportunity o = createOpp('foo');
        o.Contact__c = null;
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte tragen Sie ein Kontakt auf dem Feld "Kunde" ein.').getUrl(), pr.getUrl());
    }

    /* * * * * * * * *
     * Dieselskandal *
	 * * * * * * * * */

    @isTest
    private static void testDGCustomerJC() {
        Opportunity o = createOpp('J & C Anwälte');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDGInsuranceJC() {
        Opportunity o = createOpp('J & C Anwälte');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDGCustomerLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDGInsuranceLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDGCustomerCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDGInsuranceCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        insert o;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    /* * * * * * * * *
     * Finanzierung  *
	 * * * * * * * * */

    @isTest
    private static void testFZCustomerJC() {
        Opportunity o = createOpp('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZJaegerLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFZInsuranceJC() {
        Opportunity o = createOpp('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZJaegerLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFZCustomerLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZLeComLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFZInsuranceLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZLeComLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFZCustomerCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZKainzLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testFZInsuranceCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.FZKainzLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    /* * * * * * * * * * * *
     * Finanzierung  *
	 * * * * * * * * * * * */

    @isTest
    private static void testLVNoInsurance() {
        Opportunity o = createOpp('J & C Anwälte');
        o.Legal_Protection_Insurance__c = null;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte tragen Sie eine "Rechtsschutzversicherung" auf der Anfrage ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVCustomerJC() {
        Opportunity o = createOpp('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVInsuranceJC() {
        Opportunity o = createOpp('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
				o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVCustomerLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
				o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVInsuranceLeCom() {
        Opportunity o = createOpp('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
				o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVCustomerCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
				o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Customer'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteCustomer) +
            '&recipient=' + o.Contact__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLVInsuranceCllb() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
				o.recordTypeId = rt.Id;
        insert o;
        rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
            Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges',
            Recipient__c = 'Legal Protection Insurance'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendCostNote oe = new SendCostNote(sc);

        PageReference pr = oe.renderPage();

        string url = page.sendMail.getUrl() +
            '?id=' + c.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteInsurance) +
            '&recipient=' + o.Legal_Protection_Insurance__c +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
        System.assertEquals(new PageReference(url).getUrl(), pr.getUrl());
    }
}