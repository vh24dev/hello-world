public class OpportunityTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> OpportunityTriggerHandler :: beforeInsert :: opps: ' + Trigger.new);

        Opportunity[] oo = Trigger.new;
        Opportunities.createAccount(oo);
        Opportunities.setDateStamps(oo, (Map<ID, Opportunity>)Trigger.oldMap, Trigger.isInsert);
        
        // Will be computed and set on the Lead and mapped to the Opp on conversion
        // https://salesfive.atlassian.net/browse/VH24-91
        // Opportunities.setReference(oo, Trigger.isBefore && Trigger.isUpdate);

        Opportunities.setDefaultOwner(oo);
        
        Opportunities.setAssignmentType(oo);
        Opportunities.setHash(oo);
        Opportunities.setLegalUser(oo, null, new OpportunitiesLegal(OpportunitiesLegalSettings.CONFIGS), new OpportunitiesRecordCache());
        Opportunities.setLegalAccount(oo, null, Trigger.isInsert);
        Opportunities.setPartner(oo);
        //OpportunityAction.autoStartAutoFollowUp(Trigger.new, null, Trigger.isInsert); // TBD
        Opportunities.setLegalProcessType(oo);
        Opportunities.setCurrencyFields(oo);
        Opportunities.setOldDate(oo);

        setUniqueID(oo);

        Logger.debug('<< OpportunityTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Logger.debug('>> OpportunityTriggerHandler :: afterInsert :: opps: ' + Trigger.new);

        Opportunity[] oo = Trigger.new;
        Map<ID, Opportunity> oldOo = (Map<ID, Opportunity>)Trigger.oldMap;
		Opportunities.createObjects(oo, oldOo);
        Opportunities.calculateRevenue(oo, oldOo);
        Opportunities.processLost(oo);
        OpportunityEmails.autoSend(oo, oldOo, Trigger.isInsert);
        Opportunities.setContactLastOpportunity(oo, oldOo, Trigger.isInsert);
        
        Logger.debug('<< OpportunityTriggerHandler :: afterInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> OpportunityTriggerHandler :: beforeUpdate :: new opps: ' + Trigger.new + ' old opps: ' + Trigger.old);

        Opportunity[] oo = Trigger.new;
        Opportunities.setDateStamps(Trigger.new, (Map<ID, Opportunity>)Trigger.oldMap, Trigger.isInsert);
        
        // Will be computed and set on the Lead and mapped to the Opp on conversion
        // https://salesfive.atlassian.net/browse/VH24-91
        // Opportunities.setReference(oo, Trigger.isBefore && Trigger.isUpdate);
        
        Opportunities.setAssignmentType(Trigger.new);
        Opportunities.setHash(Trigger.new);
        Opportunities.setLegalUser(Trigger.new, (Map<ID, Opportunity>)Trigger.oldMap, new OpportunitiesLegal(OpportunitiesLegalSettings.CONFIGS), new OpportunitiesRecordCache());
        Opportunities.setLegalAccount(Trigger.new, (Map<ID, Opportunity>)Trigger.oldMap, Trigger.isInsert);
        //OpportunityAction.autoStartAutoFollowUp(Trigger.new, (Map<ID, Opportunity>)Trigger.oldMap, Trigger.isInsert); // TBD
        Opportunities.setLegalProcessType(Trigger.new);
        Opportunities.setCurrencyFields(Trigger.new);
        Opportunities.setStage(Trigger.new, (Map<ID, Opportunity>)Trigger.oldMap);

        Logger.debug('<< OpportunityTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> OpportunityTriggerHandler :: afterUpdate :: new opps: ' + Trigger.new + ' old opps: ' + Trigger.old);

        Opportunity[] oo = Trigger.new;
        Map<ID, Opportunity> oldOo = (Map<ID, Opportunity>)Trigger.oldMap;
		Opportunities.createObjects(oo, oldOo);
        Opportunities.calculateRevenue(oo, oldOo);
        Opportunities.processLost(oo);
        OpportunityEmails.autoSend(oo, oldOo, Trigger.isInsert);
        //OpportunityAction.syncToExternal(Trigger.new, Trigger.oldMap);
		Opportunities.setContactLastOpportunity(oo, oldOo, Trigger.isInsert);
       
        Logger.debug('<< OpportunityTriggerHandler :: afterUpdate');
    }

    private void setUniqueID(Opportunity[] opps) {
        for (Opportunity o: opps) {
            if (o.Token__c != null) {
                continue;
            }
            o.Token__c = GUID.Gen();
        }
    }
}