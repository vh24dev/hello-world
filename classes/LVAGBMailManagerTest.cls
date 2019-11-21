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
        system.assertNotEquals(null,
               LVAGBMailManager.executeMailPrivate(testMap)
        );
    }
}