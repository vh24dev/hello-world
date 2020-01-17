@isTest
public class SendMailTriggerTest {
   
    @isTest
    private static void testTriggerEvent(){  
        Test.startTest();
        SendMail__e mailEvent = new SendMail__e(
            Is_Recipient_Address__c = true,
			Mail_Type__c = 'MandateAsMail',
            ObjectId__c = '1234567',
         	Recipient_Adress__c = 'test@test.com',
            Mail_Id__c = 'testtest'
        );
 		Database.SaveResult result = EventBus.publish(mailEvent);
        Test.getEventBus().deliver();
    	List<EventBusSubscriber> subscribers = [SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber WHERE Topic='SendMail__e' AND Type='ApexTrigger'];
       
        System.assertNotEquals(null, subscribers);
        Test.stopTest();
    }
}