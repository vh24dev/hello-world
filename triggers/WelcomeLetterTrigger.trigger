trigger WelcomeLetterTrigger on Welcome_Letter__c (after insert) {
	Logger.debug('>> WelcomeLetterTrigger');
    new WelcomeLetterTriggerHandler().run();
    Logger.debug('<< WelcomeLetterTrigger');
}