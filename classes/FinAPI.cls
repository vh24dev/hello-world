public interface FinAPI {
    Transaction__c[] fetchTransactions(Date since, Integer fromPage, Integer perPage);
}