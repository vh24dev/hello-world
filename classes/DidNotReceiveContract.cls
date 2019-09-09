// Vertrag "Unterschrift nicht erhalten" Button
// Contract__c "Unterschrift nicht erhalten" Button
public class DidNotReceiveContract {
    private final Contract__c contract;
    private final Opportunity opp;

    public DidNotReceiveContract(ApexPages.StandardController stdCtl) {
        this.contract = [
            SELECT Id,
            Stage__c,
            Follow_up_Period__c,
            Opportunity__c,
            Opportunity__r.Account_Id__c,
            Opportunity__r.Contact__c,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks)
            FROM Contract__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;
        if (contract.Opportunity__r.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde" auf der Anfrage.');
        }

		// Send mail
		Id templateId;
		if (Accounts.isVH24(this.contract.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
			// VH24
			templateId = EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveContractVh24);
		} else {
			// VR24
			templateId = EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveContractVr24);
		}
		EmailUtilities emailUtilities = new EmailUtilities(contract.Id, contract.Opportunity__r.Contact__c, templateId, UserInfo.getUserId());
		String result = emailUtilities.send();
	    System.debug('Sent automatic mail with result: ' + result);

		// Update task
		for (Task task : this.contract.Tasks) {
			if ((task.Subject == 'Unterschriebenen Vertrag hochladen und Erhalt bestätigen') && (task.isClosed == false)){
				task.ActivityDate = System.today() +  Integer.valueOf(this.contract.Follow_up_Period__c);
				update task;
			}
		}

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}