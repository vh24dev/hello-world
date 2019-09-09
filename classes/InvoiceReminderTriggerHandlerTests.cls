@isTest
public class InvoiceReminderTriggerHandlerTests {
	@isTest
	static void testNotTestVR24() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createVR24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
		opportunity.Test__c = false;
		insert opportunity;
        User user = TestData.createUser();
		insert user;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Accounting__c = user.Id;
		insert invoice;
		Invoice_Reminder__c oldInvoiceReminder = TestData.createInvoiceReminder(invoice.Id,'Draft');
		oldInvoiceReminder.Number__c = '2017000001/IRVR';
		List<Invoice_Reminder__c> invoiceReminders = new List<Invoice_Reminder__c>();
		for (Integer i=0;i<20;i++){
			invoiceReminders.add(TestData.createInvoiceReminder(invoice.Id,'Draft'));
		}

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert oldInvoiceReminder;

		TriggerConfiguration.allInactive = false;
		insert invoiceReminders;
		Test.stopTest();

		// Assertion
		invoiceReminders = [select Id,Number__c from Invoice_Reminder__c where Id IN :invoiceReminders];

		Integer i = 1;
		for (Invoice_Reminder__c invoiceReminder : invoiceReminders){
			System.assert(invoiceReminder.Number__c.endsWith(String.valueOf(i+1) + '/IRVR'));
			i++;
		}
	}

	@isTest
	static void testNotTestVH24() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createVH24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
		opportunity.Test__c = false;
		insert opportunity;
        User user = TestData.createUser();
		insert user;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Accounting__c = user.Id;
		insert invoice;
		Invoice_Reminder__c oldInvoiceReminder = TestData.createInvoiceReminder(invoice.Id,'Draft');
		oldInvoiceReminder.Number__c = '2017000001/IRVH';
		List<Invoice_Reminder__c> invoiceReminders = new List<Invoice_Reminder__c>();
		for (Integer i=0;i<20;i++){
			invoiceReminders.add(TestData.createInvoiceReminder(invoice.Id,'Draft'));
		}

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert oldInvoiceReminder;

		TriggerConfiguration.allInactive = false;
		insert invoiceReminders;
		Test.stopTest();

		// Assertion
		invoiceReminders = [select Id,Number__c from Invoice_Reminder__c where Id IN :invoiceReminders];

		Integer i = 1;
		for (Invoice_Reminder__c invoiceReminder : invoiceReminders){
			System.assert(invoiceReminder.Number__c.endsWith(String.valueOf(i+1) + '/IRVH'));
			i++;
		}
	}

	@isTest
	static void testTest() {

		// Testsetup
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createVH24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
		opportunity.Test__c = true;
		insert opportunity;
        User user = TestData.createUser();
		insert user;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Accounting__c = user.Id;
		insert invoice;
		Invoice_Reminder__c oldInvoiceReminder = TestData.createInvoiceReminder(invoice.Id,'Draft');
		oldInvoiceReminder.Number__c = '2017000001/IRVH';
		List<Invoice_Reminder__c> invoiceReminders = new List<Invoice_Reminder__c>();
		for (Integer i=0;i<20;i++){
			invoiceReminders.add(TestData.createInvoiceReminder(invoice.Id,'Draft'));
		}

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert oldInvoiceReminder;

		TriggerConfiguration.allInactive = false;
		insert invoiceReminders;
		Test.stopTest();

		// Assertion
		invoiceReminders = [select Id,Number__c from Invoice_Reminder__c where Id IN :invoiceReminders];

		for (Invoice_Reminder__c invoiceReminder : invoiceReminders){
			System.assert(invoiceReminder.Number__c.endsWith('00/Test'));
		}
	}
}