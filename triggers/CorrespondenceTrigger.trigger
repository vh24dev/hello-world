trigger CorrespondenceTrigger on Correspondence__c (before insert, after insert, before update, after update) {
	Logger.debug('>> CorrespondenceTrigger');
    new CorrespondenceTriggerHandler().run();
    Logger.debug('<< CorrespondenceTrigger');
}