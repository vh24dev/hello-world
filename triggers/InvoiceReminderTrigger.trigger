trigger InvoiceReminderTrigger on Invoice_Reminder__c (before insert, after insert) {
	Logger.debug('>> CommissionTrigger');
    new InvoiceReminderTriggerHandler().run();
    Logger.debug('<< CommissionTrigger');
}