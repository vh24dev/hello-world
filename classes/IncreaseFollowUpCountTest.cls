@isTest
public class IncreaseFollowUpCountTest {
    private static Opportunity createOpp() {
        TriggerConfiguration.allInactive = true;
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        return o;
    }

    @isTest
    private static void testVarNull() {
        User u = TestData.createUser();
        insert u;
        Opportunity o = createOpp();
        o.RecordTypeId = Opportunities.dieselskandalRecordType();
        o.Callcenter__c = u.Id;
        insert o;
        o = [SELECT Id FROM Opportunity WHERE Id = :o.Id];
        o.StageName = 'New';
        upsert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        IncreaseFollowUpCount oe = new IncreaseFollowUpCount(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(1, o.Follow_up_Count__c);
        System.assertEquals(new PageReference('/' + o.Id).getUrl(), pr.getUrl());
        Task[] ts = [
            SELECT ID
            FROM Task
            WHERE OwnerId = :u.ID
        ];
        System.assertEquals(0, ts.size());
    }

    @isTest
    private static void testVar3() {
        Opportunity o = createOpp();
        User u = TestData.createUser();
        insert u;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        o.Follow_up_Variant__c = '3';
        o.Follow_up_Count__c = 44;
        o.Callcenter__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        IncreaseFollowUpCount oe = new IncreaseFollowUpCount(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(45, o.Follow_up_Count__c);
        System.assertEquals(new PageReference('/' + o.Id).getUrl(), pr.getUrl());
        Task[] ts = [
            SELECT ID
            FROM Task
            WHERE OwnerId = :u.ID
        ];
        System.assertEquals(0, ts.size());
    }

    @isTest
    private static void testCreateTask() {
        User u = TestData.createUser();
        insert u;
        Opportunity o = createOpp();
        o.RecordTypeId = Opportunities.lebensversicherungRecordType();
        o.StageName = 'New';
        o.Callcenter__c = u.Id;
        o.Confirmed_Terms_And_Conditions__c = false;
        o.Follow_up_Variant__c = '3';
        o.Follow_up_Count__c = 44;
        insert o;
        o = [SELECT Id FROM Opportunity WHERE Id = :o.Id];
        o.StageName = 'New';
        upsert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        IncreaseFollowUpCount oe = new IncreaseFollowUpCount(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(45, o.Follow_up_Count__c);
        System.assertEquals(new PageReference('/' + o.Id).getUrl(), pr.getUrl());

        Task[] ts = [
            SELECT ID,
            Subject,
            Description,
            Follow_Up_Task__c,
            ActivityDate,
            Status
            FROM Task
            WHERE OwnerId = :u.ID
            AND Subject LIKE 'AGB/Follow-up%'
        ];

        System.assertEquals(1, ts.size());
        Task t = ts[0];
        System.assertEquals('AGB/Follow-up #45', t.subject);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertEquals(Date.today() + 3, t.activityDate);
        System.assertNotEquals('Completed', t.status);
    }

    @isTest
    private static void testCloseTask() {
        User u = TestData.createUser();
        insert u;
        Opportunity o = createOpp();
        o.RecordTypeId = Opportunities.lebensversicherungRecordType();
        o.StageName = 'New';
        o.Callcenter__c = u.Id;
        o.Confirmed_Terms_And_Conditions__c = false;
        o.Follow_up_Variant__c = '3';
        o.Follow_up_Count__c = 44;
        insert o;
        o = [SELECT Id, Follow_up_Count__c FROM Opportunity WHERE Id = :o.Id];
        o.StageName = 'New';
        upsert o;
        Task closeTask = Tasks.build(
            'AGB/Follow-up #' + o.Follow_up_Count__c, // subject
            null, // description
            o, // parentObj
            u, // owner
            Date.today() + 3, // due date
            true, // noDuplicates
            o.Follow_up_Count__c > 0 // isFollowUpTask
        );
        insert closeTask;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        IncreaseFollowUpCount oe = new IncreaseFollowUpCount(sc);

        // Act
        PageReference pr = oe.renderPage();

        Task[] ts = [
            SELECT ID
            FROM Task
            WHERE OwnerId = :u.ID
            AND Subject LIKE 'AGB/Follow-up%'
        ];
        System.assertEquals(2, ts.size());
        ts = [
            SELECT ID,
            Subject,
            Description,
            Follow_Up_Task__c,
            ActivityDate,
            Status
            FROM Task
            WHERE OwnerId = :u.ID
            AND Status <> 'Completed'
            AND Subject LIKE 'AGB/Follow-up%'
        ];
        System.assertEquals(1, ts.size());
        Task t = ts[0];
        System.assertEquals('AGB/Follow-up #45', t.subject);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertEquals(Date.today() + 3, t.activityDate);
        System.assertNotEquals('Completed', t.status);
    }
}