@isTest
public class SendExampleCalcLeadFZTest {
    private static Lead createLead(string name) {
        PageReference p = Page.SendExampleCalcLeadFZ;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = name;
        insert a;
        Lead l = TestData.createLead();
        l.Account__c = a.ID;
        return l;
    }

    @isTest
    private static void testVR24() {
        Lead l = createLead('VR24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLeadFZ oe = new SendExampleCalcLeadFZ(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    /*@isTest
    private static void testVH24() {
        Lead l = createLead('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        insert l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        SendExampleCalcLeadFZ oe = new SendExampleCalcLeadFZ(sc);

        // Act
        PageReference pr = oe.renderPage();
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }*/
}