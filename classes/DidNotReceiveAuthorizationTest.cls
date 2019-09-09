@isTest
public class DidNotReceiveAuthorizationTest {
    private static Opportunity createOpp(string accname) {
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        Account a = TestData.createAccount();
        a.name = accname;
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
        o.Account__c = a.Id;
        o.Legal_Account__c = la.Id;
        Contact c = new Contact(FirstName = 'foo', LastName = 'bar', Email = 'baz@de.de');
        insert c;
        o.Contact__c = c.Id;
        return o;
    }

    @isTest
    private static void testNoContact() {
        Opportunity o = createOpp('VH24');
        o.Contact__c = null;
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        DidNotReceiveAuthorization oe = new DidNotReceiveAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertEquals(pr, null);
        System.assertEquals('einen Kontakt auf dem Feld "Kunde" der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testVH24() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        DidNotReceiveAuthorization oe = new DidNotReceiveAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals('', oe.errorMsg);
    }

    @isTest
    private static void testVR24() {
        Opportunity o = createOpp('VR24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id
        );
        insert auth;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        DidNotReceiveAuthorization oe = new DidNotReceiveAuthorization(sc);

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals('', oe.errorMsg);
    }

    /*
    @isTest
    private static void testVH24Task() {
        Opportunity o = createOpp('VH24');
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Authorization__c auth = new Authorization__c(
            Opportunity__c = o.Id,
            Follow_up_Period__c = 22
        );
        insert auth;
        User u = TestData.createUser();
        insert u;

        Apexpages.StandardController sc = new Apexpages.standardController(auth);
        DidNotReceiveAuthorization oe = new DidNotReceiveAuthorization(sc);

		Task t = Tasks.build(
            'Unterschriebene Vollmacht hochladen und Erhalt bestätigen', // subject
            null, // description
            auth, // parent object
            u, // owner
            System.today(), // due date
            true, // no duplicated
            false // follow up
        );
        if (t != null) {
            t.ActivityDate = System.today();
            insert t;
        }
        List<Task> ts = [SELECT ID, ActivityDate FROM Task WHERE Subject = 'Unterschriebene Vollmacht hochladen und Erhalt bestätigen'];
        System.assertEquals(1, ts.size());
        Datetime tDate = ts[0].ActivityDate;
        Datetime nDate = Datetime.now();
        System.assertEquals(nDate.year(), tDate.year());
        System.assertEquals(nDate.month(), tDate.month());
        System.assertEquals(nDate.day(), tDate.day());

        PageReference pr = oe.renderPage();

        System.assertNotEquals(pr, null);
        System.assertEquals('', oe.errorMsg);

        ts = [SELECT ID, ActivityDate FROM Task WHERE Subject = 'Unterschriebene Vollmacht hochladen und Erhalt bestätigen'];
        System.assertEquals(1, ts.size());
        tDate = ts[0].ActivityDate;
        nDate = Datetime.now();
        System.assertNotEquals(nDate.day(), tDate.day());
        nDate = Datetime.now().addDays(22);
        System.assertEquals(nDate.year(), tDate.year());
        System.assertEquals(nDate.month(), tDate.month());
        System.assertEquals(nDate.day(), tDate.day());
    }
	*/

	@isTest
    static void TaskLegacy() {
		// Testsetup
		TriggerConfiguration.allInactive = true;

		// Create test data
		User user = TestData.createUser();
		insert user;
		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Authorization__c authorization = TestData.createAuthorization(opportunity.Id);
		insert authorization;
		Task task = TestData.createTask('Unterschriebene Vollmacht hochladen und Erhalt bestätigen',authorization.Id,user.Id);
		insert task;

		TriggerConfiguration.allInactive = false;

		// Test
		Test.startTest();

        Apexpages.StandardController sc = new Apexpages.standardController(authorization);
        DidNotReceiveAuthorization oe = new DidNotReceiveAuthorization(sc);
        PageReference pr = oe.renderPage();

		Test.stopTest();

		// Assertion
		task = [select Id, ActivityDate from Task where Id = :task.Id];
		System.assert(task.ActivityDate != System.today());
	}
}