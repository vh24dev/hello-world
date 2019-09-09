// Claim "Selbstbehalt erfragen" Button
public class ClaimRequestDeductible {
    private final Claim__c claim;
    private final Opportunity opp;

    public ClaimRequestDeductible(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT ID, Opportunity__c, Opportunity_Legal_Account_Id__c
            FROM Claim__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id, Contact__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kunden auf der Anfrage');
        }
        string url = page.sendMail.getUrl() + createUrl();
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isJCLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalClaimRequestDeductible);
        }
        if (Accounts.isLegal21(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000013yLnP
            return EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalLegalClaimRequestDeductible);
        }
        if (Accounts.isCLLBLegal(this.claim.Opportunity_Legal_Account_Id__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalClaimRequestDeductible);
        }
        if (Accounts.isLegalLeCom(this.claim.Opportunity_Legal_Account_Id__c)) {
            return EmailTemplates.idOf(EmailTemplates.claims.DieselLeComLegalClaimRequestDeductible);
        }
        return EmailTemplates.idOf(EmailTemplates.name.DieselLachmairLegalClaimRequestDeductible);
    }

    private string createUrl() {
        return
            '?id=' + this.claim.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.opp.Contact__c +
            '&noatt=true' +
            '&hdl=Versende Nachfrage nach Selbstbehalt.' +
            '&showCreateFollowUpCheckbox=true';
    }
}

// 	/apex/SendMail?id={!Claim__c.Id}
// 	&tpl={!IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW','00X0Y000000dmVq',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000013yLnP','00X0Y000000yAcd',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm','00X0Y000001ab12','00X0Y000000sJU5')))}
// 	&recipient={!Opportunity.ContactId__c}
// 	&noatt=true
// 	&hdl="Versende Nachfrage nach Selbstbehalt."
// 	&showCreateFollowUpCheckbox=true