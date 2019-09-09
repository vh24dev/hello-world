// Anfrage "An Anwalt übergeben" Button
// Opportunity "An Anwalt übergeben" Button
public class SetOppClaimLegal {
    private final Opportunity opp;

    public SetOppClaimLegal(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id,
            RecordTypeId,
            Assignment_Type__c,
            Engine_Type__c,
            StageName,
            Legal__c,
            MFK__c,
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
            Has_Legal_Protection_Insurance__c,
            (SELECT Id FROM Documents__r)
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (this.opp.MFK__c == false) {
            if (this.opp.Vehicle_Brand__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeughersteller" der Anfrage');
            }
            if (this.opp.Vehicle_Brand_Name__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeugmarke" der Anfrage');
            }
            if (this.opp.Engine_Type__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Motortyp" der Anfrage');
            }
            if (this.opp.Vehicle_Identification_Number__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeug Identifizierungsnummer" der Anfrage');
            }
            if (this.opp.Registration_Date__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Zulassungsdatum" der Anfrage');
            }
            if (this.opp.Financing_Type__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Finanzierungsart" der Anfrage');
            }
            if (this.opp.Purchase_Date__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kaufdatum" der Anfrage');
            }
            if (this.opp.Purchase_Price__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kaufpreis" der Anfrage');
            }
            if (this.opp.Mileage_On_Purchase__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kilometerstand bei Kauf" der Anfrage');
            }
            if (this.opp.Current_Mileage__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Aktueller Kilometerstand" der Anfrage');
            }
            if (this.opp.Expected_Mileage__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Voraussichtliche Kilometer" der Anfrage');
            }
            if (this.opp.Legal_Account__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kanzlei" der Anfrage');
            }
            if (this.opp.Reference__c == null) {
                return Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Aktenzeichen" der Anfrage');
            }
            if (this.opp.StageName == 'New') {
                return Errors.page('Die Anfrage befindet sich in der Stage "New" und kann deswegen nicht auf "Claim" gesetzt werden.');
            }
            if (this.opp.Assignment_Type__c == null) {
                return Errors.page('Der "Auftragstyp" muss einen Wert haben.');
            }
            if (/* (this.opp.StageName == 'Claim') || */(this.opp.Legal__c == null)) {
                return Errors.page('Es muss ein "Anwalt" auf der Anfrage hinterlegt sein.');
            }
            if (this.opp.StageName == 'Claim') {
                return new PageReference('/' + opp.ID);
            }
            /*
            List<ContentDocumentLink> dls = [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :this.opp.id
            ];
            if (dls.size() < 1) {
            */
            if (this.opp.Documents__r.size() < 1) {
                return Errors.page('Es muss mindestens ein Domkument vorhanden sein.');
            }
        }

        this.opp.StageName = 'Claim';
        update this.opp;
        System.debug('Updated stage to Claim');
        return new PageReference('/' + opp.ID);
    }
}