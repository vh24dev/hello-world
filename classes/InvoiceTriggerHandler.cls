public class InvoiceTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> InvoiceTriggerHandler :: beforeInsert :: invoices: ' + Trigger.new);

        Invoices.setNumber(Trigger.new);
        
        Logger.debug('<< InvoiceTriggerHandler :: beforeInsert');
    }

    public override void afterUpdate() {
        Logger.debug('>> InvoiceTriggerHandler :: afterUpdate :: new invoices: ' + Trigger.new + ' old invoices: ' + Trigger.old);

        Invoice__c[] newInvoices = Trigger.new;
        Map<ID, Invoice__c> oldInvoices = (Map<ID, Invoice__c>)Trigger.oldMap;
        Invoices.uploadToDropbox(newInvoices, oldInvoices);

        Logger.debug('<< InvoiceTriggerHandler :: afterUpdate');
    }
}