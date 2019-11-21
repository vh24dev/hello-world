public class LVAGBMailManager {
    
    @future
    public static void executeLVAGBMail(Map<Id, String> idbns){
        try {
			Map<String,Messaging.SendEmailResult []> results = executeMailPrivate(idbns);
		} catch(Exception e) {
            documentErrorResults(e.getMessage());
        }   
    }
    
    @TestVisible
    private static Map<String,Messaging.SendEmailResult []> executeMailPrivate(Map<Id, String> idbns) {
        Map<String,Messaging.SendEmailResult []> results = new Map<String,Messaging.SendEmailResult []>();
        Map<String,Contact> bnsToCons = prepareData(idbns);
        for(String bn : prepareData(idbns).keySet()) {
        	iVH24MailDelegation agbDelegation = new LVSendAGBDelegation(bn,bnsToCons.get(bn));
            if(agbDelegation.isEnabled()){
        		VH24Mail vH24Mail = new VH24Mail();
	    		vH24Mail.setDelegation(agbDelegation);
        		Messaging.SendEmailResult [] mailResult = vH24Mail.sendMail();
            	results.put(bn,mailResult);
            }
        }
        return results;
    }
    
    private static Map<String,Contact>  prepareData(Map<Id, String> idbns) {
        List<Id> contactIds=new List<Id>();
		contactIds.addAll(idbns.keySet());
        return mapIdsToContacts(idbns);
    }
    
    private static Map<String,Contact> mapIdsToContacts(Map<Id, String> idbns){
        Map<String,Contact> cobns = new Map<String,Contact>();
        List<Contact> contacts = [Select EMail,Id,Salutation__c FROM Contact WHERE Id IN: idbns.keySet()];
        for(Contact contact :contacts){
            cobns.put(idbns.get(contact.id),contact);
        }
  		return cobns;
    } 
    
    /*
    private static void documentMailResults(Map<String,Messaging.SendEmailResult []> results){
        // still to do // next sprint
    }
    */
    private static void documentErrorResults(String errorMessage){
        System.debug('AGB Mail Sending failed, reason:' + errorMessage);
    }     
}