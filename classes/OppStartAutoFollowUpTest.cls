@isTest
public class OppStartAutoFollowUpTest {
    private static Opportunity createOpp(string accname, string legalname, boolean isCallcenter) {
        Account la = TestData.createAccount();
        la.name = legalname;
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;

		User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        o.Backoffice__c = u.Id;
        if (isCallcenter == true) {
            o.Callcenter__c = u.Id;
            o.Callcenter__r = u;
        }
        return o;
    }

    @isTest
    private static void testNoCallcenter() {
        Opportunity o = createOpp('VH24', 'J & C Anwälte', false);
        o.RecordTypeId = Opportunities.lebensversicherungRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppStartAutoFollowUp oe = new OppStartAutoFollowUp(sc);

        // Act
        PageReference pr = oe.renderPage();

        // should not create a task when the callcenter is missing
        List<Task> ts = [SELECT Id FROM Task];
        System.assertEquals(0, ts.size());
    }

    @isTest
    private static void testStageNew() {
        Opportunity o = createOpp('VR24', 'J & C Anwälte', true);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        o.StageName = 'New';
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppStartAutoFollowUp oe = new OppStartAutoFollowUp(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Auto_Follow_up_Date__c FROM Opportunity WHERE Id = :o.Id];
        Datetime nowDate = System.now();
        Datetime resDate = o.Auto_Follow_up_Date__c;
        System.assertEquals(nowDate.year(), resDate.year());
        System.assertEquals(nowDate.month(), resDate.month());
        System.assertEquals(nowDate.day(), resDate.day());
        System.assertEquals(nowDate.hour(), resDate.hour());
    }

    @isTest
    private static void testStageCheck() {
        Opportunity o = createOpp('VR24', 'J & C Anwälte', true);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        o.StageName = 'Check';
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppStartAutoFollowUp oe = new OppStartAutoFollowUp(sc);

        // Act
        PageReference pr = oe.renderPage();
        o = [SELECT Id, Auto_Follow_up_Date__c FROM Opportunity WHERE Id = :o.Id];
        Datetime nowDate = System.now();
        Datetime resDate = o.Auto_Follow_up_Date__c;
        System.assertEquals(nowDate.year(), resDate.year());
        System.assertEquals(nowDate.month(), resDate.month());
        System.assertEquals(nowDate.day(), resDate.day());
        System.assertEquals(nowDate.hour(), resDate.hour());
    }

    @isTest
    private static void testSendMail() {
        Opportunity o = createOpp('VR24', 'J & C Anwälte', true);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppStartAutoFollowUp oe = new OppStartAutoFollowUp(sc);

        // Act
        PageReference pr = oe.renderPage();

        // send mail
        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }
}