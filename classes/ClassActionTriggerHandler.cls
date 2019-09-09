public class ClassActionTriggerHandler extends BaseTriggerHandler {
    public override void afterUpdate() {
        Logger.debug('>> ClassActionTriggerHandler :: afterUpdate :: new classactions: ' + Trigger.new + ' old classactions: ' + Trigger.old);

        ClassActions.setClaimStage(Trigger.new, (Map<ID, Class_Action__c>)Trigger.oldMap);

        Logger.debug('<< ClassActionTriggerHandler :: afterUpdate');
    }

    public override void beforeUpdate() {
        Logger.debug('>> ClassActionTriggerHandler :: beforeUpdate :: new classactions: ' + Trigger.new);

		ClassActions.CheckClaims(Trigger.new);

        Logger.debug('<< ClassActionTriggerHandler :: beforeUpdate');
    }
}