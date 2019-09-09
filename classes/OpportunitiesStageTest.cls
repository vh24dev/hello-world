@isTest
public class OpportunitiesStageTest {
    @isTest
    public static void testClaimUnit() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv001';
        insert a;
        Opportunity oppOld = new Opportunity(
            Name = 'Bar',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            StageName = 'On Hold',
            AccountId = a.Id,
            Insurance__c = a.Id,
            Termination_Date__c = System.today().addDays(-2),
            Expiration_Date__c = System.today().addDays(-4),
            CloseDate = System.today().addDays(21),
            Confirmed_Terms_And_Conditions__c = false
        );
        insert oppOld;
        Opportunity oppNew = new Opportunity(
            Name = 'Bar',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            StageName = 'On Hold',
            AccountId = a.Id,
            Insurance__c = a.Id,
            Termination_Date__c = System.today().addDays(-2),
            Expiration_Date__c = System.today().addDays(-4),
            CloseDate = System.today().addDays(21),
            Confirmed_Terms_And_Conditions__c = true
        );
        insert oppNew;
        Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
        oldMap.put(oppNew.id, oppOld);
        List<Opportunity> newList = new List<Opportunity>();
        newList.add(oppNew);

        Test.startTest();
        newList = OpportunitiesStage.setStage(newList, oldMap);
        Test.stopTest();

        System.assertEquals('Claim', newList[0].StageName);
    }

    @isTest
    public static void testClaimIntegration() {
        Account a = new Account(Name = 'Foo');
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv001';
        insert a;
        Opportunity o = new Opportunity(
            Name = 'Bar',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            StageName = 'New',
            AccountId = a.Id,
            Insurance__c = a.Id,
            Termination_Date__c = System.today().addDays(-2),
            Expiration_Date__c = System.today().addDays(-4),
            CloseDate = System.today().addDays(21),
            Confirmed_Terms_And_Conditions__c = false
        );
        insert o;
        o.Confirmed_Terms_And_Conditions__c = true;

        Test.startTest();
        update o;
        Test.stopTest();

        o = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Claim', o.StageName);
    }
}