// Terminvollmacht "Per Email versenden" Button
public class TerminvollmachtSendMail {
    private final Date_Authorization__c appAuth;
    private final Date__c app;
    private final Claim__c claim;
    public boolean errorRec {get; set;}

    public TerminvollmachtSendMail(ApexPages.StandardController stdCtl) {
        errorRec = false;
        this.appAuth = [
            SELECT ID,
            Date__c
            FROM Date_Authorization__c
            WHERE ID = :stdCtl.getId()
        ];
        this.app = [
            SELECT Id,
            Claim__c,
            Representative__c
            FROM Date__c
            WHERE Id = :this.appAuth.Date__c
        ];
        this.claim = [
            SELECT Id,
            Opportunity_Record_Type_Id__c,
            Opportunity_Legal_Account_Id__c
            FROM Claim__c
            WHERE Id = :this.app.Claim__c
        ];
    }

    public PageReference renderPage() {
        if (this.app.Representative__c == null) {
            errorRec = true;
            return null;
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.claim.Opportunity_Record_Type_Id__c)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateAuthorization);
            }
            if (Accounts.isLegalLeCom(this.claim.Opportunity_Legal_Account_Id__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateAuthorization);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateAuthorization);
        }
        if (Opportunities.isFinanzierung(this.claim.Opportunity_Record_Type_Id__c)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateAuthorization);
            }
            if (Accounts.isLegalLeCom(this.claim.Opportunity_Legal_Account_Id__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateAuthorization);
            }
            return '';
        }
        if (Accounts.isCLLBLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateAuthorization);
        }
        return EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateAuthorization);
    }

    private string createUrl() {
        return
            '?id=' + this.appAuth.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.app.Representative__c +
            '&hdl=Terminvollmacht versenden' +
            '&attreq=true' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true';
    }
}

// /apex/SendMail?id={!Date_Authorization__c.Id}
// &recipient={!Date__c.RepresentativeId__c}
// &tpl={!
// IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OTRk','00X1v000000OTRp'),IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OTRu',''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X1v000000OTRz','00X1v000000OTS4')))
// }
// &hdl=Terminvollmacht versenden
// &attreq=true
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true