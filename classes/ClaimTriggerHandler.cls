public class ClaimTriggerHandler extends BaseTriggerHandler {
    @testVisible
    private static Boolean deactivate = false;
    
    public override void beforeInsert() {
        Logger.debug('>> ClaimTriggerHandler :: beforeInsert :: claims: ' + Trigger.new);

        // Grab opps related to the Claims and reuse them in all of the Claims' methods
        Claim__c[] cc = Trigger.new;
        Map<ID, Opportunity> oppByID = fetchOpps(cc);
        Claims.setRecordType(cc, oppByID);
        Claims.setUsers(cc, oppByID);
        Claims.setCourt(cc);
        Claims.setStage(cc, (Map<ID, Claim__c>)Trigger.oldMap, oppByID, true);

        setUniqueID(cc);

        Logger.debug('<< ClaimTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Logger.debug('>> ClaimTriggerHandler :: afterInsert :: claims: ' + Trigger.new);

        Claims.createTasks(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap, Trigger.isInsert);
        Claims.createCorrespondences(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        
        Logger.debug('<< ClaimTriggerHandler :: afterInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> ClaimTriggerHandler :: beforeUpdate :: new claims: ' + Trigger.new + ' old claims: ' + Trigger.old);

        Claim__c[] cc = Trigger.new;
        Map<ID, Opportunity> oppByID = fetchOpps(cc);
        Claims.setUsers(cc, oppByID);
        Claims.setHash(cc, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.setLastStageChangedAt(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.setResponseInsuranceLawsuit(Trigger.new);
        Claims.setCourt(cc);
        Claims.setStage(cc, (Map<ID, Claim__c>)Trigger.oldMap, oppByID, false);

        Logger.debug('<< ClaimTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> ClaimTriggerHandler :: afterUpdate :: new claims: ' + Trigger.new + ' old claims: ' + Trigger.old);

        Claims.createTasks(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap, Trigger.isInsert);
        Claims.closeTasks(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.autoSendMails(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.createCorrespondences(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.createCostNotes(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.updateOpportunity(Trigger.new, (Map<ID, Claim__c>)Trigger.oldMap);
        Claims.createInvoices(Trigger.new);
        
        Logger.debug('<< ClaimTriggerHandler :: afterUpdate');
    }
    
    protected override Boolean preventFromRunning() { return deactivate; }
    
    private Map<ID, Opportunity> fetchOpps(Claim__c[] cc) {
        ID[] oppIDs = new ID[]{};
        for (Claim__c c: (Claim__c[])Trigger.new) {
            oppIDs.add(c.opportunity__c);
        }
        return new Map<ID, Opportunity>([
            SELECT ID, RecordTypeID, Legal__c, Legal_Account__c, Priority_Level__c
            FROM Opportunity
            WHERE ID IN :oppIDs
        ]);
    }

    private void setUniqueID(Claim__c[] cc) {
        for (Claim__c c : cc) {
            if (c.Token__c != null) {
                continue;
            }
            c.Token__c = GUID.Gen();
        }
    }
}