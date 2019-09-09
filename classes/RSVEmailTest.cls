@isTest
public class RSVEmailTest {
    private static Opportunity createOpp(string accname, boolean hasContact) {
        PageReference p = Page.RSVEmail;
        Test.setCurrentPage(p);
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
        if (hasContact == true) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VH24', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        RSVEmail oe = new RSVEmail(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        RSVEmail oe = new RSVEmail(sc);

        // Act
        PageReference pr = oe.renderPage();
		string tplStr = '&tpl=' + EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterRsvEmailVh24);
        System.assertEquals(true, pr.getUrl().contains(tplStr));
    }

    @isTest
    private static void testVR24() {
        Opportunity o = createOpp('VR24', true);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        RSVEmail oe = new RSVEmail(sc);

        // Act
        PageReference pr = oe.renderPage();
        string tplStr = '&tpl=' + EmailTemplates.idOf(EmailTemplates.name.DieselskandalCallcenterRsvEmailVr24);
        System.assertEquals(true, pr.getUrl().contains(tplStr));
    }
}