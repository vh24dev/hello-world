@isTest
public class CostNoteTriggerHandlerTests {
	// todo:
	@isTest
    private static void testSetClaimExtrajudicialCostNoteNumber() {
         ClaimTriggerhandler.Deactivate = true;
        User u = TestData.legalUser();
        Claim__c c = ClaimsTests.buildClaim(u, null, 0, null, null);
        c.extrajudicial_Cost_Note_Number__c = null;
        insert c;

    	Cost_Note__c cn = TestData.createCostNote(c.ID, 'Draft');
        cn.type__c = 'Außergerichtlich';
        cn.number__c = '12345';
        insert cn;

        Test.startTest();
        cn.stage__c = 'Sent';
        update cn;
        Test.stopTest();

        c = [SELECT Extrajudicial_Cost_Note_Number__c FROM Claim__c];
        System.assertEquals('12345', c.extrajudicial_Cost_Note_Number__c);
    }

    /*******************
     * setNumber tests *
     *******************/

	@isTest
	static void testNotCustomerDgInsert() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
        ClaimTriggerhandler.Deactivate = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
		costNote.Recipient__c = 'Legal Protection Insurance';

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '000001/DG', costNote.Number__c);
	}

	@isTest
	static void testNotCustomerDgUpdate() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
		costNote.Date__c = null;
        costNote.Type__c = 'Sonstiges';
		insert costNote;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		costNote.Date__c = System.today();
		update costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
		System.assertEquals(String.valueOf(System.now().date().year()) + '000001/DG', costNote.Number__c);
	}

	@isTest
	static void testNotCustomerFzInsert() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
        costNote.Type__c = 'Sonstiges';

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
		System.assertEquals(String.valueOf(System.now().date().year()) + '000001/CVRFZ', costNote.Number__c);
	}

	@isTest
	static void testNotCustomerFzUpdate() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
		costNote.Date__c = null;
        costNote.Type__c = 'Sonstiges';
		insert costNote;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		costNote.Date__c = System.today();
		update costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
		System.assertEquals(String.valueOf(System.now().date().year()) + '000001/CVRFZ', costNote.Number__c);
	}

	@isTest
	static void testNotCustomerLvInsert() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;
        User user = TestData.createUser();
        insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeID = Opportunities.lebensversicherungRecordType();
        opportunity.Callcenter__c = user.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
        costNote.Type__c = 'Sonstiges';

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
		System.assertEquals(String.valueOf(System.now().date().year()) + '000001/21VRLV', costNote.Number__c);
	}

	@isTest
	static void testCustomerInsert() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Customer';
        costNote.Type__c = 'Sonstiges';

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
		System.assert(costNote.Number__c == null);
	}

	@isTest
	static void testTestInsert() {
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		opportunity.Test__c = true;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
		costNote.Recipient__c = 'Legal Protection Insurance';
        costNote.Type__c = 'Sonstiges';

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

		insert costNote;

		Test.stopTest();

		// Assertion
		costNote = [select Id, Number__c from Cost_Note__c where Id = :costNote.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '000001/Test', costNote.Number__c);
	}

    /******************************
     * setRemindersCanceled tests *
     ******************************/

	@isTest
	static void testDraft(){
		// Testsetup
		TriggerConfiguration.allInactive = true;
		ClaimTriggerhandler.Deactivate = true;

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
		insert claim;
		Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Sent');
        costNote.Type__c = 'Sonstiges';
        costNote.stage__c = 'Sent';
		insert costNote;
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(costNote.Id, 10000);
        costNoteLineItem.Type__c = 'Sonstiges';
		insert costNoteLineItem;
		Cost_Note_Reminder__c costNoteReminder = TestData.createCostNoteReminder(costNote.Id, 'Draft');
		insert costNoteReminder;

        costNote = [SELECT Id, (SELECT ID, Stage__c FROM Cost_Note_Reminders__r) FROM Cost_Note__c WHERE Id = :costNote.Id];
        TriggerConfiguration.allInactive = false;
        costNote.stage__c = 'Sent';
        update costNote;
		// Test
		Test.startTest();

		costNote.Stage__c = 'Paid';
		update costNote;

		Test.stopTest();

		// Assertion
		costNoteReminder = [SELECT Id, Stage__c FROM Cost_Note_Reminder__c WHERE Id = :costNoteReminder.Id];
		System.AssertEquals('Canceled', costNoteReminder.Stage__c);
	}
}