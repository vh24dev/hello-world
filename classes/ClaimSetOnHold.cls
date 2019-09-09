// Claim "Auf Urteil warten" Button
public class ClaimSetOnHold {
    private final Claim__c claim;
    private final Opportunity opp;

    public ClaimSetOnHold(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT ID, Opportunity__c
            FROM Claim__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id, Contact__c, AccountId
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt auf der Anfrage');
        }
        string url = page.sendMail.getUrl() + createUrl();
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isVH24(this.opp.AccountId)) {
            return EmailTemplates.idOf(EmailTemplates.claims.LvBackofficeSetClaimOnHoldVh24);
        }
        return EmailTemplates.idOf(EmailTemplates.claims.LvBackofficeSetClaimOnHoldVr24);
    }

    private string createUrl() {
        return
            '?id=' + this.claim.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.opp.Contact__c +
            '&noatt=true' +
            '&hdl=Kunde informieren.';
    }
}

// /apex/SendMail?id={!Claim__c.Id}
// &recipient={!Opportunity.ContactId__c}
// &tpl={!IF(Opportunity.AccountId = '0010Y00000eCUS9','00X0Y000000m4ur','00X0Y000000s1hm')}
// &noatt=true
// &hdl="Kunde informieren."