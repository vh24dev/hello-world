// Anfrage "Potential auslösen" Button
// Opportunity "Potential auslösen" Button
public class SetOppClaimPotential {
    private final Opportunity opp;

    public SetOppClaimPotential(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id,
            RecordTypeId,
            Assignment_Type__c,
            Engine_Type__c,
            StageName,
            Legal__c,
            Backoffice__c,
            Vehicle_Brand__c,
            Vehicle_Brand_Name__c,
            Vehicle_Identification_Number__c,
            Registration_Date__c,
            Financing_Type__c,
            Purchase_Date__c,
            Purchase_Price__c,
            Mileage_On_Purchase__c,
            Current_Mileage__c,
            Expected_Mileage__c,
            Legal_Account__c,
            Reference__c,
            Has_Legal_Protection_Insurance__c
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if ((Opportunities.isDieselSkandal(this.opp.RecordTypeId)) && (this.opp.Assignment_Type__c != 'RSV') && (this.opp.Engine_Type__c == 'EA189')) {
            String errorSubject = 'Fehler bei Übergabe des Prozesses.';
            String errorMessage = 'Anfragen ohne Rechtsschutzversicherung und Motortyp EA189 können nicht an Anwalt oder Finanzierungsprozess übergeben werden.';
            return Errors.page(errorSubject, errorMessage);
        }
        if (this.opp.Backoffice__c == null) {
            return Errors.page('Bitte tragen Sie einen Backoffice Mitarbeiter ein.');
        }
        this.opp.StageName = 'Claim';
        update this.opp;
        return new PageReference('/' + opp.ID);
    }
}