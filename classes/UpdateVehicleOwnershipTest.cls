@isTest
public class UpdateVehicleOwnershipTest {
    @isTest
    public static void test5DaysOld() {
        // setup
        ClaimTriggerhandler.Deactivate = true;
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
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige',
            Date_Link_Ownership__c = System.today().addDays(-5)
        );
        insert corr;

        // test
        UpdateVehicleOwnership batch = new UpdateVehicleOwnership();
        Test.startTest();
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();

        // assert
        c = [SELECT ID, Customer_Is_Owner__c, Ownership_Request_Date__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals(true, c.Customer_Is_Owner__c);
        System.assertEquals(System.today(), c.Ownership_Request_Date__c);
    }

    @isTest
    public static void test2DaysOld() {
        // setup
        ClaimTriggerhandler.Deactivate = true;
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
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige',
            Date_Link_Ownership__c = System.today().addDays(-2)
        );
        insert corr;

        // test
        UpdateVehicleOwnership batch = new UpdateVehicleOwnership();
        Test.startTest();
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();

        // assert
        c = [SELECT ID, Customer_Is_Owner__c, Ownership_Request_Date__c FROM Claim__c WHERE Id = :c.Id];
        System.assertNotEquals(true, c.Customer_Is_Owner__c);
        System.assertNotEquals(System.today(), c.Ownership_Request_Date__c);
    }

    @isTest
    public static void testConfirmedAlready() {
        // setup
        ClaimTriggerhandler.Deactivate = true;
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
            Customer_Is_Owner__c = true,
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Stage__c = 'Claim Letter';
        c.Result__c = 'Declined';
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Verteidigungsanzeige',
            Date_Link_Ownership__c = System.today().addDays(-5)
        );
        insert corr;

        // test
        UpdateVehicleOwnership batch = new UpdateVehicleOwnership();
        Test.startTest();
        ID batchprocessid = Database.executeBatch(batch);
        Test.stopTest();

        // assert
        c = [SELECT ID, Customer_Is_Owner__c, Ownership_Request_Date__c FROM Claim__c WHERE Id = :c.Id];
        System.assertEquals(true, c.Customer_Is_Owner__c);
        System.assertNotEquals(System.today(), c.Ownership_Request_Date__c);
    }
}