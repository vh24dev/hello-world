public class FinAPITransactionImportRunnable implements Runnable {
    private FinAPISettings settings;
    private FinAPI api;
    private FinAPITransactionMapper mapper;
    public FinAPITransactionImportRunnable(FinAPISettings settings, FinAPI api, FinAPITransactionMapper mapper) {
        this.settings = settings;
        this.api = api;
        this.mapper = mapper;
    }
    
    public void run() {
        // todo: do we need 2 queueables instead? Chained.
        FinAPITransactionFetchRunnable f = new FinAPITransactionFetchRunnable(this.settings, this.api);
        f.run();
        
        FinAPITransactionMapRunnable m = new FinAPITransactionMapRunnable(this.settings, this.mapper);
        m.run();
    }
}