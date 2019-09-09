@isTest
public class EmailUtilitiesQueueableTests {

	private class MockHttpResponseGenerator implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			if(req.getEndpoint().contains('smtp')) {
				res.setBody('{}');
			}
			res.setStatusCode(200);
			return res;
		}
	}

	@isTest
	static void test() {
		// Testsetup
		Utilities.deactivateTriggers();

		User user = TestData.createUser();
		user.SMTP_Server__c = 'smtp.test.de';
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		contact.Auto_Follow_up_Date__c = System.now() - 1;
		contact.Auto_Follow_up_Count__c = 0;
		insert contact;

		Utilities.activateTriggers();

		// Test
		test.StartTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

		Utilities.sendEmailViaAPI = true;
		EmailUtilitiesQueueable queueable = new EmailUtilitiesQueueable(new List<EmailUtilitiesQueueable.CQueueableEmailUtilities>{new EmailUtilitiesQueueable.CQueueableEmailUtilities(new EmailUtilities(contact.Id, contact.Id, EmailTemplates.idOf(EmailTemplates.name.ErrorNotification), user.Id),4, 'Follow-up'),new EmailUtilitiesQueueable.CQueueableEmailUtilities(new EmailUtilities(contact.Id, contact.Id, EmailTemplates.idOf(EmailTemplates.name.ErrorNotification), user.Id),4, 'Follow-up')});
		System.enqueueJob(queueable);

		test.StopTest();

		// Assertion
		contact = [select Id, Auto_Follow_up_Date__c, Auto_Follow_up_Count__c, (select Id from Tasks where Type = 'Email' AND isClosed = true) from Contact where Id = :contact.Id];
		System.assertEquals(2, contact.Tasks.size());
		System.assertEquals(2, contact.Auto_Follow_up_Count__c);
		System.assertNotEquals(System.now() - 1, contact.Auto_Follow_up_Date__c);
		System.assertNotEquals(null, contact.Auto_Follow_up_Date__c);
	}
}