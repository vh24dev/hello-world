@isTest
public class TestData {

    public static cloudworx_Management_Console__c createConfiguration(){
		Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User'];
		User user = new User(
			Alias = 'testus',
			Email ='testconfiguser@cloudworx.agency',
			EmailEncodingKey ='UTF-8',
			LastName ='Testuser',
			LanguageLocaleKey ='en_US',
			LocaleSidKey ='en_US',
			ProfileId = profile.Id,
			TimeZoneSidKey ='America/Los_Angeles',
			UserName ='testconfiguser@cloudworx.agency',
			isActive = true
		);
		insert user;

		cloudworx_Management_Console__c config = new cloudworx_Management_Console__c(
    		Deactivate_Email__c = true,
			Deactivate_Trigger__c = true,
			Deactivate_Auto_Follow_ups__c = true,
    		Send_Email_Via_API__c = true,
    		Deactivate_Task_Creation__c = true,
            Deactivate_Autosend_Welcome_Letter__c = true,
			Deactivate_Autosend_Authorization__c = true,
			Deactivate_Autosend_Cost_Note_Reminder__c = true,
			Deactivate_Autosend_Invoice_Reminder__c = true,
			Deactivate_Transaction_Receival__c = true,
			Deactivate_Transaction_Mapping__c = true,
			Deactivate_Auto_Loss__c = true,
			Deactivate_Dropbox_Upload__c = true,
			Deactivate_Sync_To_21legal__c = true,
			Deactivate_Email_User__c = user.Id,
			Deactivate_Trigger_User__c = user.Id
    	);
		System.debug ('Created test config.');
    	return config;
    }
    
    public static User bypassUser() {
       	Profile testProfile = [
            SELECT ID 
            FROM Profile
            WHERE Name = 'System Administrator' 
            LIMIT 1
        ];
        return new User(
            LastName = 'Test u1', 
            Username = 'testu1' + Datetime.now().millisecond() + '@test.com', 
            Email = 'testu1@test.com', 
            Alias = 'u1', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_GB', 
            EmailEncodingKey = 'ISO-8859-1', 
            ProfileId = testProfile.Id, 
            LanguageLocaleKey = 'en_US',
            IsActive = true,
           	bypass_process_builder__c = true
        );
    }

	public static User legalUser() {
       	Profile testProfile = [
            SELECT ID 
            FROM Profile
            WHERE Name = 'System Administrator' 
            LIMIT 1
        ];
        return new User(
            LastName = 'Test u1', 
            Username = 'testlegal' + Datetime.now().millisecond() + '@test.com', 
            Email = 'testu1@test.com', 
            Alias = 'u1', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_GB', 
            EmailEncodingKey = 'ISO-8859-1', 
            ProfileID = testProfile.Id, 
            UserRoleId = UserRoles.legalID,
            LanguageLocaleKey = 'en_US',
            IsActive = true
        );
    }
    
    public static User createUser(){
        Profile profile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User user = new User(
            Alias = 'testus',
            Username = 'testu' + Datetime.now().millisecond() + '@test.com',
            Email ='testuser@test.com', 
            EmailEncodingKey ='UTF-8', 
            LastName ='Testuser', 
            LanguageLocaleKey ='en_US', 
            LocaleSidKey ='en_US', 
            ProfileId = profile.Id, 
            TimeZoneSidKey ='America/Los_Angeles',
            isActive = true
        );
		System.debug ('Created test user.');
        return user;
    }
    
    public static User createUserWithTriggerDisabled(){
        User user = createUser();
        user.Disable_Trigger__c = true;
        user.Disable_Auto_Email_Sending__c = true;
        return user;
    }
    
    public static Lead createLead(){
        Lead lead = new Lead(
           	LastName = 'Testlead',
            Company = 'Testcompany'
        );
        System.debug('Created test lead.');
        return lead;
    }
    
