@isTest
public class TestCaseTriggerHandlerTests {
	@isTest
	static void testSetToken(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Opportunity opportunity = TestData.createOpportunity(null, 'New');
		insert opportunity;
		Test_Case__c testCase = TestData.createTestCase(opportunity.Id);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();
		insert testCase;
		Test.stopTest();

		// Assertion
		testCase = [SELECT Id, Token__c FROM Test_Case__c WHERE Id = :testCase.Id];
		System.assertNotEquals(null, testCase.Token__c);
	}

	@isTest
	static void testSetHash(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Opportunity opportunity = TestData.createOpportunity(null, 'New');
		insert opportunity;
		Test_Case__c testCase = TestData.createTestCase(opportunity.Id);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert testCase;

		Test.stopTest();

		// Assertion
		testCase = [select Id, Form_Hash_1__c, Form_Hash_2__c from Test_Case__c where Id = :testCase.Id];
		System.assert(testCase.Form_Hash_1__c != null);
		System.assert(testCase.Form_Hash_2__c != null);
	}
    
    @isTest
	static void testAutoJourney(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Opportunity opportunity = TestData.createOpportunity(null, 'New');
		insert opportunity;
		Test_Case__c testCase = TestData.createTestCase(opportunity.Id);
		testCase.Status__c = 'Finished';
		testCase.Auto_Follow_up_Count__c = 4;
		testCase.Autostart_Auto_Follow_up_Journeys__c = true;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert testCase;

		Test.stopTest();

		// Assertion
		testCase = [select Id, Auto_Follow_up_Date__c, Auto_Follow_up_Count__c, Started_Auto_Follow_up_Journey_1__c from Test_Case__c where Id = :testCase.Id];
		System.assertNotEquals(null,testCase.Auto_Follow_up_Date__c);
		System.assertEquals(0, testCase.Auto_Follow_up_Count__c);
		System.assertEquals(true, testCase.Started_Auto_Follow_up_Journey_1__c);
	}

	@isTest
	static void testAutoSendFinished(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Test_Case__c testCase = TestData.createTestCase(opportunity.Id);
		insert testCase;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		testCase.Status__c = 'Finished'; 
		update testCase;

		Test.stopTest();

		// Assertion - todo: what to assert?
		//List<Task> tasks = [select Id from Task where Subject LIKE 'Email:%' AND WhatId = :testCase.Id];
		//System.assertEquals(1,tasks.size());
	}
}