@isTest(SeeAllData=true)
public class LVSendAGBDelegationTest { 
    
    @isTest
    public static void testConstructor() {        
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
        system.assertNotEquals(null,delegation);
    }

    @isTest
    private static void testGetPlainTextBody(){
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.GetPlainTextBody());
    }
    
    @isTest
    private static void testGetHtmlBody(){
		Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.GetHtmlBody());
    }
    
    @isTest
    private static void testGetAddresses() {
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.getAddresses());
    }
    
    @isTest
    private static void testGetSubject(){
    	Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.getSubject());   
    }

    @isTest
    private static void testGetAttachments() {
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.getAttachments());   
    } 
    
    @isTest
    private static void testGetMailTemplate() {
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
		LVSendAGBDelegation delegation = new LVSendAGBDelegation(contact);
    	system.assertNotEquals(null,delegation.getMailTemplate()); 
    }
    /*
    @isTest
    private void testGetSenderId() {
        return senderAdressId;
    }
    
    @isTest
    private void testGetRecipientAddress() {
        return contact.Email;
    }   
    */

}