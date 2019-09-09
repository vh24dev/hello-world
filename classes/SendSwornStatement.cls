// Anfrage "Eidesstattliche Erklärung" Button
// Opportunity "Eidesstattliche Erklärung" Button
public class SendSwornStatement {
    private final Opportunity opp;
    public boolean errorContact {get; set;}

    public SendSwornStatement(ApexPages.StandardController stdCtl) {
        errorContact = false;
        this.opp = [
            SELECT ID,
            AccountId,
            Contact__c,
            Legal_Account__c,
            Account_Id__c,
            RecordTypeId,
            Account__c
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (opp.Contact__c == null) {
            errorContact = true;
            return null;
        }

        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isVH24(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeSwornStatementJaeger);  // 00X0Y000001awe3
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeSwornStatementVh24);  // 00X0Y000000mC6Z
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeSwornStatementVr24);  // 00X0Y000000mC6e
        }
        if (Accounts.isVH24(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSwornStatementJaeger);  // 00X1v000000SMxE
        }
        if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSwornStatementVh24);  // 00X1v000000SMvw
        }
        return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSwornStatementVr24);  // 00X1v000000SMw1
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&noprtatt=true' +
            '&hdl=Eidesstattliche Erklärung anfordern.' +
            '&tplatt=true' + 
            '&eidesstattlicheversicherung=true';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X0Y000001awe3',IF(Opportunity.Account__c = '0010Y00000eCUS9','00X0Y000000mC6Z','00X0Y000000mC6e')),IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000SMxE',IF(Opportunity.Account__c = '0010Y00000eCUS9','00X1v000000SMvw','00X1v000000SMw1')))}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Eidesstattliche Erklärung anfordern."
// &tplatt=true