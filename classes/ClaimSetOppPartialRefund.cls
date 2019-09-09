// Fall "Teilerstattungsbetrag hinterlegen" Button
// Claim__c "Teilerstattungsbetrag hinterlegen" Button
public class ClaimSetOppPartialRefund {
    private final Claim__c claim;
    private final Opportunity opp;
    public Opportunity parOpportunity {get; set;}

    public ClaimSetOppPartialRefund(ApexPages.StandardController stdCtl) {
        parOpportunity = new Opportunity();
        this.claim = [
            SELECT Id, Opportunity__c,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id, Contact__c, AccountId
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;

		this.opp.Partial_Refund__c = parOpportunity.Partial_Refund__c;
		update this.opp;
		update Tasks.markAsClosed('Teilerstattungsbetrag', this.claim);

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}