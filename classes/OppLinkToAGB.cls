// Anfrage "Link zur AGB Bestätigung" Button
// Opportunity "Link zur AGB Bestätigung" Button
public class OppLinkToAGB {
    private final Opportunity opp;

    public OppLinkToAGB(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id,
            Account_Id__c,
            Contact__c,
            RecordTypeId
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde".');
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.recordTypeId)) {
            // Diesel
            return Accounts.isVH24(this.opp.Account_Id__c)
                ? EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVh24)
                : EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVr24);
        }
        
        if (Opportunities.isLebensversicherung(this.opp.recordTypeId)) {
            // LV
            return EmailTemplates.idOf(EmailTemplates.Name.LvGeneralLinkZumDokumentenupload);
        }

        // FZ
        return Accounts.isVH24(this.opp.Account_Id__c)
            ? EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVh24)
            : EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVr24);
    }

    private string createUrl() {
        return
            '?id=' + this.opp.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.opp.Contact__c +
            '&noprtatt=true' +
            '&hdl="Link zu Formularstufe 2 versenden."' +
            '&showAuthorizationsList=true';  
    }
}