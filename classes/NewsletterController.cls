public class NewsletterController {
    public Contact c {get; set;}

    public PageReference init() {
        this.c = getContact();
        if (this.c == null) {
            return new PageReference('/apex/ErrorPage?h=Objekt nicht gefunden&b=Bitte geben Sie einen gültigen Token an.');
        }
        if (this.c.Email_Opt_In__c) {
            return new PageReference('/apex/ErrorPage?h=Sie haben bereits bestätigt');
        }
        // this.c.Email_Opt_In__c = true; // lookup that checks if confirmation date is not null
        this.c.Newsletter_Confirmation_Date__c = Datetime.now();
        update this.c;
        return null;
    }

    private Contact getContact() {
        string opptK = ApexPages.currentPage().getParameters().get('token');
        if (oppTK == null) {
            return null;
        }
        List<Opportunity> opps = [
            SELECT Id, Contact__c
            FROM Opportunity
            WHERE Token__c = :oppTk
        ];
        if (opps.size() != 1) {
            return null;
        }
        Opportunity opp = opps[0];
        List<Contact> cons = [
            SELECT Id, Email_Opt_In__c
            FROM Contact
            WHERE Id = :opp.Contact__c
        ];
        if (cons.size() != 1) {
            return null;
        }
        return cons[0];
    }
}