// Opportunity "Vollmacht" Button
public class ResendAuthorization {
    private final Opportunity opp;
    public boolean errorContact {get; set;}

    public ResendAuthorization(ApexPages.StandardController stdCtl) {
        errorContact = false;
        this.opp = [
            SELECT ID, AccountId, Contact__c, Legal_Account__c, Account_Id__c, RecordTypeId
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorContact = true;
            return null;
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationJaeger); // 00X0Y000001awdy
            }
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVh24); // 00X0Y000000y7Ta
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeResendAuthorizationVr24); // 00X0Y000000y7Tf
        }
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationJaeger); // 00X1v000000SMx9
        }
        if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVh24); // 00X1v000000SMvh
        }
        return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeResendAuthorizationVr24); // 00X1v000000SMvm
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&sendAuthorization=true' +
            '&noprtatt=true' +
            '&hdl=Vollmacht erneut versenden.' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X0Y000001awdy',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000y7Ta','00X0Y000000y7Tf')),IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000SMx9',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMvh','00X1v000000SMvm')))}
// &recipient={!Opportunity.ContactId__c}
// &sendAuthorization=true
// &noprtatt=true
// &hdl="Vollmacht erneut versenden."
// &attreq=true