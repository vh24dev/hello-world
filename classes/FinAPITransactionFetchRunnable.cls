public class FinAPITransactionFetchRunnable implements Runnable {
    private FinAPISettings settings;
    private FinAPI api;
    public FinAPITransactionFetchRunnable(FinAPISettings settings, FinAPI api) {
        this.settings = settings;
        this.api = api;
    }
    
    public void run() {
        FinAPITransactions finAPI = new FinAPITransactions(this.settings, this.api, null);
        finAPI.fetchAndStore();
    }
}