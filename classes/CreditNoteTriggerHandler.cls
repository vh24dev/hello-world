public class CreditNoteTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CreditNoteTriggerHandler :: beforeInsert :: creditNotes: ' + Trigger.new);

        CreditNotes.setNumber(Trigger.new, null, Trigger.isInsert);
        
        Logger.debug('<< CreditNoteTriggerHandler :: beforeInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> CreditNoteTriggerHandler :: beforeUpdate :: new creditNotes: ' + Trigger.new + ' old creditNotes: ' + Trigger.old);

        CreditNotes.setNumber(Trigger.new, (Map<ID, Credit_Note__c>)Trigger.oldMap, Trigger.isInsert);

        Logger.debug('<< CreditNoteTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> CreditNoteTriggerHandler :: afterUpdate :: new creditNotes: ' + Trigger.new + ' old creditNotes: ' + Trigger.old);

        CreditNotes.uploadToDropbox(Trigger.new, (Map<Id, Credit_Note__c>)Trigger.oldMap);

        Logger.debug('<< CreditNoteTriggerHandler :: afterUpdate');
    }
}