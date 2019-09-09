trigger UserReferenceTrigger on User_Reference__c (after insert, after update) {
	Logger.debug('>> CommissionTrigger');
    new UserReferenceTriggerHandler().run();
    Logger.debug('<< CommissionTrigger');
}