@isTest(seeAllData=true)
public class LVAGBMailManagerTest {    
    @isTest
    public static void testLVAGBMailManager(){
        Contact contact = new Contact();
 		contact.Email = 'n.hollandcunz@gmail.com';
        contact.FirstName = 'Ich bin ein automatisierter Testname';
        contact.LastName = 'Ich bin ein automatisierter Nachname';
        insert contact;
        List<Id> ids = new List<Id>();
        ids.add(contact.Id);
        LVAGBMailManager.sendAGBMail(ids);
        system.assertNotEquals(null,
              LVAGBMailManager.sendAGBMail(ids)
        );
    }
}