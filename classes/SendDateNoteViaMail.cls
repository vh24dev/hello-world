// Date_Notification__c "Per Email versenden" Button
// Terminbenachrichtigung "Per Email versenden" Button
public class SendDateNoteViaMail {
    private final Date_Notification__c datenote;
    private final Date__c datec;
    private final Claim__c claim;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public SendDateNoteViaMail(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.datenote = [
            SELECT ID,
            Date__c
            FROM Date_Notification__c
            WHERE ID = :stdCtl.getId()
        ];
        this.datec = [
            SELECT Id,
            Claim__c,
            Representative__c
            FROM Date__c
            WHERE Id = :this.datenote.Date__c
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
        if (datec.Representative__c == null) {
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
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateNotification);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateNotification);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateNotification);
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateNotification);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateNotification);
            }
            return EmailTemplates.idOf(EmailTemplates.LegalDate.FzKainzLegalDateNotification);
        }
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateNotification);
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.LegalDate.LvLeComLegalDateNotification);
        }
        return EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateNotification);
    }

    private string createUrl() {
        return
            '?id=' + datenote.Id +
            '&recipient=' + datec.Representative__c +
            '&tpl=' + getTpl() +
            '&hdl=Terminbenachrichtigung versenden' +
            '&attreq=true' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true';
    }
}

// /apex/SendMail?id={!Date_Notification__c.Id}
// &recipient={!Date__c.RepresentativeId__c}
// &tpl={!IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OS9V','00X1v000000OS9W'),IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X1v000000OS9X',''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X1v000000OS9Z','00X1v000000OS9Y')))}
// &hdl=Terminbenachrichtigung versenden
// &attreq=true
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true