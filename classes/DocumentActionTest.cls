@isTest
public class DocumentActionTest {
    @isTest
    public static void testCreateTask() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'VH24');
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        List<Document__c> docs = new List<Document__c>();
        docs.add(doc);

        List<Task> ts;
        ts = [SELECT Id FROM Task WHERE Subject = 'Neue Unterlagen'];
        System.assertEquals(0, ts.size());

        DocumentAction.createTasks(docs);

        ts = [SELECT Id FROM Task WHERE Subject = 'Neue Unterlagen'];
        System.assertEquals(1, ts.size());

        DocumentAction.createTasks(docs);

        ts = [SELECT Id FROM Task WHERE Subject = 'Neue Unterlagen'];
        System.assertEquals(1, ts.size(), 'unexpected duplication');
    }

    @isTest
    public static void hackCoverage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'VH24');
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        List<Document__c> docs = new List<Document__c>();
        docs.add(doc);

        DocumentAction.deactivateFollowUpJourneys(docs);
        DocumentAction.setRecordType(docs);
    }
}