@isTest
public class SetCorrespondenceSentTest {
    private static Correspondence__c createCorr() {
        PageReference p = Page.SetCorrespondenceSent;
        Test.setCurrentPage(p);

        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.name = 'Bla';
        a.Type = 'Lebensversicherung';
        insert a;
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity o = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = a.Id,
            CloseDate = System.today(),
            StageName = 'On Hold',
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(
            Opportunity__c = o.Id,
            Stage__c = 'Appeal',
            Clerk__c = u.Id
        );
        insert claim;
        return TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Draft');
    }

    @isTest
    private static void testWiderspruchAndFollowUpTrue() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Widerspruch durch Kunden';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();

        c = [SELECT Id, Wiedervorlage_erstellen__c FROM Correspondence__c WHERE Id = :c.Id];
        System.assertEquals(false, c.Wiedervorlage_erstellen__c); // set to false by process that creates the task

        List<Task> tasks = [SELECT Id, Status FROM Task WHERE Subject LIKE 'Wiedervorlage%' AND WhatId = :c.Id]; // created by process builder
        System.assertEquals(1, tasks.size());
    }

    @isTest
    private static void testDeckungsanfrageAndFollowUpFalse() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Deckungsanfrage für Anspruchsschreiben';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = false;
        PageReference pr = oe.renderPage();

        c = [SELECT Id, Wiedervorlage_erstellen__c FROM Correspondence__c WHERE Id = :c.Id];
        System.assertEquals(false, c.Wiedervorlage_erstellen__c);
    }

    @isTest
    private static void testAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Anspruchsschreiben';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Deckungsanfrage für Widerspruch';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testWiderspruchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Widerspruch durch Anwalt';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Deckungsanfrage für Klage';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Klageschrift';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Deckungsanfrage für Berufung';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testReplikAppeal() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Replik';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Gerichtskostenrechnung';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVollmacht() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Vollmacht §141 ZPO';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testSonstiges() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Sonstiges';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testEingehend() {
        TriggerConfiguration.allInactive = true;
        Correspondence__c c = createCorr();
        c.Type__c = 'Eingehend';
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceSent oe = new SetCorrespondenceSent(sc);

        // Act
        oe.parCreateFollowUp = true;
        PageReference pr = oe.renderPage();
    }
}