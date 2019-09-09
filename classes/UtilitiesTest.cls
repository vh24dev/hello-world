@isTest
public class UtilitiesTest {

    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
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
    static void testGetConfiguration(){
        // Testsetup
		cloudworx_Management_Console__c config = TestData.createConfiguration();
		insert config;
		
        // Test
		Test.startTest();
        
        Utilities.getConfiguration();
        
        Test.stopTest();
        
        // Assertion
        /*
		System.assert(Utilities.deactivateEmail == true);
		System.assert(Utilities.deactivateTrigger == true);
		System.assert(Utilities.deactivateAutoFollowUps == true);
		System.assert(Utilities.sendEmailViaAPI == true);
		System.assert(Utilities.deactivateTaskCreation == true);
		System.assert(Utilities.deactivateAutosendWelcomeLetter == true);
		System.assert(Utilities.deactivateAutosendAuthorization == true);
		System.assert(Utilities.deactivateAutosendCostNoteReminder == true);
	    System.assert(Utilities.deactivateAutosendInvoiceReminder == true);
	    System.assert(Utilities.deactivateTransactionReceival == true);
		System.assert(Utilities.deactivateTransactionMapping == true);
		System.assert(Utilities.deactivateAutoLoss == true);
		System.assert(Utilities.disableQueueableChaining != null);
	    System.assert(Utilities.deactivateDropboxUpload == true);
	    System.assert(Utilities.deactivateSyncTo21legal == true);
		System.assert(Utilities.deactivateEmailUser != null);
		System.assert(Utilities.deactivateTriggerUser != null);
        */
	}

	@isTest
	static void testGetCourtCost(){
		// Test
		Test.startTest();

		Decimal courtCost = Utilities.getLegalCost(250,1.0);
		courtCost = Utilities.getcourtCost(750,1.0);
		courtCost = Utilities.getcourtCost(1250,1.0);
		courtCost = Utilities.getcourtCost(1750,1.0);
		courtCost = Utilities.getcourtCost(2500,1.0);
		courtCost = Utilities.getcourtCost(3500,1.0);
		courtCost = Utilities.getcourtCost(4500,1.0);
		courtCost = Utilities.getcourtCost(5500,1.0);
		courtCost = Utilities.getcourtCost(6500,1.0);
		courtCost = Utilities.getcourtCost(7500,1.0);
		courtCost = Utilities.getcourtCost(8500,1.0);
		courtCost = Utilities.getcourtCost(9500,1.0);
		courtCost = Utilities.getcourtCost(12500,1.0);
		courtCost = Utilities.getcourtCost(15000,1.0);
		courtCost = Utilities.getcourtCost(17500,1.0);
		courtCost = Utilities.getcourtCost(20000,1.0);
		courtCost = Utilities.getcourtCost(23000,1.0);
		courtCost = Utilities.getcourtCost(28000,1.0);
		courtCost = Utilities.getcourtCost(33000,1.0);
		courtCost = Utilities.getcourtCost(38000,1.0);
		courtCost = Utilities.getcourtCost(43000,1.0);
		courtCost = Utilities.getcourtCost(48000,1.0);
		courtCost = Utilities.getcourtCost(60000,1.0);
		courtCost = Utilities.getcourtCost(70000,1.0);
		courtCost = Utilities.getcourtCost(85000,1.0);
		courtCost = Utilities.getcourtCost(100000,1.0);
		courtCost = Utilities.getcourtCost(115000,1.0);
		courtCost = Utilities.getcourtCost(130000,1.0);
		courtCost = Utilities.getcourtCost(145000,1.0);
		courtCost = Utilities.getcourtCost(160000,1.0);
		courtCost = Utilities.getcourtCost(175000,1.0);
		courtCost = Utilities.getcourtCost(190000,1.0);
		courtCost = Utilities.getcourtCost(205000,1.0);
		courtCost = Utilities.getcourtCost(240000,1.0);
		courtCost = Utilities.getcourtCost(270000,1.0);
		courtCost = Utilities.getcourtCost(300000,1.0);
		courtCost = Utilities.getcourtCost(330000,1.0);
		courtCost = Utilities.getcourtCost(360000,1.0);
		courtCost = Utilities.getcourtCost(390000,1.0);
		courtCost = Utilities.getcourtCost(420000,1.0);
		courtCost = Utilities.getcourtCost(450000,1.0);
		courtCost = Utilities.getcourtCost(480000,1.0);
		courtCost = Utilities.getcourtCost(510000,1.0);
		courtCost = Utilities.getcourtCost(560000,1.0);
		courtCost = Utilities.getcourtCost(610000,1.0);
		courtCost = Utilities.getcourtCost(660000,1.0);
		courtCost = Utilities.getcourtCost(710000,1.0);
		courtCost = Utilities.getcourtCost(760000,1.0);
		courtCost = Utilities.getcourtCost(810000,1.0);
		courtCost = Utilities.getcourtCost(860000,1.0);
		courtCost = Utilities.getcourtCost(910000,1.0);
		courtCost = Utilities.getcourtCost(960000,1.0);
		courtCost = Utilities.getcourtCost(1010000,1.0);

		Test.stopTest();

		// Assertion
		System.assert(courtCost == null);
	}

