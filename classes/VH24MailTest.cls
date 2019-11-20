@isTest(SeeAllData=true)
public class VH24MailTest {

    @isTest
    public static void testSendMail(){
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		iVH24MailDelegation delegation = new LVSendAGBDelegation(contact);
        VH24Mail mail = new VH24Mail();
        mail.setDelegation(delegation);
        system.assertNotEquals(null,mail.sendMail());
    }
}