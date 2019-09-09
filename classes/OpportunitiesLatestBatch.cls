global class OpportunitiesLatestBatch implements Database.Batchable<sObject> {
    private static final String TEMP_KEY = 'local.Opps.allOnClaimTemp';
    private static final Integer LIFETIME = 90000; // 25h
    private static final Decimal QUERY_LIMIT = GeneralSettings.OPPSONCLAIM_LIMIT;
    private final OpportunitiesCache cache;

    public OpportunitiesLatestBatch(OpportunitiesCache oc) {
		this.cache = oc;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        Logger.debug('>> OpportunitiesLatestBatch :: start');
        
        // Collects the batches of records or objects to be passed to execute
        String query = 'SELECT Id FROM Opportunity WHERE StageName = \'Claim\' ORDER BY LastModifiedDate DESC LIMIT ' + QUERY_LIMIT.intValue();
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> opps) {    
        Logger.debug('>> OpportunitiesLatestBatch :: execute :: items: ' + opps.size());
            
        // Add to current list in cache as part of the same batch
        this.cache.putInTemp(opps);

        Logger.debug('<< OpportunitiesLatestBatch :: execute');
    }   
    
    global void finish(Database.BatchableContext BC) {
        Logger.debug('>> OpportunitiesLatestBatch :: finish');
        
        this.cache.swapCurrentWithTemp();

        Logger.debug('<< OpportunitiesLatestBatch :: finish :: did set opps on cache');
    }
    
    /* Old code to use Platform Cache
	global void execute(Database.BatchableContext BC, List<Opportunity> opps) {    
        Logger.debug('>> OpportunitiesLatestBatch :: execute');
            
        // Add to current list in cache if part of the same batch
        Opportunity[] toCache = opps;
        if (Cache.Org.contains(TEMP_KEY)) {
            // Add new opps to the already existing ones
           	Opportunity[] inCache = (Opportunity[])Cache.Org.get(TEMP_KEY);
            inCache.addAll(toCache);
            toCache = inCache;
        }
         
        try {
			Cache.Org.put(TEMP_KEY, toCache);            
        } catch (Cache.ItemSizeLimitExceededException e) {
            // todo: automatically adjust
            Logger.debug('OpportunitiesLatestBatch :: put() exceeded 100KB. Adjust the query to return less records. Error: ' + e);
        }

        // todo: remove
        if (!Cache.Org.contains(TEMP_KEY)) {
            System.debug('what?');
            return;
        }
        // --
        Logger.debug('<< OpportunitiesLatestBatch :: execute :: have now in temp cache: ' + toCache.size());
    }   
    
    global void finish(Database.BatchableContext BC) {
        Logger.debug('>> OpportunitiesLatestBatch :: finish');
        
        Logger.debug('OpportunitiesLatestBatch :: current in tempkey: ' + Cache.Org.get(TEMP_KEY));
        Logger.debug('OpportunitiesLatestBatch :: current in key: ' + Cache.Org.get(OpportunitiesCache.ONCLAIM_KEY));
        
        if (!Cache.Org.contains(TEMP_KEY)) {
            System.debug('No items cached in this batch');
            return;
        }
        
        Cache.Org.remove(OpportunitiesCache.ONCLAIM_KEY);
        Cache.Org.put(OpportunitiesCache.ONCLAIM_KEY, Cache.Org.get(TEMP_KEY), LIFETIME);
        Cache.Org.remove(TEMP_KEY);
        
        Logger.debug('OpportunitiesLatestBatch :: current in key2: ' + (Opportunity[])Cache.Org.get(OpportunitiesCache.ONCLAIM_KEY));
        
        // todo: remove
        if (!Cache.Org.contains(OpportunitiesCache.ONCLAIM_KEY)) {
            System.debug('what?2');
            return;
        }
        // --
        
        Logger.debug('<< OpportunitiesLatestBatch :: finish :: did set opps on cache');
        // execute any post-processing operations
    }
	*/
}