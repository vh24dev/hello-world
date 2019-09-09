@isTest
public class OwnershipConfirmationControllerTests {
	@isTest
    private static void testNoOppRedirectsToNotFound() {
        PageReference p = Page.OwnershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            OwnershipConfirmationController c = new OwnershipConfirmationController();
            c.init();
			PageReference pr = c.confirm();
            System.assert(pr.getUrl().endsWith('/notfound'));
        }
    }
    
    @isTest
    private static void testNoSelectedOptionRedirectsToError() {
        TriggerConfiguration.allInactive = true;

        Correspondence__c cr = buildCorrespondence('abccde');
        insert cr;

        PageReference p = Page.OwnershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'abccde');
        
		OwnershipConfirmationController occ = new OwnershipConfirmationController();
        occ.init();
        PageReference pr = occ.confirm();
        System.assert(pr.getUrl().contains('/error'));
    }
    
    @isTest
    private static void testYesRedirectsToConfirmed() {
        TriggerConfiguration.allInactive = true;

        Correspondence__c cr = buildCorrespondence('abccde');
        insert cr;

        PageReference p = Page.OwnershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'abccde');
        
		OwnershipConfirmationController occ = new OwnershipConfirmationController();
        occ.init();
        occ.selectedOption = 'Yes';
        PageReference pr = occ.confirm();
        System.assert(pr.getUrl().contains('/OwnershipConfirmed'));
    }
    
    @isTest
    private static void testYesRedirectsToDeclined() {
        TriggerConfiguration.allInactive = true;

        Correspondence__c cr = buildCorrespondence('abccde');
        insert cr;

        PageReference p = Page.OwnershipConfirmation;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'abccde');
        
		OwnershipConfirmationController occ = new OwnershipConfirmationController();
        occ.init();
        occ.selectedOption = 'No';
        PageReference pr = occ.confirm();
        System.assert(pr.getUrl().contains('/OwnershipDeclined'));
    }
    
    private static Correspondence__c buildCorrespondence(String claimToken) {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        RecordType rt = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Dieselskandal' AND SObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        User u = TestData.legalUser();
        User bu = TestData.bypassUser();
        System.runAs(bu) {
            insert u;
        }
        Claim__c c = TestData.createClaim(o.ID, 'On Hold');
        c.clerk__c = u.ID;
        c.token__c = claimToken;
        insert c;
        
        return TestData.createCorrespondence(c.ID, 'Insurance', 'Widerspruch durch Kunden', 'Draft');
    }
}