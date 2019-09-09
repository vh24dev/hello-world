public class CancellationTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CancellationTriggerHandler :: beforeInsert :: cancellations: ' + Trigger.new);

        Cancellations.setNumber(Trigger.new, null, Trigger.isInsert);

        Logger.debug('<< CancellationTriggerHandler :: beforeInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> CancellationTriggerHandler :: beforeUpdate :: new cancellations: ' + Trigger.new + ' old cancellations: ' + Trigger.old);

        Cancellations.setNumber(Trigger.new, (Map<ID, Cancellation__c>)Trigger.oldMap, Trigger.isInsert);

        Logger.debug('<< CancellationTriggerHandler :: beforeUpdate');
    }
}