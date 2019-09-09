@IsTest
private class InvoiceRemindersTest {
	@isTest
	static void testSuccess() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Amount__c = 100;
		invoice.Stage__c = 'Sent';
		invoice.Disable_Dunning__c = false;
		invoice.Date__c = System.today() - 21;
		invoice.Payment_Term__c = 7;
		insert invoice;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();
		InvoiceReminders.autoCreateInvoiceReminders();
		Test.stopTest();

		// Assertion
		List<Invoice_Reminder__c> invoiceReminders = [SELECT Id FROM Invoice_Reminder__c WHERE Invoice__c = :invoice.Id];
		System.assertEquals(1,invoiceReminders.size());
	}

	@isTest
	static void testDunningDisabled() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Amount__c = 100;
		invoice.Stage__c = 'Sent';
		invoice.Disable_Dunning__c = true;
		invoice.Date__c = System.today() - 21;
		invoice.Payment_Term__c = 7;
		insert invoice;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();
		InvoiceReminders.autoCreateInvoiceReminders();
		Test.stopTest();

		// Assertion
		List<Invoice_Reminder__c> invoiceReminders = [SELECT Id FROM Invoice_Reminder__c WHERE Invoice__c = :invoice.Id];
		System.assertEquals(0,invoiceReminders.size());
	}
}