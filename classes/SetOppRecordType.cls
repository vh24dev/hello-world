// Opportunity "Übergabe zu Finanzierung" Button
public class SetOppRecordType {
    private final Opportunity opp;

    public SetOppRecordType(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT
            	Id,
            	RecordTypeId,
            	Assignment_Type__c,
            	Engine_Type__c,
            	Backoffice__c,
            	Legal_Protection_Insurance__c,
            	Bank__c, Financing_Contract_Date__c,
            	Finanzierungsvertrag_Gesamtbetrag__c,
            	Paid_Installments__c,
            	Monthly_Rate__c,
            	Credit_Contract_Numbe__c,
            	Reference__c
            FROM Opportunity
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
		PageReference pageRef;

		// Set RecordType
		if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) {
            return Errors.page('Die Anfrage darf nicht vom RecordType Finanzierung sein.');
        }

        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId) && (this.opp.Assignment_Type__c != 'RSV') && (this.opp.Engine_Type__c == 'EA189')) {
            String errorSubject = 'Fehler bei Übergabe des Prozesses.';
            String errorMessage = 'Anfragen ohne Rechtsschutzversicherung und Motortyp EA189 können nicht an Anwalt oder Finanzierungsprozess übergeben werden.';
            // pageRef = new PageReference('/apex/errorpage?errorSubject=' + errorSubject + '&errorMessage=' + errorMessage);
            pageRef = Errors.page(errorSubject, errorMessage);
        } else if (this.opp.Backoffice__c == null) {
            pageRef = Errors.page('Fehler bei Übergabe des Prozesses.', 'Bitte tragen Sie einen Backoffice Mitarbeiter ein.');
        } /* else if (this.opp.Legal_Protection_Insurance__c == null) {
            pageRef = Errors.page('Fehler bei Übergabe des Prozesses.', 'Bitte wählen Sie eine Rechtsschutzversicherung aus.');
        } else if (this.opp.Bank__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Kreditinstitut Feld ein.');
        } else if (this.opp.Financing_Contract_Date__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Finanzierungsvertragsdatum Feld ein.');
        } else if (this.opp.Finanzierungsvertrag_Gesamtbetrag__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Finanzierungsvertrag Gesamtbetrag Feld ein.');
        } else if (this.opp.Paid_Installments__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Bisher geleistete Rate Feld ein.');
        } else if (this.opp.Monthly_Rate__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Monatliche Raten Feld ein.');
        } else if (this.opp.Credit_Contract_Numbe__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Kreditvertragsnummer Feld ein.');
        } */else if (this.opp.Reference__c == null) {
            pageRef = Errors.page('Benötigtes Feld', 'Bitte tragen Sie einen Wert in das Aktenzeichen Feld ein.');
        } else {
            //System.debug('Id of recently updated opp is ' + opp.Id);
            this.opp.StageName = 'Claim';
            this.opp.RecordTypeId = Opportunities.finanzierungRecordType();
            //System.debug('Id of recordtypeID is ' + Opportunities.finanzierungRecordType());
            this.opp.Legal__c = Users.JCLegal(); // 0050Y000004hLE3
         	update this.opp;
            pageRef = Page.SuccessPage;
        }


		// Return page reference
		pageRef.setRedirect(true);
		return pageRef;
    }
}