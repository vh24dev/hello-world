trigger InvoiceTrigger on Invoice__c (before insert, after update) {
    Logger.debug('>> InvoiceTrigger');
    new InvoiceTriggerHandler().run();
    Logger.debug('<< InvoiceTrigger');
}