// Authorization__c "Unterschrift nicht erhalten" Button
// Vollmacht "Unterschrift nicht erhalten" Button
public class DidNotReceiveAuthorization {
    private final Authorization__c auth;
    private final Claim__c claim;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public DidNotReceiveAuthorization(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.auth = [
            SELECT Id,
            Stage__c,
            Follow_up_Period__c,
            Opportunity__r.Account__c,
            Opportunity__c,
            Opportunity__r.Contact__c,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks) 
            FROM Authorization__c
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (this.auth.Opportunity__r.Contact__c == null) {
            errorMsg = 'einen Kontakt auf dem Feld "Kunde" der Anfrage';
        }
        if (errorMsg != '') {
            return Null;
        }

		// Send mail
		Id templateId;
		if (Accounts.isVH24(this.auth.Opportunity__r.Account__c)) { // 0010Y00000eCUS9
			// VH24
			templateId = EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.LvCallcenterDidNotReceiveAuthorizationVh24); // 00X0Y000000m4v1
		} else {
			// VR24
			templateId = EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.LvCallcenterDidNotReceiveAuthorizationVr24); // 00X0Y000000N7BC
		}

		EmailUtilities emailUtilities = new EmailUtilities(this.auth.Id, this.auth.Opportunity__r.Contact__c, templateId, UserInfo.getUserId());
		String result = emailUtilities.send();
		System.debug('Sent automatic mail with result: ' + result);

		// Update task
		List<Task> updateTasks = new List<Task>();
		for (Task task : this.auth.Tasks){
			if ((task.Subject == 'Unterschriebene Vollmacht hochladen und Erhalt bestätigen') && (task.isClosed == false)){
				task.ActivityDate = System.today() + Integer.valueOf(this.auth.Follow_up_Period__c);
                updateTasks.add(task);
			}
		}
        if (updateTasks.size() > 0) {
            update updateTasks;
        }

        PageReference pageRef;
		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}