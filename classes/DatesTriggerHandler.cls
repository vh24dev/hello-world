public class DatesTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> DatesTriggerHandler :: beforeInsert :: dates: ' + Trigger.new);

        Dates.setHash(Trigger.new);

        Logger.debug('<< DatesTriggerHandler :: beforeInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> DatesTriggerHandler :: afterInsert :: new dates: ' + Trigger.new + ' old dates: ' + Trigger.old);

        Dates.setHash(Trigger.new);

        Logger.debug('<< DatesTriggerHandler :: afterInsert');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> DatesTriggerHandler :: afterInsert :: new dates: ' + Trigger.new + ' old dates: ' + Trigger.old);

        Dates.autoSendMails(Trigger.new, (Map<ID, Date__c>)Trigger.oldMap);
		Dates.createObjects(Trigger.new, (Map<ID, Date__c>)Trigger.oldMap);

        Logger.debug('<< DatesTriggerHandler :: afterInsert');
    }
}