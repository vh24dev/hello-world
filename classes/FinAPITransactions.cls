public inherited sharing class FinAPITransactions {
    public class FinAPITransactionsException extends Exception {}

    private FinAPISettings settings;
    private FinAPI api;
    private FinAPITransactionMapper mapper;
    public FinAPITransactions(FinAPISettings settings, FinAPI api, FinAPITransactionMapper mapper) {
        if (settings == null) {
			throw new FinAPITransactionsException('FinAPISettings is mandatory');
        }
        
        this.settings = settings;
        this.api = api;
        this.mapper = mapper;
    }

    // Fetches the latest FinAPI Transactions according the what's been passed as settings.
    // Filters out unknown accountIDs.
    // Stores non-duplicates in the database.
    public void fetchAndStore() {
        System.debug('>> FinAPITransactions :: fetchAndStore');
        
        if (this.api == null) {
			throw new FinAPITransactionsException('FinAPI is mandatory');
        }

        Transaction__c[] tt = api.fetchTransactions(System.Today() - settings.timeframe, 1, 100);

        Map<String,Transaction__c> ttMap = new Map<String, Transaction__c>();
        for (Transaction__c t : tt) {
            if (String.isBlank(t.external_ID__c)) {
                System.debug('FinAPITransactions :: fetchAndStore :: external_ID__c is blank for tID: ' + t.ID);
                continue;
            }

            ttMap.put(t.external_ID__c, t);
        }

        // Remove duplicates that already exist in database
        Transaction__c[] duplicateTrans = [
            SELECT ID, External_Id__c
            FROM Transaction__c
            WHERE External_Id__c IN :ttMap.keySet()
        ];
        for (Transaction__c dt: duplicateTrans){
            ttMap.remove(dt.external_Id__c);
            System.debug('FinAPITransactions :: fetchAndStore :: removed duplicate transaction for id ' + dt.external_Id__c);
        }

        Transaction__c[] toInsert = ttMap.values();
        insert toInsert;
        System.debug('<< FinAPITransactions :: fetchAndStore :: stored ' + toInsert.size() + ' new transactions');
    }
    
    // WIP: legacy code rewrite.
    // todo: get a clear description of what we're doing here.
    public void process() {
        System.debug('>> FinAPITransactions :: process');
        
        if (this.mapper == null) {
			throw new FinAPITransactionsException('FinAPITransactionMapper is mandatory');
        }
        
        this.mapper.doMap(this.settings.mapLastN, this.settings.mapLastNBeforeDate);
        System.debug('<< FinAPITransactions :: process');
    }
}