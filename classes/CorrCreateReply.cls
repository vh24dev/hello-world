public class CorrCreateReply {
    private final Correspondence__c corr;
    public boolean errorAppeal {get; set;}

    public CorrCreateReply(ApexPages.StandardController stdCtl) {
        errorAppeal = false;
        this.corr = [
            SELECT Id, Claim__r.Clerk_Appeal__c, Claim__r.Clerk_Appeal__r.isActive,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks)
            FROM Correspondence__c
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;
        if (this.corr.Claim__r.Clerk_Appeal__r == null) {
            errorAppeal = true;
            return null;
        }

		// Close task
		update Utilities.closeTasks('Replik erstellen', this.corr);

		// Create task
		Task task =  Utilities.createTask('Replik herunterladen und versenden', null, this.corr, this.corr.Claim__r.Clerk_Appeal__r, System.today(), true, false);
		if (task != null){
			insert task;
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}