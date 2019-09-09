// Legacy code
@isTest
public class FinAPITransactionsLegacyTests {
    private static void processTransactions(Integer lastN, Date before) {
        FinAPISettings ss = new FinAPISettings();
        ss.mapLastN = lastN;
        ss.mapLastNBeforeDate = before;
        FinAPI f = new DefaultFinAPI(ss, new DefaultLogger());
        FinAPITransactionMapper m = new FinAPITransactionPurposeMapper(new DefaultLogger());
        FinAPITransactions tran = new FinAPITransactions(ss, f, m);
        tran.process();
    }

    // todo: add test for multiple mappings where only one matches the amount, and succeeds.
    // Then one for the same but where none matches the amount, and fails.
    // Also, should ignore matching invoices which were already processed.
	@isTest
	static void testInvoice() {
		// Testsetup
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.number__c = 'oppnumber';
		insert opportunity;
		opportunity = [select Id, Number__c from Opportunity where Id = :opportunity.Id];

		Invoice__c invoice0 = TestData.createInvoice(opportunity.Id);
		invoice0.Number__c = 'i20170101000';
		invoice0.Amount__c = 2312;
		insert invoice0;
        Invoice__c invoice1 = TestData.createInvoice(opportunity.Id);
		invoice1.Number__c = 'i20170101001';
		invoice1.Amount__c = 1190;
		insert invoice1;
		Invoice__c invoice2 = TestData.createInvoice(opportunity.Id);
		invoice2.Number__c = 'i20170101002';
		invoice2.Amount__c = 2380;
		insert invoice2;
		Invoice__c invoice3 = TestData.createInvoice(opportunity.Id);
		invoice3.Number__c = 'i20170101003';
		invoice3.Amount__c = 3570;
		insert invoice3;
		Invoice_Payment__c invoicePayment = TestData.createInvoicePayment(invoice2.Id,2380);
		insert invoicePayment;

		Transaction__c successTransaction = TestData.createTransaction(1190.00,System.today(),'successTransaction','i20170101001','Open');
		insert successTransaction;

		Transaction__c noMappingResultTransaction = TestData.createTransaction(1190.00,System.today(),'noMappingResultTransaction','i20170101004','Open');
		insert noMappingResultTransaction;

        // More than one record matches the Numbers but only one matches the amount and it is not paid yet
        Transaction__c moreThanOneMappingResultTransactionButOneMatch = TestData.createTransaction(2312.00,System.today(),'moreThan1MappingResultTrans1Amount','i20170101000, i20170101002','Open');
		insert moreThanOneMappingResultTransactionButOneMatch;
		
        // More than one mapping and none matching the amount
		Transaction__c moreThanOneMappingResultTransaction = TestData.createTransaction(2544.00,System.today(),'moreThanOneMappingResultTransaction','i20170101001, i20170101002','Open');
		insert moreThanOneMappingResultTransaction;
        
		Transaction__c alreadyMappedTransaction = TestData.createTransaction(2380.00,System.today(),'alreadyMappedTransaction','i20170101002','Open');
		insert alreadyMappedTransaction;

        // One mapping but not matching amount
		Transaction__c amountNotMatchingTransaction = TestData.createTransaction(2390,System.today(),'amountNotMatchingTransaction','i20170101001','Open');
		insert amountNotMatchingTransaction;

        Transaction__c amountMatchingInsideMarginTransaction = TestData.createTransaction(3570.50,System.today(),'amountMatchingInsideMarginTran','i20170101003', 'Open');
		insert amountMatchingInsideMarginTransaction;

		Transaction__c duplicateTransaction = TestData.createTransaction(1190.00,System.today(),'duplicateTransaction','i20170101001','Open');
		insert duplicateTransaction;

		// Test
		test.StartTest();
		processTransactions(20, Date.today());
		test.StopTest();

		// Assertion
		invoicePayment = [select Id, Transaction__c from Invoice_Payment__c where Invoice__c = :invoice1.Id];
		successTransaction = [select Id,Mapping_Error__c from Transaction__c where Id = :successTransaction.Id];
		noMappingResultTransaction = [select Id,Mapping_Error__c from Transaction__c where Id = :noMappingResultTransaction.Id];
		moreThanOneMappingResultTransaction = [select Id,Mapping_Error__c, Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransaction.Id];
        moreThanOneMappingResultTransactionButOneMatch = [select Id,Mapping_Error__c, Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransactionButOneMatch.Id];
        Invoice_Payment__c invoicePayment0 = [select Id, Transaction__c from Invoice_Payment__c where Invoice__c = :invoice0.Id];
		alreadyMappedTransaction = [select Id,Mapping_Error__c from Transaction__c where Id = :alreadyMappedTransaction.Id];
		amountNotMatchingTransaction = [select Id,Mapping_Error__c, Matching_records__c from Transaction__c where Id = :amountNotMatchingTransaction.Id];
        amountMatchingInsideMarginTransaction = [select Id, Mapping_Error__c, Stage__c, Matching_records__c from Transaction__c where Id = :amountMatchingInsideMarginTransaction.Id];
		duplicateTransaction = [select Id, Mapping_Error__c, Matching_records__c from Transaction__c where Id = :duplicateTransaction.Id];

		System.assertEquals(successTransaction.Id,invoicePayment.Transaction__c);
		System.assertEquals(null,successTransaction.Mapping_Error__c);

		System.assertEquals('No mapping result.',noMappingResultTransaction.Mapping_Error__c);
        
        System.assertEquals(moreThanOneMappingResultTransactionButOneMatch.Id,invoicePayment0.Transaction__c);
		System.assertEquals(null,moreThanOneMappingResultTransactionButOneMatch.Mapping_Error__c);
		
        System.assertEquals('More than one mapping result. None matching amount.',moreThanOneMappingResultTransaction.Mapping_Error__c);
        // todo: same for other object types, not only for Invoice
        System.assert(containsAllMatchingRecords(moreThanOneMappingResultTransaction,
                                                 new ID[]{invoice1.ID, invoice2.ID}));

        System.assertEquals('Transaction already processed. Added mapping.',alreadyMappedTransaction.Mapping_Error__c);

        System.assert(amountNotMatchingTransaction.Mapping_Error__c.startsWithIgnoreCase('Amount not matching.'));
        System.assertEquals(invoice1.ID, amountNotMatchingTransaction.Matching_records__c);

		System.assert(String.isBlank(amountMatchingInsideMarginTransaction.Mapping_Error__c));
        System.assertEquals('Processed', amountMatchingInsideMarginTransaction.Stage__c);
        System.assertEquals(invoice3.ID, amountMatchingInsideMarginTransaction.Matching_records__c);
        System.assertEquals(1, [SELECT Count() FROM Invoice_Payment__c WHERE Transaction__c = :amountMatchingInsideMarginTransaction.ID]);

		System.assertEquals('Duplicate transaction.',duplicateTransaction.Mapping_Error__c);
        System.assertEquals(invoice1.ID, duplicateTransaction.Matching_records__c);
	}

