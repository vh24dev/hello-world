public class EmailUtilitiesQueueable implements Queueable, Database.AllowsCallouts {

	public List<CQueueableEmailUtilities> queueableEmails;
	public final Integer queryLimit = 20;

	public EmailUtilitiesQueueable(List<CQueueableEmailUtilities> queueableEmails){
		this.queueableEmails = queueableEmails;
	}

	@future
	public static void queueMailAsync(Id parentId, Id recipientId, Id templateId, Id userId, Integer addDays, String type){
		EmailUtilitiesQueueable queueable = new EmailUtilitiesQueueable(new List<CQueueableEmailUtilities>{new CQueueableEmailUtilities(new EmailUtilities(parentId, recipientId, templateId, userId),addDays,type)});
		System.enqueueJob(queueable);
	}

	public void execute(QueueableContext context) {
		Utilities.getConfiguration();

		Integer queueableEmailCount = 0;

		for (CQueueableEmailUtilities queueableEmail : queueableEmails) {
			if (queueableEmail.type == 'followUp'){
				queueableEmail.email.noParentAttachment = true;
			}

			String result = queueableEmail.email.send();
			System.debug('Sent automatic follow-up mail with result: ' + result);

			if (queueableEmail.email.parentId.getSobjectType() == Schema.SObjectType.Opportunity.getSObjectType()) {
				Opportunity opportunity = [select Id, Auto_Follow_up_Date__c, Auto_Follow_up_Count__c from Opportunity where Id =:queueableEmail.email.parentId];
				if ((queueableEmail.type != 'followUp') || ((opportunity.Auto_Follow_up_Date__c <= System.now()) && (opportunity.Auto_Follow_up_Date__c != null))){	// erneute Prüfung für doppel-Queueing

					if ((result == 'Success') && (queueableEmail.type == 'followUp')){
						if (queueableEmail.addDays != null){
							opportunity.Auto_Follow_up_Date__c = System.now().addDays(queueableEmail.addDays);
						} else {
							opportunity.Auto_Follow_up_Date__c = null;
						}
						opportunity.Auto_Follow_up_Count__c++;
						update opportunity;
					}
				}
			} else if (queueableEmail.email.parentId.getSobjectType() == Schema.SObjectType.Contact.getSObjectType()) {
				Contact contact = [select Id, Auto_Follow_up_Date__c, Auto_Follow_up_Count__c from contact where Id =:queueableEmail.email.parentId];

				if (result == 'Success'){
					if (queueableEmail.addDays != null){
						contact.Auto_Follow_up_Date__c = System.now().addDays(queueableEmail.addDays);
					} else {
						contact.Auto_Follow_up_Date__c = null;
					}
					contact.Auto_Follow_up_Count__c++;
					update contact;
				}
			} else if (queueableEmail.email.parentId.getSobjectType() == Schema.SObjectType.Test_Case__c.getSObjectType()) {
				Test_Case__c testCase = [select Id, Auto_Follow_up_Date__c, Auto_Follow_up_Count__c from Test_Case__c where Id =:queueableEmail.email.parentId];

				if (result == 'Success'){
					if (queueableEmail.addDays != null){
						testCase.Auto_Follow_up_Date__c = System.now().addDays(queueableEmail.addDays);
					} else {
						testCase.Auto_Follow_up_Date__c = null;
					}
					testCase.Auto_Follow_up_Count__c++;
					update testCase;
				}
			}

			queueableEmailCount++;

			Integer queriesLeft = (Limits.getLimitQueries() - Limits.getQueries());
			if (queriesLeft < queryLimit){
				break;
			}
		}

		for (Integer i=0;i<queueableEmailCount;i++){
			queueableEmails.remove(0);
		}

		if ((!queueableEmails.isEmpty()) && (Utilities.disableQueueableChaining == false)) {
			EmailUtilitiesQueueable queueable = new EmailUtilitiesQueueable(queueableEmails);
			if (!Test.isRunningTest()){
				System.enqueueJob(queueable);
			}
		}
	}

	public class CQueueableEmailUtilities {
		public Integer addDays;
		public String type;
		public EmailUtilities email;

		public CQueueableEmailUtilities(EmailUtilities email, Integer addDays, String type){
			this.email = email;
			this.addDays = addDays;
			this.type = type;
		}
	}
}