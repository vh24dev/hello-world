@isTest
public class WiderrufLeadControllerTest {
    @isTest
    private static void testFail() {
        WiderrufLeadController oe = new WiderrufLeadController();
        PageReference pr = oe.createLead();
        System.assertEquals(null, pr);
    }
 
    /*@isTest
    private static void testSuccess() {
        ClaimTriggerhandler.Deactivate = true;
        WiderrufLeadController oe = new WiderrufLeadController();

        oe.firstname = 'foo';
        oe.lastname = 'bar';
        oe.email = 'foo@bar.com';
        oe.phone = '123123123123123';
        oe.legalInsurance = true;
        oe.privacy = true;
        oe.question_d = 'Friends Life Limited';
        oe.question_c = 'Ja';
        oe.question_b = 'Ja'; 
        oe.question_a = 'Ja';

        PageReference pr = oe.createLead();
        System.assertEquals('', oe.errorMsg);
        System.assertEquals(true, pr.getUrl().contains('WiderrufLead2'));

        List<Lead> res = [SELECT Id, Email FROM Lead WHERE Email = 'foo@bar.com' LIMIT 1];
        System.assertEquals(1, res.size());
    }*/
}