public class CreateCreditNoteFromCostNote {
    public Credit_Note__c parCreditNote {get; set;}
    public List<CCostNoteLineItem> parCostNoteLineItems {get; set;}
    private final Cost_Note__c note;

    public CreateCreditNoteFromCostNote(ApexPages.StandardController stdCtl) {
        this.note = [
            SELECT Id, Claim__c
            FROM Cost_Note__c
            WHERE Id = :stdCtl.getId()
        ];
        parCreditNote = new Credit_Note__c();
        parCreditNote.Claim__c = note.Claim__c;
        parCostNoteLineItems = new List<CCostNoteLineItem>();

        Cost_Note__c costNote = [select Id,Claim__c,Type__c,Payment_Term__c,(select Id, Description__c, Subject__c, Price__c, Calculate_Vat__c from Cost_Note_Line_Items__r) from Cost_Note__c where Id = :stdCtl.getId()];
        for (Cost_Note_Line_Item__c costNoteLineItem : costNote.Cost_Note_Line_Items__r){
            parCostNoteLineItems.add(new CCostNoteLineItem(costNoteLineItem));
        }
        parCreditNote.Date__c = System.today();
        parCreditNote.Subject__c = 'Gutschrift zu Kostennote mit Typ \"' + costNote.Type__c + '\"';
        parCreditNote.Payment_Term__c = costNote.Payment_Term__c;
        parCreditNote.Claim__c = costNote.Claim__c;
        
    }

    public pageReference renderPage() {
        PageReference pageRef;
        insert parCreditNote;

        List<Credit_Note_Line_Item__c> creditNoteLineItems = new List<Credit_Note_Line_Item__c>();
        for (CCostNoteLineItem costNoteLineItem : parCostNoteLineItems) {
            if (costNoteLineItem.selected == true) {
                Credit_Note_Line_Item__c creditNoteLineItem = new Credit_Note_Line_Item__c(
                    Credit_Note__c = parCreditNote.Id,
                    Description__c = costNoteLineItem.record.Description__c,
                    Subject__c = costNoteLineItem.record.Subject__c,
                    Price__c = costNoteLineItem.record.Price__c,
                    Calculate_Vat__c = costNoteLineItem.record.Calculate_Vat__c
                );
                creditNoteLineItems.add(creditNoteLineItem);
            }
        }
        insert creditNoteLineItems;

        pageRef = new PageReference('/' + parCreditNote.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    // TODO: is this a good place?
    public class CCostNoteLineItem {
        public Cost_Note_Line_Item__c record {get; set;}
        public Boolean selected {get; set;}

        public CCostNoteLineItem(Cost_Note_Line_Item__c record) {
            this.record = record;
            selected = true;
        }
    }
}