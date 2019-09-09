// Korrespondenz "Widerspruch" Button
// Correspondence__c "Widerspruch" Button
public class CorrLegalOpposition {
    private final Correspondence__c corr;
    private final Claim__c claim;
    private final Opportunity opp;
    public boolean errorClerk {get; set;}

    public CorrLegalOpposition(ApexPages.StandardController stdCtl) {
        errorClerk = false;
        this.corr = [
            SELECT Id, Claim__r.Legal__c, Claim__r.Legal__r.isActive, Claim__r.Clerk__c, Claim__r.Clerk__r.isActive,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks)
            FROM Correspondence__c
            WHERE ID = :stdCtl.getId()
        ];
        this.claim = [
            SELECT Id, Opportunity__c
            FROM claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        this.opp = [
            SELECT Id,
            Insurance__c,
            Insurance__r.External_Id__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;
        if (this.opp.Insurance__r == null) {
            return Errors.page('Es muss eine Versicherung auf der Anfrage vorhanden sein.');
        }
        if (this.opp.Insurance__r.External_Id__c != 'lv004') {
            return Errors.page('Diese Aktion kann nur mit der Versicherung "Clerical Medical Investment Group Limited" ausgeführt werden.');
        }
        if (this.corr.Claim__r.Clerk__r == null) {
            errorClerk = true;
            return null;
        }

		update Utilities.closeTasks('Widerspruchsart prüfen', this.corr);
		Task task = Utilities.createTask('Widerspruchsschreiben versenden', null, this.corr, this.corr.Claim__r.Clerk__r, System.today(), true, false);

		if (task != null) {
			insert task;
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}