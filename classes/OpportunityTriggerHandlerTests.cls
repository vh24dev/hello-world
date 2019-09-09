@isTest
public class OpportunityTriggerHandlerTests {
    @isTest
    private static void testInsert() {
		Test.startTest();
        insertOpps();
        Test.stopTest();

        System.assertEquals(2, [SELECT Count() FROM Opportunity]);
    }
    
    @isTest
    private static void testUpdate() {
        insertOpps();
        
        Opportunity[] opps = [SELECT ID, Name FROM Opportunity];
        for (Opportunity o: opps) {
        	o.name = o.name + '-bla';
        }

		Test.startTest();
        update opps;
        Test.stopTest();

        opps = [SELECT Name FROM Opportunity];
        for (Opportunity o: opps) {
        	System.assert(o.name.endsWith('-bla'));
        }
        System.assertEquals(2, [SELECT Count() FROM Opportunity]);
    }

    private static void insertOpps() {
        Account acc = TestData.createAccount();
        insert acc;

        Opportunity[] opps = new Opportunity[]{TestData.createOpportunity(acc.ID, 'New'), TestData.createOpportunity(acc.ID, 'New')};
		insert opps;
    }
}