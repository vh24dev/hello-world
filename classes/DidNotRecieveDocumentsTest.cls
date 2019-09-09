@isTest
public class DidNotRecieveDocumentsTest {
    private static Opportunity createOpp(string accname, boolean isCallcenter, boolean isContact) {
        PageReference p = Page.DidNotRecieveDocuments;
        Test.setCurrentPage(p);

        User u = TestData.createUser();
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        insert u;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Backoffice__c = u.Id;
        insert o;
        Task t = Utilities.createTask('Foo task', 'foo desc', o, u, System.today(), false, false);
        t.Type = 'Q&A';
        insert t;
        if (isCallcenter == true) {
            o.Callcenter__c = u.Id;
            o.Callcenter__r = u;
        }
        if (isContact == true) {
            Contact c = new Contact(FirstName = 'foo', LastName = 'bar');
            insert c;
            o.Contact__c = c.Id;
        }
        return o;
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24', true, true);
        System.debug('testcallcenter: ' + o.Callcenter__r);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DidNotRecieveDocuments oe = new DidNotRecieveDocuments(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testVR24() {
        Opportunity o = createOpp('VR24', true, true);
        System.debug('testcallcenter: ' + o.Callcenter__r);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DidNotRecieveDocuments oe = new DidNotRecieveDocuments(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testNoCallcenter() {
        Opportunity o = createOpp('VH24', false, false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DidNotRecieveDocuments oe = new DidNotRecieveDocuments(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VH24', true, false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        DidNotRecieveDocuments oe = new DidNotRecieveDocuments(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();
    }
}