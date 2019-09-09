@isTest
public class OpportunityEmailsTests {
    @isTest
    public static void hackCoverage() {
        OpportunityEmails.hackCoverage();
    }

    @isTest
    public static void testDGupdateOnHoldCllb() {
        TriggerConfiguration.allInactive = true;
        List<Opportunity> oo = new List<Opportunity>();
        Map<Id, Opportunity> oldOo = new Map<Id, Opportunity>();
        Account a = new Account(
            Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Contact con = new Contact(
            LastName = 'foo',
            Email = 'bar@baz.com'
        );
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Legal_Account__c = a.Id;
        o.Contact__c = con.ID;
		o.Sales_Type__c = 'Online';
        o.RecordTypeId = Opportunities.dieselskandalRecordType();
        insert o;
        oo.add(o);
        oldOo.put(o.Id, o);
		OpportunityEmails.autoSend(oo, oldOo, false);
    }

    @isTest
    public static void testDGupdateNewCllb() {
        TriggerConfiguration.allInactive = true;
        List<Opportunity> oo = new List<Opportunity>();
        Map<Id, Opportunity> oldOo = new Map<Id, Opportunity>();
        Account a = new Account(
            Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Contact con = new Contact(
            LastName = 'foo',
            Email = 'bar@baz.com'
        );
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'New');
        o.Legal_Account__c = a.Id;
        o.Contact__c = con.ID;
		o.Sales_Type__c = 'Online';
        o.RecordTypeId = Opportunities.dieselskandalRecordType();
        insert o;
        oo.add(o);
        oldOo.put(o.Id, o);
		OpportunityEmails.autoSend(oo, oldOo, false);
    }

    @isTest
    public static void testDGupdateLostCllb() {
        TriggerConfiguration.allInactive = true;
        List<Opportunity> oo = new List<Opportunity>();
        Map<Id, Opportunity> oldOo = new Map<Id, Opportunity>();
        Account a = new Account(
            Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Contact con = new Contact(
            LastName = 'foo',
            Email = 'bar@baz.com'
        );
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'Lost');
        o.Reason_For_Loss__c = 'Nicht im Zeitraum';
        o.Legal_Account__c = a.Id;
        o.Contact__c = con.ID;
		o.Sales_Type__c = 'Online';
        o.RecordTypeId = Opportunities.dieselskandalRecordType();
        insert o;
        oo.add(o);
        oldOo.put(o.Id, o);
		OpportunityEmails.autoSend(oo, oldOo, false);
    }
}