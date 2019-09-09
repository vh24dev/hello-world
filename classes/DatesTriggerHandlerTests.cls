@isTest
public class DatesTriggerHandlerTests {
	/*@isTest
	static void testHash(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

        User u = TestData.legalUser();
		System.runAs(TestData.bypassUser()) {
			insert u;
		}

		Opportunity opportunity = TestData.createOpportunity(null, 'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = u.Id;
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert thisDate;

		Test.stopTest();

		// Assertion
		thisDate = [select Id, Form_Hash_1__c from Date__c where Id = :thisDate.Id];
		System.assert(thisDate.Form_Hash_1__c != null);
	}
    
    /*@isTest
	static void testCreateObjects(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User u = TestData.legalUser();
		System.runAs(TestData.bypassUser()) {
			insert u;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Legal__c = u.Id;
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		thisDate.Type__c = 'Gerichtstermin';
		insert thisDate;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		thisDate.Representative__c = contact.Id;
		thisDate.Representative_Confirmation_Date__c = System.now();
		update thisDate;

		Test.stopTest();

		// Assertion
		thisDate = [select Id,(select Id from Date_Notifications__r),(select Id from Date_Records__r),(select Id from Date_Authorizations__r) from Date__c where Id = :thisDate.Id];
		System.assertEquals(1,thisDate.Date_Notifications__r.size());
		System.assertEquals(1,thisDate.Date_Records__r.size());
		System.assertEquals(1,thisDate.Date_Authorizations__r.size());
	}*/
}