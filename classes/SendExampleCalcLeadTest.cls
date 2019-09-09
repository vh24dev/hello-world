@isTest
public class SendExampleCalcLeadTest {
    private static Lead createLead(string accname) {
        PageReference p = Page.SendExampleCalcLead;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Lead l = TestData.createLead();
        l.Account__c = a.Id;
        return l;
    }

    @isTest
    private static void testDieselSkandalVH24() {
        Lead l = createLead('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLead oe = new SendExampleCalcLead(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testDieselSkandalVR24() {
        Lead l = createLead('VR24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLead oe = new SendExampleCalcLead(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungVH24() {
        Lead l = createLead('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLead oe = new SendExampleCalcLead(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testFinanzierungVR24() {
        Lead l = createLead('VR24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLead oe = new SendExampleCalcLead(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

	@isTest
    private static void testLebenesversicherungVH24() {
        User u = TestData.bypassUser();
        insert u;
        System.runAs(u) {
            Lead l = createLead('VH24');
            RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Lead'];
            l.recordTypeId = rt.ID;
            insert l;
    
            Apexpages.StandardController sc = new Apexpages.standardController(l);
            SendExampleCalcLead oe = new SendExampleCalcLead(sc);
    
            // Act
            PageReference pr = oe.renderPage();
            Test.setCurrentPage(pr);
            EmailUtilities eu = new EmailUtilities();
        }
    }

    @isTest
    private static void testLebenesversicherungVR24() {
        Lead l = createLead('VR24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLead oe = new SendExampleCalcLead(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}