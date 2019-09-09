public class MembershipConfirmationController {
    public Opportunity opp { get; set; }
    public integer numVal { get; set; }
    public boolean errorToken { get; set; }
    
    public void init() {
        errorToken = !getOpp();
        this.numVal = (integer)this.opp.Current_Mileage__c;
    }
    
    public string getNumber() {
        return this.opp.Number__c;
    }
    
    private string getToken() {
        return ApexPages.currentPage().getParameters().get('token');
    }
    
    private boolean getOpp() {
        string token = getToken();
        
        if (token == null) {
            System.debug('failed on token');
            return false;
        }
        
        List<Opportunity> opps = [
            SELECT Id, Number__c, Current_Mileage__c
            FROM Opportunity
            WHERE Token__c = :token
        ];
        
        if (opps.size() == 0) {
            System.debug('failed on opps');
            return false;
        }
        
        this.opp = opps[0];
        
        return true;
    }
    
     public PageReference confirm() {
        if (errorToken) {
            Logger.error('MembershipConfirmationController :: confirm :: errorToken');
            return new PageReference('/notfound');
        }
/*'
 * 
        if (String.isBlank(selectedOption)) {
            Logger.error('OwnershipConfirmationController :: confirm :: no option has been selected');
            return Errors.page('Bitte eine Angabe machen.');
        }
         */
        this.opp.Current_Mileage__c = (double) this.numVal;
       	this.opp.MFK_Einzelklage__c = true;
        this.opp.MFK_Einzelklage_Timestamp__c = DateTime.now();
         
		update this.opp;
        return new PageReference('/MembershipConfirmed');
    }
}