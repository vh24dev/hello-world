global class OpportunityBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new OpportunitiesLatestBatch(new OpportunitiesRecordCache()));
    }
}