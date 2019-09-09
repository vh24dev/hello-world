// Anfrage "Dokument noch nicht erhalten" Button
// Opportunity "Dokument noch nicht erhalten" Button
public class DidNotRecieveDocuments {
    private final Opportunity opp;
    public boolean errorRenderedCC {get; set;}
    public string parDescription {get; set;}
    public boolean errorRenderedC {get; set;}

    public DidNotRecieveDocuments(ApexPages.StandardController stdCtl) {
        errorRenderedCC = false;
        errorRenderedC = false;
        this.opp = [
            SELECT Id, AccountId, Contact__c, Callcenter__c, Callcenter__r.Id, (SELECT Id, Comment__c, Status, Subject, IsClosed FROM Tasks) 
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;
        List<Task> updateTasks = new List<Task>();

        if (this.opp.Callcenter__r.Id == null) {
            System.debug('WARNING: Callcenter__r.Id is null');
            errorRenderedCC = true;
            return null;
        }

        if (this.opp.Contact__c == null) {
            System.debug('WARNING: Contact__c is null');
            errorRenderedC = true;
            return null;
        }

		// Send mail
		Id templateId;
		if (Accounts.isVH24(this.opp.AccountId)) { // 0010Y00000eCUS9
			// VH24
			templateId = EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveDocumentsVh24); // 00X0Y000000m4vB
		} else {
			// VR24
			templateId = EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveDocumentsVr24); // 00X0Y000000NGEm
		}
		EmailUtilities emailUtilities = new EmailUtilities(this.opp.Id, this.opp.Contact__c, templateId, this.opp.Callcenter__c);
		emailUtilities.noAttachment = true;
		String result = emailUtilities.send();
		System.debug('Sent automatic mail with result: ' + result);

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}