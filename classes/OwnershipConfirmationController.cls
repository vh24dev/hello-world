public class OwnershipConfirmationController {
    public Opportunity opp;
    public Claim__c claim;
    public Correspondence__c corr;
    public string selectedOption { get; set; }
    public boolean errorToken {get; set;}

    public string getNumber() {
        return this.opp.Number__c;
    }

    public void init() {
        errorToken = false;
        if (!getObjects()) {
            errorToken = true;
        }
    }

    public List<SelectOption> getConfirmationOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('yes', 'Ja, ich bin noch Eigentümer des Fahrzeuges'));
        options.add(new SelectOption('no', 'Nein, ich bin nicht mehr Eigentümer des Fahrzeuges'));
        return options;
    }

    public PageReference confirm() {
        if (errorToken) {
            Logger.error('OwnershipConfirmationController :: confirm :: errorToken');
            return new PageReference('/notfound');
        }

        if (String.isBlank(selectedOption)) {
            Logger.error('OwnershipConfirmationController :: confirm :: no option has been selected');
            return Errors.page('Bitte eine Angabe machen.');
        }
        
        if (selectedOption == 'Yes') {
            claim.Customer_Is_Owner__c = true;
            claim.Ownership_Request_Date__c = System.today();
            // Submission_Date_Before_Claim_Statement__c
            update claim;
            return new PageReference('/OwnershipConfirmed');
        } // No
        claim.Customer_Is_Not_Owner__c = true;
        update claim;
        return new PageReference('/OwnershipDeclined');
    }

    private boolean getObjects() {
        string token = getClaimToken();
        if (token == null) {
            System.debug('failed on token');
            return false;
        }

        List<Claim__c> claims =  [
            SELECT Id, Customer_Is_Owner__c, Opportunity__c
            FROM Claim__c
            WHERE Token__c = :token
        ];

        if (claims.size() == 0) {
            System.debug('failed on claims');
            return false;
        }

        claim = claims[0];

        List<Opportunity> opps = [
            SELECT Id, Number__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];

        if (opps.size() == 0) {
            System.debug('failed on opps');
            return false;
        }

        opp = opps[0];

        List<Correspondence__c> corrs = [
            SELECT Id, Opportunity_Id__c, Claim__c, Date_Link_Ownership__c
            FROM Correspondence__c
            WHERE Claim__c = :claim.Id
        ];

        if (corrs.size() == 0) {
            System.debug('failed on corrs');
            return false;
        }

        corr = corrs[0];
        return true;
    }

    private string getClaimToken() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}