public class SendExampleCalculation {
    private final Opportunity opp;
    public boolean errorContact {get; set;}

    public SendExampleCalculation(ApexPages.StandardController stdCtl) {
        errorContact = false;
        this.opp = [
            SELECT ID, AccountId, Contact__c, Legal_Account__c, Account_Id__c, RecordTypeId
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
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeExampleCalculationVh24); // 00X0Y000000m5bW
            }
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalBackofficeExampleCalculationVr24); // 00X0Y000000dk3U
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) {
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalculationVh24); // 00X1v000000SMwB
            }
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalculationVr24); // 00X1v000000SMwG
        }
        if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.LvBackofficeExampleCalculationVh24); // 00X1v000000OTLI
        }
        return EmailTemplates.idOf(EmailTemplates.name.LvBackofficeExampleCalculationVr24); // 00X1v000000OTLN
    }
    
    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&noprtatt=true' +
            '&hdl=Beispielrechnung versenden.';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000m5bW','00X0Y000000dk3U'),IF(Opportunity.RecordTypeId = '0120Y000000KnMH',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMwB','00X1v000000SMwG'),IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000OTLI','00X1v000000OTLN')))}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Beispielrechnung versenden."