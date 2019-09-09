trigger CommissionTrigger on Commission__c (before insert, after insert) {
	Logger.debug('>> CommissionTrigger');
    new CommissionTriggerHandler().run();
    Logger.debug('<< CommissionTrigger');
}