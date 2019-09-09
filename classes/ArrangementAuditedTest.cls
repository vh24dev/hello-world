@isTest
public class ArrangementAuditedTest {
    @isTest
    public static void testErrorClerk() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = con.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = null // !!!
        );
        insert c;
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr, 'unexpected null pagereference');
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen aktiven "Sachbearbeiter" auf dem Fall.').getUrl(), pr.getUrl());

        ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());
    }

    @isTest
    public static void testErrorContact() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = null; // !!
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr, 'expected a null page reference');
        System.assertEquals(true, oe.errorContact, 'errorContact has to be true if contact is missing');

        ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());
    }

    @isTest
    public static void testCreateTask() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        o.Contact__c = con.Id;
        o.Bank__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());

        ts = [SELECT Id, isClosed FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(1, ts.size());
        System.assertEquals(false, ts[0].isClosed);
    }

    @isTest
    public static void testCloseTask() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = con.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Bank__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;
        Task t = Tasks.build(
            'Vergleich prüfen', // subject
            null, // description
            c, // parentObj
            u, // owner
            System.today(), // acitivity date
            true, // no duplicates
            false // followup
        );
        if (t != null) {
            insert t;
        }
        List<Task> ts = [SELECT Id, isClosed FROM Task WHERE Subject = 'Vergleich prüfen'];
        System.assertEquals(1, ts.size());
        System.assertEquals(false, ts[0].isClosed);

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());

        ts = [SELECT Id, isClosed FROM Task WHERE Subject = 'Vergleich prüfen'];
        System.assertEquals(1, ts.size());
        System.assertEquals(true, ts[0].isClosed);
    }

    @isTest
    public static void testNoBank() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        a.Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        o.Contact__c = con.Id;
        o.Bank__c = null; // !!
        o.Legal_Account__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen "Kreditinstitut" auf der Anfrage.').getUrl(), pr.getUrl());
    }

    @isTest
    public static void testNoRSV() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        a.Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = null; // !!
        o.Contact__c = con.Id;
        o.Bank__c = a.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen "Rechtsschutzversicherung" auf der Anfrage.').getUrl(), pr.getUrl());
    }

    // SEND MAILS

    @isTest
    public static void testMailLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        a.Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        o.Contact__c = con.Id;
        o.Bank__c = a.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }

    @isTest
    public static void testMailJc() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        a.Name = 'J & C Anwälte';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        o.Contact__c = con.Id;
        o.Bank__c = a.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }

    @isTest
    public static void testMailCllb() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        a.Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB';
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        o.Contact__c = con.Id;
        o.Bank__c = a.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        User u = TestData.createUser();
        insert u;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ArrangementAudited oe = new ArrangementAudited(sc);

        PageReference pr = oe.renderPage();
        System.assertNotEquals(null, pr);
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }
}