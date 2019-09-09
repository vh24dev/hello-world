@isTest
public class ClaimTasksTest {
    @testsetup
    public static void createClaim() {
        Test.startTest();
        TriggerConfiguration.allInactive = true;
        System.runAs(TestData.bypassUser()) {
            Contact con = new Contact(
                LastName = 'foo',
                Email = 'bar@baz.de'
            );
            insert con;
            Account a = TestData.createAccount();
            insert a;
            Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
            o.Contact__c = con.Id;
            User u = TestData.legalUser();
            u.bypass_process_builder__c = true;
            u.LastName = 'J&C Anwälte';
            insert u;
            o.Legal__c = u.Id;
            insert o;
            Claim__c c = new Claim__c(
                Opportunity__c = o.Id,
                Customer_Is_Owner__c = false,
                Clerk__c = u.Id,
                Legal__c = u.Id,
                stage__c = 'Lawsuit',
                RecordTypeId = Claims.dieselskandalRecordType()
            );
            insert c;
            Correspondence__c corr = new Correspondence__c(
                Type__c = 'Klageschrift',
                Claim__c = c.Id
            );
            insert corr;
        }
        Test.stopTest();
    }

    @isTest
    public static void testStageBerufungsprozess() { // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-59
		TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        Contact con = new Contact(
            LastName = 'Foo',
            Email = 'bar@baz.de'
        );
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = con.Id;
        User u = [SELECT ID, isActive FROM User WHERE LastName = 'J&C Anwälte'];
        o.Legal__c = u.Id;
        insert o;
        Claim__c cl = new Claim__c(
            RecordTypeId = claims.lebensversicherungRecordType(),
            Opportunity__c = o.Id,
            Stage__c = 'Processing',
            Result__c = 'Partially won',
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Without Appeal',
            Legal__c = u.Id,
            Clerk__c = u.Id
        );
        insert cl;
        cl = [SELECT ID, Stage__c FROM Claim__c WHERE ID = :cl.Id];
        System.assertEquals('Processing', cl.Stage__c);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(0, ts.size());

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT ID, Stage__c FROM Claim__c WHERE ID = :cl.Id];
        System.assertEquals('Processing', cl.Stage__c);

        ts = [SELECT Id FROM Task WHERE Subject = 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren'];
        System.assertEquals(1, ts.size());
    }

    /*
    // TODO: soql limit
    @isTest
    public static void testKlageDokumentieren() { // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-38
        TriggerConfiguration.allInactive = true;
        Claim__c c = [SELECT ID FROM Claim__c];
        User u = [SELECT ID, isActive FROM User WHERE LastName = 'J&C Anwälte'];
        Date__c d = new Date__c(
            Subject__c = 'foo',
            Date__c = System.today().addDays(-222),
            Claim__c = c.Id
        );
        insert d;
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Ergebnis der Klage dokumentieren'];
        System.assertEquals(0, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Mandanteninfo versenden'];
        System.assertEquals(0, ts.size());

        TriggerConfiguration.allInactive = false;
        d.Date__c = System.today().addDays(-2222);
        update d;
        c.Customer_Is_Owner__c = true;
        update c;

        ts = [SELECT Id FROM Task WHERE Subject = 'Ergebnis der Klage dokumentieren'];
        System.assertEquals(1, ts.size());
        ts = [SELECT Id FROM Task WHERE Subject = 'Mandanteninfo versenden'];
        System.assertEquals(1, ts.size());
    }
	*/

    @isTest
    public static void testKlagedokumenteDG() { // https://trello.com/c/A7wrn6xK/492-dg-task-klagedokumente-pr%C3%BCfen
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Customer_Is_Owner__c = false,
            Clerk__c = u.Id,
            stage__c = 'Lawsuit',
            RecordTypeId = Claims.dieselskandalRecordType()
        );
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Type__c = 'Klageschrift',
            Claim__c = c.Id
        );
        insert corr;
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Klagedokumente prüfen'];
        System.assertEquals(0, ts.size());

		TriggerConfiguration.allInactive = false;
        c.Customer_Is_Owner__c = true;
        update c;

        ts = [SELECT Id FROM Task WHERE Subject = 'Klagedokumente prüfen'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    public static void testKlageschrift() { // https://trello.com/c/ETZVnWjM/490-lv-korrespondenz-klageschrift-task-klageschrift-versenden
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        insert a;
        User lu = [SELECT ID, isActive FROM User WHERE LastName = 'J&C Anwälte'];
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Claim__c c = new Claim__c(
            result__c = 'Partial', // for task coverage
            submission_Date_Before_Claim_Statement__c = System.today(), // for coverage
            Opportunity__c = o.Id,
            Customer_Is_Owner__c = false,
            Clerk__c = u.Id,
            stage__c = 'Lawsuit',
            Legal__c = lu.Id,
            cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Appeal',
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Type__c = 'Klageschrift',
            Claim__c = c.Id
        );
        insert corr;

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Klageschrift versenden'];
        System.assertEquals(0, ts.size());

		TriggerConfiguration.allInactive = false;
        update c;

        ts = [SELECT Id FROM Task WHERE Subject = 'Klageschrift versenden'];
        System.assertEquals(1, ts.size());
    }
}