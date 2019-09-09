@isTest
public class SendMailTest {
    @isTest
    public static void test() {
        SendMail s = new SendMail();

        Test.StartTest();
        Messaging.SingleEmailMessage sent = s.Send('foo@bar.baz', 'foo subject', 'bar body');
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
 
        /*System.assertNotEquals(null, sent);
        System.assertEquals(1, invocations, 'An email has not been sent');
        System.assertEquals('foo subject', sent.subject);
        System.assertEquals('bar body', sent.plainTextBody);*/
    }
}