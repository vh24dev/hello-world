@isTest
public class FinAPITransactionsTests {
    @isTest
    private static void testFetchAndStorePagination() {
        Test.setMock(HTTPCalloutMock.class, new FinAPIMock());
        
        FinAPISettings ss = new FinAPISettings();
        FinAPI f = new DefaultFinAPI(ss, new DefaultLogger());
        Transaction__c[] tt = f.fetchTransactions(Date.today()-5, 1, 3);
        
        System.assertEquals(4, tt.size());
    }

    // Transaction.purpose is what carries the number which we will search for in invoices, costnotes, etc.
    // Create and test mapping to Opp, Claim, Invoices, CostNotes, CreditNotes, and Receipts.
    //
    // WIP: for now we're using an adapted version of the legacy tests - FinAPITransactionsLegacyTests
    /*
    @isTest
    private static void testMappingInvoice() { 
        // Note that we look for mapping via Opp Number or Invoice Number
        Account a = TestData.createAccount();
        insert a;
        
        Opportunity o = TestData.createOpportunity(a.ID, 'Draft');
        o.number__c = 'numberOpp';
        System.runAs(TestData.bypassUser()) {
			insert o;
        }

        Invoice__c inv = TestData.createInvoice(o.ID);
        inv.number__c = 'numberInv';
        //inv.amount_Open__c = 1000;
        insert inv;
        
        FinAPIMock mock = new FinAPIMock();
		Test.setMock(HTTPCalloutMock.class, mock);
        DefaultFinAPI.CFinApiGetTransactionsResponse resp = new DefaultFinAPI.CFinApiGetTransactionsResponse();
        //resp.amount = 1000;
        mock.response = resp;

        TransactionImportRunnable r = buildRunnable();

        Test.startTest();
        GenericQueueable.enqueue(r);
        Test.stopTest();
        
        
        
        // Test that we have an error margin on the amount, e.g, 1eur.
		
        // todo:
        // - test already mapped payments but transaction not mapped
        // - test no mapping
        // - test no amount matching
        // - test amount with difference below error margin
    }
    
    @isTest
    private static void testMappingClaim() { 
		User u = TestData.legalUser();        
        Claim__c c = ClaimsTests.buildClaim(u, null, 0, null, null);
        c.extrajudicial_Cost_Note_Number__c = null;
        insert c;

        Cost_Note__c cn = TestData.createCostNote(c.ID, 'Draft');
        cn.type__c = 'Außergerichtlich';
        cn.number__c = '12345';
        insert cn;

        FinAPIMock mock = new FinAPIMock();
		Test.setMock(HTTPCalloutMock.class, mock);
        DefaultFinAPI.CFinApiGetTransactionsResponse resp = new DefaultFinAPI.CFinApiGetTransactionsResponse();
        // todo:
        // 
        mock.response = resp;

        TransactionImportRunnable r = buildRunnable();

        Test.startTest();
        GenericQueueable.enqueue(r);
        Test.stopTest();
        
        
        
        // Test that we have an error margin on the amount, e.g, 1eur.
		
    }
    
    private static TransactionImportRunnable buildRunnable() {
        FinAPISettings s = new FinAPISettings();
        FinAPI api = new DefaultFinAPI(s);
        FinAPITransactionMapper m = new FinAPITransactionPurposeMapper();
        return new TransactionImportRunnable(s, api, m);
    }
	*/
}