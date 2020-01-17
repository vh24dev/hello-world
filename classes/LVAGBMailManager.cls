public class LVAGBMailManager {
    //LVAGBMailManager.executeLVAGBMail(lead.ConvertedContactId,lead.Bearbeitungsnummer__c);

    @future
    public static void executeLVAGBMail(Id convertedContactId, String bearbeitungsnummer ) {
        try {
			Messaging.SendEmailResult [] result = executeMailPrivate(convertedContactId,bearbeitungsnummer);
            processResult(result, bearbeitungsnummer);
		} catch(Exception e) {
            //documentErrorResults(e.getMessage());
        }   
    }
    
    @TestVisible
    private static Messaging.SendEmailResult [] executeMailPrivate(Id convertedContactId, String bearbeitungsnummer) {
        Messaging.SendEmailResult [] mailResult = null;
        iVH24MailDelegation agbDelegation = new LVSendAGBDelegation(bearbeitungsnummer,mapIdToContact(convertedContactId));
        agbDelegation.prepareMail();
        if(agbDelegation.isEnabled()){
        	VH24Mail vH24Mail = new VH24Mail();
	    	vH24Mail.setDelegation(agbDelegation);
        	mailResult = vH24Mail.sendMail();
        }
        return mailResult;
    }
    
    private static Contact mapIdToContact(Id contactId){
       	return [Select EMail,Id,Salutation__c FROM Contact WHERE Id =: contactId];
    } 
    
    @TestVisible    
    private static void processResult(Messaging.SendEmailResult [] result, String bearbeitungsnummer) {
        Opportunity opp = [Select AGBMail_Send_Result__c From Opportunity Where Number__c =: bearbeitungsnummer];
        boolean success = false;
        string resultMessage = 'not set at present';
        //string resultMessage = 'could not build result message: probably something went wrong';
        if(result != null && result.size() > 0) {
            success = result[0].isSuccess();
        }
        if(success == true) {
            Datetime now = Datetime.now();
            resultMessage = 'Successfully sent AGBMail on: ' + String.valueOf(now);
        }
        opp.AGBMail_Send_Result__c = resultMessage;
        update opp;
    }
/*
    private static void documentErrorResults(String errorMessage){
        System.debug('AGB Mail Sending failed, reason:' + errorMessage);
    }
*/
}