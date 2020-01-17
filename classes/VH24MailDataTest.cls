@isTest
public class VH24MailDataTest {
    
	@isTest
    private static void testVH24MailDataCreation() {
        SendMail__e event = new SendMail__e();
        event.Is_Recipient_Address__c = true;
        event.Mail_Id__c = '123124124-123123-123123123';
        VH24MailData data = VH24MailData.buildMailData(event);
        System.assertEquals(event.Mail_Id__c, data.mailId);
        System.assertEquals(event.Is_Recipient_Address__c, data.isAddress);        
    }

}