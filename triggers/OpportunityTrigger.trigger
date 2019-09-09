trigger OpportunityTrigger on Opportunity (before insert, after insert, before update, after update) {
	Logger.debug('>> OpportunityTrigger');    
    new OpportunityTriggerHandler().run();
    Logger.debug('<< OpportunityTrigger');
}