@isTest
public class TelephonyExtensionTests {
    @isTest
    private static void testNoPhoneNumber() {
        TriggerLeadPhoneCallExtension sut = sut(null);
        
        Test.startTest();
        PageReference res = sut.triggerPhoneCall();
        Test.stopTest();

        // Assert
        System.assertEquals(null, res);
        System.assert(Page.TriggerLeadPhoneCall.getUrl().startsWithIgnoreCase(ApexPages.currentPage().getUrl()));        

        System.assertEquals(1, ApexPages.getMessages().size());
        System.assertEquals(ApexPages.Severity.ERROR, ApexPages.getMessages()[0].getSeverity());
    }
    
    @isTest
    private static void testSuccess() {
        TriggerLeadPhoneCallExtension sut = sut('123321');
        
        Test.startTest();
        PageReference res = sut.triggerPhoneCall();
        Test.stopTest();
        
        // Assert
        System.assert(res.getUrl().startsWith('callto:'));
        System.assertEquals(0, ApexPages.getMessages().size());
    }
    
    private static TriggerLeadPhoneCallExtension sut(String leadPhoneNumber) {
        PageReference p = Page.TriggerLeadPhoneCall;
        Test.setCurrentPage(p);
        
        Lead l = new Lead(lastName='Test lead', company='Comp', phone=leadPhoneNumber);
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        return new TriggerLeadPhoneCallExtension(sc);
    }
}