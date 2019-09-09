// Claim__c "Ergebnis dokumentieren" Button
// Fall "Ergebnis dokumentieren" Button
public class SetClaimResult {
    private final Claim__c claim;
    public Claim__c parClaim {get; set;}
    List<Task> updateTasks;
    List<Task> insertTasks;

    public SetClaimResult(ApexPages.StandardController stdCtl) {
        updateTasks = new List<Task>();
        insertTasks = new List<Task>();
        parClaim = new Claim__c();
        parClaim.Response_Lawsuit__c = System.today();
		parClaim.Result__c = 'Accepted';
        this.claim = [
            SELECT Id, Cover_Note__c, Stage__c, Result__c, Response_Insurance_Legal_Opposition__c,
            Opportunity__r.RecordTypeId, Opportunity__r.Account_Id__c, Opportunity__r.Product__c,
            Opportunity__r.Vehicle_Brand__c, Opportunity__r.Contact__c, Opportunity__r.Assignment_Type__c,
            Opportunity__r.Backoffice__c, Opportunity__r.Backoffice__r.isActive,
            Clerk__c, Clerk__r.isActive,
            Legal__c, Legal__r.isActive,
            Opportunity__c,
            (SELECT Id, Type__c, Description__c FROM Correspondencies__r),
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public List<SelectOption> getResults() { // Result__c
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Accepted', 'Angenommen'));
        options.add(new SelectOption('Declined', 'Abgelehnt'));
        options.add(new SelectOption('Arrangement', 'Vergleich'));
        options.add(new SelectOption('No Response', 'Keine Antwort'));
        return options;
    }

    public List<SelectOption> getAppeal() { // Cover_Note_Scope__c
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Appeal', 'Berufung'));
        options.add(new SelectOption('Without Appeal', 'Ohne Berufung'));
        return options;
    }

    public List<SelectOption> getAccepted() { // Arrangement__c
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Accepted', 'Angenommen'));
        options.add(new SelectOption('Declined', 'Abgelehnt'));
        return options;
    }

    public PageReference renderPage() {
        PageReference pageRef;

        if (claim.Opportunity__r.Backoffice__r.isActive == false) {
            return Errors.page('Bitte hinterlegen Sie einen aktiven Backoffice User.');
        }
        if (this.claim.Clerk__c != null && this.claim.Clerk__r.isActive == false) {
            return Errors.page('Bitte hinterlegen Sie einen aktiven Sachbearbeiter.');
        }
        if (this.claim.Legal__c != null && this.claim.Legal__r.isActive == false) {
            return Errors.page('Bitte hinterlegen Sie einen aktiven Anwalt.');
        }

        String claimStage = claim.Stage__c;
        this.claim.Cover_Note_Scope__c = parClaim.Cover_Note_Scope__c;
        this.claim.Arrangement__c = parClaim.Arrangement__c;

        List<Task> newTasks = new List<Task>();

        // Tasks schließen
        updateTasks.addAll(Tasks.markAsClosed('Ergebnis',claim));
        for (Correspondence__c correspondence : [SELECT Id, Type__c, (SELECT Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id IN :claim.Correspondencies__r]) {
            if (!correspondence.Type__c.contains('Deckungsanfrage')) {
                updateTasks.addAll(Tasks.markAsClosed('Wiedervorlage', correspondence));
            }
        }

        // continue process
        if ((parClaim.Result__c == 'Declined') || (parClaim.Result__c == 'No Response') || (parClaim.Result__c == 'Partial')) {
            if (claim.Stage__c == 'Customers Opposition') {
                System.debug('opp ass tyoer: ' + claim.Opportunity__r.Assignment_Type__c);
                if (claim.Opportunity__r.Assignment_Type__c != 'Share') {
                    claim.Stage__c = 'Legal Opposition';
                } else {
                    insertTasks.add(Tasks.build('Weiterführung entscheiden', null, claim, claim.Opportunity__r.Backoffice__r, System.today(), false, false, claim.opportunity__c));
                }
                // Tasks auf Ebene der Korrespondenz schließen
                for (Correspondence__c correspondence : [SELECT Id, Type__c, (SELECT Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id IN :claim.Correspondencies__r]) {
                    if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                        updateTasks.addAll(Tasks.markAsClosed('Unterschriebenen Widerspruch hochladen und',correspondence));
                    }
                }
            } else if (claim.Stage__c == 'Legal Opposition') {
                if (claim.Opportunity__r.Assignment_Type__c != 'Share') {
                    if (claim.Response_Insurance_Legal_Opposition__c != null) {
                        if (claim.Cover_Note__c == 'Refused') {
                            claim.Stage__c = 'On Hold';
                        } else if (claim.Cover_Note__c == 'Issued') {
                            claim.Stage__c = 'Lawsuit';
                        }
                    }
                } else {
                    insertTasks.add(Tasks.build('Weiterführung entscheiden', null, claim, claim.Opportunity__r.Backoffice__r, System.today(), false, false, claim.opportunity__c));
                }
            } else if (claim.Stage__c == 'Claim Letter') {
                if (claim.Cover_Note__c == 'Refused') {
                    claim.Stage__c = 'On Hold';
                } else if (claim.Cover_Note__c == 'Issued') {
                    claim.Stage__c = 'Lawsuit';
                } else if (claim.Opportunity__r.Assignment_Type__c == 'Share') {
                    claim.Stage__c = 'On Hold';
                }
            } else if (claim.Stage__c == 'Lawsuit') {
                if (claim.Cover_Note__c == 'Refused') {
                    claim.Stage__c = 'On Hold';
                } else if (claim.Cover_Note__c == 'Issued') {
                    claim.Stage__c = 'Appeal';
                } else if (claim.Opportunity__r.Assignment_Type__c == 'Share') {
                    claim.Stage__c = 'On Hold';
                }
            } else if (claim.Stage__c == 'Appeal') {
                claim.Stage__c = 'Processing';
            }
        } else if ((parClaim.Result__c == 'Accepted') || (parClaim.Result__c == 'Arrangement')) {
            if ((parClaim.Cover_Note__c != null) || (parClaim.Stage__c != 'Claim Letter')) {
                claim.Stage__c = 'Processing';
            }
        }

        // Korrespondenz erstellen
        if ((claim.Opportunity__r.Product__c == 'Lebensversicherung') && ((parClaim.Result__c == 'Partial') || (parClaim.Result__c == 'Accepted') || (parClaim.Result__c == 'Arrangement'))) {
            Correspondence__c correspondence;
            if (claimStage == 'Customers Opposition') {
                correspondence = correspondences.build(claim, 'Insurance', 'Sonstiges', 'Draft', 'SonstigesUebermittlungBankverbindungKundenwiderspruch');
            } else {
                correspondence = correspondences.build(claim, 'Insurance', 'Sonstiges', 'Draft', 'SonstigesUebermittlungBankverbindungAnwaltswiderspruch');
            }
            if (correspondence != null) {
                correspondence.Description__c = 'Mitteilung Bankdaten an VS';
                insert correspondence;
            }
        }

        // Ergebnis setzen
        if (claim.Result__c != parClaim.Result__c) {
            claim.Result__c = parClaim.Result__c;
        }

        // Datum setzen
        if (claimStage == 'Customers Opposition') {
            claim.Response_Customer_Opposition__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Claim Letter') {
            claim.Response_Claim_Letter__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Legal Opposition') {
            claim.Response_Legal_Opposition__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Lawsuit') {
            claim.Response_Lawsuit__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Appeal') {
            claim.Response_Appeal__c = parClaim.Response_Lawsuit__c;
        }

        update claim;
        update claim.Opportunity__r;

        if (updateTasks.size() > 0) {
            update updateTasks;
        }

        for (Task task : insertTasks) {
            if (task != null) {
                newTasks.add(task);
            }
        }

        if (newTasks.size() > 0) {
            insert newTasks;
        }

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}