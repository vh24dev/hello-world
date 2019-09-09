global class VehicleOwnerController {
    public Opportunity o;

    public PageReference init() {
        this.o = getOpportunity(); 
        
        if (this.o == null) {
            return new PageReference('/notfound');
        } 
        
        return null;
    }

    public List<SelectOption> getConfirmationOptions() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('yes', 'Ja, ich bin noch Eigentümer des Fahrzeuges'));
        options.add(new SelectOption('no', 'Nein, ich bin nicht mehr Eigentümer des Fahrzeuges'));
     
        return options;
    }

    private Opportunity getOpportunity() {
        string oppId = getOppUniqueId();
        if (oppId == null) {
            return null;
        }
        
        List<Opportunity> opps = [
            SELECT Id
            FROM Opportunity
            WHERE Token__c = :oppId
        ];
        
        if (opps.size() == 0) {
            return null;
        }
        
        return opps[0];
    }
    
    private string getOppUniqueId() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}