@isTest
public class FinishedPotentialCheckTest {
    private static Opportunity createOpp() {
        PageReference p = Page.FinishedPotentialCheck;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        return TestData.createOpportunity(a.ID, 'On Hold');
    }

    @isTest
    private static void testCreateTask() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedPotentialCheck oe = new FinishedPotentialCheck(sc);

        // Act
        PageReference pr = oe.renderPage();
        List<Task> tasks = [SELECT Id FROM Task WHERE Subject = 'Potential auslösen' AND WhatId = :oppID];
        System.assertEquals(1, tasks.size());
    }

    @isTest
    private static void testCompleteTask() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        FinishedPotentialCheck oe = new FinishedPotentialCheck(sc);

        // Act
        PageReference pr = oe.renderPage();
        List<Task> tasks = [SELECT Id, Status FROM Task WHERE Status <> 'Completed' AND Subject <> 'Potential auslösen' AND WhatId = :oppID];
        System.assertEquals(0, tasks.size());
    }
}