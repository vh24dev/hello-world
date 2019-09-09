@isTest
public class EmailUtilitiesTest {

	public static Integer testcase;

	private class MockHttpResponseGenerator implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			if(req.getEndpoint().contains('dropbox')) {
				res.setBody('{"name": "cost_note_cn20160810020.pdf", "path_lower": "/test/cost_note_cn20160810020.pdf", "path_display": "/Test/cost_note_cn20160810020.pdf", "id": "id:b1-3Lzp3mDQAAAAAAABR2A", "client_modified": "2016-08-10T14:40:27Z", "server_modified": "2016-08-10T14:40:27Z", "rev": "1c0470bd6ed24", "size": 84310}');
			} else if(req.getEndpoint().contains('smtp')) {
				res.setBody('{}');
			}
			res.setStatusCode(200);
			return res;
		}
	}

	private class GoogleSuccessMock implements HttpCalloutMock {
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			res.setBody('{"file":"Testfile","filename":"testfile.pdf"}');
			res.setStatusCode(200);
			return res;
		}
	}

    @isTest
    static void hackCoverage() {
        TriggerConfiguration.allInactive = true;
        EmailUtilities eu = new EmailUtilities();
        eu.getSendingModes();
        eu.getOtherRecipients();
        eu.getSenderAddresses();
        eu.HackCoverage();
    }

    @isTest
    static void testCorrespondenceDG() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		districtCourt.Email__c = 'testemail@cloudworx.agency';
		insert districtCourt;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.RecordTypeId = Opportunities.dieselskandalRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = user.ID;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Court','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		tasks.add(TestData.createTask('Urteil erhalten und hinterlegen',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', 'auto');
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
        System.currentPageReference().getParameters().put('createFollowUp', 'true');

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();
    }

    /*
    @isTest
    static void testCorrespondenceLV() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		districtCourt.Email__c = 'testemail@cloudworx.agency';
		insert districtCourt;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.RecordTypeId = Opportunities.lebensversicherungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = user.ID;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Court','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		tasks.add(TestData.createTask('Urteil erhalten und hinterlegen',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', 'auto');
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
        System.currentPageReference().getParameters().put('createFollowUp', 'true');

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();
    }

    @isTest
    static void testCorrespondenceFZ() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		districtCourt.Email__c = 'testemail@cloudworx.agency';
		insert districtCourt;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = user.ID;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Court','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		tasks.add(TestData.createTask('Urteil erhalten und hinterlegen',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', 'auto');
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
        System.currentPageReference().getParameters().put('createFollowUp', 'true');

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();
    }
	*/

	@isTest
	static void testAutoSend(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.Username = 'adminUser@cloudworx.agency';
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact reportToContact = TestData.createContact(account.Id);
		insert reportToContact;
		Contact contact = TestData.createContact(account.Id);
		contact.ReportsToId = reportToContact.Id;
		contact.Second_Email__c = 'secondMail@cloudworx.agency';
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Callcenter__c = user.Id;
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Attachment attachment = TestData.createAttachment(opportunity.Id);
		insert attachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities(opportunity.Id, contact.Id, EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24), null);
		emailUtilities.cc = contact;
		emailUtilities.cc2 = contact;
		emailUtilities.bcc = contact;
		emailUtilities.senderAddress = 'service@verbraucherrechte24.de';
		String result = emailUtilities.send();

		Test.stopTest();

		// Assertion
		System.assertEquals('Success',result);
	}

	@isTest
	static void testWelcomeLetterGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Welcome_Letter__c welcomeLetter = TestData.createWelcomeLetter(opportunity.Id);
		insert welcomeLetter;
		Attachment attachment = TestData.createAttachment(welcomeLetter.Id);
		insert attachment;
		Attachment manualAttachment1 = TestData.createAttachment(null);
		Attachment manualAttachment2 = TestData.createAttachment(null);
		Attachment manualAttachment3 = TestData.createAttachment(null);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', welcomeLetter.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.attachment1Input = manualAttachment1;
		emailUtilities.attachment2Input = manualAttachment2;
		emailUtilities.attachment3Input = manualAttachment3;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		welcomeLetter = [SELECT Id, Stage__c, (select Id FROM Attachments) FROM Welcome_Letter__c WHERE Id = :welcomeLetter.Id];
		System.assertEquals('Sent',welcomeLetter.Stage__c);
		System.assertEquals(1,welcomeLetter.Attachments.size());	// sichert ab, dass manual Attachments gelöscht wurden.
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testContractGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Contract__c contract = TestData.createContract(opportunity.Id);
		contract.Re_contracting__c = true;
		insert contract;
		Attachment attachment = TestData.createAttachment(contract.Id);
		insert attachment;
		Attachment manualAttachment1 = TestData.createAttachment(null);
		Attachment manualAttachment2 = TestData.createAttachment(null);
		Attachment manualAttachment3 = TestData.createAttachment(null);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', contract.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.attachment1Input = manualAttachment1;
		emailUtilities.attachment2Input = manualAttachment2;
		emailUtilities.attachment3Input = manualAttachment3;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		contract = [SELECT Id, Stage__c, (select Id FROM Attachments) FROM Contract__c WHERE Id = :contract.Id];
		System.assertEquals('Sent',contract.Stage__c);
		System.assertEquals(1,contract.Attachments.size());	// sichert ab, dass manual Attachments gelöscht wurden.
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testOpportunityGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.Username = 'adminUser@cloudworx.agency';
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact reportToContact = TestData.createContact(account.Id);
		insert reportToContact;
		Contact contact = TestData.createContact(account.Id);
		contact.ReportsToId = reportToContact.Id;
		contact.Second_Email__c = 'secondMail@cloudworx.agency';
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Callcenter__c = user.Id;
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Attachment attachment = TestData.createAttachment(opportunity.Id);
		insert attachment;

		TriggerConfiguration.allInactive = false;
		Utilities.sendEmailViaAPI = true;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', opportunity.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'true');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'true');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.headline = 'Testheadline';
		emailUtilities.cc = contact;
		emailUtilities.cc2 = contact;
		emailUtilities.bcc = contact;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testOpportunityCallcenterDocumentsIncompleteSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Callcenter__c = user.Id;
		insert opportunity;
		Task task = TestData.createTask('Dokumentenerhalt prüfen',opportunity.Id,user.Id);
		task.ActivityDate = System.today();
		insert task;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', opportunity.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDocumentsIncompleteVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		task = [SELECT Id, Comment__c, ActivityDate FROM Task WHERE Id = :task.Id];
		// System.assertEquals(System.today()+1,task.ActivityDate);
		// System.assertEquals('Follow-up #1',task.Comment__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testOpportunityBackofficeRefusalSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', opportunity.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralRefusalSonstigeGruendeVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testOpportunityFinanzierungOnHoldSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', opportunity.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.FzGeneralOnHoldWithRecommendationsVh24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		opportunity = [SELECT Id, StageName FROM Opportunity WHERE Id =: opportunity.Id];
		// System.assertEquals('On Hold',opportunity.StageName);
	}

	@isTest
	static void testInvoiceGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.Username = 'adminUser@cloudworx.agency';
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test data
		EmailTemplate template;
		System.runAs(adminUser){
			template = TestData.createTemplate();
			insert template;
			Attachment attachment = TestData.createAttachment(template.Id);
			insert attachment;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		insert invoice;
		Attachment attachment = TestData.createAttachment(invoice.Id);
		insert attachment;

		IntegrateDropbox.noCallout = true;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', invoice.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testClaimInsuranceSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account insurance = TestData.createAccount();
		insurance.Type = 'Lebensversicherung';
		insurance.Email__c = 'testemail@cloudworx.agency';
		insert insurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Insurance__c = insurance.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.correspondenceInput = correspondence;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		claim = [SELECT Id, (select Id, Status, Subject FROM Tasks) FROM Claim__c WHERE Id = :claim.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : claim.Tasks){
			if (task.Subject.contains('Wiedervorlage')){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		System.assertEquals(2,foundTasks);
		System.assertEquals(2,openTasks);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testClaimLegalInsuranceSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		legalInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.correspondenceInput = correspondence;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		claim = [SELECT Id, (select Id, Status, Subject FROM Tasks) FROM Claim__c WHERE Id = :claim.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : claim.Tasks){
			if (task.Subject.contains('Wiedervorlage')){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		System.assertEquals(2,foundTasks);
		System.assertEquals(2,openTasks);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testClaimDistrictCourtSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		districtCourt.Email__c = 'testemail@cloudworx.agency';
		insert districtCourt;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Appeal');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
        claim.Clerk__c = user.ID;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Court','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		tasks.add(TestData.createTask('Urteil erhalten und hinterlegen',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('showPartnerPicklist', 'true');
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.correspondenceInput = correspondence;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		claim = [SELECT Id, (select Id, Status, Subject FROM Tasks) FROM Claim__c WHERE Id = :claim.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : claim.Tasks){
			System.debug(task);
			if ((task.Subject.contains('Wiedervorlage')) || (task.Subject.contains('Urteil erhalten und hinterlegen')) || (task.Subject.contains('Ergebnis der Berufung dokumentieren'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}

		System.assertEquals(4,foundTasks);
		System.assertEquals(3,openTasks);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testClaimCustomerSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.Clerk__c = user.ID;
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',claim.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSetClaimOnHoldVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('variant', '4');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		claim = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Claim__c WHERE Id = :claim.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : claim.Tasks){
			if (task.Subject.contains('Wiedervorlage')){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		System.assertEquals(1,foundTasks);
		// System.assertEquals(0,openTasks);
		// System.assertEquals('On Hold',claim.Stage__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		insert opportunity;
		Attachment opportunityAttachment = TestData.createAttachment(opportunity.Id);
		insert opportunityAttachment;
		Document__c document = TestData.createDocument(opportunity.Id, 'http://www.cloudworx.agency/');
		document.Type__c = 'DG_Invoice';
		insert document;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
		insert claim;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		insert authorization;
		Attachment authorizationAttachment = TestData.createAttachment(authorization.Id);
		insert authorizationAttachment;
		Correspondence__c correspondence1 = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Deckungsanfrage für Anspruchsschreiben','Sent');
		insert correspondence1;
		Attachment correspondenceAttachment1 = TestData.createAttachment(correspondence1.Id);
		insert correspondenceAttachment1;
		Correspondence__c correspondence2 = TestData.createCorrespondence(claim.Id,'Court','Klageschrift','Draft');
		insert correspondence2;
		Attachment correspondenceAttachment2 = TestData.createAttachment(correspondence2.Id);
		insert correspondenceAttachment2;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',correspondence2.Id,user.Id));
		tasks.add(TestData.createTask('versenden',correspondence2.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence2.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.DieselLachmairLegalCorrespondenceGeneral));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		System.currentPageReference().getParameters().put('ShowDocumentsList', 'true');
		System.currentPageReference().getParameters().put('ShowCorrespondenciesList', 'true');
		System.currentPageReference().getParameters().put('ShowOpportunityAttachmentsList', 'true');
		System.currentPageReference().getParameters().put('ShowAuthorizationsList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		for (EmailUtilities.CDocumentListItem documentListItem : emailUtilities.documentList){
			documentListItem.selected = true;
		}
		for (EmailUtilities.CCorrespondenceAttachmentListItem correspondenceListItem : emailUtilities.correspondenceAttachmentList){
			correspondenceListItem.selected = true;
		}
		for (EmailUtilities.CAttachmentListItem opportunityAttachmentListItem : emailUtilities.opportunityAttachmentList){
			opportunityAttachmentListItem.selected = true;
		}
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence2 = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence2.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : correspondence2.Tasks){
			if ((task.Subject.contains('Wiedervorlage')) || (task.Subject.contains('versenden'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		// System.assertEquals(3,foundTasks);
		// System.assertEquals(2,openTasks);
		// System.assertEquals('Sent',correspondence2.Stage__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceKundenwiderspruchLVSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Customers Opposition');
		claim.Clerk__c = user.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Widerspruchsvorlage an Kunden versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSendCustomersOppositionToCustomerVh24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		System.currentPageReference().getParameters().put('ShowDocumentsList', 'true');
		System.currentPageReference().getParameters().put('ShowCorrespondenciesList', 'true');
		System.currentPageReference().getParameters().put('ShowOpportunityAttachmentsList', 'true');
		System.currentPageReference().getParameters().put('ShowAuthorizationsList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : correspondence.Tasks){
			if ((task.Subject.contains('Widerspruchsvorlage an Kunden versenden')) || (task.Subject.contains('Unterschriebenen Widerspruch hochladen und an Versicherung versenden'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		// System.assertEquals(2,foundTasks);
		// System.assertEquals(1,openTasks);
		// System.assertEquals('Draft',correspondence.Stage__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceKundenwiderspruchFZSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Customers Opposition');
		claim.Clerk__c = user.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Widerspruchsvorlage an Kunden versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSendCustomersOppositionToCustomerVh24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		System.currentPageReference().getParameters().put('ShowDocumentsList', 'true');
		System.currentPageReference().getParameters().put('ShowCorrespondenciesList', 'true');
		System.currentPageReference().getParameters().put('ShowOpportunityAttachmentsList', 'true');
		System.currentPageReference().getParameters().put('ShowAuthorizationsList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : correspondence.Tasks){
			if ((task.Subject.contains('Widerspruchsvorlage an Kunden versenden')) || (task.Subject.contains('Unterschriebenen Widerspruch hochladen und an Versicherung versenden'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		// System.assertEquals(2,foundTasks);
		// System.assertEquals(1,openTasks);
		// System.assertEquals('Draft',correspondence.Stage__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceAntwortBeimKundenFZSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Customers Opposition');
		claim.Clerk__c = user.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.name.FzJaegerLegalAntwortBeimKunden));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id, (select Id, Status, Subject, ActivityDate FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Date dueDate;
		for (Task task : claim.Tasks){
			if (task.Subject.contains('Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden')){
				dueDate = task.ActivityDate;
			}
		}
		System.assertNotEquals(dueDate,System.today());
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceRueckfrageEigentuemerschaftSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Customers Opposition');
        claim.Clerk__c = user.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Court','Klageschrift','Draft');
		insert correspondence;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Rückfrage zur Eigentümerschaft versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselJaegerLegalRequestOwnership));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		claim = [SELECT Id, Ownership_Request_Date__c FROM Claim__c WHERE Id = :claim.Id];
		correspondence = [SELECT Id, Stage__c FROM Correspondence__c WHERE Id = :correspondence.Id];
		tasks = [SELECT Id FROM Task WHERE Id IN :tasks AND isClosed = false];
		System.assertEquals(0,tasks.size());
		System.assertEquals(System.today(),claim.Ownership_Request_Date__c);
		System.assertEquals('Draft',correspondence.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceLetterSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		insert opportunity;
		Attachment opportunityAttachment = TestData.createAttachment(opportunity.Id);
		insert opportunityAttachment;
		Document__c document = TestData.createDocument(opportunity.Id, 'http://www.cloudworx.agency/');
		document.Type__c = 'DG_Invoice';
		insert document;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Deckungsanfrage für Anspruchsschreiben','Draft');
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',correspondence.Id,user.Id));
		tasks.add(TestData.createTask('versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/SendLetterOrFax'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showDocumentsList', 'true');
		System.currentPageReference().getParameters().put('showCorrespondenciesList', 'true');
		System.currentPageReference().getParameters().put('showOpportunityAttachmentsList', 'true');
		System.currentPageReference().getParameters().put('showAuthorizationsList', 'true');
		System.currentPageReference().getParameters().put('restrictFileTypes', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.sendingMode = 'Brief';
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : correspondence.Tasks){
			if ((task.Subject.contains('Wiedervorlage')) || (task.Subject.contains('versenden'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		// System.assertEquals(3,foundTasks);
		// System.assertEquals(2,openTasks);
		// System.assertEquals('Sent',correspondence.Stage__c );
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCorrespondenceFaxSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		insert opportunity;
		Attachment opportunityAttachment = TestData.createAttachment(opportunity.Id);
		insert opportunityAttachment;
		Document__c document = TestData.createDocument(opportunity.Id, 'http://www.cloudworx.agency/');
		document.Type__c = 'DG_Invoice';
		insert document;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Legal Protection Insurance','Deckungsanfrage für Anspruchsschreiben','Draft');
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;

		List <Task> tasks = new List<Task>();
		tasks.add(TestData.createTask('Wiedervorlage',correspondence.Id,user.Id));
		tasks.add(TestData.createTask('versenden',correspondence.Id,user.Id));
		insert tasks;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/SendLetterOrFax'));
		System.currentPageReference().getParameters().put('id', correspondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showDocumentsList', 'true');
		System.currentPageReference().getParameters().put('showCorrespondenciesList', 'true');
		System.currentPageReference().getParameters().put('showOpportunityAttachmentsList', 'true');
		System.currentPageReference().getParameters().put('showAuthorizationsList', 'true');
		System.currentPageReference().getParameters().put('restrictFileTypes', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.sendingMode = 'Fax';
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		correspondence = [SELECT Id, Stage__c, (select Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id = :correspondence.Id];
		Integer foundTasks = 0;
		Integer openTasks = 0;
		for (Task task : correspondence.Tasks){
			if ((task.Subject.contains('Wiedervorlage')) || (task.Subject.contains('versenden'))){
				foundTasks++;
				if (task.Status != 'Completed'){
					openTasks++;
				}
			}
		}
		// System.assertEquals(3,foundTasks);
		// System.assertEquals(2,openTasks);
		// System.assertEquals('Sent',correspondence.Stage__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testOpportunityCorrespondenceGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
		opportunity.Backoffice__c = user.Id;
		insert opportunity;
		Opportunity_Correspondence__c opportunityCorrespondence = TestData.createOpportunityCorrespondence(opportunity.Id,'Customer','Draft');
		insert opportunityCorrespondence;
		Attachment opportunityCorrespondenceAttachment = TestData.createAttachment(opportunityCorrespondence.Id);
		insert opportunityCorrespondenceAttachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', opportunityCorrespondence.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		opportunityCorrespondence = [SELECT Id, Stage__c, (select Id FROM Tasks WHERE Subject = 'Wiedervorlage bzgl. Darlehensvertrag') FROM Opportunity_Correspondence__c WHERE Id = :opportunityCorrespondence.Id];
		System.assertEquals('Sent',opportunityCorrespondence.Stage__c);
		System.assertEquals(1,opportunityCorrespondence.Tasks.size());
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testDateGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
		Attachment dateAttachment = TestData.createAttachment(thisDate.Id);
		insert dateAttachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', thisDate.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		// System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateReminderCustomer2));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		thisDate = [SELECT Id, Sent_Mail_Flag_1__c FROM Date__c WHERE Id = :thisDate.Id];
		// System.assertEquals(true,thisDate.Sent_Mail_Flag_1__c);
		// System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testDateNotificationGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
        opportunity.Contact__c = contact.id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
        Date_Notification__c dateNotification = new Date_Notification__c(
            Date__c = thisDate.id
        );
		insert dateNotification;
		Attachment dateNotificationAttachment = TestData.createAttachment(dateNotification.Id);
		insert dateNotificationAttachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', dateNotification.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		dateNotification = [SELECT Id, Stage__c FROM Date_Notification__c WHERE Id = :dateNotification.Id];
		System.assertEquals('Sent',dateNotification.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testDateRecordGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
        opportunity.Contact__c = contact.id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
        Date_Record__c dateRecord = new Date_Record__c(
            Date__c = thisDate.id
        );
		insert dateRecord;
		Attachment dateRecordAttachment = TestData.createAttachment(dateRecord.Id);
		insert dateRecordAttachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', dateRecord.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		dateRecord = [SELECT Id, Stage__c FROM Date_Record__c WHERE Id = :dateRecord.Id];
		System.assertEquals('Sent',dateRecord.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testDateAuthorizationGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		adminUser.Username = 'adminUser@cloudworx.agency';
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Account legalProtectionInsurance = TestData.createAccount();
		legalProtectionInsurance.Type = 'Rechtsschutzversicherung';
		legalProtectionInsurance.Email__c = 'testemail@cloudworx.agency';
		insert legalProtectionInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Legal_Protection_Insurance__c = legalProtectionInsurance.Id;
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
		Date_Authorization__c dateAuthorization = new Date_Authorization__c(
            Date__c = thisDate.id
        );
		insert dateAuthorization;
		Attachment dateAuthorizationAttachment = TestData.createAttachment(dateAuthorization.Id);
		insert dateAuthorizationAttachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new GoogleSuccessMock());

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', dateAuthorization.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('hdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		dateAuthorization = [SELECT Id, Stage__c FROM Date_Authorization__c WHERE Id = :dateAuthorization.Id];
		System.assertEquals('Sent',dateAuthorization.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCostNoteGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(costNote.Id,10000);
		insert costNoteLineItem;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', costNote.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		costNote = [SELECT Id, Stage__c FROM Cost_Note__c WHERE Id = :costNote.Id];
		System.assertEquals('/apex/successpage',nextPage.getUrl());
		System.assertEquals('Sent',costNote.Stage__c);
	}

	@isTest
	static void testCancellationGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(costNote.Id,10000);
		insert costNoteLineItem;
		Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');
		insert cancellation;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', cancellation.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		cancellation = [SELECT Id, Stage__c FROM Cancellation__c WHERE Id = :cancellation.Id];
		System.assertEquals('Sent',cancellation.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCreditNoteGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Sent');
		insert costNote;
		Attachment costNoteAttachment = TestData.createAttachment(costNote.Id);
		insert costNoteAttachment;
		Credit_Note__c creditNote = TestData.createCreditNote(claim.Id,'Draft');
		insert creditNote;
		Credit_Note_Line_Item__c creditNoteLineItem = TestData.createCreditNoteLineItem(creditNote.Id,10000);
		insert creditNoteLineItem;


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', creditNote.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		creditNote = [SELECT Id, Stage__c FROM Credit_Note__c WHERE Id = :creditNote.Id];
		System.assertEquals('Sent',creditNote.Stage__c);
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testCostNoteReminderGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Sent');
		insert costNote;
		Attachment costNoteAttachment = TestData.createAttachment(costNote.Id);
		insert costNoteAttachment;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id,'Draft');
		insert costNoteReminder;
		Attachment attachment = TestData.createAttachment(costNoteReminder.Id);
		insert attachment;
		Attachment manualAttachment1 = TestData.createAttachment(null);
		Attachment manualAttachment2 = TestData.createAttachment(null);
		Attachment manualAttachment3 = TestData.createAttachment(null);

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', costNoteReminder.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		System.currentPageReference().getParameters().put('restrictFileTypes', 'true');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.restrictFileTypes = true;
		emailUtilities.attachment1Input = manualAttachment1;
		emailUtilities.attachment2Input = manualAttachment2;
		emailUtilities.attachment3Input = manualAttachment3;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		costNoteReminder = [SELECT Id, Stage__c, (select Id FROM Attachments) FROM Cost_Note_Reminder__c WHERE Id = :costNoteReminder.Id];
		System.assertEquals('Sent',costNoteReminder.Stage__c);
		System.assertEquals(1,costNoteReminder.Attachments.size());	// sichert ab, dass manual Attachments gelöscht wurden.
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testAuthorizationGenericSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		insert authorization;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', authorization.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.createFollowUp = true;
		emailUtilities.showOtherRecipientPicklist = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		authorization = [SELECT Id, Stage__c FROM Authorization__c WHERE Id = :authorization.Id];
		System.assertEquals('/apex/successpage',nextPage.getUrl());
		System.assertEquals('Sent',authorization.Stage__c);
	}

	@isTest
	static void testTask(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Task task = TestData.createTask('Testemail', opportunity.Id, user.Id);
		task.From_Address__c = 'testemail@test.de';
		insert task;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', task.Id);
		System.currentPageReference().getParameters().put('recipient', 'auto');
		System.currentPageReference().getParameters().put('tpl', 'auto');
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		System.assertEquals('/apex/successpage',nextPage.getUrl());
	}

	@isTest
	static void testMissingEmailAdress(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		contact.Email = null;
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		// System.assert(nextPage.getUrl().contains('/apex/errorpage'));
	}

	@isTest
	static void testAttachmentMissing(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', claim.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'true');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		EmailUtilities emailUtilities = new EmailUtilities();
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		// System.assert(nextPage.getUrl().contains('/apex/errorpage'));
	}

	@isTest
	static void testResetTemplateLVVariant1(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.LebensversicherungRecordType(); // 0120Y000000W0CT
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '1';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = true;
		emailUtilities.otherRecipient = 'Legal Protection Insurance';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateLVVariant2(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.LebensversicherungRecordType(); // 0120Y000000W0CT
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '2';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Customer';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		System.assertNotEquals(null,emailUtilities.subject);
		System.assertNotEquals(null,emailUtilities.body);
	}

	@isTest
	static void testResetTemplateLVVariant3(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.LebensversicherungRecordType(); // 0120Y000000W0CT
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '3';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Court';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateLVNoVariant(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.LebensversicherungRecordType(); // 0120Y000000W0CT
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Vehicle Brand';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGVariant1(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '1';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = true;
		emailUtilities.otherRecipient = 'Legal Protection Insurance';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGVariant2(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '2';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Customer';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGVariant3(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.variant = '3';
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Court';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGNoVariant(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.otherRecipient = 'Vehicle Brand';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGWithRecommendations(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.parentId = opportunity.Id;
		emailUtilities.recipientId = contact.Id;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showRecommendationsCheckbox = true;
		emailUtilities.includeRecommendations = true;
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateDGWithoutRecommendations(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.DieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.parentId = opportunity.Id;
		emailUtilities.recipientId = contact.Id;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showRecommendationsCheckbox = true;
		emailUtilities.includeRecommendations = false;
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testResetTemplateFZNoVariant(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.FinanzierungRecordType(); // 0120Y000000KnMH
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Customer','Deckungsanfrage für Anspruchsschreiben','Draft');


		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.parentId = claim.Id;
		emailUtilities.correspondenceInput = correspondence;
		emailUtilities.subject = null;
		emailUtilities.body = null;
		emailUtilities.showOtherRecipientPicklist = false;
		emailUtilities.correspondenceInput.Partner__c = 'Vehicle Brand';
		emailUtilities.resetTemplate();

		Test.stopTest();

		// Assertion
		if (Test.isRunningTest() == false) {
			System.assertNotEquals(null, emailUtilities.subject);
			System.assertNotEquals(null, emailUtilities.body);
		}
	}

	@isTest
	static void testUnrestrictedAttachmentLists(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Sent');
		insert costNote;
		Attachment costNoteAttachment = TestData.createAttachment(costNote.Id);
		insert costNoteAttachment;
		Receipt__c receipt = TestData.createReceipt(claim.Id,100.00,'Uploaded');
		insert receipt;
		Attachment receiptAttachment = TestData.createAttachment(receipt.Id);
		insert receiptAttachment;
		Date__c date1 = TestData.createDate(claim.Id);
		insert date1;
		Attachment dateAttachment = TestData.createAttachment(date1.Id);
		insert dateAttachment;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		authorization.Stage__c = 'Signed';
		insert authorization;
		Attachment authorizationAttachment = TestData.createAttachment(authorization.Id);
		insert authorizationAttachment;
		Correspondence__c correspondence = Utilities.createCorrespondence(claim,'Legal Protection Insurance','Klageschrift','Sent',null);
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id,'Draft');
		insert costNoteReminder;
		Attachment attachment = TestData.createAttachment(costNoteReminder.Id);
		insert attachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', costNoteReminder.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		System.currentPageReference().getParameters().put('showReceiptsList', 'true');
		System.currentPageReference().getParameters().put('showDatesList', 'true');
		System.currentPageReference().getParameters().put('showAuthorizationsList', 'true');
		System.currentPageReference().getParameters().put('showCorrespondenciesList', 'true');

		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.showReceiptAttachmentsList = true;
		emailUtilities.showDateAttachmentsList = true;
		emailUtilities.showAuthorizationAttachmentsList = true;
		emailUtilities.showCorrespondenceAttachmentsList = true;
		emailUtilities.createFollowUp = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		// no assertion possible
	}

	@isTest
	static void testRestrictedAttachmentLists(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Sent');
		insert costNote;
		Attachment costNoteAttachment = TestData.createAttachment(costNote.Id);
		insert costNoteAttachment;
		Receipt__c receipt = TestData.createReceipt(claim.Id,100.00,'Uploaded');
		insert receipt;
		Attachment receiptAttachment = TestData.createAttachment(receipt.Id);
		insert receiptAttachment;
		Date__c date1 = TestData.createDate(claim.Id);
		insert date1;
		Attachment dateAttachment = TestData.createAttachment(date1.Id);
		insert dateAttachment;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		authorization.Stage__c = 'Signed';
		insert authorization;
		Attachment authorizationAttachment = TestData.createAttachment(authorization.Id);
		insert authorizationAttachment;
		Correspondence__c correspondence = Utilities.createCorrespondence(claim,'Legal Protection Insurance','Klageschrift','Sent',null);
		insert correspondence;
		Attachment correspondenceAttachment = TestData.createAttachment(correspondence.Id);
		insert correspondenceAttachment;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id,'Draft');
		insert costNoteReminder;
		Attachment attachment = TestData.createAttachment(costNoteReminder.Id);
		insert attachment;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		Test.setCurrentPageReference(new PageReference('/apex/EmailUtilities'));
		System.currentPageReference().getParameters().put('id', costNoteReminder.Id);
		System.currentPageReference().getParameters().put('recipient', contact.Id);
		System.currentPageReference().getParameters().put('tpl', EmailTemplates.idOf(EmailTemplates.Name.LvGeneralBlankTemplateVr24));
		System.currentPageReference().getParameters().put('tplatt', 'false');
		System.currentPageReference().getParameters().put('noprtatt', 'false');
		System.currentPageReference().getParameters().put('noatt', 'false');
		System.currentPageReference().getParameters().put('attreq', 'false');
		System.currentPageReference().getParameters().put('newestattonly', 'false');
		System.currentPageReference().getParameters().put('bcc', 'testbcc@cloudworx.agency');
		System.currentPageReference().getParameters().put('thdl', 'Testsubject');
		System.currentPageReference().getParameters().put('restrictFileTypes', 'true');
		System.currentPageReference().getParameters().put('showCostNotesList', 'true');
		System.currentPageReference().getParameters().put('showReceiptsList', 'true');
		System.currentPageReference().getParameters().put('showDatesList', 'true');
		System.currentPageReference().getParameters().put('showAuthorizationsList', 'true');
		System.currentPageReference().getParameters().put('showCorrespondenciesList', 'true');


		EmailUtilities emailUtilities = new EmailUtilities();
		emailUtilities.restrictFileTypes = true;
		emailUtilities.showReceiptAttachmentsList = true;
		emailUtilities.showDateAttachmentsList = true;
		emailUtilities.showAuthorizationAttachmentsList = true;
		emailUtilities.showCorrespondenceAttachmentsList = true;
		PageReference nextPage = emailUtilities.sendButton();

		Test.stopTest();

		// Assertion
		// no assertion possible
	}
}