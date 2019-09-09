public class FinAPITransactionMapRunnable implements Runnable {
    private FinAPISettings settings;
    private FinAPITransactionMapper mapper;
    public FinAPITransactionMapRunnable(FinAPISettings settings, FinAPITransactionMapper mapper) {
        this.settings = settings;
        this.mapper = mapper;
    }
    
    public void run() {
        FinAPITransactions finAPI = new FinAPITransactions(this.settings, null, this.mapper);
        finAPI.process();
    }
}