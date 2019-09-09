// Claim "Email versenden" Button
public class ClaimSendEmail {
    private final id claim;

    public ClaimSendEmail(ApexPages.StandardController stdCtl) {
        this.claim = stdCtl.getId();
    }

    public PageReference renderPage() {
        string url = page.sendMail.getUrl() + createUrl();
        return new PageReference(url);
    }

    private string createUrl() {
        return
            '?id=' + this.claim +
            '&hdl=Email versenden.' +
            '&showPartnerPicklist=true' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showCostNotesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&variant=4';
    }
}

// /apex/SendMail?id={!Claim__c.Id}
// &hdl="Email versenden."
// &showPartnerPicklist=true
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showCostNotesList=true
// &showReceiptsList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &showCreateFollowUpCheckbox=true
// &variant=4