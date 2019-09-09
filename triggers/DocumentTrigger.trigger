trigger DocumentTrigger on Document__c (before insert, after insert, before update, after update) {
	Logger.debug('>> DocumentTrigger');
    new DocumentTriggerHandler().run();
    Logger.debug('<< DocumentTrigger');
}