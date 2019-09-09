@IsTest
private class IntegrateDropboxTest {

	public static Integer testcase;

	private class MockHttpResponseGenerator implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			if(testcase == 1){
				res.setBody('{"name": "cost_note_cn20160810020.pdf", "path_lower": "/test/cost_note_cn20160810020.pdf", "path_display": "/Test/cost_note_cn20160810020.pdf", "id": "id:b1-3Lzp3mDQAAAAAAABR2A", "client_modified": "2016-08-10T14:40:27Z", "server_modified": "2016-08-10T14:40:27Z", "rev": "1c0470bd6ed24", "size": 84310}');
			} else if (testcase == 2) {
				res.setBody('{"error" : "Testfehler"}');
			}
			res.setStatusCode(200);

			return res;
		}
	}

	@isTest
	static void testUploadFromCreditNoteSuccess() {
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

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		testcase = 1;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		IntegrateDropbox.uploadFileToDropboxAsync('/Test/',attachment.Id,account.Id);

		test.StopTest();

		// Assertion
		creditNote = [select Id,Uploaded_To_Dropbox__c, (select Id,Subject from Tasks) from Credit_Note__c where Id = :creditNote.Id];

		Integer i = 0;
		for (Task task : creditNote.Tasks){
			if (task.Subject.contains('Uploaded to')){
				i++;
			}
		}

		System.assert(i == 1);
		System.assert(creditNote.Uploaded_To_Dropbox__c == true);
	}

	@isTest
	static void testUploadFromCostNoteSuccess() {
		// Testsetup
		Utilities.deactivateTriggers();

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Account__c = account.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
		costNote.Uploaded_To_Dropbox__c = false;
		insert costNote;
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(costNote.Id,10000);
		insert costNoteLineItem;
		Attachment attachment = TestData.createAttachment(costNote.Id);
		insert attachment;

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		testcase = 1;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		IntegrateDropbox.uploadFileToDropboxAsync('/Test/',attachment.Id,account.Id);

		test.StopTest();

		// Assertion
		costNote = [select Id,Uploaded_To_Dropbox__c, (select Id,Subject from Tasks) from Cost_Note__c where Id = :costNote.Id];

		Integer i = 0;
		for (Task task : costNote.Tasks){
			if (task.Subject.contains('Uploaded to')){
				i++;
			}
		}

		System.assert(i == 1);
		System.assert(costNote.Uploaded_To_Dropbox__c == true);
	}

	@isTest
	static void testUploadFromInvoiceSuccess() {
		// Testsetup
		Utilities.deactivateTriggers();

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Stage__c = 'Draft';
		invoice.Amount__c = 1000;
		insert invoice;
		Attachment attachment = TestData.createAttachment(invoice.Id);
		insert attachment;

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		testcase = 1;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		IntegrateDropbox.uploadFileToDropboxAsync('/Test/',attachment.Id,account.Id);

		test.StopTest();

		// Assertion
		invoice = [select Id,Uploaded_To_Dropbox__c, (select Id,Subject from Tasks) from Invoice__c where Id = :invoice.Id];

		Integer i = 0;
		for (Task task : invoice.Tasks){
			if (task.Subject.contains('Uploaded to')){
				i++;
			}
		}

		System.assert(i == 1);
		System.assert(invoice.Uploaded_To_Dropbox__c == true);
	}

	@isTest
	static void testBadResponse() {
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

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		testcase = 2;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		IntegrateDropbox.uploadFileToDropboxAsync('/Test/',attachment.Id,account.Id);

		test.StopTest();

		// Assertion
		creditNote = [select Id,Uploaded_To_Dropbox__c, (select Id,Subject from Tasks) from Credit_Note__c where Id = :creditNote.Id];

		Integer i = 0;
		for (Task task : creditNote.Tasks){
			if (task.Subject.contains('Uploaded to')){
				i++;
			}
		}

		System.assert(i == 0);
		System.assert(creditNote.Uploaded_To_Dropbox__c == false);
	}

	@isTest
	static void testUploadToDropboxDeactivated() {
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

		Utilities.deactivateDropboxUpload = true;

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		testcase = 2;
		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		IntegrateDropbox.uploadFileToDropboxAsync('/Test/',attachment.Id,account.Id);

		test.StopTest();

		// Assertion
		creditNote = [select Id,Uploaded_To_Dropbox__c, (select Id,Subject from Tasks) from Credit_Note__c where Id = :creditNote.Id];

		Integer i = 0;
		for (Task task : creditNote.Tasks){
			if (task.Subject.contains('Uploaded to')){
				i++;
			}
		}

		System.assert(i == 0);
		System.assert(creditNote.Uploaded_To_Dropbox__c == false);
	}
}