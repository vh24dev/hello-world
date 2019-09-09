@isTest (seeAllData = true)
public class IntegrateDropboxQueueableTest {

	@isTest
	static void test() {
		// Testsetup
		Utilities.deactivateTriggers();

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.Legal_Account__c = account.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Credit_Note__c creditNote = TestData.createCreditNote(claim.Id,'Draft');
		creditNote.Uploaded_To_Dropbox__c = false;
		insert creditNote;
		Credit_Note_Line_Item__c creditNoteLineItem = TestData.createCreditNoteLineItem(creditNote.Id,10000);
		insert creditNoteLineItem;
		Attachment attachment = TestData.createAttachment(creditNote.Id);
		insert attachment;

		IntegrateDropbox.noCallout = true;

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		List<List<String>> dropboxVariables = new List<List<String>>{new List<String>{'/Testpath/', attachment.Id, account.Id}};

		IntegrateDropboxQueueable queueable = new IntegrateDropboxQueueable();
		queueable.dropboxVariables.addAll(dropboxVariables);
		System.enqueueJob(queueable);

		test.StopTest();

		// Assertion
		// No assertion needed
	}
}