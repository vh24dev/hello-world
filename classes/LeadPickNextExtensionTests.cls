@isTest
public class LeadPickNextExtensionTests {
	@isTest
    private static void testNoNextLead() {
        PageReference p = Page.LeadPickNext;
        Test.setCurrentPage(p);
        
        Lead l = new Lead(lastName='Test lead', company='Comp');
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        LeadPickNextExtension lpn = new LeadPickNextExtension(sc);
        PageReference pr = lpn.pickNext();
        System.assert(pr.getUrl().containsIgnoreCase(Page.NothingToPick.getUrl()));
    }
    
    @isTest
    private static void testNoNextLeadWithSameSource() {
        PageReference p = Page.LeadPickNext;
        Test.setCurrentPage(p);
        
        Lead l1 = new Lead(lastName='Test lead', company='Comp', leadSource='Manual');
        Lead l2 = new Lead(lastName='Test lead', company='Comp', leadSource='API');
        insert new Lead[]{l1, l2};

        Apexpages.StandardController sc = new Apexpages.standardController(l1);
        LeadPickNextExtension lpn = new LeadPickNextExtension(sc);
        PageReference pr = lpn.pickNext();
        System.assert(pr.getUrl().containsIgnoreCase(Page.NothingToPick.getUrl()));
    }
    
    @isTest
    private static void testNextLead() {
        PageReference p = Page.LeadPickNext;
        Test.setCurrentPage(p);
        
        Lead l1 = new Lead(lastName='Test lead', company='Comp', leadSource='Manual');
        Lead l2 = new Lead(lastName='Test lead', company='Comp', leadSource='Manual');
        insert new Lead[]{l1, l2};

        Apexpages.StandardController sc = new Apexpages.standardController(l1);
        LeadPickNextExtension lpn = new LeadPickNextExtension(sc);
        PageReference pr = lpn.pickNext();
        System.assertEquals('/' + l2.ID, pr.getUrl());
        
        pr = lpn.pickNext();
        System.assert(pr.getUrl().containsIgnoreCase(Page.NothingToPick.getUrl()));
    }
}