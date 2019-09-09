@isTest
public class AbtretungslinkControllerTest {
    @isTest
    public static void TestNotFound() {
        ApexPages.currentPage().getParameters().put('token', '123');
        AbtretungslinkController c = new AbtretungslinkController();
        c.init();
    }

    @isTest
    public static void TestSetDate() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Test_Case__c tc = new Test_Case__c(
            Opportunity__c = o.Id,
            Status__c = 'Draft'
        );
        insert tc;
        tc = [SELECT Id, Token__c FROM Test_Case__c WHERE Id = :tc.Id];

        ApexPages.currentPage().getParameters().put('token', tc.Token__c);
        AbtretungslinkController c = new AbtretungslinkController();
        c.init();

        tc = [SELECT ID, Assignment_Revocation_Date__c FROM Test_Case__c WHERE Id = :tc.Id];
        Datetime tcDate = tc.Assignment_Revocation_Date__c;
        Datetime nowDate = Datetime.now();
        System.assertEquals(nowDate.year(), tcDate.year());
        System.assertEquals(nowDate.month(), tcDate.month());
        System.assertEquals(nowDate.day(), tcDate.day());
        System.assertEquals(nowDate.hour(), tcDate.hour());
    }
}