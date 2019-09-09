public class CostNoteReminderTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CostNoteReminderTriggerHandler :: beforeInsert :: costNoteReminders: ' + Trigger.new);

        CostNoteReminders.setNumber(Trigger.new);
        
        Logger.debug('<< CostNoteReminderTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Logger.debug('>> CostNoteReminderTriggerHandler :: afterInsert :: costNoteReminders: ' + Trigger.new);
        
        CostNoteReminders.autoCreateDocuments(Trigger.newMap.keySet());
        
        Logger.debug('<< CostNoteReminderTriggerHandler :: afterInsert');
    }
}