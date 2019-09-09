public class ClaimInvoices {
    private static List<Invoice__c> addInvoices(List<Invoice__c> insertInvoices, Claim__c c, Opportunity o) {
        if (c.Refund__c == 0) {
            return insertInvoices;
        }
        if (Claims.isDieselskandal(c.RecordTypeId)) {
            // RSV vorhanden
            if (o.Has_Legal_Protection_Insurance__c == true) {
                Invoice__c i = Invoices.build(c, o);
                if (i != null) {
                    insertInvoices.add(i);
                }
            }
        } else if (Claims.isFinanzierung(c.RecordTypeId)) {
            // RSV vorhanden
            if (o.Has_Legal_Protection_Insurance__c == true) {
                Invoice__c i = Invoices.build(c, o);
                if (i != null) {
                    insertInvoices.add(i);
                }
            }
        } else if (Claims.isLebensversicherung(c.RecordTypeId)) {
            Invoice__c i = Invoices.build(c, o);
            if (i != null) {
                insertInvoices.add(i);
            }
        }
        return insertInvoices;
    }

    public static List<Invoice__c> create(Claim__c[] cc) {
        List<Invoice__c> insertInvoices = new List<Invoice__c>();

        cc = [
            SELECT ID,
            Result__c,
            Refund__c,
            Stage__c,
            Cover_Note_Scope__c,
            Arrangement__c,
            RecordTypeId,
            Opportunity__c
            FROM Claim__c
            WHERE ID IN :cc
        ];

        List<Id> oppIds = new List<Id>();
        for (Claim__c c : cc) {
            oppIds.add(c.Opportunity__c);
        }

        Map<Id, Opportunity> oo = new Map<Id, Opportunity>([
            SELECT ID,
            Has_Legal_Protection_Insurance__c,
            Process_Type__c,
            RecordTypeId,
            Refund__c,
            (SELECT ID FROM Invoices__r)
            FROM Opportunity
            WHERE ID IN :oppIds
        ]);

        for (Claim__c c : cc) {
            Opportunity o = oo.get(c.Opportunity__c);
            if (
                c.Result__c == 'Arrangement' &&
                c.Arrangement__c == 'Accepted' &&
                c.Stage__c == 'Finished'
            ) {
                // Vergleich - angenommen:
                addInvoices(insertInvoices, c, o);
            } else if (
                (
                    c.Result__c == 'Accepted' ||
                    c.Result__c == 'Partially won'
                ) &&
                c.Stage__c == 'Finished' &&
                c.Cover_Note_Scope__c == 'Without Appeal'
            ) {
                // Angenommen ohne Berufung:
                addInvoices(insertInvoices, c, o);
            } else if (
                c.Result__c == 'Declined' &&
                c.Stage__c == 'Finished' &&
                c.Cover_Note_Scope__c == 'Without Appeal'
            ) {
                // Abgelehnt - ohne Berufung:
                addInvoices(insertInvoices, c, o);
            }
        }
        if (insertInvoices.size() > 0) {
            insert insertInvoices;
        }
        return insertInvoices;
    }
}