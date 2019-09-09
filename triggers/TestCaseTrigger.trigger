trigger TestCaseTrigger on Test_Case__c (before insert, after insert, before update, after update) {
	Logger.debug('>> TestCaseTrigger');
    new TestCaseTriggerHandler().run();
    Logger.debug('<< TestCaseTrigger');
}