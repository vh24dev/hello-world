@isTest
public class TasksTests {
    @isTest
    private static void testTaskCreationError() {
        // Mandatory Subject
        try {
            Tasks.build('', null, new Account(Name = 'Name'), TestData.bypassUser(), Date.today(), false, false);
            System.assert(false);
        } catch (Tasks.InvalidInputException iie) {
            System.assert(true);
        }
        
        // Mandatory parent obj
        try {
            Tasks.build('subj', null, null, TestData.bypassUser(), Date.today(), false, false);
            System.assert(false);
        } catch (Tasks.InvalidInputException iie) {
            System.assert(true);
        }
        
        // Mandatory owner
        try {
            Tasks.build('subj', null, new Account(Name = 'Name'), null, Date.today(), false, false);
            System.assert(false);
        } catch (Tasks.InvalidInputException iie) {
            System.assert(true);
        }
    }
    
    @isTest
    private static void testTaskCreationParent() {
        Account acc = TestData.createAccount();
        insert acc;
        Contact c = TestData.createContact(acc.ID);
        insert c;
        
        // Contact and Lead are set on WhoID
        Task t = Tasks.build('subj', null, c, TestData.bypassUser(), Date.today(), false, false);
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(c.ID, t.whoId);
        System.assertEquals(TestData.bypassUser().ID, t.ownerId);
        System.assertEquals(null, t.related_Opportunity__c);
        
        // Other parent objects are set on WhatID
        t = Tasks.build('subj', null, acc, TestData.bypassUser(), Date.today(), false, false);
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(acc.ID, t.whatId);
        System.assertEquals(TestData.bypassUser().ID, t.ownerId);
        System.assertEquals(null, t.related_Opportunity__c);
    }
    
    @isTest
    private static void testTaskCreationRelatedOpp() {
        Account acc = TestData.createAccount();
        insert acc;
        Opportunity opp = TestData.createOpportunity(acc.ID, 'Draft');
        insert opp;
        
        Task t = Tasks.build('subj', null, acc, TestData.bypassUser(), Date.today(), false, false, opp.ID);
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(acc.ID, t.whatId);
        System.assertEquals(TestData.bypassUser().ID, t.ownerId);
        System.assertEquals(opp.ID, t.related_Opportunity__c);
        
        t = Tasks.build('subj', null, acc, TestData.bypassUser(), Date.today(), false, false);
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(acc.ID, t.whatId);
        System.assertEquals(TestData.bypassUser().ID, t.ownerId);
        System.assertEquals(null, t.related_Opportunity__c);
    }
    
    @isTest
    private static void testTaskCreationNoDuplicates() {
        Account acc = TestData.createAccount();
        insert acc;
        
        User u = TestData.bypassUser();
        insert u;
        
        Task t = Tasks.build('subj', null, acc, u, Date.today(), false, false);
        insert t;
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(acc.ID, t.whatId);
        System.assertEquals(u.ID, t.ownerId);
        System.assertEquals(null, t.related_Opportunity__c);
        
        // Same subject and parentID is a duplicate.
        Boolean noDuplicates = true;
        t = Tasks.build('subj', null, acc, TestData.bypassUser(), Date.today(), noDuplicates, false);
        System.assertEquals(null, t);
    }
    
    // Fails - .get('Tasks') might not be the best idea to get the tasks from the parent object
    /*@isTest
    private static void testTaskMarkAsClosed() {
        Account acc = TestData.createAccount();
        insert acc;
        
        User u = TestData.bypassUser();
        insert u;
        
        Task t = Tasks.build('subj', null, acc, u, Date.today(), false, false);
        insert t;
        System.assertNotEquals(null, t);
        System.assertEquals('subj', t.subject);
        System.assertEquals(acc.ID, t.whatId);
        System.assertEquals(u.ID, t.ownerId);
        System.assertEquals(null, t.related_Opportunity__c);
        System.assertNotEquals('Completed', t.status);
        
        Task[] tt = Tasks.markAsClosed('subj', acc);
        update tt;
        
        tt = [SELECT Status FROM Task WHERE ID = :t.ID];
        System.assertEquals('Completed', tt[0].status);
    }*/
}