public class Invoices {
    public class InvalidInputException extends Exception {}
    public static Invoice__c build(Claim__c claim, Opportunity opp) {
		Logger.debug('>> Invoices :: build :: opp: ' + opp);
        if (claim == null) {
            throw new InvalidInputException('Claim is mandatory');
        }
        if (opp == null) {
            throw new InvalidInputException('Opportunity is mandatory');
        }

        decimal amount = 0.0;
        if (Opportunities.isDieselskandal(opp.RecordTypeId)) {
            if (opp.Process_Type__c == 'DG_Keep') { // Behalten
                amount = 0.15 * opp.Refund__c;
            } else { // "Rückgabe" "Unentschlossen" "keine Angabe"
                amount = 0.06 * opp.Refund__c;
            }
        } else if (Opportunities.isFinanzierung(opp.RecordTypeId)) {
			amount = 0.17 * opp.Refund__c;
        } else if (Opportunities.isLebensversicherung(opp.RecordTypeId)) {
            if (opp.Has_Legal_Protection_Insurance__c == true) {
                amount = 690; // fix 690 EUR
            } else {
                amount = 0.35 * opp.Refund__c;
            }
        }

        Invoice__c i = new Invoice__c(
        	Opportunity__c = opp.Id,
            Stage__c = 'Draft',
            Date__c = System.today(),
            Amount__c = amount // Bruttosumme
        );

        // Check for duplicates
        for (Invoice__c ei : opp.Invoices__r) {
            /*
            if (ei.Field__c == i.Field__c) {
                // Found duplicate, do not build the object
                return null;
            }
			*/
            return null;
        }

		Logger.debug('<< Invoices :: build :: i: ' + i);
        return i;
    }

    // Legacy code, todo: refactor
    public static void setNumber(Invoice__c[] invoices) {
        Logger.debug('>> Invoices :: setNumber :: invoices: ' + invoices);
        
        List<Invoice__c> oldVhInvoices = [select Number__c from Invoice__c where Opportunity__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%IVH' ORDER BY Number__c DESC NULLS LAST LIMIT 1];
        List<Invoice__c> oldVrInvoices = [select Number__c from Invoice__c where Opportunity__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%IVR' ORDER BY Number__c DESC NULLS LAST LIMIT 1];

        Integer oldVhInvoicesCount = 0;
        Integer oldVrInvoicesCount = 0;

        if (oldVhInvoices.Size() > 0) {
            oldVhInvoicesCount = Integer.valueOf(oldVhInvoices[0].Number__c.substring(4, 10));
        }
        if (oldVrInvoices.Size() > 0) {
            oldVrInvoicesCount = Integer.valueOf(oldVrInvoices[0].Number__c.substring(4, 10));
        }

        Set<Id> opportunityIds = new Set<Id>();
        for (Invoice__c invoice : invoices) {
            opportunityIds.add(invoice.Opportunity__c);
        }
        Map<Id,Opportunity> opps = new Map<Id,Opportunity>([select Id, Account_Name__c, Test__c from Opportunity where Id IN :opportunityIds]);

        String year = System.now().date().year().format().replace('.', '');
        Integer i = 0;
        for (Invoice__c invoice : invoices) {
            if (invoice.Number__c == null) {
                Opportunity opportunity = opps.get(invoice.Opportunity__c);
                Logger.debug('Opp: ' + opportunity);
                if (opportunity.Test__c == false) {
                    i++;
                }

                Integer VhCount = oldVhInvoicesCount + i;
                Integer VrCount = oldVrInvoicesCount + i;

                if (opportunity.Test__c == true) {
                    invoice.Number__c = year + VrCount.format().replace('.', '').leftPad(6, '0') + '/Test';
                    Logger.debug('Invoices :: setNumber1 :: invoice.Number__c: ' + invoice.Number__c);
                } else if (Opportunities.isVH24(opportunity, false)) {
                    invoice.Number__c = year + VhCount.format().replace('.', '').leftPad(6, '0') + '/IVH';
                    Logger.debug('Invoices :: setNumber2 :: invoice.Number__c: ' + invoice.Number__c);
                } else if (Opportunities.isVR24(opportunity, false)) {
                    invoice.Number__c = year + VrCount.format().replace('.', '').leftPad(6, '0') + '/IVR';
                    Logger.debug('Invoices :: setNumber3 :: invoice.Number__c: ' + invoice.Number__c);
                }
            }
        }
        
        Logger.debug('<< Invoices :: setNumber');
    }
    
	public static void uploadToDropbox(Invoice__c[] invoices, Map<Id,Invoice__c> oldInvoices) {
        List<Id>relatedInvoiceIds = new List<Id>();

        for (Invoice__c invoice : invoices){
            if ((invoice.Stage__c != oldInvoices.get(invoice.Id).Stage__c) && (invoice.Stage__c == 'Sent') && (invoice.Uploaded_To_Dropbox__c == false)){
                relatedInvoiceIds.add(invoice.Id);
            }
        }

        if (relatedInvoiceIds.isEmpty() == false){

            Map<Id, String> paths = new Map<Id, String>{
                    Accounts.VR24ID => '/Accounting/DATEV/VR24/',
                    Accounts.VH24ID => '/Accounting/DATEV/VH24/'
            };

            List<Invoice__c> relatedInvoices = [select Id,Opportunity__r.Account_Id__c,Opportunity__r.Test__c,Date__c from Invoice__c where Id IN :relatedInvoiceIds];
            List<Attachment> attachments = [select Id,ParentId from Attachment where ParentId IN :invoices];

            for (Invoice__c invoice : relatedInvoices){
                for (Attachment attachment : attachments){
                    if (attachment.ParentId == invoice.Id){
                        Date folderDate;
                        if (invoice.Date__c == null) {
                            folderDate = System.now().date();
                        } else {
                            folderDate = invoice.Date__c;
                        }
                        String path;
                        if ((paths.containsKey(invoice.Opportunity__r.Account_Id__c)) && (invoice.Opportunity__r.Test__c == false)) {
                            path = paths.get(invoice.Opportunity__r.Account_Id__c) + folderDate.year() + '/' + folderDate.month() + '/';
                        } else {
                            path = '/Technik/Testdaten/Invoices/' + folderDate.year() + '/' + folderDate.month() + '/';
                        }
                        IntegrateDropbox.uploadFileToDropboxAsync(path, attachment.Id,invoice.Opportunity__r.Account_Id__c);
                    }
                }
            }
        }
	}
}