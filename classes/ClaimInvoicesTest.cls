@isTest
public class ClaimInvoicesTest {
    @testSetup
    public static void createClaim() {
        TriggerConfiguration.allInactive = true;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
            Account a = new Account(Name = 'foo');
            insert a;
            User u = TestData.legalUser();
            insert u;
            Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
            o.Refund__c = 123;
            o.Legal__c = u.id;
            o.Backoffice__c = u.Id;
            insert o;
            Claim__c c = new Claim__c(
                Opportunity__c = o.Id,
                Arrangement__c = 'Accepted',
                Stage__c = 'Finished',
                Result__c = 'Accepted',
                Legal__c = u.id,
                Clerk__c = u.id
            );
            insert c;
        }
        Test.stopTest();
    }

    private static User bpUser() {
        Profile testProfile = [
            SELECT ID 
            FROM Profile
            WHERE Name = 'System Administrator' 
            LIMIT 1
        ];
        return new User(
            LastName = 'foo', 
            Username = 'bar@test.com', 
            Email = 'baz@test.com', 
            Alias = 'u2', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_GB', 
            EmailEncodingKey = 'ISO-8859-1', 
            ProfileId = testProfile.Id, 
            LanguageLocaleKey = 'en_US',
            IsActive = true,
            bypass_process_builder__c = true
        );
    }

    @isTest
    public static void testDGVergleichAngenommen() {
        Claim__c c = [SELECT Id FROM Claim__c];
        List<Invoice__c> invs;
        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(0, invs.size());
        TriggerConfiguration.allInactive = false;

        c.Result__c = 'Arrangement';
        update c;

        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(1, invs.size());
    }

    @isTest
    public static void testDGAngenommenOhneBerufung() {
        Claim__c c = [SELECT Id FROM Claim__c];
        List<Invoice__c> invs;
        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(0, invs.size());
        c.Cover_Note_Scope__c = 'Without Appeal';
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Result__c = 'Accepted';
        update c;
        TriggerConfiguration.allInactive = false;

        c.Stage__c = 'Finished';
        update c;
        
        c = [
            SELECT Id,
            Stage__c
            FROM Claim__c
            WHERE Id = :c.id
        ];
        System.assertEquals('Finished', c.Stage__c);

        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(1, invs.size());
    }

    @isTest
    public static void testDGTeilweiseAngenommenOhneBerufung() {
        Claim__c c = [SELECT Id FROM Claim__c];
        List<Invoice__c> invs;
        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(0, invs.size());
        c.Cover_Note_Scope__c = 'Without Appeal';
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Result__c = 'Partially won';
        update c;
        TriggerConfiguration.allInactive = false;

        c.Stage__c = 'Finished';
        update c;
        
        c = [
            SELECT Id,
            Stage__c
            FROM Claim__c
            WHERE Id = :c.id
        ];
        System.assertEquals('Finished', c.Stage__c);

        invs = [SELECT ID FROM Invoice__c];
        System.assertEquals(1, invs.size());
    }

    @isTest
    public static void testLVAbgelehntOhneBerufung() {
        TriggerConfiguration.allInactive = true;
        // System.runAs(bpUser()) {
            Claim__c c = [SELECT Id FROM Claim__c];
            List<Invoice__c> invs;
            invs = [SELECT ID FROM Invoice__c];
            System.assertEquals(0, invs.size());
            
            c.RecordTypeId = Claims.lebensversicherungRecordType();
            c.Result__c = 'Declined';
            c.Cover_Note_Scope__c = 'Without Appeal';
            c.Stage__c = 'Finished';
            update c;
            TriggerConfiguration.allInactive = false;
            
            // c.Result__c = 'Declined';
            update c;
            
            invs = [SELECT ID FROM Invoice__c];
            System.assertEquals(1, invs.size());
        // }
    }
}