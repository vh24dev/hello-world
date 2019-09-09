trigger NonContributoryPeriodTrigger on Non_contributory_Period__c (before insert, before update) {
	Logger.debug('>> NonContributoryPeriodTrigger');
    new NonContributoryPeriodTriggerHandler().run();
    Logger.debug('<< NonContributoryPeriodTrigger');
}