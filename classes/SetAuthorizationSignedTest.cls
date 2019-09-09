@isTest
public class SetAuthorizationSignedTest {
	@isTest
    static void testSetAuthorizationSignedSuccess(){
		TriggerConfiguration.allInactive = true;

        // Create test data
        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        insert opportunity;
        Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
        insert authorization;

        TriggerConfiguration.allInactive = false;
        
		// Test
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(authorization);
        SetAuthorizationSigned oe = new SetAuthorizationSigned(sc);
        oe.renderPage();
        
        Test.stopTest();

		// Assertion
		authorization = [select Id, Stage__c from Authorization__c where Id = :authorization.Id];
        System.assert(authorization.Stage__c == 'Signed');
    }

	@isTest
    static void TaskLegacy() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		insert authorization;
		Task task = TestData.createTask('Unterschriebene Vollmacht hochladen und Erhalt bestätigen',authorization.Id,user.Id);
		insert task;
		task = [select Id, isClosed from Task where Id = :task.Id];
        System.assertEquals(false, task.isClosed);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

        Apexpages.StandardController sc = new Apexpages.standardController(authorization);
        SetAuthorizationSigned oe = new SetAuthorizationSigned(sc);
        PageReference pr = oe.renderPage();

		Test.stopTest();

		// Assertion
		task = [select Id, isClosed from Task where Id = :task.Id];
        System.assertEquals(true, task.isClosed);
	}
}