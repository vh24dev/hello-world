// Anfrage "Mandat zurückgeben" Button
// Opportunity "Mandat zurückgeben" Button
public class SetOpportunityLost {
	private final Opportunity opp;
    private final List<claim__c> claims;
    public Opportunity parOpportunity {get; set;}
    public string errorMsg { get; set; }

    public SetOpportunityLost(ApexPages.StandardController stdCtl) {
        parOpportunity = new Opportunity();
        errorMsg = '';
        this.opp = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
        this.claims = [
            SELECT ID, Clerk__c
            FROM Claim__c
            WHERE Opportunity__c = :opp.id 
        ];
    }

    public PageReference renderPage() {
        for (claim__c cl : claims) {
            if (cl.clerk__c == null) {
                errorMsg = 'einen Sachbearbeiter auf dem Fall (' + cl.id + ') ein.';
            }
        }
        if (errorMsg != '') {
            return null;
        }

        if (this.opp.StageName != 'Lost') {
	        this.opp.StageName = 'Lost';
        }
		this.opp.Reason_For_Loss__c = parOpportunity.Reason_For_Loss__c;
		this.opp.Comment_On_Loss__c = parOpportunity.Comment_On_Loss__c;
        update this.opp;

        PageReference pageRef = new PageReference('/' + this.opp.id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}