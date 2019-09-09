@isTest
public class DidNotReceiveContractTest {
    private static Opportunity createOpp(string accname) {
        TriggerConfiguration.allInactive = true;
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        o.Contact__c = null;
        insert o;
        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        DidNotReceiveContract oe = new DidNotReceiveContract(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde" auf der Anfrage.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testTask() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        User u = TestData.createUser();
        insert u;

        Task t = Tasks.build(
            'Unterschriebenen Vertrag hochladen und Erhalt bestätigen', // subject
            null, // description
            o, // parentObj
            u, // owner
            System.today(), // acitivity date
            true, // no duplicates
            false // followup
        );
        if (t != null) {
            insert t;
        }
        List<Task> ts = [SELECT Id, WhatId FROM Task WHERE Subject = 'Unterschriebenen Vertrag hochladen und Erhalt bestätigen'];
        System.assertEquals(1, ts.size());
        System.assertEquals(o.Id, ts[0].WhatID);

        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        DidNotReceiveContract oe = new DidNotReceiveContract(sc);

        PageReference pr = oe.renderPage();

        ts = [SELECT Id, ActivityDate FROM Task WHERE Subject = 'Unterschriebenen Vertrag hochladen und Erhalt bestätigen'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    private static void testVH4() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        DidNotReceiveContract oe = new DidNotReceiveContract(sc);

        PageReference pr = oe.renderPage();
        // System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveContractVh24)));
    }

    @isTest
    private static void testVR4() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Contract__c ctr = new Contract__c(
            Opportunity__c = o.Id
        );
        insert ctr;

        Apexpages.StandardController sc = new Apexpages.standardController(ctr);
        DidNotReceiveContract oe = new DidNotReceiveContract(sc);

        PageReference pr = oe.renderPage();
        // System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.name.LvCallcenterDidNotReceiveContractVh24)));
    }
}