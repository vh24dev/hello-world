@isTest
public class FinAPITransactionImportRunnableTests {
    @isTest
    private static void testRunnableProcessesTransactions() {
        Test.setMock(HTTPCalloutMock.class, new FinAPIMock());
        
        FinAPISettings s = new FinAPISettings();
        FinAPI f = new DefaultFinAPI(s, new DefaultLogger());
        FinAPITransactionMapper m = new FinAPITransactionPurposeMapper(new DefaultLogger());
        FinAPITransactionImportRunnable r = new FinAPITransactionImportRunnable(s, f, m);
        
        Test.startTest();
        GenericQueueable.enqueue(r);
        Test.stopTest();
        
        // todo: test the mapping part by inserting an invoice that maps to one of the transactions
        // and check that the transaction is no longer "Open".
        System.assertNotEquals(0, [SELECT Count() FROM Transaction__c]);
    }
}