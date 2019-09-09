@isTest
public class StartPhoneCallTest {
    private static Opportunity createOpp(string phoneNum) {
        PageReference p = Page.StartPhoneCall;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
        c.Phone = phoneNum;
        insert c;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Contact__c = c.Id;
        insert o;
        return o;
    }

    private static Lead createLead(string phoneNum) {
        Lead l = TestData.createLead();
        l.Phone = phoneNum;
        insert l;
        return l;
    }

    @isTest
    private static void testOppNoPhone() {
        Opportunity o = createOpp('');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        StartPhoneCall oe = new StartPhoneCall(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    @isTest
    private static void testOppPhone() {
        string num = '4242424242424';
        Opportunity o = createOpp(num);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        StartPhoneCall oe = new StartPhoneCall(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('callto:' + num, pr.getUrl());
    }

    @isTest
    private static void testLeadPhone() {
        string num = '4242424242424';
        Lead l = createLead(num);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        update l;

        Apexpages.StandardController sc = new Apexpages.standardController(l);
        StartPhoneCall oe = new StartPhoneCall(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('callto:' + num, pr.getUrl());
    }
}