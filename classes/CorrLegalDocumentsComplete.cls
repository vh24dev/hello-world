public class CorrLegalDocumentsComplete {
    private final Correspondence__c corr;
    public boolean errorClaim {get; set;}
    public boolean errorLegal {get; set;}

    public CorrLegalDocumentsComplete(ApexPages.StandardController stdCtl) {
        errorClaim = false;
        errorLegal = false;
        this.corr = [
            SELECT Id, Claim__r.Legal__c, Claim__r.Legal__r.isActive, Claim__r.Opportunity__r.Assignment_Type__c, Claim__r.Cover_Note_Scope__c, Claim__r.Opportunity__c,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks)
            FROM Correspondence__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;
		Correspondence__c newCorrespondence;
        /*
        // claim is mandatory for inserting
        if (this.corr.Claim__r == null) {
            errorClaim = true;
            return null;
        }
		*/
        if (this.corr.Claim__r.Legal__r == null) {
            errorLegal = true;
            return null;
        }

		// Close task
		update Tasks.markAsClosed('Klagedokumente prüfen', this.corr);

		// Create task & correspondence
		if ((this.corr.Claim__r.Opportunity__r.Assignment_Type__c == 'RSV') && ((this.corr.Claim__r.Cover_Note_Scope__c == null) || (this.corr.Claim__r.Cover_Note_Scope__c.contains('Judicial') == false))) {
			newCorrespondence = Correspondences.build(this.corr.Claim__r, 'Legal Protection Insurance', 'Deckungsanfrage für Klage', 'Draft', null);
			if (newCorrespondence != null) {
				insert newCorrespondence;
			}
		} else {
			Task task = Tasks.build('Klageschrift versenden', null, this.corr, this.corr.Claim__r.Legal__r, System.today(), true, false, this.corr.claim__r.Opportunity__c);
			if (task != null) {
				insert task;
			}
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}