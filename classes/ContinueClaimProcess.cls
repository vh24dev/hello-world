// Fall "Prozess weiterführen" Button
// Claim__c "Prozess weiterführen" Button
public class ContinueClaimProcess {
    private final Claim__c claim;

    public ContinueClaimProcess(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT Id,
            Stage__c,
            Result__c,
            Legal__c,
            Legal__r.isActive,
            Opportunity__r.RecordTypeId,
            Opportunity__r.Assignment_Type__c,
            Opportunity__r.Backoffice__c,
            Opportunity__r.Backoffice__r.isActive,
            (SELECT Id, Type__c, Stage__c, Description__c FROM Correspondencies__r WHERE Stage__c != 'Canceled'),
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public void updateStage() {
        if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000W0CY
            // DG
            if ((claim.Result__c == 'Declined') || (claim.Result__c == 'Partial')) {
                if (claim.Stage__c == 'Claim Letter') {
                    claim.Stage__c = 'Lawsuit';
                } else if (claim.Stage__c == 'Lawsuit') {
                    claim.Stage__c = 'Appeal';
                } else if (claim.Stage__c == 'Appeal') {
                    claim.Stage__c = 'Processing';
                }
                return;
            }
            claim.Stage__c = 'Processing';
            return;
        }
        // LV
        if ((claim.Result__c == 'Declined') || (claim.Result__c == 'Partial')) {
            if (claim.Stage__c == 'Customers Opposition') {
                claim.Stage__c = 'Legal Opposition';
            } else if (claim.Stage__c == 'Legal Opposition') {
                Boolean legalOppositionExisting = false;
                String legalOppositionStage;
                for (Correspondence__c correspondence : claim.Correspondencies__r) {
                    if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                        legalOppositionExisting = true;
                        legalOppositionStage = correspondence.Stage__c;
                    }
                }
                if (legalOppositionExisting == true) {
                    if (legalOppositionStage != 'Draft') {
                        claim.Stage__c = 'Lawsuit';
                        return;
                    }
                    update Tasks.markAsClosed('Weiterführung entscheiden', claim);
                    return;
                }
                Correspondence__c correspondence = correspondences.build(claim, 'Insurance', 'Widerspruch durch Anwalt', 'Draft', null);
                if (correspondence != null) {
                    insert correspondence;
                }
                update Tasks.markAsClosed('Weiterführung entscheiden', claim);
            } else if (claim.Stage__c == 'Lawsuit') {
                Boolean complaintExisting = false;
                String complaintStage;
                for (Correspondence__c correspondence : claim.Correspondencies__r) {
                    if (correspondence.Type__c == 'Klageschrift') {
                        complaintExisting = true;
                        complaintStage = correspondence.Stage__c;
                    }
                }
                if (complaintExisting == true) {
                    if (complaintStage != 'Draft') {
                        claim.Stage__c = 'Processing';
                        return;
                    }
                    update Tasks.markAsClosed('Weiterführung entscheiden', claim);
                    return;
                }
                Correspondence__c correspondence = correspondences.build(claim, 'Court', 'Klageschrift', 'Draft', null);
                if (correspondence != null) {
                    insert correspondence;
                }
                update Tasks.markAsClosed('Weiterführung entscheiden', claim);
            } else if (claim.Stage__c == 'Appeal') {
                Boolean complaintExisting = false;
                String complaintStage;
                for (Correspondence__c correspondence : claim.Correspondencies__r) {
                    if (correspondence.Type__c == 'Replik') {
                        complaintExisting = true;
                        if ((complaintExisting == false) || (correspondence.Stage__c == 'Draft')) {
                            complaintStage = correspondence.Stage__c;
                        }
                    }
                }
                if (complaintExisting == true) {
                    if (complaintStage != 'Draft') {
                        claim.Stage__c = 'Processing';
                        return;
                    }
                    update Tasks.markAsClosed('Weiterführung entscheiden', claim);
                    return;
                }
                Correspondence__c correspondence = correspondences.build(claim, 'Court', 'Replik', 'Draft', null);
                if (correspondence != null) {
                    insert correspondence;
                }
                update Tasks.markAsClosed('Weiterführung entscheiden', claim);
            }
            return;
        }
        claim.Stage__c = 'Processing';
    }

    public PageReference renderPage() {
        PageReference pageRef;
        if (this.claim.Legal__r.isActive == false) {
			return Errors.page('Bitte setzten Sie den Anwalt auf aktiv');
        }

        updateStage();
        update claim;

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}