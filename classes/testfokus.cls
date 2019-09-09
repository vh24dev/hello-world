@isTest
public class testfokus {
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

    
    /*
    private static Claim__c createClaim(string accname) {
        Account a = TestData.createAccount();
        a.name = accname;
        a.Department__c = 'Heinrich Jäger - DG & FZ';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact co = new Contact(LastName = 'foo');
        insert co;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        o.Contact__c = co.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void testJC() {
        System.debug('startof test ==============');
        ClaimTriggerHandler.deactivate = true;
        Claim__c c = createClaim('J & C Anwälte');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimRequestDeductible oe = new ClaimRequestDeductible(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalClaimRequestDeductible)));
    }
*/
}