    public static Lead createLead(ID accountID, String recordTypeName, String lastName) {
        RecordType rt = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = :recordTypeName AND SObjectType = 'Lead'
        ];
        Lead l = createLead();
        l.lastName = lastName;
        l.account__c = accountID;
		l.recordTypeID = rt.ID;
        return l;
    }

    public static Account createAccount(){
        Account account = new Account(
           	Name = 'Testaccount'
        );
        System.debug('Created test account.');
        return account;
    }
    
    public static Account createVH24Account(){
        Account a = createAccount();
        a.name = 'VH24';
        return a;
    }

    public static Account createVR24Account(){
        Account a = createAccount();
        a.name = 'VR24';
        return a;
    }
    
    public static Account createCLLBLegal(){
        Account a = createAccount();
        a.name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB';
        return a;
    }
    
    public static Account createDaimlerBrand(){
        Account a = createAccount();
        a.type = 'Fahrzeughersteller';
        a.name = 'Daimler AG';
        return a;
    }
    
    public static Account createPorscheBrand(){
        Account a = createAccount();
        a.type = 'Fahrzeughersteller';
        a.name = 'Porsche AG';
        return a;
    }
    
    public static Account createAudiBrand(){
        Account a = createAccount();
        a.type = 'Fahrzeughersteller';
        a.name = 'Audi AG';
        return a;
    }

    public static Account createOpelBrand(){
        Account a = createAccount();
        a.type = 'Fahrzeughersteller';
        a.name = 'Opel AG';
        return a;
    }
    
    public static Account createVWBrand(){
        Account a = createAccount();
        a.type = 'Fahrzeughersteller';
        a.name = 'VW AG';
        return a;
    }
    
    public static Account createStuttgartAmtsgerichtCourt(){
        Account a = createAccount();
        a.name = 'AG Stuttgart';
        a.type = 'Gericht';
        return a;
    }
    
    public static Account createStuttgartLandgerichtCourt(){
        Account a = createAccount();
        a.name = 'Landgericht Stuttgart';
        a.type = 'Gericht';
        return a;
    }
    
	public static Account createDarmstadtAmtsgerichtCourt(){
        Account a = createAccount();
        a.name = 'AG Darmstadt';
        a.type = 'Gericht';
        return a;
    }

    public static Account createInsurance(String externalID){
        Account a = createAccount();
        a.name = 'Insurance';
        a.type = 'Lebensversicherung';
        a.external_Id__c = externalID;
        return a;
    }
    
    public static Account createLegalProtection() {
        Account a = createAccount();
        a.name = 'LegalPro';
        a.type = 'Rechtsschutzversicherung';
        return a;
    }
    
    public static Contact createContact(Id accountId){
        Contact contact = new Contact(
            LastName = 'Testcontact',
            AccountId = accountId,
            Email = 'testcontact@testorg.com'
        );
        System.debug('Created test contact.');
        return contact;
    }
    
    public static Opportunity createOpportunity(Id accountId, String stageName){
		Account vehicleBrand = new Account(
			Name = 'TestVehicleBrand',
			Type = 'Fahrzeughersteller'
		);
		insert vehicleBrand;

        Opportunity opportunity = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountId,
            CloseDate = System.today(),
            StageName = stageName,
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
			Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
			Sales_Type__c = 'Online',
			Vehicle_Brand__c = vehicleBrand.Id
        );
        System.debug('Created test opportunity.');
        return opportunity;
    }

    public static Product2 createProduct(){
        Product2 product = new Product2(
            Name = 'Testproduct', 
            Family = 'Testfamily'
        );
        System.debug('Inserted 1 test product.');
		return product;        
    }

    public static PricebookEntry createPricebookEntry(Id productId){
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = productId,
            UnitPrice = 100.00,
            IsActive = true
        );
        System.debug('Inserted 1 test pricebookentry.');
        return standardPrice;
    }

    public static OpportunityLineItem createOpportunityLineItem(Id opportunityId, Id pricebookEntryId, Decimal totalPrice){
        OpportunityLineItem opportunityLineItem = new OpportunityLineItem(
            OpportunityId = opportunityId,
            PricebookEntryId = pricebookEntryId,
            Quantity = 1,
            TotalPrice = totalPrice
        );
		System.debug('Created test opportunitylineitem.');
        return opportunityLineItem;
    }

    public static OpportunityContactRole createOpportunityContactRole(Id opportunityId, Contact contact){
        OpportunityContactRole opportunityContactRole = new OpportunityContactRole(
            OpportunityId = opportunityId,
            ContactId = contact.Id
        );
        System.debug('Created test opportunitycontactroles.');
        return opportunityContactRole;
    }

    public static Note createNote(Id opportunityId){
        Note note = new Note(
        	ParentId = opportunityId,
            Title = 'TestNote',
            Body = 'TestDescription'
        );
        return note;
    }

    public static Welcome_Letter__c createWelcomeLetter(Id opportunityId){
        Welcome_Letter__c welcomeLetter = new Welcome_Letter__c(
                Opportunity__c = opportunityId,
                Stage__c = 'Draft',
				Date__c = System.today()
        );
        System.debug('Created test welcome letter.');
        return welcomeLetter;
    }

    public static Document__c createDocument(Id opportunityId, String url){
        Document__c document = new Document__c(
            Opportunity__c = opportunityId,
            Name = 'TestName',
            Type__c = 'Other',
			Source__c = 'Other',
            Link__c = url
        );
        System.debug('Created test document.');
        return document;
    }

    public static Contract__c createContract(Id opportunityId){
        Contract__c contract = new Contract__c(
            Opportunity__c = opportunityId,
            Stage__c = 'Draft'
        );
        System.debug('Created test contract.');
        return contract;
    }

    public static Claim__c createClaim(Id opportunityId,String stage){
        Claim__c claim = new Claim__c(
            Opportunity__c = opportunityId,
            Stage__c = stage
        );
        System.debug('Created test claim.');
        return claim;
    }

	public static Deadline__c createDeadline(Id claimId){
		Deadline__c deadline = new Deadline__c(
			Claim__c = claimId,
			Type__c = 'Sonstige',
			Date__c = System.today() + 14
		);
		System.debug('Created test deadline.');
		return deadline;
	}

	public static Date__c createDate(Id claimId){
		Date__c thisDate = new Date__c(
			Claim__c = claimId,
			Type__c = 'Sonstiges',
			Date__c = System.today() + 14,
			Subject__c = 'Sonstiges'
		);
		System.debug('Created test date.');
		return thisDate;
	}

	public static Analysis__c createAnalysis(Id opportunityId){
		Analysis__c analysis = new Analysis__c(
			Opportunity__c = opportunityId
		);
		System.debug('Created test analysis.');
		return analysis;
	}

	public static Non_contributory_Period__c createNonContributoryPeriod(Id opportunityId, Date startDate, Date endDate){
		Non_contributory_Period__c nonContributoryPeriod = new Non_contributory_Period__c(
			Opportunity__c = opportunityId,
			Start__c = startDate,
			End__c = endDate
		);
		System.debug('Created test Non-contributory Period.');
		return nonContributoryPeriod;
	}

	public static Opportunity_Correspondence__c createOpportunityCorrespondence(Id opportunityId, String partner, String stage){
		// Create object
		Opportunity_Correspondence__c opportunityCorrespondence = new Opportunity_Correspondence__c(
			Opportunity__c = opportunityId,
			Partner__c = partner,
			Stage__c = stage,
			Follow_up_Period__c = 14
		);
		System.debug('Created test opportunity correspondence');
		return opportunityCorrespondence;
	}

	public static Opportunity_Text_Module__c createOpportunityTextModule(Id opportunityCorrespondenceId, String name){
		Opportunity_Text_Module__c opportunityTextModule = new Opportunity_Text_Module__c(
			Opportunity_Correspondence__c = opportunityCorrespondenceId,
			Name = name,
			Developer_Name__c = name,
			Text__c = 'Testtext'
		);
		System.debug('Created test opportunity text module');
		return opportunityTextModule;
	}

	public static Authorization__c createAuthorization(Id opportunityId){
        Authorization__c authorization = new Authorization__c(
            Opportunity__c = opportunityId,
            Stage__c = 'Draft',
			Follow_up_Period__c = 3
        );
        System.debug('Created test authorization.');
        return authorization;
    }

    public static Invoice__c createInvoice(Id opportunityId){
        Invoice__c invoice = new Invoice__c(
            Opportunity__c = opportunityId,
            Stage__c = 'Draft'
        );
        System.debug('Created test invoice.');
        return invoice;
    }

	public static Test_Case__c createTestCase(Id opportunityId){
		Test_Case__c testCase = new Test_Case__c(
			Opportunity__c = opportunityId,
			Status__c = 'Draft'
		);
		System.debug('Created test test case.');
		return testCase;
	}

    public static Invoice_Payment__c createInvoicePayment(Id invoiceId, Decimal amount){
        Invoice_Payment__c invoicePayment = new Invoice_Payment__c(
            Invoice__c = invoiceId,
            Method__c = 'Bank transfer',
            Amount__c = amount
        );
        System.debug('Created test invoice payment');
        return invoicePayment;
    }

	public static Invoice_Reminder__c createInvoiceReminder(Id invoiceId, String status){
		Invoice_Reminder__c invoiceReminder = new Invoice_Reminder__c(
				Invoice__c = invoiceId,
				Stage__c = status,
				Payment_Term__c = 14,
				Date__c = System.today()
		);
		System.debug('Created test invoice reminder');
		return invoiceReminder;
	}

    public static Task createTask(String subject, Id whatId, Id userId){
		Task task = new Task(
            OwnerId = userId,
            Subject = subject,
            WhatId = whatId,
            Status = 'Open',
            Priority = 'Normal',
            ActivityDate = System.today(),
            Description = 'Testdescription'
        );
        
        System.debug('Created test task.');
        return task;
    }
    
    public static EmailTemplate createTemplate(){
        List<Folder> folders = [select Id from Folder where Type = 'Email'];

        EmailTemplate template = new EmailTemplate(
            Name = 'Testtemplate',
            FolderId = folders[0].Id,
            TemplateType = 'Text',
            DeveloperName = 'Testtemplate',
            Body = '{!Contact.LastName}{Opportunity.Contact__r.LastName}{Opportunity.Contact__r.Account.Name}{User.LastName}',
            Subject = '{!Contact.LastName}{Opportunity.Name}{User.LastName}'
        );
        System.debug('Created test template');
        return template;
    }
    
    public static EmailMessage createEmailMessage(Id parentId){
        EmailMessage emailMessage = new EmailMessage(
			Incoming = true,
            RelatedToId = parentId
        );
        System.debug('Created test email message');
        return emailMessage;
    }
    
    public static Attachment createAttachment(Id parentId){
        Attachment attachment = new Attachment(
        	Body = Blob.valueOf('12345'),
            Name = 'Testattachment.pdf',
            ParentId = parentId
        );
        System.debug('Created test attachment');
        return attachment;
    }

    public static Fund__c createFund(String label, String isin){
        Fund__c fund = new Fund__c(
            Label__c = label,
            ISIN__c = isin
        );
        System.debug('Created test fund');
        return fund;
    }

    public static Rate__c createRate(Id fundId, Decimal trend, Decimal value, Date rateDate){
        Rate__c rate = new Rate__c(
			Fund__c = fundId,
			Trend__c = trend,
			Value__c = value,
			Date__c = rateDate
        );
        System.debug('Created test rate');
        return rate;
    }

    public static Fund_Reference__c createFundReference(Id opportunityId, Id fundId, Decimal weighting){
        Fund_Reference__c fundReference = new Fund_Reference__c(
            Opportunity__c = opportunityId,
            Fund__c = fundId,
			Weighting__c = weighting
        );
        System.debug('Created test fund reference');
        return fundReference;
    }

    public static Correspondence__c createCorrespondence(Id claimId, String partner, String type, String stage){
        // Create object
        Correspondence__c correspondence = new Correspondence__c(
        	Claim__c = claimId,
            Partner__c = partner,
            Type__c = type,
            Stage__c = stage,
			Inform_Customer__c = false,
			Follow_up_Period__c = 14
        );
        System.debug('Created test correspondence');
        return correspondence;
    }

    public static Text_Module__c createTextModule(Id correspondenceId, String name){
	    Text_Module__c textModule = new Text_Module__c(
            Correspondence__c = correspondenceId,
            Name = name,
            Developer_Name__c = name,
            Text__c = 'Testtext'
        );
        System.debug('Created test text module');
        return textModule;
    }

    public static Cost_Note__c createCostNote(Id claimId, String status){
    	Cost_Note__c costNote = new Cost_Note__c(
    		Claim__c = claimId,
            Subject__c = 'I. Instanz',
            Stage__c = status,
    		Date__c = System.today(),
			Payment_Term__c = 14,
			Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Außergerichtlich'
    	);
        System.debug('Created test cost note');
    	return costNote;
    }

	public static Credit_Note__c createCreditNote(Id claimId, String status){
		Credit_Note__c creditNote = new Credit_Note__c(
			Claim__c = claimId,
			Subject__c = 'Gutschrift I. Instanz',
			Stage__c = status,
			Date__c = System.today(),
			Payment_Term__c = 14
		);
		System.debug('Created test credit note');
		return creditNote;
	}

	public static Cost_Note_Line_Item__c createCostNoteLineItem(Id costNoteId, Decimal price){
        Cost_Note_Line_Item__c costNoteLineItem = new Cost_Note_Line_Item__c(
			Cost_Note__c = costNoteId,
			Subject__c = 'Testsubject',
			Price__c = price,
			Calculate_Vat__c = true,
            Type__c = 'Außergerichtlich'
		);
        System.debug('Created test cost note line item');
        return costNoteLineItem;
    }

	public static Cancellation__c createCancellation(Id costNoteId, String status){
		Cancellation__c cancellation = new Cancellation__c(
			Cost_Note__c = costNoteId,
			Date__c = System.today(),
			Stage__c = status
		);
		System.debug('Created test cancellation');
		return cancellation;
	}

	public static Credit_Note_Line_Item__c createCreditNoteLineItem(Id creditNoteId, Decimal price){
		Credit_Note_Line_Item__c creditNoteLineItem = new Credit_Note_Line_Item__c(
			Credit_Note__c = creditNoteId,
			Subject__c = 'Testsubject',
			Price__c = price,
			Calculate_Vat__c = true
		);
		System.debug('Created test credit note line item');
		return creditNoteLineItem;
	}

    public static Cost_Note_Payment__c createCostNotePayment(Id costNoteId, Decimal amount){
        Cost_Note_Payment__c costNotePayment = new Cost_Note_Payment__c(
			Cost_Note__c = costNoteId,
			Method__c = 'Bank transfer',
			Amount__c = amount,
			Sender_Type__c = 'RSV'
		);
        System.debug('Created test cost note payment');
        return costNotePayment;
    }

	public static Credit_Note_Payment__c createCreditNotePayment(Id creditNoteId, Decimal amount){
		Credit_Note_Payment__c creditNotePayment = new Credit_Note_Payment__c(
			Credit_Note__c = creditNoteId,
			Method__c = 'Bank transfer',
			Amount__c = amount,
			Recipient_Type__c = 'RSV'
		);
		System.debug('Created test credit note payment');
		return creditNotePayment;
	}

	public static Cost_Note_Reminder__c createCostNoteReminder(Id costNoteId, String status){
		Cost_Note_Reminder__c costNoteReminder = new Cost_Note_Reminder__c(
			Cost_Note__c = costNoteId,
			Stage__c = status,
			Date__c = System.today(),
			Payment_Term__c = 7
		);
		System.debug('Created test cost note reminder');
		return costNoteReminder;
	}

	public static Receipt__c createReceipt(Id claimId, Decimal amount, String status){
		Receipt__c receipt = new Receipt__c(
			Claim__c = claimId,
			Amount__c = amount,
			Type__c = 'Sonstiges',
			Stage__c = status,
			Date__c = System.today(),
			Payment_Term__c = 14,
			Number__c = 'receiptTestNumber'
		);
		System.debug('Created test receipt');
		return receipt;
	}

	public static Receipt_Payment__c createReceiptPayment(Id receiptId, Decimal amount){
		Receipt_Payment__c receiptPayment = new Receipt_Payment__c(
			Receipt__c = receiptId,
			Method__c = 'Bank transfer',
			Amount__c = amount
		);
		System.debug('Created test receipt payment');
		return receiptPayment;
	}

	public static Transaction__c createTransaction(Decimal amount, Date dateValue, String externalId, String purpose, String stage){
		Transaction__c trans = new Transaction__c(
			Amount__c = amount,
			Date__c = dateValue,
			External_Id__c = externalId,
			Method__c = 'Bank transfer',
			Name__c = 'Testname',
			Purpose__c = purpose,
			Stage__c = stage
		);
		System.debug('Created test transaction: ' + trans);
		return trans;
	}

	public static Class_Action__c createClassAction(Id opponentId, String stage){
		Class_Action__c classAction = new Class_Action__c(
			Opponent__c = opponentId,
			Stage__c = stage
		);
		System.debug('Created class action');
		return classAction;
	}

	public static Class_Action_Reference__c createClassActionReference(Id classActionId, Id claimId){
		Class_Action_Reference__c classActionReference = new Class_Action_Reference__c(
			Claim__c = claimId,
			Class_Action__c = classActionId
		);
		System.debug('Created class action reference');
		return classActionReference;
	}

	public static User_Reference__c createUserReference(Id accountId, Id userId){
		User_Reference__c userReference = new User_Reference__c(
				Account__c = accountId,
				User__c = userId
		);
		System.debug('Created user reference');
		return userReference;
	}

	public static Commission__c createCommission(Id accountId, Id legalAccountId, Decimal commissionRateDg, Decimal commissionRateLv, Date startDate, Date endDate){
		Commission__c commission = new Commission__c(
				Legal_Account__c = legalAccountId,
				Account__c = accountId,
				Start_Date__c = startDate,
				End_Date__c = endDate,
				Commission_Rate_Dg__c = commissionRateDg,
				Commission_Rate_Lv__c = commissionRateLv,
				Product__c = 'Dieselskandal; Lebensversicherung'

		);
		System.debug('Created commission');
		return commission;
	}

	public static Commission_Rate__c createCommissionRate(Id accountId, Id legalAccountId, String product, Decimal rate){
		Commission_Rate__c commissionRate = new Commission_Rate__c(
				Account__c = accountId,
				Legal_Account__c = legalAccountId,
				Product__c = product,
				Rate__c = rate
		);
		System.debug('Created commission rate');
		return commissionRate;
	}
    
    public static General_Settings__mdt SettingsEMailAndTriggerTrue() {
        return new General_Settings__mdt(
            Disable_Auto_Email_Sending__c = true,
            Disable_all_triggers__c = true,
            OppsOnClaimCache_Query_LIMIT__c = 1000,
            Default_Owner_username__c = 'test@test@com',
            Reassign_if_owned_by__c = 'test'
        );
    }
    
    public static General_Settings__mdt SettingsEMailAndTriggerFalse() {
        return new General_Settings__mdt(
            Disable_Auto_Email_Sending__c = false,
            Disable_all_triggers__c = false,
            OppsOnClaimCache_Query_LIMIT__c = 1000,
            Default_Owner_username__c = 'test@test@com',
            Reassign_if_owned_by__c = 'test'
        );
    }
}