    @isTest
	static void testCostNote() {
		// Testsetup
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.number__c = 'oppnumber';
        insert opportunity;
        
        Opportunity opportunity2 = TestData.createOpportunity(account.Id,'New');
        opportunity2.number__c = 'oppnumber2';
        opportunity2.Legal_Protection_Deductible__c = 3570;
        insert opportunity2;

        TriggerConfiguration.allInactive = true;
		User bpUser = TestData.bypassUser();
        
        Claim__c claim0 = TestData.createClaim(opportunity.Id,'Draft');
		claim0.Reference__c = 'Reference/DG0';
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		claim.Reference__c = 'Reference/DG';
        Claim__c claim2 = TestData.createClaim(opportunity2.Id,'Draft');
		claim2.Reference__c = 'Reference/DG2';
        System.runAs(bpUser) {
            insert new Claim__c[]{claim0, claim, claim2};
        }
            
        Cost_Note__c[] cns = new Cost_Note__c[]{};

		Cost_Note__c costNote0 = TestData.createCostNote(claim0.Id,'Draft');
		costNote0.Number__c = '2017000000/DG';
        cns.add(costNote0);

		Cost_Note__c costNote1 = TestData.createCostNote(claim.Id,'Draft');
		costNote1.Number__c = '2017000001/DG';
        cns.add(costNote1);

        Cost_Note__c costNote2 = TestData.createCostNote(claim.Id,'Draft');
        costNote2.Number__c = '2017000002/DG';
		cns.add(costNote2);
        
        Cost_Note__c costNote3 = TestData.createCostNote(claim.Id,'Draft');
		costNote3.Number__c = '2017000003/DG';
        cns.add(costNote3);
        
        Cost_Note__c costNote4 = TestData.createCostNote(claim2.Id,'Draft');
		costNote4.Number__c = '2017000005/DG';
        cns.add(costNote4);
        
        insert cns;
        
        Cost_Note_Line_Item__c[] cnlis = new Cost_Note_Line_Item__c[]{};

		Cost_Note_Line_Item__c costNoteLineItem0 = TestData.createCostNoteLineItem(costNote0.Id,1000);
        cnlis.add(costNoteLineItem0);
        
		Cost_Note_Line_Item__c costNoteLineItem1 = TestData.createCostNoteLineItem(costNote1.Id,1000);
        cnlis.add(costNoteLineItem1);

		Cost_Note_Line_Item__c costNoteLineItem2 = TestData.createCostNoteLineItem(costNote2.Id,2000);
		cnlis.add(costNoteLineItem2);
        
		Cost_Note_Line_Item__c costNoteLineItem3 = TestData.createCostNoteLineItem(costNote3.Id,3000);
		cnlis.add(costNoteLineItem3);
        
        Cost_Note_Line_Item__c costNoteLineItem4 = TestData.createCostNoteLineItem(costNote4.Id,3570);
		cnlis.add(costNoteLineItem4);

        insert cnlis;

		Cost_Note_Payment__c costNotePayment = TestData.createCostNotePayment(costNote2.Id,2380);
		insert costNotePayment;
		Transaction__c successTransaction = TestData.createTransaction(1190.00,System.today(),'successTransaction','2017000000/DG','Open');
		insert successTransaction;
		Transaction__c noMappingResultTransaction = TestData.createTransaction(1190.00,System.today(),'noMappingResultTransaction','2017000004/DG','Open');
		insert noMappingResultTransaction;
        
        // More than one record matches the Numbers but only one matches the amount and it is not paid yet.
        // Includes a match with a transaction already paid - '2017000000/DG'.
        // Note: when using '2017000000/DG', it will find a duplicated transaction and mark as error, even when it matches other CostNotes and it could be a mistaken match.
        // But it's better to fail than to create another CostNotePayment? VH24 can have a report for all the ones that match more than one and have an error set.
        //Transaction__c moreThanOneMappingResultTransactionButOneMatch = TestData.createTransaction(1190.00,System.today(),'moreThan1MappingResultTrans1Amount','2017000000/DG, 2017000001/DG, 2017000002/DG','Open');
        Transaction__c moreThanOneMappingResultTransactionButOneMatch = TestData.createTransaction(1190.00,System.today(),'moreThan1MappingResultTrans1Amount','2017000001/DG, 2017000002/DG','Open');
		insert moreThanOneMappingResultTransactionButOneMatch;
                
        // More than one mapping and none matching the amount
		Transaction__c moreThanOneMappingResultTransaction = TestData.createTransaction(1200.00,System.today(),'moreThanOneMappingResultTransaction',claim.Reference__c,'Open');

		insert moreThanOneMappingResultTransaction;
		Transaction__c alreadyMappedTransaction = TestData.createTransaction(2380.00,System.today(),'alreadyMappedTransaction','2017000002/DG','Open');
		insert alreadyMappedTransaction;
		Transaction__c amountNotMatchingTransaction = TestData.createTransaction(2380.00,System.today(),'amountNotMatchingTransaction','2017000003/DG','Open');
		insert amountNotMatchingTransaction;
        Transaction__c amountMatchingInsideMarginTransaction = TestData.createTransaction(3570.50,System.today(),'amountMatchingInsideMarginTran','2017000005/DG','Open');
		insert amountMatchingInsideMarginTransaction;
		Transaction__c duplicateTransaction = TestData.createTransaction(1190.00,System.today(),'duplicateTransaction','2017000000/DG','Open');
		insert duplicateTransaction;

		// Test
		test.StartTest();

		processTransactions(20, Date.today());

		test.StopTest();

		// Assertion
		costNotePayment = [select Id, Transaction__c from Cost_Note_Payment__c where Cost_Note__c = :costNote0.Id];

		successTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :successTransaction.Id];
		noMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :noMappingResultTransaction.Id];
        moreThanOneMappingResultTransactionButOneMatch = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransactionButOneMatch.Id];
		moreThanOneMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransaction.Id];
		alreadyMappedTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :alreadyMappedTransaction.Id];
		amountNotMatchingTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountNotMatchingTransaction.Id];
        amountMatchingInsideMarginTransaction = [select Id,Stage__c,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountMatchingInsideMarginTransaction.Id];
		duplicateTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :duplicateTransaction.Id];

		System.assertEquals(successTransaction.Id,costNotePayment.Transaction__c);
		System.assertEquals(null,successTransaction.Mapping_Error__c);
        System.assertEquals(costNote0.ID, successTransaction.Matching_records__c);
        
		System.assertEquals('No mapping result.',noMappingResultTransaction.Mapping_Error__c);
		System.assertEquals(null, noMappingResultTransaction.Matching_records__c);

        Cost_Note_Payment__c cnPayment0 = [select Id, Transaction__c from Cost_Note_Payment__c where Cost_Note__c = :costNote1.Id];
        System.assertEquals(moreThanOneMappingResultTransactionButOneMatch.Id, cnPayment0.Transaction__c);
		System.assertEquals(null,moreThanOneMappingResultTransactionButOneMatch.Mapping_Error__c);
        
        System.assert(containsAllMatchingRecords(moreThanOneMappingResultTransaction,
                                                 new ID[]{costNote2.ID, costNote3.ID}));
		System.assertEquals('More than one mapping result. None matching amount.',moreThanOneMappingResultTransaction.Mapping_Error__c);
        
		System.assertEquals('Transaction already processed. Added mapping.',alreadyMappedTransaction.Mapping_Error__c);
        System.assertEquals(costNote2.ID, alreadyMappedTransaction.Matching_records__c);
        
		System.assert(amountNotMatchingTransaction.Mapping_Error__c.startsWithIgnoreCase('Amount not matching.'));
        System.assertEquals(costNote3.ID, amountNotMatchingTransaction.Matching_records__c);
        
		System.assertEquals('Duplicate transaction.',duplicateTransaction.Mapping_Error__c);
        System.assertEquals(costNote0.ID, duplicateTransaction.Matching_records__c);
        
        System.assertEquals(1, [SELECT Count() FROM Cost_Note_Payment__c WHERE Transaction__c = :amountMatchingInsideMarginTransaction.Id]);
		System.assert(String.isBlank(amountMatchingInsideMarginTransaction.Mapping_Error__c));
        System.assertEquals('Processed', amountMatchingInsideMarginTransaction.Stage__c);
        System.assertEquals(costNote4.ID, amountMatchingInsideMarginTransaction.Matching_records__c);
	}

	@isTest
	static void testCreditNote() {
		// Testsetup
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        opportunity.number__c = 'oppnumber';
		insert opportunity;
        Opportunity opportunity2 = TestData.createOpportunity(account.Id,'New');
        opportunity2.number__c = 'oppnumber2';
        opportunity2.Legal_Protection_Deductible__c = 3570;
        insert opportunity2;
        
        TriggerConfiguration.allInactive = true;
		User bpUser = TestData.bypassUser();
        
        Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
        Claim__c claim2 = TestData.createClaim(opportunity2.Id,'Draft');
		claim2.Reference__c = 'Reference/DG2';
        System.runAs(bpUser) {
            insert new Claim__c[]{claim, claim2};
        }

        Credit_Note__c[] cns = new Credit_Note__c[]{};
            
		Credit_Note__c creditNote1 = TestData.createCreditNote(claim.Id,'Draft');
		creditNote1.Number__c = '2017000001/CNDG';
        cns.add(creditNote1);
		
        Credit_Note__c creditNote2 = TestData.createCreditNote(claim.Id,'Draft');
		creditNote2.Number__c = '2017000002/CNDG';
        cns.add(creditNote2);
        
        Credit_Note__c creditNote3 = TestData.createCreditNote(claim.Id,'Draft');
		creditNote3.Number__c = '2017000003/CNDG';
        cns.add(creditNote3);
        
        Credit_Note__c creditNote4 = TestData.createCreditNote(claim2.Id,'Draft');
		creditNote4.Number__c = '2017000005/CNDG';
        cns.add(creditNote4);
        
        insert cns;

        Credit_Note_Line_Item__c[] cnlis = new Credit_Note_Line_Item__c[]{};

		Credit_Note_Line_Item__c creditNoteLineItem1 = TestData.createCreditNoteLineItem(creditNote1.Id,1000);
        cnlis.add(creditNoteLineItem1);
        
		Credit_Note_Line_Item__c creditNoteLineItem2 = TestData.createCreditNoteLineItem(creditNote2.Id,2000);
        cnlis.add(creditNoteLineItem2);
        
		Credit_Note_Line_Item__c creditNoteLineItem3 = TestData.createCreditNoteLineItem(creditNote3.Id,3000);
		cnlis.add(creditNoteLineItem3);

        insert cnlis;

        Credit_Note_Payment__c creditNotePayment = TestData.createCreditNotePayment(creditNote2.Id,2380);
		insert creditNotePayment;
		Transaction__c successTransaction = TestData.createTransaction(-1190.00,System.today(),'successTransaction','2017000001/CNDG','Open');
		insert successTransaction;
		Transaction__c noMappingResultTransaction = TestData.createTransaction(-1190.00,System.today(),'noMappingResultTransaction','2017000004/CNDG','Open');
		insert noMappingResultTransaction;
		Transaction__c moreThanOneMappingResultTransaction = TestData.createTransaction(-1190.00,System.today(),'moreThanOneMappingResultTransaction','2017000001/CNDG, 2017000002/CNDG','Open');
		insert moreThanOneMappingResultTransaction;
		Transaction__c alreadyMappedTransaction = TestData.createTransaction(-2380.00,System.today(),'alreadyMappedTransaction','2017000002/CNDG','Open');
		insert alreadyMappedTransaction;
		Transaction__c amountNotMatchingTransaction = TestData.createTransaction(-2380.00,System.today(),'amountNotMatchingTransaction','2017000001/CNDG','Open');
		insert amountNotMatchingTransaction;
        Transaction__c amountMatchingInsideMarginTransaction = TestData.createTransaction(3570.50,System.today(),'amountMatchingInsideMarginTran','2017000005/CNDG','Open');
		insert amountMatchingInsideMarginTransaction;
		Transaction__c duplicateTransaction = TestData.createTransaction(-1190.00,System.today(),'duplicateTransaction','2017000001/CNDG','Open');
		insert duplicateTransaction;

		// Test
		test.StartTest();

		processTransactions(20, Date.today());

		test.StopTest();

		// Assertion
		creditNotePayment = [select Id, Transaction__c from Credit_Note_Payment__c where Credit_Note__c = :creditNote1.Id];

		successTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :successTransaction.Id];
		noMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :noMappingResultTransaction.Id];
		moreThanOneMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransaction.Id];
		alreadyMappedTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :alreadyMappedTransaction.Id];
		amountNotMatchingTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountNotMatchingTransaction.Id];
        amountMatchingInsideMarginTransaction = [select Id,Stage__c,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountMatchingInsideMarginTransaction.Id];
		duplicateTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :duplicateTransaction.Id];
        
		System.assertEquals(successTransaction.Id,creditNotePayment.Transaction__c);
		System.assertEquals(null,successTransaction.Mapping_Error__c);
        System.assertEquals(creditNote1.ID, successTransaction.Matching_records__c);

		System.assertEquals('No mapping result.',noMappingResultTransaction.Mapping_Error__c);
        System.assertEquals(null, noMappingResultTransaction.Matching_records__c);
        
		System.assertEquals('More than one mapping result. None matching amount.',moreThanOneMappingResultTransaction.Mapping_Error__c);
        System.assert(containsAllMatchingRecords(moreThanOneMappingResultTransaction,
                                                 new ID[]{creditNote1.ID, creditNote2.ID}));
        
		System.assertEquals('Transaction already processed. Added mapping.',alreadyMappedTransaction.Mapping_Error__c);
		System.assertEquals(creditNote2.ID, alreadyMappedTransaction.Matching_records__c);
        
		System.assert(amountNotMatchingTransaction.Mapping_Error__c.startsWithIgnoreCase('Amount not matching.'));
        System.assertEquals(creditNote1.ID, amountNotMatchingTransaction.Matching_records__c);

		System.assertEquals('Duplicate transaction.',duplicateTransaction.Mapping_Error__c);
        System.assertEquals(creditNote1.ID, duplicateTransaction.Matching_records__c);

        System.assertEquals(1, [SELECT Count() FROM Credit_Note_Payment__c WHERE Transaction__c = :amountMatchingInsideMarginTransaction.Id]);
		System.assert(String.isBlank(amountMatchingInsideMarginTransaction.Mapping_Error__c));
        System.assertEquals('Processed', amountMatchingInsideMarginTransaction.Stage__c);
        System.assertEquals(creditNote4.ID, amountMatchingInsideMarginTransaction.Matching_records__c);
	}

	@isTest
	static void testReceipt() {
		// Testsetup   
        Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		insert opportunity;
        Opportunity opportunity2 = TestData.createOpportunity(account.Id,'New');
		insert opportunity2;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Draft');
		insert claim;
        Claim__c claim2 = TestData.createClaim(opportunity2.Id,'Draft');
		insert claim2;
        
		Receipt__c receipt1 = TestData.createReceipt(claim.Id,1190,'Draft');
		receipt1.Number__c = '2017000001/DG';
		Receipt__c receipt2 = TestData.createReceipt(claim.Id,2380,'Draft');
		receipt2.Number__c = '2017000002/DG';
		Receipt__c receipt3 = TestData.createReceipt(claim.Id,3570,'Draft');
		receipt3.Number__c = '2017000003/DG';
        Receipt__c receipt4 = TestData.createReceipt(claim2.Id,3570,'Draft');
		receipt4.Number__c = '2017000006/DG';
        
        TriggerConfiguration.allInactive = true;

        Receipt_Payment__c receiptPayment;
        System.runAs(TestData.bypassUser()) {
        	insert new Receipt__c[]{receipt1, receipt2, receipt3, receipt4};   
			receiptPayment = TestData.createReceiptPayment(receipt2.Id, 2380);
			insert receiptPayment;
        }

        TriggerConfiguration.allInactive = false;
        
		Transaction__c successTransaction = TestData.createTransaction(1190.00,System.today(),'successTransaction','2017000001/DG','Open');
		insert successTransaction;
		Transaction__c noMappingResultTransaction = TestData.createTransaction(1190.00,System.today(),'noMappingResultTransaction','2017000004/DG','Open');
		insert noMappingResultTransaction;
		Transaction__c moreThanOneMappingResultTransaction = TestData.createTransaction(1190.00,System.today(),'moreThanOneMappingResultTransaction','2017000002/DG, 2017000003/DG','Open');
		insert moreThanOneMappingResultTransaction;
		Transaction__c alreadyMappedTransaction = TestData.createTransaction(2380.00,System.today(),'alreadyMappedTransaction','2017000002/DG','Open');
		insert alreadyMappedTransaction;
		Transaction__c amountNotMatchingTransaction = TestData.createTransaction(2380.00,System.today(),'amountNotMatchingTransaction',receipt3.Number__c,'Open');
		insert amountNotMatchingTransaction;
        Transaction__c amountMatchingInsideMarginTransaction = TestData.createTransaction(3570.50,System.today(),'amountMatchingInsideMarginTran','2017000006/DG','Open');
		insert amountMatchingInsideMarginTransaction;
		Transaction__c duplicateTransaction = TestData.createTransaction(1190.00,System.today(),'duplicateTransaction','2017000001/DG','Open');
		insert duplicateTransaction;

		// Test
		test.StartTest();

		processTransactions(20, Date.today());

		test.StopTest();

		// Assertion
		receiptPayment = [select Id, Transaction__c from Receipt_Payment__c where Receipt__c = :receipt1.Id];
		successTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :successTransaction.Id];
		noMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :noMappingResultTransaction.Id];
		moreThanOneMappingResultTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :moreThanOneMappingResultTransaction.Id];
		alreadyMappedTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :alreadyMappedTransaction.Id];
		amountNotMatchingTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountNotMatchingTransaction.Id];
        amountMatchingInsideMarginTransaction = [select Id,Stage__c,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :amountMatchingInsideMarginTransaction.Id];
		duplicateTransaction = [select Id,Mapping_Error__c,Matching_records__c from Transaction__c where Id = :duplicateTransaction.Id];

		System.assertEquals(successTransaction.Id, receiptPayment.Transaction__c);
		System.assertEquals(null, successTransaction.Mapping_Error__c);
        System.assertEquals(receipt1.ID, successTransaction.Matching_records__c);
        
		System.assertEquals('No mapping result.',noMappingResultTransaction.Mapping_Error__c);
        System.assertEquals(null, noMappingResultTransaction.Matching_records__c);
        
		System.assertEquals('More than one mapping result. None matching amount.',moreThanOneMappingResultTransaction.Mapping_Error__c);
        System.assert(containsAllMatchingRecords(moreThanOneMappingResultTransaction,
                                                 new ID[]{receipt2.ID, receipt3.ID}));
        
		System.assertEquals('Transaction already processed. Added mapping.',alreadyMappedTransaction.Mapping_Error__c);
        System.assertEquals(null, noMappingResultTransaction.Matching_records__c);
        
		System.assert(amountNotMatchingTransaction.Mapping_Error__c.startsWithIgnoreCase('Amount not matching.'));
        System.assertEquals(receipt3.ID, amountNotMatchingTransaction.Matching_records__c);
        
		System.assertEquals('Duplicate transaction.',duplicateTransaction.Mapping_Error__c);
        System.assertEquals(receipt1.ID, duplicateTransaction.Matching_records__c);
        
        System.assert(String.isBlank(amountMatchingInsideMarginTransaction.Mapping_Error__c));
        System.assertEquals('Processed', amountMatchingInsideMarginTransaction.Stage__c);
        System.assertEquals(1, [SELECT Count() FROM Receipt_Payment__c WHERE Transaction__c = :amountMatchingInsideMarginTransaction.Id]);
        System.assertEquals(receipt4.ID, amountMatchingInsideMarginTransaction.Matching_records__c);
	}
    
    @isTest
	static void testMapLastNBefore() {
        // Arrange
		Transaction__c t1 = TestData.createTransaction(1190.00, System.today(), 't', 'i20170101001', 'Open');
        Transaction__c t2 = TestData.createTransaction(1190.00, System.today() - 1, 't2', 'i20170101001', 'Open');
        Transaction__c t3 = TestData.createTransaction(1190.00, System.today() + 1, 't3', 'i20170101001', 'Open');
        insert new Transaction__c[]{t1, t2, t3};

		// Act
		test.StartTest();
        
        Logger.debug('here1');
        // Process only t1 and t2, since t3 is out of the range [today-20, today].
		processTransactions(20, Date.today());
        Logger.debug('here2');
		test.StopTest();

		// Assert
		t1 = [SELECT ID, Mapping_Error__c FROM Transaction__c WHERE ID = :t1.ID];
		System.assertEquals('No mapping result.', t1.Mapping_Error__c);
        
        t2 = [SELECT ID, Mapping_Error__c FROM Transaction__c WHERE ID = :t2.ID];
		System.assertEquals('No mapping result.', t2.Mapping_Error__c);
        
        t3 = [SELECT ID, Mapping_Error__c FROM Transaction__c WHERE ID = :t3.ID];
		System.assertEquals(null, t3.Mapping_Error__c);
	}

    private static Boolean containsAllMatchingRecords(Transaction__c t, ID[] ids) {
        for (ID i: ids) {
            if (!t.matching_records__c.containsIgnoreCase(i)) {
                return false;
            }
        }
        
        return true;
    }

    // todo: test parsing transaction comment
}