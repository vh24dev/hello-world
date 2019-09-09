public class WelcomeLetters {
    // todo: depends on doc gen feature
    @future (callout=true)
	public static void autoCreateDocuments(Set<Id> ids) {
		Welcome_Letter__c[] wcc = [select Id, Stage__c, Opportunity__c, Opportunity__r.Account_Name__c, Opportunity__r.Assignment_Type__c from Welcome_Letter__c where Id IN :ids];

		for (Welcome_Letter__c wc : wcc){
			if (wc.stage__c == 'Draft' && wc.opportunity__r.Account_Name__c == 'VR24') {
				DocumentCreationAction.autoCreateDocument(wc.Id,false,'pdf',null,null);
			}
		}
	}
}