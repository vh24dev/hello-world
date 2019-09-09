@isTest
public class SetOpportunityLostTest {
    private static Opportunity createOpp(string accname, string salestype) {
        PageReference p = Page.SetOpportunityLost;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Sales_Type__c = salestype;
        return o;
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOpportunityLost oe = new SetOpportunityLost(sc);

        // Act
        oe.parOpportunity.Reason_For_Loss__c = 'Auto verkauft';
        PageReference pr = oe.renderPage();

        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testClaimNoClerk() {
        Opportunity o = createOpp('VH24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.id
        );
        insert cl;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOpportunityLost oe = new SetOpportunityLost(sc);

        // Act
        oe.parOpportunity.Reason_For_Loss__c = 'Auto verkauft';
        PageReference pr = oe.renderPage();

        System.assertEquals(null, pr);
    }

    @isTest
    private static void testClaimClerk() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp('VH24', 'Online');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c cl = new Claim__c(
            Opportunity__c = o.id,
            Clerk__c = u.Id
        );
        insert cl;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOpportunityLost oe = new SetOpportunityLost(sc);

        // Act
        oe.parOpportunity.Reason_For_Loss__c = 'Auto verkauft';
        PageReference pr = oe.renderPage();

        System.assertNotEquals(null, pr);
    }
}