@isTest
public class MembershipConfirmationControllerTests {
    @isTest
    private static void testNoOppRedirectsToNotFound() {
        PageReference p = Page.MembershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            MembershipConfirmationController c = new MembershipConfirmationController();
            c.init();
            PageReference pr = c.confirm();
            System.assert(pr.getUrl().endsWith('/notfound'));
        }
    }
    
     @isTest
    private static void testYesRedirectsToConfirmed() {
        TriggerConfiguration.allInactive = true;

        Opportunity o = new Opportunity(
        	Token__c = 'test123',
        	CloseDate= Date.today(),
            Name = 'Foo',
            StageName = 'On Hold'
        );
        
        insert o;
            

        o = [SELECT Id, Token__c FROM Opportunity WHERE Id = :o.Id];
        PageReference p = Page.MembershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', o.Token__c);
        
		MembershipConfirmationController occ = new MembershipConfirmationController();
        occ.init();
        PageReference pr = occ.confirm();
        System.assert(pr.getUrl().contains('/MembershipConfirmed'));
    }
}