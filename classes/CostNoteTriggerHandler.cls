public class CostNoteTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CostNoteTriggerHandler :: beforeInsert :: costNotes: ' + Trigger.new);

        // New requirements say that Number and Date should be set when a Document is generated.
        //CostNotes.setNumber(Trigger.new, null, Trigger.isInsert);
		CostNotes.setUser(Trigger.new);
        
        Logger.debug('<< CostNoteTriggerHandler :: beforeInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> CostNoteTriggerHandler :: beforeUpdate :: new costNotes: ' + Trigger.new + ' old costNotes: ' + Trigger.old);

        // New requirements say that Number and Date should be set when a Document is generated.
        //CostNotes.setNumber(Trigger.new, (Map<ID, Cost_Note__c>)Trigger.oldMap, Trigger.isInsert);
		CostNotes.setUser(Trigger.new);

        Logger.debug('<< CostNoteTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> CostNoteTriggerHandler :: afterUpdate :: new costNotes: ' + Trigger.new + ' old costNotes: ' + Trigger.old);

        Cost_Note__c[] cnn = Trigger.new;
        Map<ID, Cost_Note__c> oldCnn = (Map<ID, Cost_Note__c>)Trigger.oldMap;
        CostNotes.setRemindersCanceled(cnn, oldCnn);
        CostNotes.uploadToDropbox(cnn, oldCnn);
        CostNotes.setClaimAmountInDispute(cnn, oldCnn);
        CostNotes.setClaimExtrajudicialCostNoteNumber(cnn, oldCnn);
        
        Logger.debug('<< CostNoteTriggerHandler :: afterUpdate');
    }
}