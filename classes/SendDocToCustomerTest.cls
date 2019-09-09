@isTest
public class SendDocToCustomerTest {
    private static Claim__c createClaim(string legalname, string rtName) {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Backoffice__c = u.Id;
        o.Insurance__c = a.Id;
        o.Assignment_Type__c = 'RSV';
        o.Contact__c = con.Id;
        Account la = TestData.createAccount();
        la.Name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = :rtName AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        return c;
    }

    @isTest
    private static void TestNoContact() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        a.Type = 'Lebensversicherung';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        Account la = TestData.createAccount();
        la.Name = 'VH24';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        o.Legal_Account__c = la.Id;
        RecordType rt = [SELECT Id FROM RecordType WHERE Name = 'Finanzierung' AND sObjectType = 'Opportunity'];
        o.RecordTypeId = rt.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            Legal__c = u.Id
        );
        rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendDocToCustomer oe = new SendDocToCustomer(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void TestFzTask() {
        Claim__c c = createClaim('VH24', 'Finanzierung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendDocToCustomer oe = new SendDocToCustomer(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden'];
        System.assertEquals(0, ts.size());

        PageReference pr = oe.renderPage();

        ts = [SELECT Id FROM Task WHERE Subject = 'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden'];
        System.assertEquals(1, ts.size());
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSendCustomersOppositionToCustomerVr24)));
    }

    @isTest
    private static void TestLv() {
        Claim__c c = createClaim('VH24', 'Lebensversicherung');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(corr);
        SendDocToCustomer oe = new SendDocToCustomer(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSendCustomersOppositionToCustomerVr24)));
    }
}