public class ClaimTasks {
    public static List<Task> create(Claim__c[] cc, Map<ID, Claim__c> oldCc, Boolean isInsertingClaim) {
        cc = [
            SELECT  ID,
            RecordTypeId,
            Result__c,
            Stage__c,
            Cover_Note_Scope__c,
            Lawsuit_Date__c,
            Legal__c,
            Clerk__c,
            Clerk__r.isActive,
            Opportunity__r.Sales_Type__c,
            Response_Insurance_Lawsuit__c,
            Cover_Note__c, Customer_Is_Owner__c,
            Next_Court_Date__c,
            Canceled_Next_Court_Date__c,
            Submission_Date_Before_Claim_Statement__c,
            Submission_Date_Before_Lawsuit_Date__c,
            Legal__r.isActive,
            Opportunity__r.Backoffice__c,
            Opportunity__r.Backoffice__r.isActive,
            Opportunity__r.Assignment_Type__c,
            Opportunity__r.RecordTypeId,
            Opportunity__c,
            (SELECT ID, Status, Subject FROM Tasks) FROM Claim__c WHERE ID IN :cc
        ];
        Correspondence__c[] crr = [
            SELECT ID,
            Claim__c,
            Stage__c,
            Type__c,
            (SELECT ID, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Claim__c IN :cc
        ];

        Task[] tt = new Task[]{};
        for (Claim__c c : cc) {
            // TODO: is this logic correct? We'll create more than one task for some cases.
            Task t;
            if (c.result__c == 'Partial'){
                t = Tasks.build('Teilerstattungsbetrag hinterlegen', null, c, c.legal__r, Date.today(), true, false, c.opportunity__c);
                if (t != null) {
                    tt.add(t);   
                }
            }

            if (
                c.stage__c == 'Lawsuit'
                && !isInsertingClaim
                && c.next_Court_Date__c != null
                && c.next_Court_Date__c != oldCc.get(c.Id).next_Court_Date__c
            ) {
                // change due date from c.next_Court_Date__c to today + 8 weeks:
                // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-38
                t = Tasks.build('Ergebnis der Klage dokumentieren', null, c, c.legal__r, System.today().addMonths(2), true, false, c.opportunity__c);
                if (t != null) {
                    tt.add(t);
                }
                // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-58
                t = Tasks.build('Mandanteninfo versenden', null, c, c.legal__r, System.today(), true, false, c.opportunity__c);
                if (t != null) {
                    tt.add(t);
                }
                //continue; // continue?
            }

            if (c.stage__c == 'Processing') {
                String subj = c.result__c == 'Declined' ? 'Als abgeschlossen markieren' : 'Erstattungsbetrag hinterlegen und als abgeschlossen markieren';
                t = Tasks.build(subj, null, c, c.legal__r, Date.today(), true, false, c.opportunity__c);
                if (t != null) {
                    tt.add(t);   
                }
                continue;
            }

            if (c.stage__c == 'Lawsuit') {
                if (c.canceled_Next_Court_Date__c && c.customer_Is_Owner__c) {
                    t = Tasks.build('Neuen Gerichtstermin vereinbaren', null, c, c.legal__r, Date.today(), true, false, c.opportunity__c);
                    if (t != null) {
                        tt.add(t);   
                    }
                }

                // TODO: use a map instead
                for (Correspondence__c cr : crr) {
                    if (cr.claim__c != c.Id) {
                        continue;
                    }
                    
                    // https://trello.com/c/ETZVnWjM/490-lv-korrespondenz-klageschrift-task-klageschrift-versenden
                    if (cr.type__c == 'Klageschrift'
                        && c.Legal__c != null
                        && c.cover_Note__c != null && c.Cover_Note__c != ''
                        && c.cover_Note_Scope__c != null && c.Cover_Note_Scope__c != '') {
                        t = Tasks.build('Klageschrift versenden', null, cr, c.legal__r, Date.today(), true, false, c.opportunity__c);
                        if (t != null) {
                            tt.add(t);
                        }
                    }

                    // https://trello.com/c/A7wrn6xK/492-dg-task-klagedokumente-pr%C3%BCfen
                    if (Claims.isDieselskandal(c.RecordTypeId)
                        && oldCc.get(c.Id).Customer_Is_Owner__c != true
                        && c.Customer_Is_Owner__c == true
                        && cr.Type__c == 'Klageschrift'
                        && c.Clerk__c != null) {
						t = Tasks.build('Klagedokumente prüfen', null, cr, c.Clerk__r, Date.today(), true, false, c.opportunity__c);
                        if (t != null) {
                            tt.add(t);
                        }
                    }

                    if (!Claims.isDieselskandal(c.RecordTypeId)
                        && c.lawsuit_Date__c == null
                        && cr.type__c == 'Klageschrift'
                        && c.submission_Date_Before_Claim_Statement__c != null) { // && c.customer_Is_Owner__c // removed by https://trello.com/c/k9Ma3b9u/438-lv-claim-korrespondent-klageschrift
                        t = Tasks.build('Klagedokumente prüfen', null, cr, c.clerk__r, Date.today(), true, false, c.opportunity__c);
                        if (t != null) {
                            tt.add(t);
                        }
                    }
                }
            }
        }

        if (tt.size() > 0) {
            insert tt;
        }
        return tt;
    }
}