public class ClaimCreateStatement {
    private final Claim__c claim;

    public ClaimCreateStatement(ApexPages.StandardController stdCtl) {
        this.claim = [
			select Id, Submission_Date_Before_Claim_Statement__c, Legal__c, Legal__r.isActive
            from Claim__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;

        if (this.claim.Legal__c == null) {
            String errorSubject = 'Fehler!';
            String errorMessage = 'Bitte setzten Sie das Feld Anwalt.';
            pageRef = Errors.page(errorSubject, errorMessage);
            pageRef.setRedirect(true);
            return pageRef;
        }

		Correspondence__c correspondence = Utilities.createCorrespondence(claim, 'Court', 'Klageschrift', 'Draft', null);
		if (correspondence != null) {
			insert correspondence;
		}

		Task task = Utilities.createTask('Klageschrift versenden', null, correspondence, claim.Legal__r, System.today(), true, false);
		if (task != null){
			insert task;
		}

		if (claim.Submission_Date_Before_Claim_Statement__c == null) {
			claim.Submission_Date_Before_Claim_Statement__c = System.today();
			claim.Submitter_Before_Claim_Statement__c = 'System';
			claim.Customer_Is_Owner__c = true;
			update claim;
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}