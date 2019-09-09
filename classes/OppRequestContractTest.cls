@isTest
public class OppRequestContractTest {
    private static Opportunity createOpp() {
        PageReference p = Page.OppRequestContract;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createAccount();
        vh24.name = 'VH24';
        Account vr24 = TestData.createAccount();
        vr24.name = 'VR24';
        insert new Account[]{vh24, vr24};

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        User u = TestData.createUser();
        u.UserName = 'foo@barbazbang.de';
        insert u;
        o.Callcenter__c = u.Id;
        return o;
    }

    @isTest
    private static void testLvSendMailNoBackoffice() {
        Account a = new Account(
            Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        Opportunity o = createOpp();
        o.Contact__c = con.Id;
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        System.assertEquals(Errors.page('Bitte tragen Sie einen aktiven Backoffice Mitarbeiter auf der Anfrage ein.').getUrl(), pr.getUrl());

        txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());
		*/
    }

    @isTest
    private static void testLvSendMailNoContact() {
        Account a = new Account(
            Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = createOpp();
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        System.assertEquals(Errors.page('Bitte tragen Sie ein Kontakt auf dem Feld "Kunde" ein.').getUrl(), pr.getUrl());

        txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());
		*/
    }

    @isTest
    private static void testLvSendMailJaeger() {
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        insert a;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        Opportunity o = createOpp();
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Contact__c = con.Id;
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Insurance', res.Partner__c);

        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(1, corrs.size());
		*/
    }

    @isTest
    private static void testLvSendMailLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        Opportunity o = createOpp();
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Contact__c = con.Id;
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());
        List<Task> ts = new List<Task>();
        ts = [SELECT Id, Subject FROM Task where not(subject like '%Bearbeitungsnummer%' or subject = 'Dokumentenerhalt prüfen und an Anwalt übergeben')];
        System.assertEquals(0, ts.size(), 'tasks exist already: ' + ts);
        TriggerConfiguration.allInactive = false;

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Insurance', res.Partner__c);

        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(1, corrs.size());

        ts = [SELECT id FROM Task where not(subject like '%Bearbeitungsnummer%' or subject = 'Dokumentenerhalt prüfen und an Anwalt übergeben')];
        System.assertEquals(1, ts.size(), 'no task created');
        ts = [
            SELECT Id
            FROM Task
            WHERE Subject = 'Wiedervorlage bzgl. Vertrag'
        ];
        System.assertEquals(1, ts.size(), 'tasks dont match: ' + ts);
		*/
    }

    @isTest
    private static void testLvSendMailKainz() {
        Account a = new Account(
            Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        Opportunity o = createOpp();
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Contact__c = con.Id;
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());
        List<Task> ts = new List<Task>();
        ts = [SELECT Id, Subject FROM Task where not(subject like '%Bearbeitungsnummer%' or subject = 'Dokumentenerhalt prüfen und an Anwalt übergeben')];
        System.assertEquals(0, ts.size(), 'tasks exist already: ' + ts);

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Insurance', res.Partner__c);

        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(1, corrs.size());

        ts = [SELECT id FROM Task where not(subject like '%Bearbeitungsnummer%' or subject = 'Dokumentenerhalt prüfen und an Anwalt übergeben')];
        System.assertEquals(1, ts.size(), 'no task created');
        ts = [
            SELECT Id
            FROM Task
            WHERE Subject = 'Wiedervorlage bzgl. Vertrag'
        ];
        System.assertEquals(1, ts.size(), 'tasks dont match: ' + ts);
		*/
    }

    @isTest
    private static void testDieselSkandalTextModules() {
        Account a = new Account(
            Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = createOpp();
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        o.Contact__c = con.Id;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Opportunity_Text_Module__c> txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(0, txt.size());
        List<Opportunity_Correspondence__c> corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(0, corrs.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Bank', res.Partner__c);

        txt = [SELECT ID FROM Opportunity_Text_Module__c];
        System.assertEquals(1, txt.size());
        corrs = [SELECT Id FROM Opportunity_Correspondence__c];
        System.assertEquals(1, corrs.size());
		*/
    }

    @isTest
    private static void testDieselSkandal() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        o.Contact__c = con.Id;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Bank', res.Partner__c);
		*/
    }

    @isTest
    private static void testLebensversicherung() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Contact__c = con.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Insurance', res.Partner__c);
		*/
    }

    @isTest
    private static void testLvJcCreateTask() {
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv001';
        insert a;
        Opportunity o = createOpp();
        o.Legal_Account__c = a.Id;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        o.Contact__c = con.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Backoffice__c = u.ID;
        o.Insurance__c = a.ID;
        o.Termination_Date__c = System.today().addDays(2);
        o.Expiration_Date__c = System.today().addDays(4);
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Vertrag'];
        System.assertEquals(0, ts.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Vertrag'];
        System.assertEquals(1, ts.size());
		*/
    }

    @isTest
    private static void testFzJcCreateTask() {
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = createOpp();
        o.Legal_Account__c = a.Id;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        o.Contact__c = con.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Backoffice__c = u.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Darlehensvertrag'];
        System.assertEquals(0, ts.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        ts = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Wiedervorlage bzgl. Darlehensvertrag'];
        System.assertEquals(1, ts.size());
        System.assertEquals(System.today().addDays(14), ts[0].ActivityDate);
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Bank', res.Partner__c);
		*/
    }

    @isTest
    private static void testDgJcCreateTask() {
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Account a = new Account(
            Name = 'J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = createOpp();
        o.Legal_Account__c = a.Id;
        Contact con = new Contact(LastName = 'bar', Email = 'Foo@bar.de');
        insert con;
        o.Contact__c = con.Id;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Backoffice__c = u.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppRequestContract oe = new OppRequestContract(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Darlehensvertrag'];
        System.assertEquals(0, ts.size());

        Test.startTest();
        PageReference pr = oe.renderPage();
        Test.stopTest();

        /*
        ts = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Wiedervorlage bzgl. Darlehensvertrag'];
        System.assertEquals(1, ts.size());
        System.assertEquals(System.today().addDays(14), ts[0].ActivityDate);
        Opportunity_Correspondence__c res = [SELECT Id, Partner__c FROM Opportunity_Correspondence__c WHERE Opportunity__c = :o.Id];
        System.assertEquals('Bank', res.Partner__c);
		*/
    }
}