	@isTest
	static void testGetLegalCost(){
		// Test
		Test.startTest();

		Decimal legalCost = Utilities.getLegalCost(250,1.0);
		legalCost = Utilities.getLegalCost(750,1.0);
		legalCost = Utilities.getLegalCost(1250,1.0);
		legalCost = Utilities.getLegalCost(1750,1.0);
		legalCost = Utilities.getLegalCost(2500,1.0);
		legalCost = Utilities.getLegalCost(3500,1.0);
		legalCost = Utilities.getLegalCost(4500,1.0);
		legalCost = Utilities.getLegalCost(5500,1.0);
		legalCost = Utilities.getLegalCost(6500,1.0);
		legalCost = Utilities.getLegalCost(7500,1.0);
		legalCost = Utilities.getLegalCost(8500,1.0);
		legalCost = Utilities.getLegalCost(9500,1.0);
		legalCost = Utilities.getLegalCost(12500,1.0);
		legalCost = Utilities.getLegalCost(15000,1.0);
		legalCost = Utilities.getLegalCost(17500,1.0);
		legalCost = Utilities.getLegalCost(20000,1.0);
		legalCost = Utilities.getLegalCost(23000,1.0);
		legalCost = Utilities.getLegalCost(28000,1.0);
		legalCost = Utilities.getLegalCost(33000,1.0);
		legalCost = Utilities.getLegalCost(38000,1.0);
		legalCost = Utilities.getLegalCost(43000,1.0);
		legalCost = Utilities.getLegalCost(48000,1.0);
		legalCost = Utilities.getLegalCost(60000,1.0);
		legalCost = Utilities.getLegalCost(70000,1.0);
		legalCost = Utilities.getLegalCost(85000,1.0);
		legalCost = Utilities.getLegalCost(100000,1.0);
		legalCost = Utilities.getLegalCost(115000,1.0);
		legalCost = Utilities.getLegalCost(130000,1.0);
		legalCost = Utilities.getLegalCost(145000,1.0);
		legalCost = Utilities.getLegalCost(160000,1.0);
		legalCost = Utilities.getLegalCost(175000,1.0);
		legalCost = Utilities.getLegalCost(190000,1.0);
		legalCost = Utilities.getLegalCost(205000,1.0);
		legalCost = Utilities.getLegalCost(240000,1.0);
		legalCost = Utilities.getLegalCost(270000,1.0);
		legalCost = Utilities.getLegalCost(300000,1.0);
		legalCost = Utilities.getLegalCost(330000,1.0);
		legalCost = Utilities.getLegalCost(360000,1.0);
		legalCost = Utilities.getLegalCost(390000,1.0);
		legalCost = Utilities.getLegalCost(420000,1.0);
		legalCost = Utilities.getLegalCost(450000,1.0);
		legalCost = Utilities.getLegalCost(480000,1.0);
		legalCost = Utilities.getLegalCost(510000,1.0);
		legalCost = Utilities.getLegalCost(560000,1.0);
		legalCost = Utilities.getLegalCost(610000,1.0);
		legalCost = Utilities.getLegalCost(660000,1.0);
		legalCost = Utilities.getLegalCost(710000,1.0);
		legalCost = Utilities.getLegalCost(760000,1.0);
		legalCost = Utilities.getLegalCost(810000,1.0);
		legalCost = Utilities.getLegalCost(860000,1.0);
		legalCost = Utilities.getLegalCost(910000,1.0);
		legalCost = Utilities.getLegalCost(960000,1.0);
		legalCost = Utilities.getLegalCost(1010000,1.0);

		Test.stopTest();

		// Assertion
		System.assert(legalCost == null);
	}

