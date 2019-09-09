// Vertrag "Vertrag erneut versenden" Button
// Contract__c "Vertrag erneut versenden" Button
public class ResendContract {
    private final Contract__c contract;
    private final Opportunity opp;

    public ResendContract(ApexPages.StandardController stdCtl) {
        this.contract = [
            SELECT Id,
            Opportunity__c
            FROM Contract__c
            WHERE Id = :stdCtl.getId()
        ];
        this.opp = [
            SELECT ID, AccountId, Contact__c, Legal_Account__c, Account_Id__c, RecordTypeId
            FROM Opportunity
            WHERE ID = :this.contract.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.LvCallcenterResendContractVh24);
        }
        return EmailTemplates.idOf(EmailTemplates.name.LvCallcenterResendContractVr24);
    }

    private string createUrl() {
        return
            '?id=' + this.contract.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.opp.Contact__c +
            '&hdl=Vertrag versenden.' +
            '&attreq=true';
    }
}

// /apex/SendMail?
// id={!Contract__c.Id}
// &tpl={!
// IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000m4vp','00X0Y000000rzmn')
// }
// &recipient={!Opportunity.ContactId__c}
// &hdl="Vertrag versenden."
// &attreq=true