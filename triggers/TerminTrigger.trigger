trigger TerminTrigger on Date__c (before insert) {
    Logger.debug('>> TerminTrigger');
    new TerminTriggerHandler().run();
    Logger.debug('<< TerminTrigger');
}