@isTest
public class QuestionToBackofficeTest {
    private static Claim__c createOpp(string accname) {
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = TestData.createUser();
        u.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
		o.Backoffice__c = u.Id;
		insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Legal__c = u.Id
        );
        insert c;
		Task task =  Utilities.createTask('Frage des Anwalts', 'foobarbaz', c, u, System.today(), false, false);
        insert task;
        return c;
    }

    @isTest
    private static void testVH24() {
        Claim__c c = createOpp('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        update c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        QuestionToBackoffice oe = new QuestionToBackoffice(sc);

        // Act
        oe.parDescription = 'foo bar world';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVR24() {
        Claim__c c = createOpp('VR24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        update c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        QuestionToBackoffice oe = new QuestionToBackoffice(sc);

        // Act
        oe.parDescription = 'foo bar world';
        PageReference pr = oe.renderPage();
    }
}