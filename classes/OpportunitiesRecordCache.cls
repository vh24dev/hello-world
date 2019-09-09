public class OpportunitiesRecordCache implements OpportunitiesCache {
    public static final String ONCLAIM_KEY = 'allOnClaim';

    // Returns a list of cached Opportunity IDs.
    public ID[] getOnClaim() {
        Logger.debug('>> getOnClaim');

        OppsOnClaimCacheItem__c[] items = [SELECT Opportunity__c FROM OppsOnClaimCacheItem__c WHERE Visible__c = true];
        ID[] ids = new ID[]{};
        for (OppsOnClaimCacheItem__c i: items) {
            ids.add(i.opportunity__c);
        }
        
        Logger.debug('<< getOnClaim :: returning ' + ids.size() + ' items');
        return ids;
    }
    
    public void putInTemp(Opportunity[] opps) {
        Logger.debug('>> putInTemp :: ' + opps.size() + ' items to add');

        OppsOnClaimCacheItem__c[] items = new OppsOnClaimCacheItem__c[]{};
        for (Opportunity o: opps) {
            items.add(new OppsOnClaimCacheItem__c(name = 'CachedOpp-' + o.ID,
                                                  opportunity__c = o.ID,
                                                  visible__c = false));
        }
        insert items;

        Logger.debug('>> putInTemp :: added ' + items.size() + ' to temp');
    }
    
    public void swapCurrentWithTemp() {
    	Logger.debug('>> swapCurrentWithTemp');

        OppsOnClaimCacheItem__c[] allItems = [SELECT Visible__c FROM OppsOnClaimCacheItem__c];
        ID[] toDelete = new ID[]{};
		OppsOnClaimCacheItem__c[] toUpdate = new OppsOnClaimCacheItem__c[]{};
        for (OppsOnClaimCacheItem__c i: allItems) {
            if (i.visible__c) {
                toDelete.add(i.ID);
                continue;
            }
            
            i.visible__c = true;
			toUpdate.add(i);
        }
        
        Logger.debug('swapCurrentWithTemp :: toDelete: ' + toDelete.size() + ' to be made visible: ' + toUpdate.size());   
        update toUpdate;
		deleteAsync(toDelete);

        Logger.debug('>> swapCurrentWithTemp');   
    }
    
    private static void deleteAsync(ID[] ids) {
        System.debug('>> deleteAsync');
        
        OppsOnClaimCacheItem__c[] toDelete = [SELECT ID FROM OppsOnClaimCacheItem__c WHERE ID IN :ids];
        if (toDelete.size() > 0) {
            ID jobID = System.enqueueJob(new GenericQueueable(new DeleteItems(toDelete)));
        	Logger.debug('Enqueued deletion jobID: ' + jobID + ' toDelete: ' + toDelete.size());
        }
        
        System.debug('<< deleteAsync');
    }
    
    public void clearAll() {
        Logger.debug('>> clearAll');
        clear(false);
    }
    
    private void clear(Boolean tempOnly) {
        OppsOnClaimCacheItem__c[] items = tempOnly ? [SELECT ID FROM OppsOnClaimCacheItem__c WHERE Visible__c = true] : [SELECT ID FROM OppsOnClaimCacheItem__c];
		delete items; 
    }
    
    class DeleteItems implements Runnable {
        private final OppsOnClaimCacheItem__c[] toDelete;
        DeleteItems(OppsOnClaimCacheItem__c[] items) {
            this.toDelete = items;
        }

        public void run() {
            Logger.debug('DeleteItems :: run :: deleting: ' + this.toDelete.size());
			delete this.toDelete;            
        }
    }
}