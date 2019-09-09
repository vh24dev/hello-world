// Lead "Beispielrechnung versenden fz" Button
public class SendExampleCalcLeadFZ {
    private final Lead lead;

    public SendExampleCalcLeadFZ(ApexPages.StandardController stdCtl) {
        this.lead = [
            SELECT ID, RecordTypeId, Email
            FROM Lead
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Leads.isVH24(this.lead)) {
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalcLeadVh24);
        }
        return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeExampleCalcLeadVr24);
    }

    private string createUrl() {
        return
            '?id=' + lead.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + lead.id +
            '&islead=true' +
            '&noprtatt=true' +
            '&hdl=Beispielrechnung versenden.';
    }
}