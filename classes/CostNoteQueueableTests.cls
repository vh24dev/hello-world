// Legacy
@IsTest
private class CostNoteQueueableTests {
	@isTest
	static void test() {
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
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);

        TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		CostNoteQueueable queueable = new CostNoteQueueable();
		queueable.insertCostNotes.put(costNote,new List<Cost_Note_Line_Item__c>{costNoteLineItem});
		System.enqueueJob(queueable);

		Test.stopTest();

		// Assertion
		//Assertion not possible
	}
}