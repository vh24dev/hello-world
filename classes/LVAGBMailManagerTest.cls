@isTest(seeAllData=true)
public class LVAGBMailManagerTest {    
    @isTest
    public static void testLVAGBMailManager(){
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
        Map<Id, String> testMap = new Map<Id, String> ();
        testMap.put(contact.Id,'BN123456');
        system.assertEquals(null,
               LVAGBMailManager.executeMailPrivate(contact.Id,'BN123456')
        );
    }
    
    @isTest
    public static void testProcessResult(){
        Test.startTest();
        User user = testdata.createUser();
        insert  user;
        Account account = TestData.createAccount();
        Opportunity opportunity = testdata.createOpportunity(account.Id, 'Check');
        opportunity.Number__c = 'BN123456123456';
        opportunity.Backoffice__c = user.Id;
        insert opportunity;
    	Messaging.SendEmailResult  er =(Messaging.SendEmailResult) JSON.deserialize('{"success":true}', 
                                                                                   Messaging.SendEmailResult.class);
        
        Messaging.SendEmailResult [] results = new List<Messaging.SendEmailResult>();
        results.add(er);
        LVAGBMailManager.processResult(results,'BN123456123456');
     
		Opportunity opportunityResult = [Select AGBMail_Send_Result__c From Opportunity Where Number__c = 'BN123456123456' ];
        String sendResult = opportunityResult.AGBMail_Send_Result__c;
        System.assert(sendResult.startsWithIgnoreCase('Successfully sent'));
        Test.stopTest();
    
    }
}