@isTest
public class TransactionImportRunnableTests {
    @isTest
    private static void testRunnableProcessesTransactions() {
        Test.setMock(HTTPCalloutMock.class, new FinAPIMock());
        
        FinAPISettings s = new FinAPISettings();
        FinAPI f = new DefaultFinAPI(s);
        FinAPITransactionMapper m = new FinAPITransactionPurposeMapper();
        TransactionImportRunnable r = new TransactionImportRunnable(s, f, m);
        
        Test.startTest();
        GenericQueueable.enqueue(r);
        Test.stopTest();
        
        System.assertNotEquals(0, [SELECT Count() FROM Transaction__c]);
    }
}