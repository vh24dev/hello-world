@isTest
public class NonContributoryPeriodTriggerHandlerTests {
	@isTest
	static void testSetFields() {
		TriggerConfiguration.allInactive = true;

		Opportunity opportunity = TestData.createOpportunity(null, 'New');
		insert opportunity;
		Non_contributory_Period__c nonContributoryPeriod = TestData.createNonContributoryPeriod(opportunity.Id, System.today()-2, System.today()+2);

		TriggerConfiguration.allInactive = false;

		Test.startTest();
		insert nonContributoryPeriod;
		Test.stopTest();

		nonContributoryPeriod = [select Id,Active_Clean__c from Non_contributory_Period__c where Id = :nonContributoryPeriod.Id];
		System.assertEquals(true,nonContributoryPeriod.Active_Clean__c);
	}
}