// Anfrage "Email versenden" Button
// Opportunity "Email versenden" Button
public class SendMailUrl {
    private final Opportunity opp;

    public SendMailUrl(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT ID, AccountId, Contact__c, Account_Id__c, RecordTypeId
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (opp.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde".');
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalGeneralBlankTemplateVh24); // 00X0Y000000m5dc
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalGeneralBlankTemplateVr24); // 00X0Y000000diZC
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.FzGeneralBlankTemplateVh24); // 00X1v000000SMwL
            }
            return EmailTemplates.idOf(EmailTemplates.name.FzGeneralBlankTemplateVr24); // 00X1v000000SMwV
        }
        if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.LvGeneralBlankTemplateVh24); // 00X0Y000000m4tZ
        }
        return EmailTemplates.idOf(EmailTemplates.name.LvGeneralBlankTemplateVr24); // 00X0Y000000N0fU
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&hdl=Email versenden.' +
            '&showDocumentsList=true' +
            '&noprtatt=true';
    }
}

// 	/apex/SendMail?id={!Opportunity.Id}
// 	&tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000m5dc','00X0Y000000diZC'),IF(Opportunity.RecordTypeId = '0120Y000000KnMH',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMwL','00X1v000000SMwV'),IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000m4tZ','00X0Y000000N0fU')))}
// 	&recipient={!Opportunity.ContactId__c}
// 	&hdl="Email versenden."
// 	&noprtatt=true