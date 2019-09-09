trigger CostNotePaymentTrigger on Cost_Note_Payment__c (before update, before delete) {
	Logger.debug('>> CostNotePaymentTrigger');
    new CostNotePaymentTriggerHandler().run();
    Logger.debug('<< CostNotePaymentTrigger');
}