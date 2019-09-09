public class NonContributoryPeriodTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> NonContributoryPeriodTriggerHandler :: beforeInsert :: NonContributoryPeriods: ' + Trigger.new);

        NonContributoryPeriods.setFields(Trigger.new, (Map<ID, Non_Contributory_Period__c>)Trigger.oldMap, Trigger.isInsert);
        
        Logger.debug('<< NonContributoryPeriodTriggerHandler :: beforeInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> NonContributoryPeriodTriggerHandler :: beforeUpdate :: new NonContributoryPeriods: ' + Trigger.new + ' old NonContributoryPeriods: ' + Trigger.old);

        NonContributoryPeriods.setFields(Trigger.new, (Map<ID, Non_Contributory_Period__c>)Trigger.oldMap, Trigger.isInsert);
        
        Logger.debug('<< NonContributoryPeriodTriggerHandler :: beforeUpdate');
    }
}