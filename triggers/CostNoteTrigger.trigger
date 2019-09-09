trigger CostNoteTrigger on Cost_Note__c (before insert, before update, after update) {
	Logger.debug('>> CostNoteTrigger');  
    new CostNoteTriggerHandler().run();
    Logger.debug('<< CostNoteTrigger');
}