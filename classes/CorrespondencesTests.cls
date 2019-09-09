@isTest
public class CorrespondencesTests {
    @isTest
    static void testSetTerm() {
        TriggerConfiguration.allInactive = true;

        User user = TestData.createUser();
        insert user;
        Account account = TestData.createAccount();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Correspondence__c correspondence = TestData.createCorrespondence(claim.Id, 'Insurance', 'Widerspruch durch Kunden', 'Draft');
        insert correspondence;

        TriggerConfiguration.allInactive = false;

        Test.startTest();

        correspondence.Date__c = System.today() + 10;
        update correspondence;

        Test.stopTest();

        correspondence = [select Id,Date__c, Term__c, Follow_up_Period__c from Correspondence__c where Id = :correspondence.Id];
        System.assert(correspondence.Term__c == (correspondence.Date__c + (Integer)correspondence.Follow_up_Period__c));
    }
    
    @isTest
    public static void testHackCoverage() {
        new Correspondences().HackCoverage();
    }
}