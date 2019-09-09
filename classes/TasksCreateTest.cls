@isTest
public class TasksCreateTest {
    /*
	@isTest
    public static void testCreateTaskNoDuplicates() {
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.customer_interaction_notes__c = 'foo bar baz';
        l.follow_up_Count__c = 2;
        l.Last_follow_up_task__c = System.today().addDays(-3);
        l.Callcenter__c = u.Id;
        l.customer_Reached__c = true;
        insert l;
        Task t = Tasks.build(
            'AGB/Kunde erreicht #2',
            l.customer_interaction_notes__c,
            l,
            u,
            l.follow_up_Period__c > 0 ? Date.today() + Integer.valueOf(l.follow_Up_Period__c) : Date.today(),
            true,	// no duplicates
            true // follow up l.follow_up_Count__c > 0
        );
        insert t;
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(1, ts.size());

        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id, description, subject FROM Task];
        System.assertEquals(1, ts.size());
        System.assertEquals('foo bar baz', ts[0].description);
        System.assertEquals('AGB/Kunde erreicht #2', ts[0].subject);
    }
    */

	@isTest
    public static void testCreateReachedTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.customer_interaction_notes__c = 'foo bar baz';
        l.follow_up_Count__c = 2;
        l.Last_follow_up_task__c = System.today().addDays(-5);
        l.Callcenter__c = u.Id;
        l.customer_Reached__c = true;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id, description, subject FROM Task];
        System.assertEquals(1, ts.size());
        System.assertEquals('foo bar baz', ts[0].description);
        System.assertEquals('AGB/Kunde erreicht #2', ts[0].subject);
    }

	@isTest
    public static void testNoCreateReachedTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.customer_interaction_notes__c = 'foo bar baz';
        l.follow_up_Count__c = 2;
        l.Last_follow_up_task__c = System.today().addDays(-4); // has to be 5 or more to create one
        l.Callcenter__c = u.Id;
        l.customer_Reached__c = true;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id, description, subject FROM Task];
        System.assertEquals(0, ts.size());
    }

	@isTest
    public static void testCreateFirstTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.follow_up_Count__c = 1;
        l.Last_follow_up_task__c = System.today().addDays(-3);
        l.Callcenter__c = u.Id;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        // expect none this task shpuld be created by the button
        ts = [SELECT Id FROM Task WHERE Subject = 'AGB/Kunde nicht erreicht #1'];
        System.assertEquals(0, ts.size());
    }

	@isTest
    public static void testCreateSecondTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.follow_up_Count__c = 2;
        l.Last_follow_up_task__c = System.today().addDays(-3);
        l.Callcenter__c = u.Id;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id FROM Task WHERE Subject = 'AGB/Kunde nicht erreicht #2'];
        System.assertEquals(1, ts.size());
    }

	@isTest
    public static void testCreateThirdTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.follow_up_Count__c = 3;
        l.Last_follow_up_task__c = System.today().addDays(-3);
        l.Callcenter__c = u.Id;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id FROM Task WHERE Subject = 'AGB/Kunde nicht erreicht #3'];
        System.assertEquals(1, ts.size());
    }

	@isTest
    public static void testCreateForthTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.follow_up_Count__c = 4;
        l.Last_follow_up_task__c = System.today().addDays(-3);
        l.Callcenter__c = u.Id;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        // no task should be created if follow up is bigger than 3
        ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());
    }

	@isTest
    public static void testCreateNoTask() {
        List<task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Lead l = TestData.createLead();
        l.follow_up_Count__c = 2;
        l.Last_follow_up_task__c = System.today().addDays(-2);
        l.Callcenter__c = u.Id;
        insert l;
        Test.startTest();
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
        Test.stopTest();

        ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());
    }
}