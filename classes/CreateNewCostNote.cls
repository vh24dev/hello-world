// Cancellation__c "Neue Kostennote erstellen" Button
public class CreateNewCostNote {
    private final Cancellation__c can;
    private final Cost_Note__c costnote;

    public CreateNewCostNote(ApexPages.StandardController stdCtl) {
        this.can = [
            SELECT ID, Cost_Note__c
            FROM Cancellation__c
            WHERE Id = :stdCtl.getId()
        ];
        this.costnote = [
            SELECT Id,
            Claim__c,
            Type__c,
            Recipient__c,
            Number__c,
            Total_Price__c,
            Total_VAT__c,
            Amount__c,
            Amount_For_Legal_Prot_Insurance__c,
            Umsatz__c,
            Subject__c
            FROM Cost_Note__c
            WHERE Id = :this.can.Cost_Note__c
        ];
    }

    public PageReference renderPage() {
        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = this.costnote.Claim__c, // Fall
            Type__c = this.costnote.Type__c, // Typ
            Recipient__c = this.costnote.Recipient__c, // Empfänger
            Stage__c = 'Draft', // Status
            Subject__c = this.costnote.Subject__c
            // Total_Price__c = this.costnote.Total_Price__c, // Gesamthonorar
            // Total_VAT__c = this.costnote.Total_VAT__c, // USt.
			// Amount__c = this.costnote.Amount__c, // Summe
			// Amount_For_Legal_Prot_Insurance__c = this.costnote.Amount_For_Legal_Prot_Insurance__c, // Summe (RSV)
			// Umsatz__c = this.costnote.Umsatz__c, // Umsatz
            // Subject__c = 'Zusätzliche Kostennote zu "' + this.costnote.Number__c +  '"' // Betreff
        );
        insert cn;
		return new PageReference('/' + cn.Id);
    }
}