@isTest
public class TaskTriggerHandlerTests {
	@isTest
    private static void testRelatedOpportunity() {
        // If Task has no RelatedOpportunity set, and the parent object (WhatID) is one of the supported ones,
        // we want to set RelatedOpportunity to the Opp linked to the parent object.
        // Supported parent objects: Opportunity, Claim, Opportunity Correspondence, or Correspondence.
        
        User u = TestData.bypassUser();
        insert u;

        Account acc = TestData.createAccount();
        insert acc;
        
        // Skip if RelatedOpp is provided
        Opportunity opp = TestData.createOpportunity(acc.ID, 'New');
        insert opp;
        Claim__c c = TestData.createClaim(opp.ID, 'Draft');
        insert c;
        Task t = Tasks.build('subject', 'description', c, u, Date.today(), true, false, opp.ID);
        insert t;

        t = [SELECT Related_Opportunity__c FROM Task WHERE ID = :t.ID];
        System.assertEquals(opp.ID, t.related_Opportunity__c);

		delete t;
        
        // No RelatedOpp but parent object as:

        // Opp
        t = Tasks.build('subject', 'description', opp, u, Date.today(), true, false);
        insert t;
        
        t = [SELECT Related_Opportunity__c FROM Task WHERE ID = :t.ID];
        System.assertEquals(opp.ID, t.related_Opportunity__c);

        delete t;

        // Claim
        t = Tasks.build('subject', 'description', c, u, Date.today(), true, false);
        insert t;
        
        t = [SELECT Related_Opportunity__c FROM Task WHERE ID = :t.ID];
        System.assertEquals(c.opportunity__c, t.related_Opportunity__c);
        
        delete t;
        
        // Correspondence
        Correspondence__c corr = TestData.createCorrespondence(c.Id, 'Insurance', 'Widerspruch durch Kunden', 'Draft');
        insert corr;
        corr = [SELECT Claim__r.Opportunity__c FROM Correspondence__c WHERE ID = :corr.ID];
        
        t = Tasks.build('subject', 'description', corr, u, Date.today(), true, false);
        insert t;
        
        t = [SELECT Related_Opportunity__c FROM Task WHERE ID = :t.ID];
        System.assertEquals(corr.claim__r.opportunity__c, t.related_Opportunity__c);
        
        delete t;
        
        // Opportunity Correspondence
        Opportunity_Correspondence__c oc = TestData.createOpportunityCorrespondence(opp.ID, 'Customer', 'Sent');
        insert oc;

        t = Tasks.build('subject', 'description', oc, u, Date.today(), true, false);
        insert t;
        
        t = [SELECT Related_Opportunity__c FROM Task WHERE ID = :t.ID];
        System.assertEquals(oc.opportunity__c, t.related_Opportunity__c);
        
        delete t;
    }
}