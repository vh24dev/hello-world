public class MandateMailController {
    
    private static boolean isCustomerOpposition;
    
    @AuraEnabled
    public static string init (String claimId){
        Claim__c claim = [Select Stage__c, Opportunity__r.Id, Opportunity__r.Legal__r.Email, Opportunity__r.Product__c
 		FROM Claim__c WHERE Id =: claimId];

        if(isEnabled(claim)){
        	return claim.Opportunity__r.Legal__r.Email;
        } else {
            return 'disabled';
        }
    }
    
    @AuraEnabled
    public static boolean sendMail(String oppId, string mailAddress, String mailId){
        system.debug('----oppId-----' + oppId);  
        system.debug('----mailId-----' + mailId);  
        system.debug('----mailAddress-----' + mailAddress);        
        SendMail__e mailEvent = new SendMail__e(
            Is_Recipient_Address__c = true,
			Mail_Type__c = 'MandateAsMail',
            ObjectId__c = oppId,
         	Recipient_Adress__c = mailAddress,
            Mail_Id__c = mailId
        );
 		Database.SaveResult result = EventBus.publish(mailEvent);
        system.debug('----result-----' + result.isSuccess());
        return true; 
    }
               
    @AuraEnabled
    public static string retrieveMailUuid(){
    	return (String)GUID.Gen(); 
    }
    
    @AuraEnabled
    public static string retrieveOppId(String claimId){
        Claim__c claim = [Select  Opportunity__r.Id FROM Claim__c WHERE Id =: claimId];
        return claim.Opportunity__r.Id;
    }
    
    private static boolean isEnabled(Claim__c claim){
        system.debug('----claim opp producz-----' + claim.Opportunity__r.Product__c);  

        if(claim.Opportunity__r.Product__c == 'Lebensversicherung'
          && claim.Stage__c == 'Legal Opposition') {
        	return true;    
        } else if(claim.Opportunity__r.Product__c == 'Finanzierung'
          && claim.Stage__c == 'Legal Opposition') {
            return true; 
        } else if(claim.Opportunity__r.Product__c == 'Dieselskandal') {
        	return true; 
        }
        return false;
    }

   
}