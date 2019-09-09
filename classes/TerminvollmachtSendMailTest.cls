@isTest
public class TerminvollmachtSendMailTest {
    private static Opportunity createOpp(string legalname) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        return o;
    }

    /*@isTest
    private static void testNoRecipient() {
        Opportunity o = createOpp('Foo');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Subject__c = 'Foo',
            Date__c = System.today()
        );
        insert d;
        Date_Authorization__c da = new Date_Authorization__c(
            Date__c = d.Id
        );
        insert da;

        Apexpages.StandardController sc = new Apexpages.standardController(da);
        TerminvollmachtSendMail oe = new TerminvollmachtSendMail(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }*/

    @isTest
    private static void testDieselKainz() {
        Opportunity o = createOpp('Kainz');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Subject__c = 'Foo',
            Date__c = System.today(),
            Representative__c = con.Id
        );
        insert d;
        Date_Authorization__c da = new Date_Authorization__c(
            Date__c = d.Id
        );
        insert da;

        Apexpages.StandardController sc = new Apexpages.standardController(da);
        TerminvollmachtSendMail oe = new TerminvollmachtSendMail(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateAuthorization)));

        // send mail
        Test.setCurrentPage(pr);
        //EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungEmpty() {
        Opportunity o = createOpp('Foo');
        o.recordTypeId = Opportunities.finanzierungRecordType();
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Subject__c = 'Foo',
            Date__c = System.today(),
            Representative__c = con.Id
        );
        insert d;
        Date_Authorization__c da = new Date_Authorization__c(
            Date__c = d.Id
        );
        insert da;

        Apexpages.StandardController sc = new Apexpages.standardController(da);
        TerminvollmachtSendMail oe = new TerminvollmachtSendMail(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testLebensversicherungKainz() {
        Opportunity o = createOpp('Kainz');
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Subject__c = 'Foo',
            Date__c = System.today(),
            Representative__c = con.Id
        );
        insert d;
        Date_Authorization__c da = new Date_Authorization__c(
            Date__c = d.Id
        );
        insert da;

        Apexpages.StandardController sc = new Apexpages.standardController(da);
        TerminvollmachtSendMail oe = new TerminvollmachtSendMail(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateAuthorization)));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /*
    @isTest
    private static void testLebensversicherungCLLB() {
        Opportunity o = createOpp('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Date__c d = new Date__c(
        	Claim__c = c.Id,
            Subject__c = 'Foo',
            Date__c = System.today(),
            Representative__c = con.Id
        );
        insert d;
        Date_Authorization__c da = new Date_Authorization__c(
            Date__c = d.Id
        );
        insert da;

        Apexpages.StandardController sc = new Apexpages.standardController(da);
        TerminvollmachtSendMail oe = new TerminvollmachtSendMail(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateAuthorization)));

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
	*/
}