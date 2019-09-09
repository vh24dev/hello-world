@isTest
public class CorrespondencesTasksTest {
    // ============
    // create tests
    // ============

    /* * * * * * * *
     * New tests:  *
     * unit        *
     * * * * * * * */

    @isTest
    public static void testDontBreakOnInvalidOwner() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = null,
            Clerk_Appeal__c = null,
            Legal__c = null,
            Cover_Note_Scope__c = 'Appeal',
            Result__c = 'Accepted'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Fristverlängerung',
            Stage__c = 'Sent'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage für Berufung',
            Stage__c = 'Sent'
        );
        insert corr2;
        Correspondence__c corr3 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Berufungsschrift',
            Stage__c = 'Sent'
        );
        insert corr3;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);
        corrs.add(corr3);

        CorrespondencesTasks.create(corrs);
    }

    @isTest
    public static void testCreateWiedervorlageErstellen1() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id,
            Cover_Note_Scope__c = 'Appeal',
            Result__c = 'Accepted'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Widerspruch durch Kunden',
            Stage__c = 'Sent'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Anspruchsschreiben',
            Stage__c = 'Sent'
        );
        insert corr2;
        Correspondence__c corr3 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Klageschrift',
            Stage__c = 'Sent'
        );
        insert corr3;
        Correspondence__c corr4 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Gerichtskostenrechnung',
            Stage__c = 'Sent'
        );
        insert corr4;
        Correspondence__c corr5 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Replik',
            Stage__c = 'Sent'
        );
        insert corr5;
        Correspondence__c corr6 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Vollmacht §141 ZPO',
            Stage__c = 'Sent'
        );
        insert corr6;
        Correspondence__c corr7 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben',
            Stage__c = 'Sent'
        );
        insert corr7;
        Correspondence__c corr8 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage für Klage',
            Stage__c = 'Sent'
        );
        insert corr8;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);
        corrs.add(corr3);
        corrs.add(corr4);
        corrs.add(corr5);
        corrs.add(corr6);
        corrs.add(corr7);
        corrs.add(corr8);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruch durch Kunden'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Anspruchsschreiben'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Klageschrift'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Gerichtskostenrechnung'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Replik'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Vollmacht §141 ZPO'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Anspruchsschreiben'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Klage'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruch durch Kunden'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Anspruchsschreiben'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Klageschrift'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Gerichtskostenrechnung'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Replik'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Vollmacht §141 ZPO'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Anspruchsschreiben'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Klage'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateWiedervorlageErstellen2() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Clerk_Appeal__c = u.Id,
            Legal__c = u.Id,
            Cover_Note_Scope__c = 'Appeal',
            Result__c = 'Accepted'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Sonstiges',
            Stage__c = 'Sent'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige',
            Stage__c = 'Sent'
        );
        insert corr2;
        Correspondence__c corr3 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Fristverlängerung',
            Stage__c = 'Sent'
        );
        insert corr3;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);
        corrs.add(corr3);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Sonstiges'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Verteidigungsanzeige'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Fristverlängerung'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Sonstiges'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Verteidigungsanzeige'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Fristverlängerung'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateWiedervorlageErstellen3() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Clerk_Appeal__c = u.Id,
            Legal__c = u.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage für Berufung',
            Stage__c = 'Sent'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Berufungsschrift',
            Stage__c = 'Sent'
        );
        insert corr2;
        Correspondence__c corr3 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Berufungsbegründung',
            Stage__c = 'Sent'
        );
        insert corr3;
        Correspondence__c corr4 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Verteidigungsanzeige',
            Stage__c = 'Sent'
        );
        insert corr4;
        Correspondence__c corr5 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Sent'
        );
        insert corr5;
        Correspondence__c corr6 = new Correspondence__c(
            Claim__c = cl.Id,
            Wiedervorlage_erstellen__c = true,
            Type__c = 'Deckungsanfrage für Widerspruch',
            Stage__c = 'Sent'
        );
        insert corr6;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);
        corrs.add(corr3);
        corrs.add(corr4);
        corrs.add(corr5);
        corrs.add(corr6);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Berufung'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Berufungsschrift'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Berufungsbegründung'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Verteidigungsanzeige'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruchsschreiben'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruch'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Deckungsanfrage für Berufung'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Berufungsschrift'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Berufungsbegründung'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Verteidigungsanzeige'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruchsschreiben'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Wiedervorlage bzgl. Widerspruch'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateWiderspruchKundeAndDeckungsanfrage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Widerspruch durch Kunden',
            Stage__c = 'Draft'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Widerspruch',
            Stage__c = 'Draft'
        );
        insert corr2;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsvorlage an Kunden versenden'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Widerspruch versenden'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsvorlage an Kunden versenden'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Widerspruch versenden'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateWiderspruchAnwaltCMI() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        a.Type = 'Lebensversicherung';
		a.External_Id__c = 'lv004';
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        User lu = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert lu;
        }
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = lu.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Draft'
        );
        insert corr;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsart prüfen'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsart prüfen'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateWiderspruchAnwaltAndere() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        a.Type = 'Lebensversicherung';
		a.External_Id__c = 'lv003';
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        User lu = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert lu;
        }
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = lu.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Widerspruch durch Anwalt',
            Stage__c = 'Draft'
        );
        insert corr;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corr = [SELECT ID, Type__c, Stage__c FROM Correspondence__c WHERE ID = :corr.Id];
        System.assertEquals('Widerspruch durch Anwalt', corr.Type__c, 'the type changed');
        System.assertEquals('Draft', corr.Stage__c, 'the stage changed');

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsschreiben versenden'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Widerspruchsschreiben versenden'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateDeckungsanfrageAnspruchsschreibenKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben',
            Stage__c = 'Draft'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Anspruchsschreiben',
            Stage__c = 'Draft'
        );
        insert corr2;
        Correspondence__c corr3 = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Klage',
            Stage__c = 'Draft'
        );
        insert corr3;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);
        corrs.add(corr3);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Anspruchsschreiben versenden'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Anspruchsschreiben versenden'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Klage versenden'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Anspruchsschreiben versenden'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Anspruchsschreiben versenden'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungsanfrage für Klage versenden'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testCreateDeckungsanfrageBerufungAndAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben',
            Stage__c = 'Sent'
        );
        insert corr;
        Correspondence__c corr2 = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Berufung',
            Stage__c = 'Sent'
        );
        insert corr2;
        List<Correspondence__c> corrs = new List<Correspondence__c>();
        corrs.add(corr);
        corrs.add(corr2);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Deckungszusage für Anspruchsschreiben dokumentieren'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungszusage für Berufung dokumentieren'];
        System.assertEquals(0, ts.size());

        CorrespondencesTasks.create(corrs);

		ts = [SELECT Id FROM Task WHERE Subject = 'Deckungszusage für Anspruchsschreiben dokumentieren'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Deckungszusage für Berufung dokumentieren'];
        System.assertEquals(1, ts.size());
    }

    /* * * * * * * * *
     * Legacy tests: *
     * integration   *
     * * * * * * * * */

    /*
    @isTest
    static void testDraftLV1(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

        // Create test users and set their roles with admin user
        List<User> users = new List<User>();
        User backofficeUser = TestData.createUser();
        backofficeUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        backofficeUser.Username = 'backofficeUser@cloudworx.agency';
        users.add(backofficeUser);
        User legalUser = TestData.createUser();
        legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        legalUser.Username = 'legalUser@cloudworx.agency';
        users.add(legalUser);
        insert users;

        System.runAs(adminUser) {
            backofficeUser.UserRoleId = UserRoles.BackofficeID; // 00E0Y000000Hvlx
            update backofficeUser;
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

    	Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
		account.External_Id__c = 'lv004';
		insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Backoffice__c = backofficeUser.Id;
		opportunity.Sales_Type__c = 'Partner';
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        claim.Legal__c = legalUser.Id;
        claim.Clerk__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
        
        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
		insert correspondence;

		TriggerConfiguration.allInactive = false;
		correspondence.Type__c = 'Widerspruch durch Kunden';
		update correspondence;

		TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Deckungsanfrage für Widerspruch';
        update correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Widerspruch durch Anwalt';
        update correspondence;

		Test.stopTest();

		// Assertion
        correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
        Integer foundTasks = 0;
        for (Task task : correspondence.Tasks){
            if ((task.Subject == 'Widerspruchsvorlage an Kunden versenden') || (task.Subject == 'Deckungsanfrage für Widerspruch versenden') || (task.Subject == 'Widerspruchsschreiben versenden')){
                foundTasks++;
            }
        }
        System.assertEquals(3,foundTasks);
    }

    @isTest
    static void testDraftLV2(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

        // Create test users and set their roles with admin user
        List<User> users = new List<User>();
        User backofficeUser = TestData.createUser();
        backofficeUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        backofficeUser.Username = 'backofficeUser@cloudworx.agency';
        users.add(backofficeUser);
        User legalUser = TestData.createUser();
        legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        legalUser.Username = 'legalUser@cloudworx.agency';
        users.add(legalUser);
        insert users;

        System.runAs(adminUser) {
            backofficeUser.UserRoleId = UserRoles.BackofficeID; // 00E0Y000000Hvlx
            update backofficeUser;
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

    	Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
		account.External_Id__c = 'lv004';
		insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Backoffice__c = backofficeUser.Id;
		opportunity.Sales_Type__c = 'Partner';
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        claim.Legal__c = legalUser.Id;
        claim.Clerk__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
        
        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
		insert correspondence;

		TriggerConfiguration.allInactive = false;
		correspondence.Type__c = 'Widerspruch durch Kunden';
		update correspondence;

		TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Deckungsanfrage für Widerspruch';
        update correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Widerspruch durch Anwalt';
        update correspondence;

		Test.stopTest();

		// Assertion
        correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
        Integer foundTasks = 0;
        for (Task task : correspondence.Tasks){
            if ((task.Subject == 'Widerspruchsvorlage an Kunden versenden') || (task.Subject == 'Deckungsanfrage für Widerspruch versenden') || (task.Subject == 'Widerspruchsschreiben versenden')){
                foundTasks++;
            }
        }
        System.assertEquals(3, foundTasks);
    }

	@isTest
	static void testDraftFZ(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Clerk__c = legalUser.Id;
		claim.Legal__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Bank','Widerspruch durch Kunden','Draft');

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert correspondence;

		TriggerConfiguration.allInactive = false;
		correspondence.Type__c = 'Replik';
		update correspondence;

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		for (Task task : correspondence.Tasks){
			if ((task.Subject == 'Replik erstellen') || (task.Subject == 'Widerspruchsvorlage an Kunden versenden')){
				foundTasks++;
			}
		}
		System.assertEquals(2, foundTasks);
	}

    @isTest
    static void testDraftDG(){
        // Testsetup
        TriggerConfiguration.allInactive = true;

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

        // Create test users and set their roles with admin user
        List<User> users = new List<User>();
        User legalUser = TestData.createUser();
        legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        legalUser.Username = 'legalUser@cloudworx.agency';
        users.add(legalUser);
        insert users;

        System.runAs(adminUser) {
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.Legal__c = legalUser.Id;
		claim.Clerk__c = legalUser.Id;
        insert claim;
        Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Klageschrift','Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert correspondence;

        Test.stopTest();

        // Assertion
        correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
        Integer foundTasks = 0;
        for (Task task : correspondence.Tasks){
            if (task.Subject == 'Rückfrage zur Eigentümerschaft versenden'){
                foundTasks++;
            }
        }
        System.assertEquals(1, foundTasks);
    }

    @isTest
    static void testSentLV1(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

        // Create test users and set their roles with admin user
        List<User> users = new List<User>();
        User backofficeUser = TestData.createUser();
        backofficeUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        backofficeUser.Username = 'backofficeUser@cloudworx.agency';
        users.add(backofficeUser);
        User legalUser = TestData.createUser();
        legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        legalUser.Username = 'legalUser@cloudworx.agency';
        users.add(legalUser);
        insert users;

        System.runAs(adminUser) {
            backofficeUser.UserRoleId = UserRoles.BackofficeID; // 00E0Y000000Hvlx
            update backofficeUser;
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

    	Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Backoffice__c = backofficeUser.Id;
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Sent');
        
        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
		insert correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Deckungsanfrage für Widerspruch';
        update correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Widerspruch durch Anwalt';
        update correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Deckungsanfrage für Klage';
        update correspondence;

		Test.stopTest();

		// Assertion
        claim = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Claim__c WHERE Id = :claim.Id];
        Integer foundTasks = 0;
        for (Task task : claim.Tasks){
            if ((task.Subject.contains('Ergebnis')) || (task.Subject.contains('Deckungszusage'))){
                foundTasks++;
            }
        }
        System.assertEquals(4, foundTasks);
    }

    @isTest
    static void testSentLV2(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

        // Create test users and set their roles with admin user
        List<User> users = new List<User>();
        User backofficeUser = TestData.createUser();
        backofficeUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        backofficeUser.Username = 'backofficeUser@cloudworx.agency';
        users.add(backofficeUser);
        User legalUser = TestData.createUser();
        legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        legalUser.Username = 'legalUser@cloudworx.agency';
        users.add(legalUser);
        insert users;

        System.runAs(adminUser) {
            backofficeUser.UserRoleId = UserRoles.BackofficeID; // 00E0Y000000Hvlx
            update backofficeUser;
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

    	Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Backoffice__c = backofficeUser.Id;
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Sent');
        
        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
		insert correspondence;

        TriggerConfiguration.allInactive = false;
        correspondence.Type__c = 'Klageschrift';
        update correspondence;

		Test.stopTest();

		// Assertion
        claim = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Claim__c WHERE Id = :claim.Id];
        Integer foundTasks = 0;
        for (Task task : claim.Tasks){
            if (task.Subject.contains('Ergebnis')){
                foundTasks++;
            }
        }
        System.assertEquals(1, foundTasks);
    }

	@isTest
	static void testSentDG(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		List<User> users = new List<User>();
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		users.add(legalUser);
		insert users;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Legal__c = legalUser.Id;
		claim.Clerk__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Deckungsanfrage für Widerspruch','Sent');

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert correspondence;

		TriggerConfiguration.allInactive = false;
		correspondence.Type__c = 'Replik';
		update correspondence;

		Test.stopTest();

		// Assertion
		claim = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Claim__c WHERE Id = :claim.Id];
		Integer foundTasks = 0;
		for (Task task : claim.Tasks){
			if ((task.Subject.contains('Gerichtstermin')) || (task.Subject.contains('Deckungszusage für Widerspruch dokumentieren'))){
				foundTasks++;
			}
		}
		System.assertEquals(2, foundTasks);
	}
	*/

    // ============
    // close tests
    // ============

   @isTest
    static void testCanceled(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
        insert user;
    	Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        insert opportunity;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        claim.Clerk__c = u.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;
            
        List <Task> tasks = new List<Task>();
        tasks.add(TestData.createTask('Task 1',claim.Id,user.Id));
		tasks.add(TestData.createTask('Task 2',claim.Id,user.Id));
		insert tasks;
        
        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
		claim.Stage__c = 'Canceled';
        update claim;

        Test.stopTest();

		// Assertion
        correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
        Integer foundTasks = 0;
        for (Task task : correspondence.Tasks){
            for (Task oldtask : tasks){
                if (task.Subject == oldtask.Subject){
                    foundTasks++;
                }
            }
        }
        System.assertEquals(0, foundTasks);
    }

	@isTest
	static void testReceived(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Eingehend','Draft');
		// correspondence.RecordTypeId = 0120Y000000RLxj
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Auf Vollständigkeit/Frist prüfen, Dokument hochladen und als empfangen markieren',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		correspondence.Stage__c = 'Received';
		update correspondence;

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id,(select Id, Subject FROM Tasks WHERE isClosed = false) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		for (Task task : correspondence.Tasks){
			for (Task oldtask : tasks){
				if (task.Subject == oldtask.Subject){
					foundTasks++;
				}
			}
		}
		System.assertEquals(0, foundTasks);
	}
}