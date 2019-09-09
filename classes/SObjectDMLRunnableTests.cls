@isTest
public class SObjectDMLRunnableTests {
	@isTest
    private static void testRunnableInsert() {
		Opportunity[] opps = buildOpps();

        Test.startTest();
        ID jobID = GenericQueueable.enqueue(new SObjectDMLRunnable(opps, SObjectDMLRunnable.DMLOp.INS));
        Test.stopTest();

        System.assertNotEquals(null, jobID);
        System.assertEquals(2, [SELECT Count() FROM Opportunity]);
    }
    
    @isTest
    private static void testRunnableUpdate() {
		Opportunity[] opps = buildOpps();
        insert opps;

        opps[0].name = 'updatedName1';
        opps[1].name = 'updatedName2';
        
        Test.startTest();
        ID jobID = GenericQueueable.enqueue(new SObjectDMLRunnable(opps, SObjectDMLRunnable.DMLOp.UPD));
        Test.stopTest();

        opps = [SELECT Name FROM Opportunity ORDER BY Name];

        System.assertNotEquals(null, jobID);
        System.assertEquals(2, opps.size());
        System.assertEquals('updatedName1', opps[0].name);
        System.assertEquals('updatedName2', opps[1].name);
    }
    
    @isTest
    private static void testRunnableUpsert() {
		Opportunity[] opps = buildOpps();
        insert opps;

        opps[0].name = 'updatedName1';
        opps[1].name = 'updatedName2';
        
        Opportunity o = TestData.createOpportunity(opps[0].accountID, 'On Hold');
        o.name = 'updatedName3';
        opps.add(o);
        
        Test.startTest();
        ID jobID = GenericQueueable.enqueue(new SObjectDMLRunnable(opps, SObjectDMLRunnable.DMLOp.UPS));
        Test.stopTest();

        opps = [SELECT Name FROM Opportunity ORDER BY Name];

        System.assertNotEquals(null, jobID);
        System.assertEquals(3, opps.size());
        System.assertEquals('updatedName1', opps[0].name);
        System.assertEquals('updatedName2', opps[1].name);
        System.assertEquals('updatedName3', opps[2].name);
    }
    
    @isTest
    private static void testRunnableDelete() {
		Opportunity[] opps = buildOpps();
        insert opps;

        Test.startTest();
        ID jobID = GenericQueueable.enqueue(new SObjectDMLRunnable(opps, SObjectDMLRunnable.DMLOp.DEL));
        Test.stopTest();

        opps = [SELECT Name FROM Opportunity ORDER BY Name];

        System.assertNotEquals(null, jobID);
        System.assertEquals(0, opps.size());
    }
    
    private static Opportunity[] buildOpps() {
        Account acc = TestData.createAccount();
        insert acc;

		return new Opportunity[]{TestData.createOpportunity(acc.ID, 'On Hold'), TestData.createOpportunity(acc.ID, 'On Hold')};
    }
}