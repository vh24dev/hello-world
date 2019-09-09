@isTest
public class DocumentTriggerHandlerTest {
    @isTest
    public static void testDeactivateJourney() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Auto_Follow_up_Date__c = System.today();
        insert o;
        Document__c document = new Document__c(
            Opportunity__c = o.Id,
            Name = 'TestName',
            Type__c = 'Other',
            Source__c = 'Other',
            Link__c = 'http://foo.bar'
        );
        Test.startTest();
        insert document;
        update document;
        Test.stopTest();

        o = [SELECT Id, Auto_Follow_up_Date__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(null, o.Auto_Follow_up_Date__c);
    }

    @isTest
    public static void testCreateTask() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Auto_Follow_up_Date__c = System.today();
        insert o;
        Document__c document = new Document__c(
            Opportunity__c = o.Id,
            Name = 'TestName',
            Type__c = 'Other',
            Source__c = 'Other',
            Link__c = 'http://foo.bar'
        );

		List<Task> ts = [SELECT ID FROM Task WHERE Subject = 'Neue Unterlagen'];
        System.assertEquals(0, ts.size());

        Test.startTest();
        insert document;
        Test.stopTest();

        ts = [SELECT ID FROM Task WHERE Subject = 'Neue Unterlagen'];
        System.assertEquals(1, ts.size());
    }
}