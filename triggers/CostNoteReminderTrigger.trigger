trigger CostNoteReminderTrigger on Cost_Note_Reminder__c (before insert, after insert) {
	Logger.debug('>> CostNoteReminderTrigger');
    new CostNoteReminderTriggerHandler().run();
    Logger.debug('<< CostNoteReminderTrigger');
}