@isTest
public class TESTAPI_Newsletter {
    @isTest
    public static void TestNewsletterContact() {
        TriggerConfiguration.allInactive = true;
        
        Account a = new Account(
            Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        
        Contact c = new Contact(
            AccountId = a.Id,
            Unique_Id__c = 'test',
            FirstName = 'first',
            LastName = 'last'
        );
        insert c;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('unique', 'test');
        
        API_Newsletter.Signup();
        
        c = [
            SELECT Id, Newsletter_Registered__c, Newsletter_Registration_Date__c
            FROM Contact
            WHERE Id = :c.Id
        ];
        
        System.assertEquals(true, c.Newsletter_Registered__c);
        System.assertEquals(System.today(), c.Newsletter_Registration_Date__c);
    }
    
    @isTest
    public static void TestNewsletterNoUnqiueId() {
        TriggerConfiguration.allInactive = true;
        
        RestContext.request = new RestRequest();
        
        try {
            API_Newsletter.Signup();
        } catch (API_Exception e) {
            
        }
    }
    
    @isTest
    public static void TestNewsletterBadUniqueId() {
        TriggerConfiguration.allInactive = true;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('unique', 'test');
        try {
            API_Newsletter.Signup();
        } catch (API_Exception e) {
        }
    }
    
    @isTest
    public static void TestNewsletterLead() {
        TriggerConfiguration.allInactive = true;
        
        Lead l = new Lead(
            Company = 'test',
            Unique_Id__c = 'test',
            FirstName = 'first',
            LastName = 'last'
        );
        insert l;
        
        RestContext.request = new RestRequest();
        RestContext.request.params.put('unique', 'test');
        
        API_Newsletter.Signup();
        
        l = [
            SELECT Id, Newsletter_Registered__c, Newsletter_Registration_Date__c
            FROM Lead
            WHERE Id = :l.Id
        ];
        
        System.assertEquals(true, l.Newsletter_Registered__c);
        System.assertEquals(System.today(), l.Newsletter_Registration_Date__c);
    }
}