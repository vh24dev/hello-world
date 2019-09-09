@isTest
public class ClaimSetOnHoldTest { 
    @isTest
    private static void testErrorContact() { 
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSetOnHold oe = new ClaimSetOnHold(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains('Kontakt'));
    }

    @isTest
    private static void testVH24() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        o.Contact__c = con.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSetOnHold oe = new ClaimSetOnHold(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.claims.LvBackofficeSetClaimOnHoldVh24)));
    }

    @isTest
    private static void testJC() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = 'J & C Anwälte';
        insert a;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        Contact con = new Contact(LastName = 'bar');
        insert con;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Backoffice__c = u.Id;
        o.Legal_Account__c = a.Id;
        o.Contact__c = con.Id;
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id,
            legal__c = u.Id
        );
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSetOnHold oe = new ClaimSetOnHold(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.claims.LvBackofficeSetClaimOnHoldVr24)));
    }
}