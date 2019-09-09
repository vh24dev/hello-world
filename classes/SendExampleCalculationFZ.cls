// Opportunity "Beispielrechnung versenden fz" Button
public class SendExampleCalculationFZ {
    private final Opportunity opp;
    public boolean errorContact {get; set;}

    public SendExampleCalculationFZ(ApexPages.StandardController stdCtl) {
        errorContact = false;
        this.opp = [
            SELECT ID, AccountId, Contact__c, Account_Id__c
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
        if (Accounts.isVH24(this.opp.Account_Id__c)) {
			return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalculationVh24); // 00X1v000000SMwB
        }
		return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalculationVr24); // 00X1v000000SMwG
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&noprtatt=true' +
            '&hdl=Beispielrechnung versenden (FZ).';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMwB','00X1v000000SMwG')}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Beispielrechnung versenden."