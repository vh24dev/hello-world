// Authorization__c "Vollmacht versenden" Button
public class SendAuthorization {
    private final Authorization__c auth;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public SendAuthorization(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.auth = [
            SELECT ID,
            Opportunity__c
            FROM Authorization__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT ID,
            RecordTypeId,
            Legal_Account__c,
            Account__c,
            Contact__c
            FROM Opportunity
            WHERE ID = :this.auth.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorMsg = 'einen Kontakt auf dem Feld "Kunde" der Anfrage';
        }
        if (errorMsg != '') {
            return Null;
        }
        string url = page.SendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        // these templates are copied over from ResendAuthorization.apxc
        // https://trello.com/c/9Uydt17V/531-button-vollmacht-versenden
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationJaeger); // 00X0Y000001awdy
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVh24); // 00X0Y000000y7Ta
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVr24); // 00X0Y000000y7Tf
        }
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationJaeger); // 00X1v000000SMx9
        }
        if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVh24); // 00X1v000000SMvh
        }
        return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVr24); // 00X1v000000SMvm
        /*
        // these commented out tpls were used in the old code
        // but got replaced by ResendAuthorization tpls
        // https://trello.com/c/9Uydt17V/531-button-vollmacht-versenden
        // Dieselskandal
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselJaegerLegalAuthorization);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselLeComLegalAuthorization);
            }
            if (Accounts.isLegal21(this.opp.Legal_Account__c)) { // 0010Y000013yLnP
                return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.Diesel21LegalLegalAuthorization);
            }
            if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
                return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselKainzLegalAuthorization);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.DieselLachmairLegalAuthorization);
        }
        // Lebensversicherung
        if (Accounts.isLegal21(this.opp.Legal_Account__c)) { // 0010Y000013yLnP
            return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.Lv21LegalLegalAuthorization);
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvLeComLegalAuthorization);
        }
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvKainzLegalAuthorization);
        }
        return EmailTemplates.idOf(EmailTemplates.LegalAuthorization.LvJaegerLegalAuthorization);
		*/
    }

    private string createUrl() {
        return
            '?id=' + auth.Id +
            '&recipient=' + this.opp.Contact__c +
            '&tpl=' + getTpl() +
            '&hdl="Vollmacht anfordern."' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Authorization__c.Id}
// &recipient={!Opportunity.ContactId__c}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X0Y000000dmVP',IF(Opportunity.Legal_AccountId__c = '0010Y000013yLnP','00X0Y000000yAcT',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X0Y000001ab0t','00X0Y000000sJaE'))),IF(Opportunity.Legal_AccountId__c = '0010Y000013yLnP','00X0Y000000yAWb',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X0Y000000yAWB','00X0Y000000m8AH')))}
// &hdl="Vollmacht anfordern."
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showOpportunityAttachmentsList=true
// &showCreateFollowUpCheckbox=true
// &attreq=true