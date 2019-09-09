// Lead "Beispielrechnung versenden" Button
public class SendExampleCalcLead {
    private final Lead lead;

    public SendExampleCalcLead(ApexPages.StandardController stdCtl) {
        this.lead = [
            SELECT ID, RecordTypeId, Account__r.Id, Email
            FROM Lead
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    public EmailTemplates.name getEmailTemplateName() {
        boolean vh24 = Accounts.isVH24(this.lead.Account__r.Id);
        id rtid = this.lead.RecordTypeId;
        // Dieselskandal
        if (Leads.isDieselSkandal(rtId)) { // 0120Y000000W0CY
            if (vh24) { // 0010Y00000eCUS9
                return EmailTemplates.name.DieselskandalBackofficeExampleCalcLeadVh24; // 00X0Y000000m5bW
            }
            return EmailTemplates.name.DieselskandalBackofficeExampleCalcLeadVr24; // 00X0Y000000dk3U
        }
        // Finanzierung
        if (Leads.isFinanzierung(rtId)) {
            if (vh24) { // 0010Y00000eCUS9
                return EmailTemplates.name.FzBackofficeExampleCalcLeadVh24; // 00X1v000000SMwB
            }
            return EmailTemplates.name.FzBackofficeExampleCalcLeadVr24; // 00X1v000000SMwG
        }
        // Lebensversicherung
        if (vh24) { // 0010Y00000eCUS9
            return EmailTemplates.name.LvBackofficeExampleCalcLeadVh24; // 00X1v000000OTLI
        }
        return EmailTemplates.name.LvBackofficeExampleCalcLeadVr24; // 00X1v000000OTLN
    }

    private string getTpl() {
        return EmailTemplates.idOf(getEmailTemplateName());
    }

    private string createUrl() {
        return
            '?id=' + lead.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + lead.Id +
            '&islead=true' +
            '&noprtatt=true' +
            '&hdl=Beispielrechnung versenden.';
    }
}

// /apex/SendMail?id={!Opportunity.Id}
// &tpl={!IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000m5bW','00X0Y000000dk3U'),IF(Opportunity.RecordTypeId = '0120Y000000KnMH',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMwB','00X1v000000SMwG'),IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000OTLI','00X1v000000OTLN')))}
// &recipient={!Opportunity.ContactId__c}
// &noprtatt=true
// &hdl="Beispielrechnung versenden."