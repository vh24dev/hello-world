// Opportunity "Link zum Dokumentenupload (Anwalt)" Button
// Anfrage "Link zum Dokumentenupload (Anwalt)" Button
public class DocumentUploadLinkLegal {
    private final Opportunity opp;
	private final List<ContentDocumentLink> docs;
    public string errorMsg {get; set;}

    public DocumentUploadLinkLegal(ApexPages.StandardController stdCtl) {
        errorMsg = '';
        this.opp = [
            SELECT ID,
            AccountId,
            Contact__c,
            Backoffice__c,
            Legal_Account__c,
            Account__c,
            RecordTypeId,
            Follow_up_Count__c
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
        this.docs = [
            SELECT Id
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :this.opp.Id
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Backoffice__c == null) {
            errorMsg = 'einen Backoffice Mitarbeiter ein';
        }
        if (this.opp.Contact__c == null) {
            errorMsg = 'einen Kontakt im Feld "Kunde"';
        }
        if (errorMsg != '') {
            return null;
        }
        if (this.opp.Follow_up_Count__c == 2 && this.docs.size() == 0) {
            this.opp.Automatisches_Follow_up_2__c = true;
            System.debug('DocumentUploadLinkLegal :: Button has been pressed 3 times and still no docs => check auto follow up 2');
        }
		this.opp.Follow_up_Count__c = this.opp.Follow_up_Count__c == null ? 1 : (this.opp.Follow_up_Count__c + 1);
		System.debug('DocumentUploadLinkLegal :: followupcount: ' + this.opp.Follow_up_Count__c);
        update this.opp;
        string url = page.sendMail.getUrl() + createUrl();
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeDocumentUploadLinkJaeger); // 00X0Y000001awdt
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeDocumentUploadLinkVh24); // 00X0Y000000mCIG
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeDocumentUploadLinkVr24); // 00X0Y000000mCIL
        }
        
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) {
        	if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeDocumentUploadLinkJaeger); // 00X1v000000SMx4
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeDocumentUploadLinkVh24); // 00X1v000000SMv8
            }
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeDocumentUploadLinkVr24); // 00X1v000000SMvD    
        }
        
        // https://salesfive.atlassian.net/browse/VH24-150
        // LV
        return EmailTemplates.idOf(EmailTemplates.name.LvGeneralLinkZumDokumentenupload);
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&sendAuthorization=true' +
            '&noprtatt=true' +
            '&hdl=Link zum Dokumentenupload versenden.' +
            '&tplatt=true';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X0Y000001awdt',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000mCIG','00X0Y000000mCIL')),IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000SMx4',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMv8','00X1v000000SMvD')))}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Link zum Dokumentenupload versenden."
// &tplatt=true
// &showAuthorizationsList=true