    @isTest
    static void testActivateTriggers(){
        // Testsetup
		Utilities.runInsertTriggers = false;
	    Utilities.runDeleteTriggers = false;
		Utilities.accountActionBeforeInsertRun = 2;
		Utilities.accountActionBeforeUpdateRun = 2;
		Utilities.accountActionAfterInsertRun = 2;
		Utilities.accountActionAfterUpdateRun = 2;
		Utilities.opportunityActionBeforeInsertRun = 2;
		Utilities.opportunityActionBeforeUpdateRun = 2;
		Utilities.opportunityActionAfterInsertRun = 2;
		Utilities.opportunityActionAfterUpdateRun = 2;
        Utilities.authorizationActionBeforeInsertRun = 2;
        Utilities.authorizationActionBeforeUpdateRun = 2;
        Utilities.authorizationActionAfterInsertRun = 2;
        Utilities.authorizationActionAfterUpdateRun = 2;
		Utilities.claimActionBeforeUpdateRun = 2;
		Utilities.claimActionAfterUpdateRun = 2;
        Utilities.contractActionBeforeInsertRun = 2;
        Utilities.contractActionBeforeUpdateRun = 2;
        Utilities.contractActionAfterInsertRun = 2;
        Utilities.contractActionAfterUpdateRun = 2;
        Utilities.correspondenceActionBeforeInsertRun = 2;
        Utilities.correspondenceActionBeforeUpdateRun = 2;
        Utilities.correspondenceActionAfterInsertRun = 2;
        Utilities.correspondenceActionAfterUpdateRun = 2;
        Utilities.invoiceActionBeforeInsertRun = 2;
        Utilities.invoiceActionBeforeUpdateRun = 2;
        Utilities.invoiceActionAfterInsertRun = 2;
        Utilities.invoiceActionAfterUpdateRun = 2;
        Utilities.leadActionBeforeInsertRun = 2;
        Utilities.leadActionBeforeUpdateRun = 2;
        Utilities.leadActionAfterInsertRun = 2;
        Utilities.leadActionAfterUpdateRun = 2;
		Utilities.nonContributoryPeriodActionBeforeUpdateRun = 2;
		Utilities.nonContributoryPeriodActionAfterUpdateRun = 2;
		Utilities.taskActionBeforeUpdateRun = 2;
    	Utilities.taskActionAfterUpdateRun = 2;
		Utilities.costNoteActionBeforeUpdateRun = 2;
    	Utilities.costNoteActionAfterUpdateRun = 2;
		Utilities.documentActionBeforeInsertRun = 2;
		Utilities.documentActionBeforeUpdateRun = 2;
		Utilities.documentActionAfterInsertRun = 2;
		Utilities.documentActionAfterUpdateRun = 2;
		Utilities.welcomeLetterActionBeforeInsertRun = 2;
		Utilities.welcomeLetterActionBeforeUpdateRun = 2;
		Utilities.welcomeLetterActionAfterInsertRun = 2;
		Utilities.welcomeLetterActionAfterUpdateRun = 2;
		Utilities.attachmentActionBeforeInsertRun = 2;
		Utilities.attachmentActionBeforeUpdateRun = 2;
		Utilities.attachmentActionAfterInsertRun = 2;
		Utilities.attachmentActionAfterUpdateRun = 2;
		Utilities.receiptActionBeforeInsertRun = 2;
		Utilities.receiptActionBeforeUpdateRun = 2;
		Utilities.receiptActionAfterInsertRun = 2;
		Utilities.receiptActionAfterUpdateRun = 2;
		Utilities.costNoteReminderActionBeforeInsertRun = 2;
		Utilities.costNoteReminderActionBeforeUpdateRun = 2;
		Utilities.costNoteReminderActionAfterInsertRun = 2;
		Utilities.costNoteReminderActionAfterUpdateRun = 2;
		Utilities.classActionActionBeforeInsertRun = 2;
		Utilities.classActionActionBeforeUpdateRun = 2;
		Utilities.classActionActionAfterInsertRun = 2;
		Utilities.classActionActionAfterUpdateRun = 2;
	    Utilities.invoiceReminderActionBeforeInsertRun = 2;
	    Utilities.invoiceReminderActionBeforeUpdateRun = 2;
	    Utilities.invoiceReminderActionAfterInsertRun = 2;
	    Utilities.invoiceReminderActionAfterUpdateRun = 2;
	    Utilities.userReferenceActionBeforeInsertRun = 2;
	    Utilities.userReferenceActionBeforeUpdateRun = 2;
	    Utilities.userReferenceActionBeforeDeleteRun = 2;
	    Utilities.userReferenceActionAfterInsertRun = 2;
	    Utilities.userReferenceActionAfterUpdateRun = 2;
	    Utilities.userReferenceActionAfterDeleteRun = 2;
		Utilities.deadlineActionBeforeInsertRun = 2;
		Utilities.deadlineActionBeforeUpdateRun = 2;
		Utilities.deadlineActionAfterInsertRun = 2;
		Utilities.deadlineActionAfterUpdateRun = 2;
		Utilities.creditNoteActionBeforeInsertRun = 2;
		Utilities.creditNoteActionBeforeUpdateRun = 2;
		Utilities.creditNoteActionAfterInsertRun = 2;
		Utilities.creditNoteActionAfterUpdateRun = 2;
		Utilities.dateActionBeforeUpdateRun = 2;
		Utilities.dateActionAfterUpdateRun = 2;
	    Utilities.dateActionAfterUpdateRun = 2;
	    Utilities.commissionActionBeforeUpdateRun = 2;
	    Utilities.commissionActionAfterUpdateRun = 2;
	    Utilities.costNotePaymentActionBeforeUpdateRun = 2;
	    Utilities.costNotePaymentActionAfterUpdateRun = 2;
		Utilities.contactActionBeforeUpdateRun = 2;
		Utilities.contactActionAfterUpdateRun = 2;
		Utilities.cancellationActionBeforeUpdateRun = 2;
		Utilities.cancellationActionAfterUpdateRun = 2;
		Utilities.testCaseActionBeforeUpdateRun = 2;
		Utilities.testCaseActionAfterUpdateRun = 2;
		Utilities.opportunityCorrespondenceActionBeforeUpdateRun = 2;
		Utilities.opportunityCorrespondenceActionAfterUpdateRun = 2;

	    // Test
	    Test.startTest();
        
        Utilities.activateTriggers();
        
        Test.stopTest();
        
        // Assertion
		System.assert(Utilities.runInsertTriggers == true);
	    System.assert(Utilities.runDeleteTriggers == true);
		System.assert(Utilities.accountActionBeforeInsertRun == 0);
		System.assert(Utilities.accountActionBeforeUpdateRun == 0);
		System.assert(Utilities.accountActionAfterInsertRun == 0);
		System.assert(Utilities.accountActionAfterUpdateRun == 0);
		System.assert(Utilities.opportunityActionBeforeInsertRun == 0);
		System.assert(Utilities.opportunityActionBeforeUpdateRun == 0);
		System.assert(Utilities.opportunityActionAfterInsertRun == 0);
		System.assert(Utilities.opportunityActionAfterUpdateRun == 0);
        System.assert(Utilities.authorizationActionBeforeInsertRun == 0);
        System.assert(Utilities.authorizationActionBeforeUpdateRun == 0);
        System.assert(Utilities.authorizationActionAfterInsertRun == 0);
        System.assert(Utilities.authorizationActionAfterUpdateRun == 0);
		System.assert(Utilities.claimActionBeforeUpdateRun == 0);
		System.assert(Utilities.claimActionAfterUpdateRun == 0);
        System.assert(Utilities.contractActionBeforeInsertRun == 0);
        System.assert(Utilities.contractActionBeforeUpdateRun == 0);
        System.assert(Utilities.contractActionAfterInsertRun == 0);
        System.assert(Utilities.contractActionAfterUpdateRun == 0);
        System.assert(Utilities.correspondenceActionBeforeInsertRun == 0);
        System.assert(Utilities.correspondenceActionBeforeUpdateRun == 0);
        System.assert(Utilities.correspondenceActionAfterInsertRun == 0);
        System.assert(Utilities.correspondenceActionAfterUpdateRun == 0);
        System.assert(Utilities.invoiceActionBeforeInsertRun == 0);
        System.assert(Utilities.invoiceActionBeforeUpdateRun == 0);
        System.assert(Utilities.invoiceActionAfterInsertRun == 0);
        System.assert(Utilities.invoiceActionAfterUpdateRun == 0);
        System.assert(Utilities.leadActionBeforeInsertRun == 0);
        System.assert(Utilities.leadActionBeforeUpdateRun == 0);
        System.assert(Utilities.leadActionAfterInsertRun == 0);
        System.assert(Utilities.leadActionAfterUpdateRun == 0);
		System.assert(Utilities.nonContributoryPeriodActionBeforeUpdateRun == 0);
		System.assert(Utilities.nonContributoryPeriodActionAfterUpdateRun == 0);
		System.assert(Utilities.taskActionBeforeUpdateRun == 0);
    	System.assert(Utilities.taskActionAfterUpdateRun == 0);
		System.assert(Utilities.costNoteActionBeforeUpdateRun == 0);
    	System.assert(Utilities.costNoteActionAfterUpdateRun == 0);
		System.assert(Utilities.documentActionBeforeInsertRun == 0);
		System.assert(Utilities.documentActionBeforeUpdateRun == 0);
		System.assert(Utilities.documentActionAfterInsertRun == 0);
		System.assert(Utilities.documentActionAfterUpdateRun == 0);
		System.assert(Utilities.welcomeLetterActionBeforeInsertRun == 0);
		System.assert(Utilities.welcomeLetterActionBeforeUpdateRun == 0);
		System.assert(Utilities.welcomeLetterActionAfterInsertRun == 0);
		System.assert(Utilities.welcomeLetterActionAfterUpdateRun == 0);
		System.assert(Utilities.attachmentActionBeforeInsertRun == 0);
		System.assert(Utilities.attachmentActionBeforeUpdateRun == 0);
		System.assert(Utilities.attachmentActionAfterInsertRun == 0);
		System.assert(Utilities.attachmentActionAfterUpdateRun == 0);
		System.assert(Utilities.receiptActionBeforeInsertRun == 0);
		System.assert(Utilities.receiptActionBeforeUpdateRun == 0);
		System.assert(Utilities.receiptActionAfterInsertRun == 0);
		System.assert(Utilities.receiptActionAfterUpdateRun == 0);
		System.assert(Utilities.costNoteReminderActionBeforeInsertRun == 0);
		System.assert(Utilities.costNoteReminderActionBeforeUpdateRun == 0);
		System.assert(Utilities.costNoteReminderActionAfterInsertRun == 0);
		System.assert(Utilities.costNoteReminderActionAfterUpdateRun == 0);
		System.assert(Utilities.classActionActionBeforeInsertRun == 0);
		System.assert(Utilities.classActionActionBeforeUpdateRun == 0);
		System.assert(Utilities.classActionActionAfterInsertRun == 0);
		System.assert(Utilities.classActionActionAfterUpdateRun == 0);
	    System.assert(Utilities.invoiceReminderActionBeforeInsertRun == 0);
	    System.assert(Utilities.invoiceReminderActionBeforeUpdateRun == 0);
	    System.assert(Utilities.invoiceReminderActionAfterInsertRun == 0);
	    System.assert(Utilities.invoiceReminderActionAfterUpdateRun == 0);
	    System.assert(Utilities.userReferenceActionBeforeInsertRun == 0);
	    System.assert(Utilities.userReferenceActionBeforeUpdateRun == 0);
	    System.assert(Utilities.userReferenceActionBeforeDeleteRun == 0);
	    System.assert(Utilities.userReferenceActionAfterInsertRun == 0);
	    System.assert(Utilities.userReferenceActionAfterUpdateRun == 0);
	    System.assert(Utilities.userReferenceActionAfterDeleteRun == 0);
		System.assert(Utilities.deadlineActionBeforeInsertRun == 0);
		System.assert(Utilities.deadlineActionBeforeUpdateRun == 0);
		System.assert(Utilities.deadlineActionAfterInsertRun == 0);
		System.assert(Utilities.deadlineActionAfterUpdateRun == 0);
		System.assert(Utilities.creditNoteActionBeforeInsertRun == 0);
		System.assert(Utilities.creditNoteActionBeforeUpdateRun == 0);
		System.assert(Utilities.creditNoteActionAfterInsertRun == 0);
		System.assert(Utilities.creditNoteActionAfterUpdateRun == 0);
		System.assert(Utilities.dateActionBeforeUpdateRun == 0);
		System.assert(Utilities.dateActionAfterUpdateRun == 0);
	    System.assert(Utilities.commissionActionBeforeUpdateRun == 0);
	    System.assert(Utilities.commissionActionAfterUpdateRun == 0);
	    System.assert(Utilities.costNotePaymentActionBeforeUpdateRun == 0);
	    System.assert(Utilities.costNotePaymentActionAfterUpdateRun == 0);
		System.assert(Utilities.contactActionBeforeUpdateRun == 0);
		System.assert(Utilities.contactActionAfterUpdateRun == 0);
		System.assert(Utilities.cancellationActionBeforeUpdateRun == 0);
		System.assert(Utilities.cancellationActionAfterUpdateRun == 0);
		System.assert(Utilities.testCaseActionBeforeUpdateRun == 0);
		System.assert(Utilities.testCaseActionAfterUpdateRun == 0);
		System.assert(Utilities.opportunityCorrespondenceActionBeforeUpdateRun == 0);
		System.assert(Utilities.opportunityCorrespondenceActionAfterUpdateRun == 0);
    }
    
