public class TransactionImportRunnable implements Runnable {
    private FinAPISettings settings;
    private FinAPI api;
    private FinAPITransactionMapper mapper;
    public TransactionImportRunnable(FinAPISettings settings, FinAPI api, FinAPITransactionMapper mapper) {
        this.settings = settings;
        this.api = api;
        this.mapper = mapper;
    }
    
    public void run() {
        // todo: do we need 2 queueables instead?
        FinAPITransactions finAPI = new FinAPITransactions(this.settings, this.api, this.mapper);
        finAPI.fetchAndStore();
        finAPI.process();
    }
}