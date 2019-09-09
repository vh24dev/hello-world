@isTest
public class RegistrationTest{

     @testSetup static void setup() {
        // Create common test accounts
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;     
        
        Contact c = new Contact(AccountId = testAccts[0].id,lastname = 'test');
        insert c;
        Invitation__c inv = new   Invitation__c(contact__c = c.id);
        insert inv;
    }
    
    static testMethod void createUser(){
    
         Account acct = [SELECT Id FROM Account WHERE Name='TestAcct0' LIMIT 1];
         Contact con = [select id from Contact limit 1];
         Invitation__c inv = [select id from Invitation__c limit 1];
         
         PageReference PageRef = Page.Registration;
         Test.setCurrentPage(PageRef);
         ApexPages.currentPage().getParameters().put('id', inv.id);
         ApexPages.currentPage().getParameters().put('PartnerId', con.id);
         Registration r = new Registration();
         r.init();
         PageReference  pR = r.doRegister();

         
    }

}