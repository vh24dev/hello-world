public class CommissionTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CommissionTriggerHandler :: beforeInsert :: commissions: ' + Trigger.new);

        Commissions.setCommissionRate(Trigger.new);
        
        Logger.debug('<< CommissionTriggerHandler :: beforeInsert');
    }

    public override void afterInsert() {
        Logger.debug('>> CommissionTriggerHandler :: afterInsert :: new commissions: ' + Trigger.new + ' old commissions: ' + Trigger.old);

        Commissions.assignCostNotePayments(Trigger.new);
        Commissions.autoCreateDocuments(Trigger.newMap.keySet());

        Logger.debug('<< CommissionTriggerHandler :: afterInsert');
    }
}