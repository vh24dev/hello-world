// Claim "Deckungszusage dokumentieren" Button
// Fall "Deckungszusage dokumentieren" Button
public class SetClaimCoverNote {
    private final Claim__c claim;
    private final Opportunity opp;
    public string parDescription {get; set;}
    public Opportunity parOpportunity {get; set;}
    public Claim__c parClaim {get; set;}
    public boolean renderKlage {get; set;}

    public SetClaimCoverNote(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT Id,
            Result__c,
            Cover_Note_Scope__c,
            Opportunity__c,
            Opportunity__r.Contact__c,
            Stage__c,
            Cover_Note__c,
            Reason_For_Cover_Note_Refusal__c,
            Legal_Protection_Insurance_Case_Number__c,
            Response_Legal_Opposition__c,
            Response_Claim_Letter__c,
            (SELECT Id, Description__c, Type__c FROM Correspondencies__r),
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id,
            Account_Id__c,
            Assignment_Type__c,
            RecordTypeId,
            Vehicle_Brand__c,
            Legal_Protection_Deductible__c,
            Engine_Type__c,
            Has_Legal_Protection_Insurance__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
        this.parOpportunity = [
            SELECT Id, Legal_Protection_Deductible__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
        this.parClaim = [
            SELECT Id,
            Response_Lawsuit__c,
            Result__c,
            Cover_Note_Scope__c,
            Opportunity__c,
            Opportunity__r.Contact__c,
            Stage__c,
            Cover_Note__c,
            Reason_For_Cover_Note_Refusal__c,
            Legal_Protection_Insurance_Case_Number__c,
            Response_Legal_Opposition__c,
            Response_Claim_Letter__c
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
        renderKlage = this.claim.Stage__c == 'Lawsuit';
    }

    public PageReference renderPage() {
        Savepoint sp = Database.setSavepoint();
        PageReference pageRef;
        List<Contract__c> contracts = [
            SELECT Id
            FROM Contract__c
            WHERE Opportunity__c = :this.claim.Opportunity__c
        ];

        String claimStage = claim.Stage__c;
        List<Task> updateTasks = new List<Task>();

        updateTasks.addAll(Tasks.markAsClosed('Deckungszusage', this.claim));
        for (Correspondence__c correspondence : [SELECT Id, Type__c, (SELECT Id, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Id IN :this.claim.Correspondencies__r]){
            if (correspondence.Type__c.contains('Deckungsanfrage')){
                updateTasks.addAll(Tasks.markAsClosed('Wiedervorlage',correspondence));
            }
        }
        update updateTasks;

        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId) && (this.opp.Assignment_Type__c != 'RSV') && (this.opp.Engine_Type__c == 'EA189')) {
            String errorSubject = 'Fehler bei Übergabe des Prozesses.';
            String errorMessage = 'Anfragen ohne Rechtsschutzversicherung und Motortyp EA189 können nicht an Anwalt oder Finanzierungsprozess übergeben werden.';
            pageRef = Errors.page(errorSubject, errorMessage);
            pageRef.setRedirect(true);
            return pageRef;
        }
        updateStage();

        // set deckunszusage
        if (this.claim.Cover_Note__c != parClaim.Cover_Note__c) {
            this.claim.Cover_Note__c = parClaim.Cover_Note__c;
        }

        // set deckungsumfang
        if ((this.claim.Cover_Note_Scope__c != parClaim.Cover_Note_Scope__c) && (parClaim.Cover_Note_Scope__c != null)) {
            addToCoverNote(parClaim.Cover_Note_Scope__c);
        }

        // set absagegrund
        if (this.claim.Reason_For_Cover_Note_Refusal__c != parClaim.Reason_For_Cover_Note_Refusal__c) {
            this.claim.Reason_For_Cover_Note_Refusal__c = parClaim.Reason_For_Cover_Note_Refusal__c;
        }

        // set date
        if (claimStage == 'Claim Letter') {
            this.claim.Response_Insurance_Claim_Letter__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Legal Opposition') {
            this.claim.Response_Insurance_Legal_Opposition__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Lawsuit') {
            this.claim.Response_Insurance_Lawsuit__c = parClaim.Response_Lawsuit__c;
        } else if (claimStage == 'Appeal') {
            this.claim.Response_Insurance_Appeal__c = parClaim.Response_Lawsuit__c;
        }

        // set selbstbehalt
        if ((parOpportunity.Legal_Protection_Deductible__c != null) && (this.opp.Legal_Protection_Deductible__c != parOpportunity.Legal_Protection_Deductible__c)) {
            this.opp.Legal_Protection_Deductible__c = parOpportunity.Legal_Protection_Deductible__c;
        }

        // set schadensnummer
        if ((parClaim.Legal_Protection_Insurance_Case_Number__c != null) && (this.claim.Legal_Protection_Insurance_Case_Number__c != parClaim.Legal_Protection_Insurance_Case_Number__c)) {
            this.claim.Legal_Protection_Insurance_Case_Number__c = parClaim.Legal_Protection_Insurance_Case_Number__c;
        }

        if (this.opp.Assignment_Type__c == 'Share' && this.opp.Has_Legal_Protection_Insurance__c) {
            Database.rollback(sp);
            return Errors.page('Der Auftragstyp kann nicht "Share" sein, wenn eine Rechtsschutzversicherung vorhanden ist.');
        }
        update this.opp; // Important to update this first
        update this.claim;

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void addToCoverNote(string note) {
        if ((this.claim.Cover_Note_Scope__c == null) || (this.claim.Cover_Note_Scope__c.contains(note) == false)) {
            if (this.claim.Cover_Note_Scope__c != null) {
                this.claim.Cover_Note_Scope__c = this.claim.Cover_Note_Scope__c + ';';
            } else {
                this.claim.Cover_Note_Scope__c = '';
            }
            this.claim.Cover_Note_Scope__c = this.claim.Cover_Note_Scope__c + note;
        }
    }

    public void updateStage() {
        if (this.parClaim.Cover_Note__c == 'Refused') {
            // Auftragstyp auf Opp ebene soll nicht geändert werden
            // (kommentar https://trello.com/c/ITiiWvCQ/186-claim-deckungszusage-dokumentieren-button)
            // E Osahon Mar 6 at 5:26 PM
            // der Auftragstyp soll nicht auf "Share" geändert werden, wenn Ergebnis = "Abgelehnt"
            /*
            if (this.claim.Result__c != 'Declined') {
                this.opp.Assignment_Type__c = 'Share';
            }
			*/
            // Utilities.claimActionAfterUpdateRun = 1;    // to avoid automatic correspondence creation
            // update this.opp; // had to be commented out due to validation errors that get catched at the end

            if ((this.claim.Result__c == 'Declined') || (this.claim.Result__c == 'No Response') || (this.claim.Result__c == 'Partial')) {
                this.claim.Stage__c = 'On Hold'; // do it here to not send the Backoffice-Mail
                return;
            }
            if ((this.claim.Result__c == 'Accepted') || (this.claim.Result__c == 'Arrangement')) {
                this.claim.Stage__c = 'Processing';
                System.debug('Claim=' + this.claim.Id + ' Stage=' + this.claim.Stage__c); // TODO: cover this by tests one day
                return;
            }
        }
        if (this.parClaim.Cover_Note__c != 'Issued') {
            return;
        }
        if (this.claim.Stage__c == 'Claim Letter') {
            if (this.claim.Response_Claim_Letter__c != null) {
                if ((this.claim.Result__c == 'Declined') || (this.claim.Result__c == 'No Response') || (this.claim.Result__c == 'Partial')) {
                    this.claim.Stage__c = 'Lawsuit';
                    return;
                }
                if ((this.claim.Result__c == 'Accepted') || (this.claim.Result__c == 'Arrangement')) {
                    this.claim.Stage__c = 'Processing';
                    return;
                }
            }
        }
        if (this.claim.Stage__c == 'Legal Opposition') {
            if (this.claim.Response_Legal_Opposition__c != null) {
                if ((this.claim.Result__c == 'Declined') || (claim.Result__c == 'No Response') || (claim.Result__c == 'Partial')) {
                    this.claim.Stage__c = 'Lawsuit';
                } else if ((claim.Result__c == 'Accepted') || (claim.Result__c == 'Arrangement')) {
                    this.claim.Stage__c = 'Processing';
                }
            }
        }
        if (this.claim.Stage__c == 'Lawsuit') {
            Correspondence__c correspondence;
            correspondence = Correspondences.build(this.claim, 'Court', 'Klageschrift', 'Draft', null);
            if (correspondence != null) {
                insert correspondence;
            }
            addToCoverNote('Judicial');
            return;
        }
        if (this.claim.Stage__c == 'Appeal') {
            Correspondence__c correspondence;
            correspondence = Correspondences.build(this.claim, 'Court', 'Replik', 'Draft', null);
            if (correspondence != null) {
                insert correspondence;
            }
            addToCoverNote('Appeal');
        }
    }
}