public without sharing class PartnerCommunityManager{

    public static id getProfile(string profileName){
    
        return [Select id from Profile where Name =:profileName limit 1].id;
    
    }
    
    public static Invitation__c getInv(string invId){
    
        return [Select OwnerId,Invitee_Id__c ,id,Status__c,Invitation_URL__c from Invitation__c where Id =:invId limit 1];
    
    }
    
    public static Contact getcontact(id contactId){
    
        return [Select ownerId,MailingCity,MailingCountry,MailingCountryCode,MailingPostalCode,MailingStreet, AccountId,Account_Holder__c,Anwalt__c,Auftragstyp__c,Autostart_Auto_Follow_up_Journeys__c,Auto_Follow_up_Count__c,Auto_Follow_up_Date__c,Bank_Name__c,Bearbeitungsnummer__c,BIC__c,Birthdate,BypassProcessBuilder__c,ContactImpID__c,Created_Date_Old_Org__c,Department,Description,Document_Count__c,Email,FirstName,HomePhone,IBAN__c,Id,Invalid__c,LastName,MiddleName,Phone,Primary__c,Pro__c,Salutation,Salutation__c,Unternehmen__c FROM Contact where id=: contactId];
    }
    
    public static Account getAccount(id accountId){
        
        return [select ParentId,ownerId,name,Leitung__c,BIC__c,IBAN__c,Ich_bin_damIit_einverstanden_dass_im_Rah__c,Ich_stimme_hiermit_dem_SEPA_Einzugsverfa__c,Ich_stimme_hiermit_dem_VH24_Partnervertr__c,Id,Vermittler__c from Account where id=: accountId];
        
    }
    
    public static string createPartnerUser(string profileId, string email, string lastName, string firstName, string contactId){
        
        try{
            User user  = new User(
                 Username          = email+'.'+lastName,
                 ContactId         = contactId,
                 ProfileId         = profileId,
                 Alias             = lastName.left(4),
                 Email             = email,
                 EmailEncodingKey  = 'UTF-8',
                 LastName          = lastName,
                 CommunityNickname = lastName,
                 TimeZoneSidKey    = 'Europe/Berlin',
                 LocaleSidKey      = 'de_DE',
                 LanguageLocaleKey = 'de'
            );
            Database.insert(user);
            return 'true';
        }catch(Exception e){
            return e.getMessage();
        }
    
    }

}