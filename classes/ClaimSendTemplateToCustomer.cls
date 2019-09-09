// Claim__c "Vorlage an Kunden versenden" Button
// Fall "Vorlage an Kunden versenden" Button
public class ClaimSendTemplateToCustomer {
    private final Claim__c claim;
    private final Opportunity opp;
    private string errorMessage = null;
    
    public ClaimSendTemplateToCustomer(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT ID,
            Opportunity__c,
            RecordTypeId,
            Clerk__c,
            Clerk__r.Id,
            Clerk__r.isActive
            FROM Claim__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT ID,
            Priority_Level__c,
            RecordTypeId,
            Insurance_Status__c
            FROM Opportunity
            WHERE ID = :this.claim.Opportunity__c
        ];
        
        
    }
    public string getErrorMessage() {
        return this.errorMessage;
    }

    public PageReference renderPage() {
        if (!Claims.isLebensversicherung(this.claim.RecordTypeId)) {
            this.errorMessage = 'Die Sparte muss Lebensversicherung sein!';
            return null;
        }
        
        if (this.opp.Priority_Level__c != 'III') {
            this.errorMessage = 'Die Anfrage muss die Prioritätsstufe III haben';
            return null;
        }
        
        if (this.opp.Insurance_Status__c != 'noch aktiv' && this.opp.Insurance_Status__c != 'beitragsfrei gestellt') {
			this.errorMessage = 'Der Versicherungsstatus muss "noch aktiv" oder "beitragsfrei gestellt" sein.';            
            return null;
        }
        
        if (this.claim.Clerk__c == null) {
            this.errorMessage = 'Es muss ein Sachbearbeiter auf dem Fall hinterlegt sein!';
            return null;
        }
        
        Correspondence__c cr = Correspondences.build(this.claim, 'Insurance', 'Widerspruch durch Kunden', 'Draft', null);
        if (cr != null) {
            insert cr;
        }
        
        /*
        // created by process or trigger already so reacreating it is useless since no duplicates will always filter it
        Task t = Tasks.build(
            'Widerspruchsvorlage an Kunden versenden', // subject
            null, // description
            cr, // parentObj
            this.claim.Clerk__r, // owner
            System.today(), // activityDate
            true, // noDuplicates
            false // isFollowUpTask
		);
        if (t != null) {
            t.Status = 'Open';
            t.Priority = 'Normal';
            insert t;
        }
		*/
        return Page.SuccessPage;
    }
}