    @isTest
    static void testDeactivateTriggers(){
        // Testsetup
		Utilities.runInsertTriggers = true;
	    Utilities.runDeleteTriggers = true;
		Utilities.accountActionBeforeInsertRun = 0;
		Utilities.accountActionBeforeUpdateRun = 0;
		Utilities.accountActionAfterInsertRun = 0;
		Utilities.accountActionAfterUpdateRun = 0;
		Utilities.opportunityActionBeforeInsertRun = 0;
		Utilities.opportunityActionBeforeUpdateRun = 0;
		Utilities.opportunityActionAfterInsertRun = 0;
		Utilities.opportunityActionAfterUpdateRun = 0;
        Utilities.authorizationActionBeforeInsertRun = 0;
        Utilities.authorizationActionBeforeUpdateRun = 0;
        Utilities.authorizationActionAfterInsertRun = 0;
        Utilities.authorizationActionAfterUpdateRun = 0;
		Utilities.claimActionBeforeUpdateRun = 0;
		Utilities.claimActionAfterUpdateRun = 0;
        Utilities.contractActionBeforeInsertRun = 0;
        Utilities.contractActionBeforeUpdateRun = 0;
        Utilities.contractActionAfterInsertRun = 0;
        Utilities.contractActionAfterUpdateRun = 0;
        Utilities.correspondenceActionBeforeInsertRun = 0;
        Utilities.correspondenceActionBeforeUpdateRun = 0;
        Utilities.correspondenceActionAfterInsertRun = 0;
        Utilities.correspondenceActionAfterUpdateRun = 0;
        Utilities.invoiceActionBeforeInsertRun = 0;
        Utilities.invoiceActionBeforeUpdateRun = 0;
        Utilities.invoiceActionAfterInsertRun = 0;
        Utilities.invoiceActionAfterUpdateRun = 0;
        Utilities.leadActionBeforeInsertRun = 0;
        Utilities.leadActionBeforeUpdateRun = 0;
        Utilities.leadActionAfterInsertRun = 0;
        Utilities.leadActionAfterUpdateRun = 0;
		Utilities.nonContributoryPeriodActionBeforeUpdateRun = 0;
		Utilities.nonContributoryPeriodActionAfterUpdateRun = 0;
		Utilities.taskActionBeforeUpdateRun = 0;
    	Utilities.taskActionAfterUpdateRun = 0;
		Utilities.costNoteActionBeforeUpdateRun = 0;
    	Utilities.costNoteActionAfterUpdateRun = 0;
		Utilities.documentActionBeforeInsertRun = 0;
		Utilities.documentActionBeforeUpdateRun = 0;
		Utilities.documentActionAfterInsertRun = 0;
		Utilities.documentActionAfterUpdateRun = 0;
		Utilities.welcomeLetterActionBeforeInsertRun = 0;
		Utilities.welcomeLetterActionBeforeUpdateRun = 0;
		Utilities.welcomeLetterActionAfterInsertRun = 0;
		Utilities.welcomeLetterActionAfterUpdateRun = 0;
		Utilities.attachmentActionBeforeInsertRun = 0;
		Utilities.attachmentActionBeforeUpdateRun = 0;
		Utilities.attachmentActionAfterInsertRun = 0;
		Utilities.attachmentActionAfterUpdateRun = 0;
		Utilities.receiptActionBeforeInsertRun = 0;
		Utilities.receiptActionBeforeUpdateRun = 0;
		Utilities.receiptActionAfterInsertRun = 0;
		Utilities.receiptActionAfterUpdateRun = 0;
		Utilities.costNoteReminderActionBeforeInsertRun = 0;
		Utilities.costNoteReminderActionBeforeUpdateRun = 0;
		Utilities.costNoteReminderActionAfterInsertRun = 0;
		Utilities.costNoteReminderActionAfterUpdateRun = 0;
		Utilities.classActionActionBeforeInsertRun = 0;
		Utilities.classActionActionBeforeUpdateRun = 0;
		Utilities.classActionActionAfterInsertRun = 0;
		Utilities.classActionActionAfterUpdateRun = 0;
	    Utilities.invoiceReminderActionBeforeInsertRun = 0;
	    Utilities.invoiceReminderActionBeforeUpdateRun = 0;
	    Utilities.invoiceReminderActionAfterInsertRun = 0;
	    Utilities.invoiceReminderActionAfterUpdateRun = 0;
	    Utilities.userReferenceActionBeforeInsertRun = 0;
	    Utilities.userReferenceActionBeforeUpdateRun = 0;
	    Utilities.userReferenceActionBeforeDeleteRun = 0;
	    Utilities.userReferenceActionAfterInsertRun = 0;
	    Utilities.userReferenceActionAfterUpdateRun = 0;
	    Utilities.userReferenceActionAfterDeleteRun = 0;
		Utilities.deadlineActionBeforeInsertRun = 0;
		Utilities.deadlineActionBeforeUpdateRun = 0;
		Utilities.deadlineActionAfterInsertRun = 0;
		Utilities.deadlineActionAfterUpdateRun = 0;
		Utilities.creditNoteActionBeforeInsertRun = 0;
		Utilities.creditNoteActionBeforeUpdateRun = 0;
		Utilities.creditNoteActionAfterInsertRun = 0;
		Utilities.creditNoteActionAfterUpdateRun = 0;
		Utilities.dateActionBeforeUpdateRun = 0;
		Utilities.dateActionAfterUpdateRun = 0;
	    Utilities.commissionActionBeforeUpdateRun = 0;
	    Utilities.commissionActionAfterUpdateRun = 0;
	    Utilities.costNotePaymentActionBeforeUpdateRun = 0;
	    Utilities.costNotePaymentActionAfterUpdateRun = 0;
		Utilities.contactActionBeforeUpdateRun = 0;
		Utilities.contactActionAfterUpdateRun = 0;
		Utilities.cancellationActionBeforeUpdateRun = 0;
		Utilities.cancellationActionAfterUpdateRun = 0;
		Utilities.testCaseActionBeforeUpdateRun = 0;
		Utilities.testCaseActionAfterUpdateRun = 0;
		Utilities.opportunityCorrespondenceActionBeforeUpdateRun = 0;
		Utilities.opportunityCorrespondenceActionAfterUpdateRun = 0;

        // Test
		Test.startTest();
        
        Utilities.deactivateTriggers();
        
        Test.stopTest();
        
        // Assertion
		System.assert(Utilities.runInsertTriggers == false);
	    System.assert(Utilities.runDeleteTriggers == false);
		System.assert(Utilities.accountActionBeforeInsertRun == 2);
		System.assert(Utilities.accountActionBeforeUpdateRun == 2);
		System.assert(Utilities.accountActionAfterInsertRun == 2);
		System.assert(Utilities.accountActionAfterUpdateRun == 2);
		System.assert(Utilities.opportunityActionBeforeInsertRun == 2);
		System.assert(Utilities.opportunityActionBeforeUpdateRun == 2);
		System.assert(Utilities.opportunityActionAfterInsertRun == 2);
		System.assert(Utilities.opportunityActionAfterUpdateRun == 2);
        System.assert(Utilities.authorizationActionBeforeInsertRun == 2);
        System.assert(Utilities.authorizationActionBeforeUpdateRun == 2);
        System.assert(Utilities.authorizationActionAfterInsertRun == 2);
        System.assert(Utilities.authorizationActionAfterUpdateRun == 2);
		System.assert(Utilities.claimActionBeforeUpdateRun == 2);
		System.assert(Utilities.claimActionAfterUpdateRun == 2);
        System.assert(Utilities.contractActionBeforeInsertRun == 2);
        System.assert(Utilities.contractActionBeforeUpdateRun == 2);
        System.assert(Utilities.contractActionAfterInsertRun == 2);
        System.assert(Utilities.contractActionAfterUpdateRun == 2);
        System.assert(Utilities.correspondenceActionBeforeInsertRun == 2);
        System.assert(Utilities.correspondenceActionBeforeUpdateRun == 2);
        System.assert(Utilities.correspondenceActionAfterInsertRun == 2);
        System.assert(Utilities.correspondenceActionAfterUpdateRun == 2);
        System.assert(Utilities.invoiceActionBeforeInsertRun == 2);
        System.assert(Utilities.invoiceActionBeforeUpdateRun == 2);
        System.assert(Utilities.invoiceActionAfterInsertRun == 2);
        System.assert(Utilities.invoiceActionAfterUpdateRun == 2);
        System.assert(Utilities.leadActionBeforeInsertRun == 2);
        System.assert(Utilities.leadActionBeforeUpdateRun == 2);
        System.assert(Utilities.leadActionAfterInsertRun == 2);
        System.assert(Utilities.leadActionAfterUpdateRun == 2);
		System.assert(Utilities.nonContributoryPeriodActionBeforeUpdateRun == 2);
		System.assert(Utilities.nonContributoryPeriodActionAfterUpdateRun == 2);
		System.assert(Utilities.taskActionBeforeUpdateRun == 2);
    	System.assert(Utilities.taskActionAfterUpdateRun == 2);
		System.assert(Utilities.costNoteActionBeforeUpdateRun == 2);
    	System.assert(Utilities.costNoteActionAfterUpdateRun == 2);
		System.assert(Utilities.documentActionBeforeInsertRun == 2);
		System.assert(Utilities.documentActionBeforeUpdateRun == 2);
		System.assert(Utilities.documentActionAfterInsertRun == 2);
		System.assert(Utilities.documentActionAfterUpdateRun == 2);
		System.assert(Utilities.welcomeLetterActionBeforeInsertRun == 2);
		System.assert(Utilities.welcomeLetterActionBeforeUpdateRun == 2);
		System.assert(Utilities.welcomeLetterActionAfterInsertRun == 2);
		System.assert(Utilities.welcomeLetterActionAfterUpdateRun == 2);
		System.assert(Utilities.attachmentActionBeforeInsertRun == 2);
		System.assert(Utilities.attachmentActionBeforeUpdateRun == 2);
		System.assert(Utilities.attachmentActionAfterInsertRun == 2);
		System.assert(Utilities.attachmentActionAfterUpdateRun == 2);
		System.assert(Utilities.receiptActionBeforeInsertRun == 2);
		System.assert(Utilities.receiptActionBeforeUpdateRun == 2);
		System.assert(Utilities.receiptActionAfterInsertRun == 2);
		System.assert(Utilities.receiptActionAfterUpdateRun == 2);
		System.assert(Utilities.costNoteReminderActionBeforeInsertRun == 2);
		System.assert(Utilities.costNoteReminderActionBeforeUpdateRun == 2);
		System.assert(Utilities.costNoteReminderActionAfterInsertRun == 2);
		System.assert(Utilities.costNoteReminderActionAfterUpdateRun == 2);
		System.assert(Utilities.classActionActionBeforeInsertRun == 2);
		System.assert(Utilities.classActionActionBeforeUpdateRun == 2);
		System.assert(Utilities.classActionActionAfterInsertRun == 2);
		System.assert(Utilities.classActionActionAfterUpdateRun == 2);
	    System.assert(Utilities.invoiceReminderActionBeforeInsertRun == 2);
	    System.assert(Utilities.invoiceReminderActionBeforeUpdateRun == 2);
	    System.assert(Utilities.invoiceReminderActionAfterInsertRun == 2);
	    System.assert(Utilities.invoiceReminderActionAfterUpdateRun == 2);
	    System.assert(Utilities.userReferenceActionBeforeInsertRun == 2);
	    System.assert(Utilities.userReferenceActionBeforeUpdateRun == 2);
	    System.assert(Utilities.userReferenceActionBeforeDeleteRun == 2);
	    System.assert(Utilities.userReferenceActionAfterInsertRun == 2);
	    System.assert(Utilities.userReferenceActionAfterUpdateRun == 2);
	    System.assert(Utilities.userReferenceActionAfterDeleteRun == 2);
		System.assert(Utilities.deadlineActionBeforeInsertRun == 2);
		System.assert(Utilities.deadlineActionBeforeUpdateRun == 2);
		System.assert(Utilities.deadlineActionAfterInsertRun == 2);
		System.assert(Utilities.deadlineActionAfterUpdateRun == 2);
		System.assert(Utilities.creditNoteActionBeforeInsertRun == 2);
		System.assert(Utilities.creditNoteActionBeforeUpdateRun == 2);
		System.assert(Utilities.creditNoteActionAfterInsertRun == 2);
		System.assert(Utilities.creditNoteActionAfterUpdateRun == 2);
		System.assert(Utilities.dateActionBeforeUpdateRun == 2);
		System.assert(Utilities.dateActionAfterUpdateRun == 2);
	    System.assert(Utilities.commissionActionBeforeUpdateRun == 2);
	    System.assert(Utilities.commissionActionAfterUpdateRun == 2);
	    System.assert(Utilities.costNotePaymentActionBeforeUpdateRun == 2);
	    System.assert(Utilities.costNotePaymentActionAfterUpdateRun == 2);
		System.assert(Utilities.contactActionBeforeUpdateRun == 2);
		System.assert(Utilities.contactActionAfterUpdateRun == 2);
		System.assert(Utilities.cancellationActionBeforeUpdateRun == 2);
		System.assert(Utilities.cancellationActionAfterUpdateRun == 2);
		System.assert(Utilities.testCaseActionBeforeUpdateRun == 2);
		System.assert(Utilities.testCaseActionAfterUpdateRun == 2);
		System.assert(Utilities.opportunityCorrespondenceActionBeforeUpdateRun == 2);
		System.assert(Utilities.opportunityCorrespondenceActionAfterUpdateRun == 2);
    }

