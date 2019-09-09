@isTest
public class TerminTriggerHandlerTest {
    /*@isTest
    static void testCreateWebtoken(){
        // Testsetup
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u; 
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        insert c;
        Date__c termin = new Date__c(
            Claim__c = c.Id,
            Date__c = System.today(),
            Subject__c = 'Foo'
        );
        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();
        insert termin;
        Test.stopTest();

        termin = [SELECT Id, Token__c FROM Date__c WHERE Id = :termin.Id];
        System.assertNotEquals(null, termin.Token__c);
    }

    @isTest
    static void testSkipWebtoken(){
        // Testsetup
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        insert c;
        Date__c termin = new Date__c(
            Claim__c = c.Id,
            Date__c = System.today(),
            Subject__c = 'Foo',
            Token__c = 'Bar'
        );
        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();
        insert termin;
        Test.stopTest();

        termin = [SELECT Id, Token__c FROM Date__c WHERE Id = :termin.Id];
        System.assertEquals('Bar', termin.Token__c);
    }*/
}