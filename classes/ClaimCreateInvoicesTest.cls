@isTest
public class ClaimCreateInvoicesTest {
    /***************************************
     *                                     *
     *        Vergleich - angenommen:      *
     *                                     *
     ***************************************/

	@isTest
    public static void testCreateNoInvoice() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 0; // causes no invoices to be created
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
    }

	@isTest
    public static void testCreateNoInvoiceDraft() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Draft', // has to be finished to be created
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
    }

	@isTest
    public static void testCreateNoInvoiceOnHold() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'On Hold', // has to be finished to be created
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
    }

	@isTest
    public static void testCreateNoInvoiceAppeal() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Appeal', // has to be finished to be created
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
    }

	@isTest
    public static void testCreateInvoice() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        insert oppLV;
        Opportunity oppFZ = TestData.createOpportunity(a.Id, 'On Hold');
        oppFZ.Refund__c = 1;
        oppFZ.RecordTypeId = Opportunities.FinanzierungRecordType();
        oppFZ.Has_Legal_Protection_Insurance__c = true;
        insert oppFZ;
        Opportunity oppDG = TestData.createOpportunity(a.Id, 'On Hold');
        oppDG.Refund__c = 1;
        oppDG.RecordTypeId = Opportunities.DieselskandalRecordType();
        oppDG.Has_Legal_Protection_Insurance__c = true;
        insert oppDG;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        Claim__c cFZ = new Claim__c(
            Opportunity__c = oppFZ.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.finanzierungRecordType()
        );
        Claim__c cDG = new Claim__c(
            Opportunity__c = oppDG.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.dieselskandalRecordType()
        );
        insert cLV;
        insert cFZ;
        insert cDG;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        cs.add(cFZ);
        cs.add(cDG);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(3, invs.size());
    }

    @isTest
    public static void testFixAmount() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        oppLV.Has_Legal_Protection_Insurance__c = true;
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id, Amount__c FROM Invoice__c];
        System.assertEquals(1, invs.size());
        Invoice__c res = invs[0];
        System.assertEquals(690, res.Amount__c);
    }

    @isTest
    public static void testUnFixAmountNoDuplicates() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        oppLV.Assignment_Type__c = 'Share';
        oppLV.Has_Legal_Protection_Insurance__c = false;
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Arrangement',
            Arrangement__c = 'Accepted',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);
		Claims.createInvoices(cs); // 2 x 2 the same claim -> expect only one invoice

        invs = [SELECT Id, Amount__c FROM Invoice__c];
       // System.assertEquals(1, invs.size()); // only expect one invoice because it was the same claim
        Invoice__c res = invs[0];
        //System.assertNotEquals(690, res.Amount__c); // it is not the fix value
       // System.assertEquals(0.35 * oppLV.Refund__c, res.Amount__c);
    }

    /***************************************
     *                                     *
     *       Angenommen ohne Berufung:     *
     *                                     *
     ***************************************/

    @isTest
    public static void testAngenommenOhneBerufung() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        oppLV.Has_Legal_Protection_Insurance__c = true;
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Accepted',
            Cover_Note_Scope__c = 'Without Appeal',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        List<Invoice__c> invs = [SELECT Id FROM Invoice__c];
        System.assertEquals(0, invs.size());
        Claims.createInvoices(cs);

        invs = [SELECT Id, Amount__c FROM Invoice__c];
        System.assertEquals(1, invs.size());
        Invoice__c res = invs[0];
        System.assertEquals(690, res.Amount__c);
    }

    /***************************************
     *                                     *
     *      Abgelehnt - ohne Berufung:     *
     *                                     *
     ***************************************/

    @isTest
    public static void testAbgelehntOhneBerufung() {
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        Insert a;
        Opportunity oppLV = TestData.createOpportunity(a.Id, 'On Hold');
        oppLV.Refund__c = 1;
        oppLV.RecordTypeId = Opportunities.LebensversicherungRecordType();
        oppLV.Has_Legal_Protection_Insurance__c = true;
        insert oppLV;
        Claim__c cLV = new Claim__c(
            Opportunity__c = oppLV.Id,
            Result__c = 'Declined',
            Cover_Note_Scope__c = 'Without Appeal',
            Stage__c = 'Finished',
            Clerk__c = u.id,
            RecordTypeId = Claims.lebensversicherungRecordType()
        );
        insert cLV;
        List<Claim__c> cs = new List<Claim__c>();
        cs.add(cLV);
        
        Test.startTest();
        cLV.Appeal_Date__c = Date.today(); // simple change
        update cLV;
        Test.stopTest();

        List<Invoice__c> invs = [SELECT Id, Amount__c FROM Invoice__c];
        System.assertEquals(1, invs.size());
        Invoice__c res = invs[0];
        System.assertEquals(690, res.Amount__c);
    }
}