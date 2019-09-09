trigger ClassActionTrigger on Class_Action__c (after update, before update) {
	Logger.debug('>> ClassActionTrigger');
    new ClassActionTriggerHandler().run();
    Logger.debug('<< ClassActionTrigger');
}