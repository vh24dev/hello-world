@isTest
public class QuestionToCallcenterTest {
    public static Opportunity createOpp(Id accountId, String stageName) {
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity opp = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountId,
            CloseDate = System.today(),
            StageName = stageName,
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        return opp;
    }

    private static Opportunity createOpp(string accname, boolean isCallcenter) {
        PageReference p = Page.QuestionToCallcenter;
        Test.setCurrentPage(p);

        User u = TestData.createUser();
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        insert u;
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
        return o;
    }

    @isTest
    private static void testCallcenter() {
        Opportunity o = createOpp('VH24', true);
        System.debug('testcallcenter: ' + o.Callcenter__r);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        QuestionToCallcenter oe = new QuestionToCallcenter(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Frage des Backoffices'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    private static void testNoCallcenter() {
        Opportunity o = createOpp('VH24', false);
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        update o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        QuestionToCallcenter oe = new QuestionToCallcenter(sc);

        // Act
        oe.parDescription = 'Foo bar';
        PageReference pr = oe.renderPage();

        // should not create a task when the callcenter is missing
        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Frage des Backoffices'];
        System.assertEquals(0, ts.size());
    }
}