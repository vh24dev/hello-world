public without sharing class Registration{

    public static string contactId;
    public static string invId;
    public Contact contact{set;get;}
    public Account account{set;get;}
    public Invitation__c inv{set;get;}
    public string salutation {set;get;}
    public string firstname {set;get;}
    public string lastname {set;get;}
    public string email {set;get;}
    public string phone {set;get;}
    public string mailingStreet {set;get;}
    public string mailingPostalCode {set;get;}
    public string mailingCity {set;get;}
    public string mailingCountry {set;get;}
    public string bIC {set;get;}
    public string iban {set;get;}
    public string company {set;get;}
    public static id ownerId ;
    
    
    public Registration(){
    
        contactId = ApexPages.currentPage().getParameters().get('PartnerId');
        invId     = ApexPages.currentPage().getParameters().get('id');
        
    
    }
    
    public void init(){
        contact   = PartnerCommunityManager.getContact(contactId); 
        account   = PartnerCommunityManager.getAccount(contact.AccountId); 
        
        inv       = PartnerCommunityManager.getInv(invId); 
        iban = contact.IBAN__c;
        salutation = contact.Salutation;
        firstname = contact.Firstname;
        lastname = contact.LastName;
        email = contact.Email;
        phone = contact.Phone;
        mailingStreet = contact.MailingStreet;
        mailingPostalCode = contact.MailingPostalCode;
        mailingCity = contact.MailingCity;
        mailingCountry = contact.MailingCountry;
        bIC = contact.BIC__c;
        company = account.name;
        ownerId = account.ownerId;
    }
    
    
    public PageReference doRegister(){
        
        //system.debug('contact' + contact);
        try{
            contact.IBAN__c = iban;
            contact.Salutation = salutation;
            contact.Firstname  = firstname;
            contact.LastName = lastname;
            contact.Email = email;
            contact.Phone = phone;
            contact.MailingStreet = mailingStreet;
            contact.MailingPostalCode = mailingPostalCode;
            contact.MailingCity = mailingCity;
            contact.MailingCountry = mailingCountry;
            contact.BIC__c =  bIC;
            contact.OwnerId = Label.PartnerUserOwner;
            update contact;
            
            inv.status__c = 'Accepted';
            update inv;
            
            account.name = company;
            account.OwnerId = Label.PartnerUserOwner;
            update account;
            
            
           
            
            
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        string profileId = PartnerCommunityManager.getProfile(Label.PartnerUserProfile);
        string userCreated = PartnerCommunityManager.createPartnerUser(profileId,contact.Email,contact.LastName,contact.FirstName,contact.Id);
        if(userCreated == 'true'){
            
            PageReference p = new PageReference('https://www.verbraucherhilfe24.de');
            contact.OwnerId = inv.OwnerId;
            update contact;
            
            return p;
        }else{
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, userCreated);
            ApexPages.addMessage(msg);
            PageReference p = new PageReference(inv.Invitation_URL__c);
            return null;
        }


    }
    
    
}