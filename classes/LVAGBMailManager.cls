public class LVAGBMailManager {

    public static List<Messaging.SendEmailResult []> sendAGBMail(List<Id> ids){
        list<Contact>contacts = getMailFieldsFromOpps(ids);
        List<Messaging.SendEmailResult []> results = new List<Messaging.SendEmailResult []>();
        for(Contact contact : contacts) {
        	iVH24MailDelegation agbDelegation = new LVSendAGBDelegation(contact);
            if(agbDelegation.isEnabled()){
        		VH24Mail vH24Mail = new VH24Mail();
	    		vH24Mail.setDelegation(agbDelegation);
        		Messaging.SendEmailResult [] mailResult = vH24Mail.sendMail();
            	results.add(mailResult);
            }
        }
        return results;
    }
    
    private static List<Contact> getMailFieldsFromOpps(List<Id> ids) {
        List<Contact> contacts = [Select EMail,Id FROM Contact WHERE Id IN: ids];
        return contacts;
    }
    
    private static boolean isLVLead(){
        return true;
    }
    
}