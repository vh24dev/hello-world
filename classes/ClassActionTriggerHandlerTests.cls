// Legacy code, todo: refactor
@isTest
public class ClassActionTriggerHandlerTests {
    @isTest
    static void testClassAction(){
        TriggerConfiguration.allInactive = true;

        User u = TestData.createUser();
        insert u;
        User lu = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert lu;
        }
        Account account = TestData.createAccount();
        account.Type = 'Fahrzeughersteller';
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id,'Claim Letter');
        claim.Clerk__c = u.Id;
        claim.Legal__c = lu.Id;
        insert claim;
        Class_Action__c classAction = TestData.createClassAction(account.Id,'Draft');
        insert classAction;
        Class_Action_Reference__c classActionReference = TestData.createClassActionReference(classAction.Id,claim.Id);
        insert classActionReference;
        System.debug('claim legal and clerk=' + [SELECT ID, Legal__c, Clerk__c FROM Claim__c WHERE ID = :claim.id]);

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        classAction.Stage__c = 'Lawsuit';
        update classAction;

        Test.stopTest();

        // Assertion
        claim = [select Id, Stage__c from Claim__c where Id = :claim.Id];
        System.assertEquals('Class Action',claim.Stage__c);
    }

    @isTest
    static void testProcessing(){
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createAccount();
        account.Type = 'Fahrzeughersteller';
        insert account;

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }

        Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
        insert opportunity;

        Claim__c claim = TestData.createClaim(opportunity.Id,'Class Action');
        claim.Clerk__c = u.Id;
        claim.Legal__c = u.Id;
        insert claim;

        Logger.debug('come on: ' + [select name, legal__c from claim__c]);

        Class_Action__c classAction = TestData.createClassAction(account.Id,'Processing');
        insert classAction;
        Class_Action_Reference__c classActionReference = TestData.createClassActionReference(classAction.Id,claim.Id);
        insert classActionReference;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        classAction.Stage__c = 'Finished';
        update classAction;

        Test.stopTest();

        // Assertion
        claim = [select Id, Stage__c from Claim__c where Id = :claim.Id];
        System.assertEquals('Processing',claim.Stage__c);
    }
}