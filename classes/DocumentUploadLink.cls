// Opportunity "Link zum Dokumentenupload" Button
// Anfrage "Link zum Dokumentenupload" Button
public class DocumentUploadLink {
    private final Opportunity opp;
    private final List<ContentDocumentLink> docs;
    public boolean errorContact {get; set;}

    public DocumentUploadLink(ApexPages.StandardController stdCtl) {
        errorContact = false;
        this.opp = [
            SELECT ID, AccountId, Contact__c, Account_Id__c, RecordTypeId, Follow_up_Count__c
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
        if (this.opp.Contact__c == null) {
            errorContact = true;
            return null;
        }
        if (this.opp.Follow_up_Count__c == 2 && this.docs.size() == 0) {
            this.opp.Automatisches_Follow_up_2__c = true;
            System.debug('Button has been pressed 3 times and still no docs => check auto follow up 2');
        }
		this.opp.Follow_up_Count__c = this.opp.Follow_up_Count__c == null ? 1 : (this.opp.Follow_up_Count__c + 1);
		System.debug('count: ' + this.opp.Follow_up_Count__c);
        update this.opp;
        string url = page.sendMail.getUrl() + createUrl();
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
                return Accounts.isVH24(this.opp.Account_Id__c) // 0010Y00000eCUS9
                    ? EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterFormstep2LinkVh24) // 00X0Y000001aYwQ
                    : EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterFormstep2LinkVr24); // 00X0Y000001aYwV
        }

        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) {
            return Accounts.isVH24(this.opp.Account_Id__c)
                ? EmailTemplates.idOf(EmailTemplates.name.FzCallcenterFormstep2LinkVh24) // 00X1v000000SMvI
                : EmailTemplates.idOf(EmailTemplates.name.FzCallcenterFormstep2LinkVr24); // 00X1v000000SMvN
        }

        return EmailTemplates.idOf(EmailTemplates.name.LvGeneralLinkZumDokumentenupload);
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&showAuthorizationsList=true' +
            '&noprtatt=true' +
            '&hdl=Link zu Formularstufe 2 versenden.' +
            '&noprtatt=true';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000001aYwQ','00X0Y000001aYwV'),IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMvI','00X1v000000SMvN'))}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Link zu Formularstufe 2 versenden."
// &showAuthorizationsList=true