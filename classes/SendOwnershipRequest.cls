// Correspondence__c "Rückfrage zur Eigentümerschaft" Button
public class SendOwnershipRequest {
    private final Opportunity opp;
    private final Claim__c claim;
    private final Correspondence__c corr;
    public string errorMsg {get; set;}

    public SendOwnershipRequest(ApexPages.StandardController stdCtl) {
        errorMsg = '';
        this.corr = [
            SELECT Id, Claim__c
            FROM Correspondence__c
            WHERE Id = :stdCtl.getId()
        ];
        /*
        if (this.corr.Claim__c == null) {
            errorMsg = 'einen Fall auf der Korrespondenz';
            return;
        }
		*/
        this.claim = [
            SELECT Id, Opportunity__c, Opportunity_Legal_Account_Id__c
            FROM Claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        /*
        if (this.claim.Opportunity__c == null) {
            errorMsg = 'eine Anfrage auf dem Fall';
            return;
        }
		*/
        this.opp = [
            SELECT Id, Contact__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorMsg = 'einen Kontakt auf dem Feld "Kunde" der Anfrage';
        }
        if (errorMsg != '') {
            return null;
        }
        string url = page.sendMail.getUrl() + createUrl();
        this.corr.Date_Link_Ownership__c = System.today();
        update this.corr;
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isJCLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselJaegerLegalRequestOwnership);
        }
        if (Accounts.isLegalLeCom(this.claim.Opportunity_Legal_Account_Id__c)) {
            return EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselLeComLegalRequestOwnership);
        }
        if (Accounts.isLegal21(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000013yLnP
            return EmailTemplates.idOf(EmailTemplates.RequestOwnership.Diesel21LegalLegalRequestOwnership);
        }
        if (Accounts.isCLLBLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselKainzLegalRequestOwnership);
        }
        return EmailTemplates.idOf(EmailTemplates.RequestOwnership.DieselLachmairLegalRequestOwnership);
    }

    private string createUrl() {
        return
            '?id=' + corr.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&hdl=Rückfrage zur Eigentümerschaft versenden.' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showCostNotesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&tplatt=true' +
            '&notsent=true' + // do not update stage: https://trello.com/c/WrzgvAKb/497-dg-klageschrift-button-rückfrage-zur-eigentümerschaft
            '&attreq=true';
    }
}

// /apex/SendMail?
// id={!Correspondence__c.Id}
// &recipient={!Opportunity.ContactId__c}
// &tpl={!IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X0Y000001aaSv',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000013yLnP','00X0Y000000yAc6',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X0Y000001ab0Y','00X0Y000000m4Cj')))}
// &hdl=Rückfrage zur Eigentümerschaft versenden.
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showCostNotesList=true
// &showReceiptsList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &showCreateFollowUpCheckbox=true
// &tplatt=true
// &attreq=true