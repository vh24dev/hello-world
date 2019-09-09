// Date_Record__c "Per Email versenden" Button
// Terminprotokoll "Per Email versenden" Button
public class DateRecordSendMail {
    private final Date_Record__c daterec;
    private final Date__c datec;
    private final Claim__c claim;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public DateRecordSendMail(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.daterec = [
            SELECT ID,
            Date__c
            FROM Date_Record__c
            WHERE ID = :stdCtl.getId()
        ];
        this.datec = [
            SELECT Id,
            Claim__c,
            Representative__c
            FROM Date__c
            WHERE Id = :this.daterec.Date__c
        ];
        this.claim = [
            SELECT Id,
            Opportunity__c
            FROM Claim__c
            WHERE Id = :this.datec.Claim__c
        ];
        this.opp = [
            SELECT Id,
            RecordTypeId,
            Legal_Account__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.datec.Representative__c == null) {
            errorMsg = 'einen "Terminsvertreter" auf dem Termin';
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
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateRecord);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateRecord);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateRecord);
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateRecord);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateRecord);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalDate.FzKainzLegalDateRecord);
        }
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateRecord);
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.LegalDate.LvLeComLegalDateRecord);
        }
        return EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateRecord);
    }

    private string createUrl() {
        return
            '?id=' + this.daterec.Id +
            '&recipient=' + this.datec.Representative__c +
            '&tpl=' + getTpl() +
            '&hdl=Terminprotokoll versenden' +
            '&attreq=true' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true';
    }
}

//  /apex/SendMail?id={!Date_Record__c.Id}
// &recipient={!Date__c.RepresentativeId__c}
// &tpl={!IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OS9a','00X1v000000OS9b'),IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OS9c',''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X1v000000OS9e','00X1v000000OS9d')))}
// &hdl=Terminprotokoll versenden
// &attreq=true
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true