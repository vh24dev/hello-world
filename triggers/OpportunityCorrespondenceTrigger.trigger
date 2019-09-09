trigger OpportunityCorrespondenceTrigger on Opportunity_Correspondence__c (before insert, before update, after insert, after update) {
    Logger.debug('>> OpportunityCorrespondenceTrigger');
    new OpportunityCorrespondenceTriggerHandler().run();
    Logger.debug('<< OpportunityCorrespondenceTrigger');
}