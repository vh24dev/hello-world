public class AbmeldenController {
    private Opportunity o;
    private Lead l;
    private boolean isLead;
    public string signedOut {get; set;}

    public List<SelectOption> getYN() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes', 'Ja'));
        options.add(new SelectOption('No', 'Nein'));
        return options;
    }

    public PageReference init() { 
        this.o = getOpp();
        this.l = getLead();
        isLead = false;

        if (this.o == null) {
            isLead = true;
        }

        if (isLead && this.l == null) { // opportunity == null && lead == null
            return new PageReference('/apex/ErrorPage?h=Objekt nicht gefunden&b=Bitte geben Sie einen gültigen Token an.');
        }
        // if (this.l.Assignment_Type__c == 'Share' && this.l.Has_Legal_Protection_Insurance__c) {
        /*
        // made no sense
        if (this.l.Assignment_Type__c == 'Share') {
            return new PageReference('/apex/ErrorPage?b=Die Rechtsschutzversicherung kann nicht auf vorhanden gesetzt werden, wenn der Auftragstyp "Share" ist.');
        }
        */

        return null;
    }

    public PageReference optOut() {
        if (signedOut != 'Yes') {
            return new PageReference('/AbmeldenAbgelehnt');
        }

        if (isLead) {
            this.l.Status = 'Lost';
            this.l.Absagegrund__c = 'Kunde hat widerrufen';
            update this.l;
        } else { // Opportunity
            this.o.Reason_For_Loss__c = 'Kunde hat widerrufen';
            this.o.StageName = 'Closed Lost';
            update this.o;
        }
        return new PageReference('/AbmeldenFertig');
    }

    private Opportunity getOpp() {
        string uId = getUniqueId();
        if (uId == null) {
            return null;
        }

        List<Opportunity> opps = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Token__c = :uId
        ];
        if (opps.size() == 0) {
            return null;
        }
        return opps[0];
    }

    private Lead getLead() {
        string uId = getUniqueId();
        if (uId == null) {
            return null;
        }
        List<Lead> leads = [
            SELECT Id, Status, Assignment_Type__c, Has_Legal_Protection_Insurance__c
            FROM Lead
            WHERE Token__c = :uId
        ];
        if (leads.size() == 0) {
            return null;
        }
        return leads[0];
    }

    private string getUniqueId() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}