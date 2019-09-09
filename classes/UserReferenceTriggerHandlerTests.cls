@isTest
public class UserReferenceTriggerHandlerTests {
	@isTest
	static void testInsert() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		user.CompanyName = '';
		user.Account_Id__c = '';
		insert user;
		Account account = TestData.createAccount();
		account.Type = 'Legal Office';
		insert account;
		User_Reference__c userReference = TestData.createUserReference(account.Id,user.Id);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert userReference;

		Test.stopTest();

		// Assertion
		user = [select Id,CompanyName,Account_Id__c from User where Id = :user.Id];

		System.assert(user.Account_Id__c == account.Id);
		System.assert(user.CompanyName == account.Name);
	}

	@isTest
	static void testUpdateUser() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createAccount();
		account.Type = 'Legal Office';
		insert account;
        
		User oldUser = TestData.createUser();
		insert oldUser;
		User_Reference__c userReference = TestData.createUserReference(account.Id,oldUser.Id);
		insert userReference;

        User newUser = TestData.legalUser();
		newUser.CompanyName = '';
		newUser.Account_Id__c = '';
        System.runAs(TestData.bypassUser()) {
        	insert newUser;   
        }
        
		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		userReference.User__c = newUser.Id;
		update userReference;

		Test.stopTest();

		// Assertion
		newUser = [select Id,CompanyName,Account_Id__c from User where Id = :newUser.Id];
		System.assert(newUser.Account_Id__c == account.Id);
		System.assert(newUser.CompanyName == account.Name);
	}

	@isTest
	static void testUpdateAccount() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account oldAccount = TestData.createAccount();
		oldAccount.Type = 'Legal Office';
		insert oldAccount;
		User user = TestData.createUser();
		user.UserName = 'user@test.de';
		user.CompanyName = oldAccount.Name;
		user.Account_Id__c = oldAccount.Id;
		insert user;
		Account newAccount = TestData.createAccount();
		newAccount.Name = 'New Account';
		newAccount.Type = 'Legal Office';
		insert newAccount;
		User_Reference__c userReference = TestData.createUserReference(oldAccount.Id,user.Id);
		insert userReference;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		userReference.Account__c = newAccount.Id;
		update userReference;

		Test.stopTest();

		// Assertion
		user = [select Id,CompanyName,Account_Id__c from User where Id = :user.Id];

		System.assert(user.CompanyName == newAccount.Name);
		System.assert(user.Account_Id__c == newAccount.Id);
	}
}