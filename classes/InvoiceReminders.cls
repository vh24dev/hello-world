public class InvoiceReminders {
    // Legacy code, todo: refactor
    @future (callout=true)
    public static void autoCreateDocuments(Set<Id> ids) {
        List<Invoice_Reminder__c> invoiceReminders = [select Id, Stage__c from Invoice_Reminder__c where Id in :ids];
        for (Invoice_Reminder__c invoiceReminder : invoiceReminders) {
            if (invoiceReminder.Stage__c == 'Draft') {
                DocumentCreationAction.autoCreateDocument(invoiceReminder.Id,false,'pdf',null,null);
            }
        }
    }
    
    public static void autoCreateInvoiceReminders(){
        List<Invoice__c> invoices = [select Id, Amount_Open__c,Disable_Dunning__c,Due_Date__c, (select Id from Invoice_Reminders__r where Stage__c != 'Canceled') from Invoice__c where Stage__c = 'Sent'];
        List<Invoice_Reminder__c> newInvoiceReminders = new List<Invoice_Reminder__c>();

        Integer creationLimit = 50;
        Integer creationCount = 0;

        for (Invoice__c invoice : invoices){
            if (creationCount >= creationLimit) {
                break;
            }
            if ((invoice.Amount_Open__c > 0) && (Date.parse(invoice.Due_Date__c) <= System.today())){
                if ((invoice.Invoice_Reminders__r.size() == 0) && (invoice.Disable_Dunning__c == false)){
                    newInvoiceReminders.add(new Invoice_Reminder__c(
                        Invoice__c = invoice.Id
                    ));
                    creationCount++;
                }
            }
        }
        if (newInvoiceReminders.size() > 0){
            insert newInvoiceReminders;
            System.debug('Successfully created ' + newInvoiceReminders.size() + ' invoice reminders.');
        }
    }

	public static void setNumber(List<Invoice_Reminder__c> invoiceReminders) {
		List<Invoice_Reminder__c> oldVhInvoiceReminders = [select Number__c from Invoice_Reminder__c where Invoice__r.Opportunity__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%IRVH' ORDER BY Number__c DESC NULLS LAST LIMIT 1];
		List<Invoice_Reminder__c> oldVrInvoiceReminders = [select Number__c from Invoice_Reminder__c where Invoice__r.Opportunity__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%IRVR' ORDER BY Number__c DESC NULLS LAST LIMIT 1];

		Set<Id> invoiceIds = new Set<Id>();
		for (Invoice_Reminder__c invoiceReminder : invoiceReminders){
			invoiceIds.add(invoiceReminder.Invoice__c);
		}

		Map<Id,Invoice__c> invoices = new Map<Id,Invoice__c>([select Id, Opportunity__r.Test__c,Opportunity__r.Account_Name__c from Invoice__c where Id IN :invoiceIds]);

		Integer oldVhInvoiceRemindersCount = 0;
		Integer oldVrInvoiceRemindersCount = 0;

		if (oldVhInvoiceReminders.Size() > 0){
			oldVhInvoiceRemindersCount = Integer.valueOf(oldVhInvoiceReminders[0].Number__c.substring(4,10));
		}
		if (oldVrInvoiceReminders.Size() > 0){
			oldVrInvoiceRemindersCount = Integer.valueOf(oldVrInvoiceReminders[0].Number__c.substring(4,10));
		}
		Integer i = 0;
        for (Invoice_Reminder__c invoiceReminder : invoiceReminders){
            if (invoiceReminder.Number__c != null) {
                continue;
            }
            Invoice__c invoice = invoices.get(invoiceReminder.Invoice__c);
            if (invoice.Opportunity__r.Test__c == false){
                i++;
            }

            Integer VhCount = oldVhInvoiceRemindersCount + i;
            Integer VrCount = oldVrInvoiceRemindersCount + i;

            String year = System.now().date().year().format().replace('.','');

            if (invoice.Opportunity__r.Test__c == true){
                invoiceReminder.Number__c = year + VrCount.format().replace('.','').leftPad(6,'0') + '/Test';
            } else if (invoice.Opportunity__r.Account_Name__c == 'VH24'){
                invoiceReminder.Number__c = year + VhCount.format().replace('.','').leftPad(6,'0') + '/IRVH';
            } else if (invoice.Opportunity__r.Account_Name__c == 'VR24'){
                invoiceReminder.Number__c = year + VrCount.format().replace('.','').leftPad(6,'0') + '/IRVR';
            }
		}
	}
}