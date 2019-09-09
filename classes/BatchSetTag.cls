global class BatchSetTag implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id, Reference__c FROM Opportunity WHERE Tag__c = null';
        return Database.getQueryLocator(query);
    }
    
    // Go through all revenue schedules and update the closing priority based on the Opportunity Info.
    global void execute(Database.BatchableContext BC, List<Opportunity> opps) {  
        
        For(Opportunity o : opps) {
            o.Tag__c = o.Reference__c.substringBeforeLast('-');
        }
        
        update opps;
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations
    }
}