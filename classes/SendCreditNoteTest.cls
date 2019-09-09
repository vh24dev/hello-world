@isTest
public class SendCreditNoteTest {
    @isTest
    public static void testNoLegalProtection() {
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today()
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
        System.assertEquals(oe.errorMsg, 'eine "Rechtsschutzversicherung" auf der Anfrage');
    }

    @isTest
    public static void testDGJC() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'J & C Anwälte';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.dieselskandalRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = Accounts.JCLegalID
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.DieselJaegerLegalCreditNote)));
    }

    @isTest
    public static void testDGLeCom() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.dieselskandalRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.DieselLeComLegalCreditNote)));
    }

    @isTest
    public static void testDG() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.dieselskandalRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.DieselKainzLegalCreditNote)));
    }

    @isTest
    public static void testFZJC() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'J & C Anwälte';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.finanzierungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = Accounts.JCLegalID
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.FzJaegerLegalCreditNote)));
    }

    @isTest
    public static void testFZLeCom() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.finanzierungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.FzLeComLegalCreditNote)));
    }

    @isTest
    public static void testFZ() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.finanzierungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.FzJaegerLegalCreditNote)));
        System.assertNotEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.DieselKainzLegalCreditNote)));
    }

    @isTest
    public static void testLVCLLB() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.lebensversicherungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.LvKainzLegalCreditNote)));
    }

    @isTest
    public static void testLVLeCom() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
		a.name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.lebensversicherungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id,
            Legal_Account__c = a.ID
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.LvLeComLegalCreditNote)));
    }

    @isTest
    public static void testLV() {
        Account a = new Account(Name = 'foo');
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            RecordTypeID = Opportunities.lebensversicherungRecordType(),
            AccountId = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today(),
            Legal_Protection_Insurance__c = a.Id
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id
        );
        insert c;
        Credit_Note__c cn = new Credit_Note__c(
            Claim__c = c.Id
        );
        insert cn;

        Apexpages.StandardController sc = new Apexpages.standardController(cn);
        SendCreditNote oe = new SendCreditNote(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(oe.errorMsg, '');
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.CreditNote.LvJaegerLegalCreditNote)));
    }
}