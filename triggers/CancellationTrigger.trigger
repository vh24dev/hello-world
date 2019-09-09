trigger CancellationTrigger on Cancellation__c (before insert, before update) {
	Logger.debug('>> CancellationTrigger');
    new CancellationTriggerHandler().run();
    Logger.debug('<< CancellationTrigger');
}