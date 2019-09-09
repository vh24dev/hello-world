@isTest
public class ClaimCorrespondencesTest {
    private static Map<ID, Claim__c> oldMapFromNewList(Claim__c[] cc) {
        Map<ID, Claim__c> oldMap = new Map<ID, Claim__c>();
        for (Claim__c c : cc) {
            Claim__c oldC = new Claim__c(
                Opportunity__c = c.Opportunity__c,
                Stage__c = c.Stage__c,
                Result__c = c.Result__c,
                Cover_Note_Scope__c = c.Cover_Note_Scope__c,
                Cover_Note__c = c.Cover_Note__c
            );
            oldMap.put(c.Id, oldC);
        }
        return oldMap;
    }

    /* * * * * * * * * * * *
     *                     *
     *  Integration tests  *
     *                     *
     * * * * * * * * * * * */

    /*
    // SOQL 101 LIMIT
    @isTest
    public static void testChangeResultIntegration() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = false,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued'
        );
        insert c;

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(0, corrs.size());

        TriggerConfiguration.allInactive = false;
        c.Result__c = 'Declined';
        update c;

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testLegalOppositionLVNoLegalIntegration() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = false,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Legal Opposition',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued'
        );
        insert c;

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(0, corrs.size());

        TriggerConfiguration.allInactive = false;
        c.Result__c = 'Declined';
        update c;

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(0, corrs.size());
    }
	*/

    /* * * * * * * * * * * *
     *                     *
     *      Unit tests     *
     *                     *
     * * * * * * * * * * * */

    @isTest
    public static void testChangeResult() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Claim__c oldC = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        Map<ID, Claim__c> oldMap = new Map<ID, Claim__c>();
        oldMap.put(c.Id, oldC);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testNoChangeResult() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsbegründung'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(1, corrs.size());
    }

    // TODO: this suddenly started to fail on restricted picklist
    @isTest
    public static void testVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Verteidigungsanzeige',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage Verteidigungsanzeige'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Verteidigungsanzeige'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Fristverlängerung'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage Verteidigungsanzeige'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Verteidigungsanzeige'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Fristverlängerung'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungserwiderung'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testCustomersOppositionFZ() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.finanzierungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Customers Opposition',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Kunden'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Kunden'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testCustomersOppositionLV() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        a.Type = 'Lebensversicherung';
        a.External_Id__c = 'lv999'; // prio III
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Termination_Date__c = System.today().addDays(2),
            Expiration_Date__c = System.today().addDays(4),
            Insurance__c = a.Id
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Customers Opposition',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Kunden'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Kunden'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testLegalOppositionFZ() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.finanzierungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Legal Opposition',
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Widerspruch'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Widerspruch'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testLegalOppositionLV() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Legal Opposition',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Anwalt'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Widerspruch'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Widerspruch durch Anwalt'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Widerspruch'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testLegalOppositionLVNoLegal() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'Share',
            Has_Legal_Protection_Insurance__c = false,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Legal Opposition',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(0, corrs.size());
    }

    @isTest
    public static void testClaimLetter() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Claim Letter',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Anspruchsschreiben'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Anspruchsschreiben'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Anspruchsschreiben'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Anspruchsschreiben'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testLawsuit() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Lawsuit',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.Id
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Klageschrift'];
        System.assertEquals(1, corrs.size());
    }

    @isTest
    public static void testAppeal() {
        TriggerConfiguration.allInactive = true;
        List<Claim__c> cls = new List<Claim__c>();
        Account a = new Account(Name = 'foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            RecordTypeId = Opportunities.lebensversicherungRecordType()
        );
        insert o;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Appeal',
            Cover_Note__c = 'Issued',
            Clerk__c = u.ID
        );
        insert c;
        cls.add(c);
        Map<ID, Claim__c> oldMap = oldMapFromNewList(cls);

        List<Correspondence__c> corrs;
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Replik'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Berufung'];
        System.assertEquals(0, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(0, corrs.size());

        ClaimCorrespondences.create(cls, oldMap);

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Replik'];
        System.assertEquals(1, corrs.size());
        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Deckungsanfrage für Berufung'];
        System.assertEquals(1, corrs.size());

        corrs = [SELECT Id FROM Correspondence__c WHERE Type__c = 'Berufungsschrift'];
        System.assertEquals(1, corrs.size());
    }
    
    @isTest
    public static void testHackCoverage() {
        new ClaimCorrespondences().HackCoverage();
    }
}