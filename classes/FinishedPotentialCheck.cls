public class FinishedPotentialCheck {
    private final Opportunity opp;

    public FinishedPotentialCheck(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id, Sales_Type__c, AccountId, Contact__c, Backoffice__c,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks)
            FROM Opportunity
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;

		// Close task
		update Utilities.closeTasks('Potential prüfen', this.opp);

		// Create task
		User user = [SELECT Id, isActive FROM User WHERE Id = :Users.potentialCheck()]; // 0050Y000001hhIp Stefanie Hoffmann (Sachberater) in old org, now please to Martin Braun
		Task task = Utilities.createTask('Potential auslösen', null, this.opp, user, System.today(), true, false);
		if (task != null){
			insert task;
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}