@isTest
public class CommissionsTests {
	@isTest
	static void testCommissionRate() {
		TriggerConfiguration.allInactive = true;

		Account account = TestData.createAccount();
		insert account;
		Account legalAccount = TestData.createAccount();
		insert legalAccount;
		Commission_Rate__c commissionRate1 = TestData.createCommissionRate(account.Id, legalAccount.Id, 'Lebensversicherung', 50);
		insert commissionRate1;
		Commission_Rate__c commissionRate2 = TestData.createCommissionRate(account.Id, legalAccount.Id, 'Dieselskandal', 50);
		insert commissionRate2;
		Commission__c commission = TestData.createCommission(account.Id,legalAccount.Id,null,null,System.today()-1,System.today()+1);

		TriggerConfiguration.allInactive = false;

		Test.startTest();
		insert commission;
		Test.stopTest();

		Commission__c updatedCommission = [select Id, Commission_Rate_Dg__c, Commission_Rate_Lv__c from Commission__c where Id = :commission.Id];
		System.assert(updatedCommission.Commission_Rate_Lv__c == commissionRate1.Rate__c);
		System.assert(updatedCommission.Commission_Rate_Dg__c == commissionRate2.Rate__c);
	}
}