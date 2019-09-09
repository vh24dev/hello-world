trigger DatesTrigger on Date__c (before insert, before update, after update) {
	Logger.debug('>> DatesTrigger');
    new DatesTriggerHandler().run();
    Logger.debug('<< DatesTrigger');
}