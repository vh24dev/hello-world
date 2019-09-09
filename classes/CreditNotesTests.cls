// Adapted from legacy code, todo: refactor
@isTest
public class CreditNotesTests {
    @isTest
    static void testDgInsert() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        /*Account account = TestData.createAccount();
        insert account;*/

        Opportunity opportunity = TestData.createOpportunity(null, 'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/CNDG'));
    }

    @isTest
    static void testDgUpdate() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        /*Account account = TestData.createAccount();
        insert account;*/

        Opportunity opportunity = TestData.createOpportunity(null, 'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');
        creditNote.Date__c = null;
        insert creditNote;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        creditNote.Date__c = System.today();
        update creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/CNDG'));
    }

    @isTest
    static void testFzInsert() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createVR24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/CNCVRFZ'));
    }

    @isTest
    static void testFzUpdate() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createVR24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');
        creditNote.Date__c = null;
        insert creditNote;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        creditNote.Date__c = System.today();
        update creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/CNCVRFZ'));
    }

    @isTest
    static void testLvInsert() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        User user = TestData.createUser();
        insert user;
        Account account = TestData.createVR24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.lebensversicherungRecordType();
        opportunity.Callcenter__c = user.Id;
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/CN21VRLV'));
    }

    @isTest
    static void testTestInsert() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Opportunity opportunity = TestData.createOpportunity(null, 'New');
        opportunity.Test__c = true;
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Credit_Note__c creditNote = TestData.createCreditNote(claim.Id, 'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert creditNote;

        Test.stopTest();

        // Assertion
        creditNote = [select Id, Number__c from Credit_Note__c where Id = :creditNote.Id];
        System.assert(creditNote.Number__c.contains('000001/Test'));
    }
}