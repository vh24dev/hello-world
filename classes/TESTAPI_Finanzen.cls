@isTest
public class TESTAPI_Finanzen {
    @isTest
    public static void TestCreationSuccess() {
        TriggerConfiguration.allInactive = true;

        string req = '{"firstname":"Dylan","lastname":"Johnston","phone":"016666660934","email":"dj@salesfive.com"}';
        API_TestHelper.setRequest(req);
        API_Finanzen.createLead();

        List<Lead> l = [
            SELECT Id
            FROM Lead
        ];

        System.assertEquals(1, l.size());
    }
    
       @isTest
    public static void TestCreationFailure() {
        TriggerConfiguration.allInactive = true;

        string req = '{"phone":"016666660934","email":"dj@salesfive.com"}';
        API_TestHelper.setRequest(req);
        
        boolean exceptionCaught = false;
        try {
            API_Finanzen.createLead();
        } catch(API_Exception e) {
            exceptionCaught = true;
        }
        
        System.assertEquals(true, exceptionCaught);
        List<Lead> l = [
            SELECT Id
            FROM Lead
        ];

        System.assertEquals(0, l.size());
    }
}