// Credit_Note__c "Gutschrift versenden" Button
// Gutschrift "Gutschrift versenden" Button
public class SendCreditNote {
    private final Credit_Note__c creditnote;
    private final Claim__c claim;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public SendCreditNote(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.creditnote = [
            SELECT ID, Claim__c
            FROM Credit_Note__c
            WHERE ID = :stdCtl.getId()
        ];
        this.claim = [
            SELECT ID, Opportunity__c
            FROM Claim__c
            WHERE ID = :this.creditnote.Claim__c
        ];
        this.opp = [
			SELECT ID,
            Legal_Protection_Insurance__c,
            RecordTypeId,
            Legal_Account__c
            FROM Opportunity
            WHERE ID = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Legal_Protection_Insurance__c == null) {
            errorMsg = 'eine "Rechtsschutzversicherung" auf der Anfrage';
        }
        if (errorMsg != '') {
            return Null;
        }
        string url = page.SendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.CreditNote.DieselJaegerLegalCreditNote);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.CreditNote.DieselLeComLegalCreditNote);
            }
            return EmailTemplates.idOf(EmailTemplates.CreditNote.DieselKainzLegalCreditNote);
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.CreditNote.FzJaegerLegalCreditNote);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.CreditNote.FzLeComLegalCreditNote);
            }
            return '';
        }
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.CreditNote.LvKainzLegalCreditNote);
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.CreditNote.LvLeComLegalCreditNote);
        }
        return EmailTemplates.idOf(EmailTemplates.CreditNote.LvJaegerLegalCreditNote);
    }

    private string createUrl() {
        return
            '?id=' + creditnote.Id +
            '&recipient=' + this.opp.Legal_Protection_Insurance__c +
            '&tpl=' + getTpl() + 
            '&hdl=Gutschrift versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Credit_Note__c.Id}
// &recipient={!Opportunity.Legal_Protection_InsuranceId__c}
// &tpl={!
// IF(Credit_Note__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X0Y000001MTXz','00X0Y000001ab0d'),IF(Credit_Note__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000SOHU',''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X0Y000001MTXf','00X0Y000001MTXa')))
// }
// &hdl=Gutschrift versenden
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &attreq=true