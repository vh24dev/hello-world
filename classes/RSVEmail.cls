// Anfrage "RSV Email" button
// Opportunity "RSV Email" button
public class RSVEmail {
    private final Opportunity opp;
    public boolean errorNoContact {get; set;}

    public RSVEmail(ApexPages.StandardController stdCtl) {
        errorNoContact = false;
        this.opp = [
            SELECT ID, Contact__c, Account_Id__c
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorNoContact = true;
            return null;
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterRsvEmailVh24); // 00X0Y000001atMV
        }
        return EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterRsvEmailVr24); // 00X0Y000001atMf
    }

    private string createUrl() {
        return
            '?id=' + opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + opp.Contact__c +
            '&noprtatt=true' +
            '&hdl=Informationen zu Rechtschutzversicherungen versenden.' +
            '&tplatt=true';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000001atMV','00X0Y000001atMf')}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Informationen zu Rechtschutzversicherungen versenden."
// &tplatt=true