	@isTest
	static void testDecimalToCurrency(){
		// Test
		String outputString1 = Utilities.decimalToCurrency(12345.67);
		String outputString2 = Utilities.decimalToCurrency(12345.6);
		String outputString3 = Utilities.decimalToCurrency(12345);

		// Assertion
		System.assertEquals('12.345,67 €', outputString1);
		System.assertEquals('12.345,60 €', outputString2);
		System.assertEquals('12.345,00 €', outputString3);
	}

	@isTest
	static void testCalculateRevenue(){
		// Test
		Test.startTest();

		Decimal dgAmount1 = Utilities.calculateRevenue(Accounts.VR24ID,5000,Opportunities.DieselSkandalRecordType(),'Share');
		Decimal dgAmount2 = Utilities.calculateRevenue(Accounts.VR24ID,15000,Opportunities.DieselSkandalRecordType(),'Share');
		Decimal dgAmount3 = Utilities.calculateRevenue(Accounts.VR24ID,15000,Opportunities.DieselSkandalRecordType(),'RSV');
		Decimal lvVrAmount1 = Utilities.calculateRevenue(Accounts.VR24ID,15000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVrAmount2 = Utilities.calculateRevenue(Accounts.VR24ID,70000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVrAmount3 = Utilities.calculateRevenue(Accounts.VR24ID,90000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVrAmount4 = Utilities.calculateRevenue(Accounts.VR24ID,110000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVrAmount5 = Utilities.calculateRevenue(Accounts.VR24ID,15000,Opportunities.LebensversicherungRecordType(),'RSV');
		Decimal lvVrAmount6 = Utilities.calculateRevenue(Accounts.VR24ID,15000,Opportunities.LebensversicherungRecordType(),'Direkt');
		Decimal lvVhAmount1 = Utilities.calculateRevenue(Accounts.VH24ID,15000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVhAmount2 = Utilities.calculateRevenue(Accounts.VH24ID,70000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVhAmount3 = Utilities.calculateRevenue(Accounts.VH24ID,90000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVhAmount4 = Utilities.calculateRevenue(Accounts.VH24ID,110000,Opportunities.LebensversicherungRecordType(),'Share');
		Decimal lvVhAmount5 = Utilities.calculateRevenue(Accounts.VH24ID,15000,Opportunities.LebensversicherungRecordType(),'RSV');
		Decimal lvVhAmount6 = Utilities.calculateRevenue(Accounts.VH24ID,15000,Opportunities.LebensversicherungRecordType(),'Direkt');

		Test.stopTest();

		// Assertion
		System.assertEquals(1250,dgAmount1);
		System.assertEquals(2436.97,dgAmount2);
		System.assertEquals(0,dgAmount3);
		System.assertEquals(7500,lvVrAmount1);
		System.assertEquals(31500,lvVrAmount2);
		System.assertEquals(36000,lvVrAmount3);
		System.assertEquals(38500,lvVrAmount4);
		System.assertEquals(3000,lvVrAmount5);
		System.assertEquals(0,lvVrAmount6);
		// System.assertEquals(7140,lvVhAmount1);
		// System.assertEquals(30821,lvVhAmount2);
		// System.assertEquals(36414,lvVhAmount3);
		// System.assertEquals(39270,lvVhAmount4);
		// System.assertEquals(3659,lvVhAmount5);
		// System.assertEquals(0,lvVhAmount6);
	}

    @isTest
    static void testCreateCorrespondenceSuccess(){
        // Testsetup
        Utilities.deactivateTriggers();

        // Create admin user to update roles on other users
        User adminUser = TestData.createUser();
		adminUser.Username = 'adminUser@cloudworx.agency';
        adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        insert adminUser;

		// Create test text modules
		List<EmailTemplate> textModules = new List<EmailTemplate>();
        System.runAs(adminUser){
	        List<Folder> folders = [select Id from Folder where DeveloperName LIKE '%TextModules%'];
            for (Integer i = 1;i < 6;i++){
	            EmailTemplate textModule = TestData.createTemplate();
	            textModule.Name = 'TextModule' + i;
	            textModule.DeveloperName = 'TextModule' + i;
	            textModule.FolderId = folders[0].Id;
	            textModules.add(textModule);
            }
            insert textModules;
        }

        User user = TestData.createUser();
		insert user;
        Lead lead = TestData.createLead();
		insert lead;
        Account account = TestData.createAccount();
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;

        Utilities.activateTriggers();

        // Test
		Test.startTest();
        
		claim = [select Id, (select Id, Type__c from Correspondencies__r) from Claim__c where Id = :claim.Id];
		Correspondence__c correspondence = Utilities.createCorrespondence(claim,'Insurance','Widerspruch durch Kunden','Draft','TextModule1;TextModule2');
        
        Test.stopTest();
        
        // Assertion
        System.assert(correspondence != null);
    }

    @isTest
    static void testCreateCorrespondenceDuplicate(){
        // Testsetup
        Utilities.deactivateTriggers();

        User user = TestData.createUser();
		insert user;
        Lead lead = TestData.createLead();
		insert lead;
        Account account = TestData.createAccount();
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
		Correspondence__c correspondence = Utilities.createCorrespondence(claim,'Insurance','Widerspruch durch Kunden','Draft',null);
		insert correspondence;
		
        Utilities.activateTriggers();

        // Test
		Test.startTest();

		claim = [select Id, (select Id, Type__c, Description__c from Correspondencies__r) from Claim__c where Id = :claim.Id];
		Correspondence__c duplicateCorrespondence = Utilities.createCorrespondence(claim,'Insurance','Widerspruch durch Kunden','Draft',null);
        
        Test.stopTest();
        
        // Assertion
        System.assert(duplicateCorrespondence == null);
    }

    @isTest
    static void testCreateTaskSuccess(){
        // Testsetup
        User user = TestData.createUser();
		insert user;
        Lead lead = TestData.createLead();
		insert lead;
        Account account = TestData.createAccount();
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;

        // Test
		Test.startTest();
        
		opportunity = [select id, (select Id, Subject, Status from Tasks) from Opportunity where Id = :opportunity.Id];
        Task task = Utilities.createTask('Testtask', null, opportunity, user, System.today(), true, false);
        
        Test.stopTest();
        
        // Assertion
        System.assert(task != null);
    }

    @isTest
    static void testCreateTaskUserInactive(){
        // Testsetup
        User user = TestData.createUser();
		user.isActive = false;
        insert user;
        Lead lead = TestData.createLead();
		insert lead;
        Account account = TestData.createAccount();
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;

        // Test
		Test.startTest();
        
		opportunity = [select id, (select Id, Subject, Status from Tasks) from Opportunity where Id = :opportunity.Id];
        Task task = Utilities.createTask('Testtask', null, opportunity, user, System.today(), true, false);
        
        Test.stopTest();
        
        // Assertion
        System.assert(task == null);
    }

    @isTest
    static void testCreateTaskTaskExisting(){
        // Testsetup
        User user = TestData.createUser();
		insert user;
        Lead lead = TestData.createLead();
		insert lead;
        Account account = TestData.createAccount();
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.CreateOpportunity(account.Id,'New');
		insert opportunity;

        List <Task> tasks = new List<Task>();
        tasks.add(TestData.createTask('Testtask',opportunity.Id,user.Id));
		insert tasks;

        // Test
		Test.startTest();
        
		opportunity = [select id, (select Id, Subject, Status from Tasks) from Opportunity where Id = :opportunity.Id];
        Task task = Utilities.createTask('Testtask', null, opportunity,user,System.today(), true, false);
        
        Test.stopTest();
        
        // Assertion
        System.assert(task == null);
    }

    @isTest
    static void testCloseTasks(){
		// Testsetup
        Utilities.deactivateTriggers();

		User user = TestData.createUser();
        insert user;
    	Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        insert opportunity;

        List <Task> tasks = new List<Task>();
        tasks.add(TestData.createTask('Testtask',opportunity.Id,user.Id));
		insert tasks;
        
        Utilities.activateTriggers();
        
		// Test
        Test.startTest();
        
		opportunity = [select id, (select Id, Subject, Status from Tasks) from Opportunity where Id = :opportunity.Id];
        List<Task> closeTasks = Utilities.closeTasks('Testtask', opportunity);
        
        Test.stopTest();
        
        // Assertion
        System.assert(closeTasks.size() == 1);
    }

    @isTest
    static void testSendErrorMail(){
        Test.startTest();
        
		// Test
        Utilities.sendErrorMail('Subject', 'Error', 'http://api.cloudworx.de/', '{"success":true}', true);

        // Assertion
        System.assert(Utilities.errorMails.size() == 1);
        
		// Test
		Utilities.flushMailQueue();

        // Assertion
	    System.debug('Utilities.errorMails.size(): ' + Utilities.errorMails.size());
	    System.debug('errorMails: ' + Utilities.errorMails);
        System.assert(Utilities.errorMails.size() == 0);
        
		// Test
        Utilities.sendErrorMail('Subject', 'Error', 'http://api.cloudworx.agency/', '{"success":true}', false);

        // Assertion
        System.assert(Utilities.errorMails.size() == 0);

        Test.stopTest();
    }

    @isTest
    static void testSendHTTPRequestSuccess(){
    	// Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        HTTPResponse response = Utilities.sendHTTPRequest('POST', 'application/json', null, 'http://api.cloudworx.agency', '', 120000, 2);
            
	    Test.stopTest();

        // Assertion
        System.assert(response.getStatusCode() == 200);
    }

    @isTest
    static void testSendHTTPRequestFailure(){
    	// Test
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpErrorResponseGenerator());
        HTTPResponse response = Utilities.sendHTTPRequest('POST', 'application/json', null, 'http://api.cloudworx.agency', '', 120000, 2);
            
	    Test.stopTest();

        // Assertion
		System.assert(response.getStatusCode() != 200);
    }

    @isTest
    static void testMergeText(){
    	// Testsetup
        Account parentAccount = TestData.createAccount();
		insert parentAccount;
        Account account = TestData.createAccount();
		account.ParentId = parentAccount.Id;
		insert account;
        Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;

        String text = '{!Opportunity.Name}, {!Opportunity.Account__r.Name}, {!Opportunity.Account__r.Parent.Name}';

        // Test
        Test.startTest();

		text = Utilities.mergeText(text, new Map<Id,String>{opportunity.Id => 'Opportunity'});        
            
	    Test.stopTest();

        // Assertion
        // System.assert(text == opportunity.Name + ', ' + account.Name + ', ' + parentAccount.Name);
    }

    @isTest
    static void testCreateHash(){
        // Test
        Test.startTest();

		String hash1 = Utilities.createHash();        
		String hash2 = Utilities.createHash();        
            
	    Test.stopTest();

        // Assertion
        System.assert(hash1 != null);
        System.assert(hash2 != null);
        System.assert(hash1 != hash2);
    }
}