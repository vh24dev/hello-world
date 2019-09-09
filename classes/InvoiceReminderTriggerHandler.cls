public class InvoiceReminderTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> InvoiceReminderTriggerHandler :: beforeInsert :: invoicereminders: ' + Trigger.new);

        InvoiceReminders.setNumber(Trigger.new);
        
        Logger.debug('<< InvoiceReminderTriggerHandler :: beforeInsert');
    }

    public override void afterInsert() {
        Logger.debug('>> InvoiceReminderTriggerHandler :: afterInsert :: new invoicereminders: ' + Trigger.new + ' old invoicereminders: ' + Trigger.old);
        
		InvoiceReminders.autoCreateDocuments(Trigger.newMap.keySet());

        Logger.debug('<< InvoiceReminderTriggerHandler :: afterInsert');
    }
}