// Claim "Erstattungsbetrag hinterlegen" Button
public class SetOppRefund {
    private final Opportunity opp;
    public Opportunity parOpportunity {get; set;}

    public SetOppRefund(ApexPages.StandardController stdCtl) {
        parOpportunity = new Opportunity();
        Claim__c claim;
        claim = [
            SELECT Id, Opportunity__c
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];

        this.opp = [
            SELECT Id, Refund__c
            FROM Opportunity
            WHERE Id = :claim.Opportunity__c
        ];
    }

    public pageReference renderPage() {
        PageReference pageRef;
        this.opp.Refund__c = parOpportunity.Refund__c;
        update this.opp;

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}