@isTest
public class CancellationsTest {
    @isTest
    static void testUpdateLV() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        User u = user();
        u.bypass_process_builder__c = true;
        insert u;
        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opp = TestData.createOpportunity(account.Id, 'New');
        opp.RecordTypeId = Opportunities.lebensversicherungRecordType();
        opp.Callcenter__c = u.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');
        cancellation.Date__c = null;
        insert cancellation;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        cancellation.Date__c = System.today();
        update cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assert(cancellation.Number__c.contains('000001/21VRLV'));
    }

    @isTest
    static void testInsertLV() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        User u = user();
        u.bypass_process_builder__c = true;
        insert u;
        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opp = TestData.createOpportunity(account.Id, 'New');
        opp.RecordTypeId = Opportunities.lebensversicherungRecordType();
        opp.Callcenter__c = u.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '1000001/21VRLV', cancellation.Number__c);
    }

    @isTest
    static void testUpdateDG() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');
        cancellation.Date__c = null;
        insert cancellation;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        cancellation.Date__c = System.today();
        update cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '1000001/DG', cancellation.Number__c);
    }

    @isTest
    static void testInsertDG() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '1000001/DG', cancellation.Number__c);
    }

    @isTest
    static void testUpdateFZ() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');
        cancellation.Date__c = null;
        insert cancellation;

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        cancellation.Date__c = System.today();
        update cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '1000001/CVRFZ', cancellation.Number__c);
    }

    @isTest
    static void testInsertFZ() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createAccount();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(account.Id, 'New');
        opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
        insert opportunity;
        Claim__c claim = TestData.createClaim(opportunity.Id, 'Draft');
        insert claim;
        Cost_Note__c costNote = TestData.createCostNote(claim.Id, 'Draft');
        costNote.Type__c = 'Sonstiges';
        insert costNote;
        Cancellation__c cancellation = TestData.createCancellation(costNote.Id,'Draft');

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert cancellation;

        Test.stopTest();

        // Assertion
        cancellation = [SELECT Id, Number__c FROM Cancellation__c WHERE Id = :cancellation.Id];
        System.assertEquals(String.valueOf(System.now().date().year()) + '1000001/CVRFZ', cancellation.Number__c);
    }

    private static User user() {
        Profile testProfile = [
            SELECT ID 
            FROM Profile
            WHERE Name = 'System Administrator' 
            LIMIT 1
        ];
        return new User(
            LastName = 'Test u1', 
            Username = 'testu1@test.com', 
            Email = 'testu1@test.com', 
            Alias = 'u1', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_GB', 
            EmailEncodingKey = 'ISO-8859-1', 
            ProfileId = testProfile.Id, 
            LanguageLocaleKey = 'en_US',
            IsActive = true
        );
    }
}