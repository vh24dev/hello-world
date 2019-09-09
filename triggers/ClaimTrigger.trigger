trigger ClaimTrigger on Claim__c (before insert, after insert, before update, after update) {
	Logger.debug('>> ClaimTrigger');
    new ClaimTriggerHandler().run();
    Logger.debug('<< ClaimTrigger');
}