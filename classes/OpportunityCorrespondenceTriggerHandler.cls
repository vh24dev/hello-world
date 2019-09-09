public class OpportunityCorrespondenceTriggerHandler extends BaseTriggerHandler {
    @testVisible
    private static Boolean deactivate = false;

    public override void beforeInsert() {
        Logger.debug('>> OpportunityCorrespondenceTriggerHandler :: beforeInsert :: opps: ' + Trigger.new);
        OpportunityCorrespondences.setRecordType(Trigger.new);
        OpportunityCorrespondences.setTerm(Trigger.new, (Map<ID, Opportunity_Correspondence__c>)Trigger.oldMap, false);
        Logger.debug('<< OpportunityCorrespondenceTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Logger.debug('>> OpportunityCorrespondenceTriggerHandler :: afterInsert :: opps: ' + Trigger.new);
        OpportunityCorrespondences.manageTextModules(Trigger.new);
        OpportunityCorrespondences.autoCreateDocuments(Trigger.newMap.keySet());
        Logger.debug('<< OpportunityCorrespondenceTriggerHandler :: afterInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> OpportunityCorrespondenceTriggerHandler :: beforeUpdate :: new opps: ' + Trigger.new + ' old opps: ' + Trigger.old);
        OpportunityCorrespondences.setTerm(Trigger.new, (Map<ID, Opportunity_Correspondence__c>)Trigger.oldMap, true);
        Logger.debug('<< OpportunityCorrespondenceTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> OpportunityCorrespondenceTriggerHandler :: afterUpdate :: opps: ' + Trigger.new);
        OpportunityCorrespondences.manageTextModules(Trigger.new);
        Logger.debug('<< OpportunityCorrespondenceTriggerHandler :: afterUpdate');
    }
    
    protected override Boolean preventFromRunning() { return deactivate; }
}