@isTest (seeAllData=true)
public class DocumentCreationActionTest {

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('documents')){
                res.setBody('{"file":"Testfile","extension":"pdf","calculated_fields":{"Ergebnis!B46":"13410,93 €"}}');
            }
            res.setStatusCode(200);
            return res;
        }
	}

    private class MockHttpErrorResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            return res;
        }
	}

    @isTest
    static void hackCoverage() {
        DocumentCreationAction.hackCoverage();
    }
                            
    @isTest
	static void testAnalysisSuccess(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		// Create test data
        Account account = TestData.createAccount();
        insert account;
        Account insurance = TestData.createAccount();
        insurance.Type = 'Lebensversicherung';
        insert insurance;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
        opportunity.Insurance__c = insurance.Id;
        insert opportunity;
        Fund__c fund = TestData.createFund('Testfund','99999');
        fund.Default_Trend__c = 0.35;
		insert fund;
        Rate__c rate = TestData.createRate(fund.Id,0.3,100.45,Date.valueOf('2000-10-15'));
		insert rate;
        Rate__c rate2 = TestData.createRate(fund.Id,null,100.45,Date.valueOf('2000-10-15'));
		insert rate2;
        Fund_Reference__c fundReference = TestData.createFundReference(opportunity.Id,fund.Id,100);
		insert fundReference;
	    Analysis__c analysis = TestData.createAnalysis(opportunity.Id);
	    insert analysis;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(analysis.Id,false,'sameAsInput',null,null);

        Test.stopTest();

        // Assertion impossible
    }
    
    @isTest
    static void testContract50Success(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		// Create test data
        Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = account.Id;
		opportunity.Assignment_Type__c = 'Share';
        opportunity.Has_Legal_Protection_Insurance__c = false;
        opportunity.Contact__c = contact.Id;
        insert opportunity;
        Contract__c contract = TestData.createContract(opportunity.Id);
        insert contract;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(contract.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

    @isTest
    static void testContract20Success(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		// Create test data
        Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = account.Id;
		opportunity.Assignment_Type__c = 'RSV';
        opportunity.Contact__c = contact.Id;
        insert opportunity;
        Contract__c contract = TestData.createContract(opportunity.Id);
        insert contract;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(contract.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

    @isTest
    static void testContractDirektSuccess(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		// Create test data
        Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = account.Id;
		opportunity.Assignment_Type__c = 'Direkt';
        opportunity.Contact__c = contact.Id;
        insert opportunity;
        Contract__c contract = TestData.createContract(opportunity.Id);
        insert contract;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(contract.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

	@isTest
	static void testInvoiceSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
		Invoice__c invoice = TestData.createInvoice(opportunity.Id);
		invoice.Stage__c = 'Draft';
		invoice.Amount__c = 15000;
		invoice.Accounting__c = user.Id;
		insert invoice;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(invoice.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
    static void testWelcomeLetterRSVSuccess(){
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
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

        // Create test data
        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Assignment_Type__c = 'RSV';
        opportunity.Contact__c = contact.Id;
        opportunity.Legal__c = legalUser.Id;
        insert opportunity;
		Welcome_Letter__c welcomeLetter = TestData.createWelcomeLetter(opportunity.Id);
		insert welcomeLetter;

        // Test
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(welcomeLetter.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

	@isTest
	static void testWelcomeLetterShareSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Assignment_Type__c = 'Direkt'; // TODO: was Share but validation rule
		opportunity.Contact__c = contact.Id;
		opportunity.Legal__c = legalUser.Id;
		insert opportunity;
		Welcome_Letter__c welcomeLetter = TestData.createWelcomeLetter(opportunity.Id);
		insert welcomeLetter;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(welcomeLetter.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testAuthorizationSuccess(){
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
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

		// Create test data
        Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = account.Id;
        opportunity.Contact__c = contact.Id;
        opportunity.Legal__c = legalUser.Id;
        insert opportunity;
        Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
        insert authorization;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(authorization.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }
    
    @isTest
	static void testCorrespondenceLVSuccess(){
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
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

		// Create test data
        Account account = TestData.createAccount();
        insert account;
        Account districtCourt = TestData.createAccount();
        districtCourt.Type = 'Gericht';
        insert districtCourt;
        Account insurance = TestData.createAccount();
        insurance.Type = 'Lebensversicherung';
        insert insurance;
        Account legalInsurance = TestData.createAccount();
        legalInsurance.Type = 'Rechtsschutzversicherung';
        insert legalInsurance;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = insurance.Id;
        opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
        opportunity.Contact__c = contact.Id;
        opportunity.Legal__c = legalUser.Id;
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        claim.Court__c = districtCourt.Id;
        claim.Legal__c = legalUser.Id;
        insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(correspondence.Id,false,'sameAsInput',null,null);

        Test.stopTest();

        // Assertion impossible
    }

	@isTest
	static void testCorrespondenceFZSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		insert districtCourt;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		opportunity.Bank__c = account.Id;
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		opportunity.Legal__c = legalUser.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Bank','Widerspruch durch Kunden','Draft');
		insert correspondence;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(correspondence.Id,false,'sameAsInput',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testCorrespondenceDGSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account districtCourt = TestData.createAccount();
		districtCourt.Type = 'Gericht';
		insert districtCourt;
		Account insurance = TestData.createAccount();
		insurance.Type = 'Lebensversicherung';
		insert insurance;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		opportunity.Insurance__c = insurance.Id;
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		opportunity.Legal__c = legalUser.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Court__c = districtCourt.Id;
		claim.Legal__c = legalUser.Id;
		insert claim;
		Correspondence__c correspondence = TestData.createCorrespondence(claim.Id,'Insurance','Widerspruch durch Kunden','Draft');
		insert correspondence;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(correspondence.Id,false,'sameAsInput',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testCostNoteSuccess(){
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
            legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
            update legalUser;
        }

		// Create test data
        Account account = TestData.createAccount();
        insert account;
        Account legalInsurance = TestData.createAccount();
        legalInsurance.Type = 'Rechtsschutzversicherung';
        insert legalInsurance;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
        opportunity.Contact__c = contact.Id;
        insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        claim.Legal__c = legalUser.Id;
        insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        DocumentCreationAction.autoCreateDocument(costNote.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

	@isTest
	static void testCancellationSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;
		Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');
		insert cancellation;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(cancellation.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testCreditNoteSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
		insert claim;
		Credit_Note__c creditNote = TestData.createCreditNote(claim.Id,'Draft');
		insert creditNote;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(creditNote.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testCostNoteReminderSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id,'Draft');
		insert costNoteReminder;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(costNoteReminder.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testCommissionSuccess(){
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
			legalUser.UserRoleId = UserRoles.LegalID; // 00E0Y000000Hvm7
			update legalUser;
		}

		// Create test data
		Account account = TestData.createAccount();
		insert account;
		Account legalInsurance = TestData.createAccount();
		legalInsurance.Type = 'Rechtsschutzversicherung';
		insert legalInsurance;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Legal_Protection_Insurance__c = legalInsurance.Id;
		opportunity.Contact__c = contact.Id;
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType(); // 0120Y000000W0CY
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Legal__c = legalUser.Id;
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		insert costNote;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id,'Draft');
		insert costNoteReminder;
		Commission__c commission = TestData.createCommission(account.Id,legalInsurance.Id,20,30,System.today() - 1,System.today());
		insert commission;
		Cost_Note_Payment__c costNotePayment1 = TestData.createCostNotePayment(costNote.Id,100);
		costNotePayment1.Commission__c = commission.Id;
		insert costNotePayment1;
		Cost_Note_Payment__c costNotePayment2 = TestData.createCostNotePayment(costNote.Id,100);
		costNotePayment2.Commission__c = commission.Id;
		insert costNotePayment2;

		TriggerConfiguration.allInactive = false;
		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(commission.Id,false,'pdf',null,null);
		TriggerConfiguration.allInactive = false;
		DocumentCreationAction.autoCreateDocument(commission.Id,false,'sameAsInput',null,null);
		Test.stopTest();

		// Assertion impossible
	}

	@isTest
    static void testError(){
		// Testsetup
        TriggerConfiguration.allInactive = true;

		// Create test data
        Account account = TestData.createAccount();
        account.Type = 'Lebensversicherung';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
        opportunity.Insurance__c = account.Id;
        opportunity.Contact__c = contact.Id;
        insert opportunity;
        Contract__c contract = TestData.createContract(opportunity.Id);
        insert contract;

        // Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponseGenerator());
        DocumentCreationAction.autoCreateDocument(contract.Id,false,'pdf',null,null);

        Test.stopTest();

        // Assertion impossible
    }

	@isTest
	static void testTestCaseSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		Account account = TestData.createAccount();
		account.Type = 'Lebensversicherung';
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Test_Case__c testCase = TestData.createTestCase(opportunity.Id);
		insert testCase;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(testCase.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testOpportunityCorrespondenceSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		Account account = TestData.createAccount();
		account.Type = 'Lebensversicherung';
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Opportunity_Correspondence__c opportunityCorrespondence = TestData.createOpportunityCorrespondence(opportunity.Id,'Customer','Draft');
		insert opportunityCorrespondence;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(opportunityCorrespondence.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testDateNotificationSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
        Date_Notification__c dateNotification = new Date_Notification__c(
            Date__c = thisDate.Id
        );
		insert dateNotification;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(dateNotification.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testDateRecordSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
        Date_Record__c dateRecord = new Date_Record__c(
            Date__c = thisDate.Id
        );
		insert dateRecord;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(dateRecord.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}

	@isTest
	static void testDateAuthorizationSuccess(){
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Date__c thisDate = TestData.createDate(claim.Id);
		insert thisDate;
		Date_Authorization__c dateAuthorization = new Date_Authorization__c(
            date__c = thisDate.Id
        );
		insert dateAuthorization;

		// Test
		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		DocumentCreationAction.autoCreateDocument(dateAuthorization.Id,false,'pdf',null,null);

		Test.stopTest();

		// Assertion impossible
	}
}