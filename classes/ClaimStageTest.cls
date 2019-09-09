@isTest
public class ClaimStageTest {
    @testsetup
    public static void createClaim() {
        Test.startTest();
        TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'Bar',
            AccountID = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today().addDays(3)
        );
        insert o;        
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Draft',
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Appeal',
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        insert cl;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);
        Test.stopTest();
    }

    @isTest
    public static void testNoClerkLv() {
        TriggerConfiguration.allInactive = true;

        Claim__c cl = [SELECT Id, Stage__c FROM Claim__c LIMIT 1];
        cl.Clerk__c = null;
        update cl;
        // System.assertEquals('Draft', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Finished', cl.Stage__c);
    }

    @isTest
    public static void testFzLegalOpposition() {
        TriggerConfiguration.allInactive = true;

        Claim__c cl = [SELECT Id, Stage__c FROM Claim__c LIMIT 1];
        cl.Result__c = 'Arrangement';
        cl.Arrangement__c = 'Declined';
        cl.RecordTypeId = Claims.finanzierungRecordType();
        update cl;
        // System.assertEquals('Draft', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Legal Opposition', cl.Stage__c);
    }


    @isTest
    public static void testStageVerteidigungsanzeige() {
        // TODO: use setup here
		TriggerConfiguration.allInactive = true;
        Account a = new Account(Name = 'Foo');
        insert a;
        Opportunity o = new Opportunity(
            Name = 'Bar',
            AccountID = a.Id,
            StageName = 'On Hold',
            CloseDate = System.today().addDays(3)
        );
        insert o;
        Claim__c cl = new Claim__c(
            RecordTypeId = claims.lebensversicherungRecordType(),
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Result__c = 'Accepted',
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Appeal'
        );
        insert cl;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Appeal', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Appeal', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Verteidigungsanzeige', cl.Stage__c);
    }

    @isTest
    public static void testStagePartiallyWonVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Claim__c cl = [SELECT ID FROM Claim__c];
        cl.RecordTypeId = Claims.lebensversicherungRecordType();
        cl.Stage__c = 'Appeal';
        cl.Result__c = 'Partially won';
        cl.Cover_Note__c = 'Issued';
        cl.Cover_Note_Scope__c = 'Appeal';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Appeal', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Verteidigungsanzeige', cl.Stage__c);
    }

    @isTest
    public static void testStagePartiallyWonProcessing() {
		TriggerConfiguration.allInactive = true;
        Claim__c cl = [SELECT ID FROM Claim__c];
        cl.RecordTypeId = Claims.lebensversicherungRecordType();
        cl.Stage__c = 'Appeal';
        cl.Result__c = 'Partially won';
        cl.Cover_Note__c = 'Issued';
        cl.Cover_Note_Scope__c = 'Without Appeal';
        update cl;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Appeal', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Appeal', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Processing', cl.Stage__c);
    }

    @isTest
    public static void testStageFinished() {
        TriggerConfiguration.allInactive = true;
        Claim__c cl = [SELECT ID FROM Claim__c];
        cl.RecordTypeId = Claims.lebensversicherungRecordType();
        cl.Stage__c = 'Appeal';
        cl.Cover_Note__c = 'Issued';
        cl.Cover_Note_Scope__c = 'Appeal';
        update cl;

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        System.assertEquals('Finished', cl.Stage__c);
    }

    /*
    @isTest
    public static void testClerkLv() {
        TriggerConfiguration.allInactive = true;

        Claim__c cl = [SELECT Id, Stage__c FROM Claim__c LIMIT 1];
        // System.assertEquals('Draft', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);

        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Finished', cl.Stage__c);
    }
	*/

    @isTest
    public static void testClerkFz() {
        TriggerConfiguration.allInactive = true;
        Claim__c cl = [SELECT ID FROM Claim__c];
        cl.RecordTypeId = Claims.finanzierungRecordType();
        cl.Stage__c = 'Draft';
        cl.Cover_Note__c = 'Issued';
        cl.Cover_Note_Scope__c = 'Appeal';
        update cl;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);
        Correspondence__c corr = Correspondences.build(cl, 'Court', 'Deckungsanfrage Verteidigungsanzeige', 'Draft', null);
        insert corr;
        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Draft', cl.Stage__c);
        
        TriggerConfiguration.allInactive = false;
        cl.Cover_Note__c = 'Refused';
        update cl;

        cl = [SELECT Id, Stage__c FROM Claim__c WHERE Id = :cl.id];
        // System.assertEquals('Finished', cl.Stage__c);
    }
}