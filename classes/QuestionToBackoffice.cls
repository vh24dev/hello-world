public class QuestionToBackoffice {
    private final Claim__c claim;
    private final Opportunity opp;
    public string parDescription {get; set;}

    public QuestionToBackoffice(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT Id, Stage__c, Follow_up_Period__c, Legal__c, Legal__r.isActive, Opportunity__c,
			(SELECT Id, Status, Subject, OwnerId, IsClosed FROM Tasks)
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id, Account__r.Name, Backoffice__c, Backoffice__r.isActive,
            (SELECT Id, Status, Subject, OwnerId, IsClosed FROM Tasks)
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;

		if (Accounts.isVH24(this.opp.Account__c)) {
			EmailTemplate template = [
                SELECT Id, Subject, Body
                FROM EmailTemplate
                WHERE Id = :EmailTemplates.idOf(EmailTemplates.name.SendQuestionToVH24) // 00X0Y000000dmsH
            ];
			String subject = Utilities.mergeText(template.Subject, new Map<Id,String>{claim.Id => 'Claim__c',UserInfo.getUserId() => 'User'});
			String body = Utilities.mergeText(template.Body, new Map<Id,String>{claim.Id => 'Claim__c',UserInfo.getUserId() => 'User'});
			body = body.replace('{description}', parDescription);
			EmailUtilities mail = new EmailUtilities(claim.Id, null, subject, body, UserInfo.getUserId());
            mail.emailAddress = 'ra-abgas@verbraucherhilfe24.de';
            String result = mail.send();
            System.debug('Sent automatic mail with result: ' + result);
		} else {
			List<Task> updateTasks = new List<Task>();

			// Create task
			Task task =  Utilities.createTask('Frage des Anwalts', parDescription, this.opp, this.opp.Backoffice__r, System.today(), false, false);
			if (task != null) {
				task.Type = 'Q&A';
				insert task;
			}

			// Set tasks for legal on hold
			for (Task existingTask : this.claim.Tasks) {
				if ((existingTask.OwnerId == claim.Legal__c) && (existingTask.IsClosed == false)) {
					existingTask.Status = 'On hold';
					updateTasks.add(existingTask);
				}
			}

			if (updateTasks.size() > 0) {
				update updateTasks;
			}
		}
        // Return page reference
        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}