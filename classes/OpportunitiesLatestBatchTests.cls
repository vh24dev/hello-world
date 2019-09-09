@isTest
public class OpportunitiesLatestBatchTests {
    @isTest
    private static void testBatch() {
        Account a = TestData.createAccount();
		insert a;
		Opportunity o = TestData.createOpportunity(a.ID, 'Claim');
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
			insert u;            
        }
        o.backoffice__c = u.ID;
		insert o;

        Test.startTest();
		Database.executeBatch(new OpportunitiesLatestBatch(new OpportunitiesRecordCache()));
        Test.stopTest();
        
        System.assertNotEquals(0, [SELECT Count() FROM OppsOnClaimCacheItem__c WHERE Visible__c = true]);
    }
}