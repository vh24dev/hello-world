trigger CreditNoteTrigger on Credit_Note__c (before insert, before update, after update) {
	Logger.debug('>> CreditNoteTrigger');
    new CreditNoteTriggerHandler().run();
    Logger.debug('<< CreditNoteTrigger');
}