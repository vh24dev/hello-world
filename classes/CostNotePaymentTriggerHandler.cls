public class CostNotePaymentTriggerHandler extends BaseTriggerHandler {
    public override void beforeUpdate() {
        Logger.debug('>> CostNotePaymentTriggerHandler :: beforeUpdate :: CostNotePayments: ' + Trigger.new);

        CostNotePayments.preventUpdate(Trigger.new, (Map<ID, Cost_Note_Payment__c>)Trigger.oldMap);
        
        Logger.debug('<< CostNotePaymentTriggerHandler :: beforeUpdate');
    }

    public override void beforeDelete() {
        Logger.debug('>> CostNotePaymentTriggerHandler :: beforeUpdate :: new CostNotePayments: ' + Trigger.new + ' old CostNotePayments: ' + Trigger.old);

        CostNotePayments.preventDelete(Trigger.old);

        Logger.debug('<< CostNotePaymentTriggerHandler :: beforeUpdate');
    }
}