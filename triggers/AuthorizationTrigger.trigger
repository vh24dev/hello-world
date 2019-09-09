trigger AuthorizationTrigger on Authorization__c (before insert, after insert) {
    Logger.debug('>> AuthorizationTrigger');
    new AuthorizationTriggerHandler().run();
    Logger.debug('<< AuthorizationTrigger');
}