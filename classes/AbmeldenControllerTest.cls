@isTest
public class AbmeldenControllerTest {
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

    @isTest
    public static void testErrorToken() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        insert o;

        PageReference pref = Page.Abmelden;
        test.setCurrentPageReference(pref);
        pref.getParameters().put('token', 'invalid_token');
        AbmeldenController oe = new AbmeldenController();

        // Act
        PageReference pr = oe.init();
        System.assertEquals(true, pr.getUrl().contains('Token'));
    }

    @isTest
    public static void testDecline() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Token__c = '123';
        insert o;

        PageReference pref = Page.Abmelden;
        test.setCurrentPageReference(pref);
        pref.getParameters().put('token', '123');
        AbmeldenController oe = new AbmeldenController();

        // Act
        PageReference pr = oe.init();
        System.assertEquals(null, pr);

        pr = oe.optOut();
        System.assertEquals(true, pr.getUrl().contains('AbmeldenAbgelehnt'));
    }

    @isTest
    public static void testOptOutOpp() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Token__c = '123';
        insert o;

        PageReference pref = Page.Abmelden;
        test.setCurrentPageReference(pref);
        pref.getParameters().put('token', '123');
        AbmeldenController oe = new AbmeldenController();

        // Act
        PageReference pr = oe.init();
        System.assertEquals(null, pr);

        oe.signedOut = 'Yes';
        pr = oe.optOut();
        System.assertEquals(true, pr.getUrl().contains('AbmeldenFertig'));

        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        //System.assertEquals('Closed Lost', res.StageName);//change stage form Lost To Closed Lost
    }

    @isTest
    public static void testOptOutLead() {
        Lead l = TestData.createLead();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        l.Token__c = '123';
        l.Assignment_Type__c = 'Direkt';
        l.Has_Legal_Protection_Insurance__c = true; // avoids assignment type getting updated by process builder
        insert l;

        PageReference pref = Page.Abmelden;
        test.setCurrentPageReference(pref);
        pref.getParameters().put('token', '123');
        AbmeldenController oe = new AbmeldenController();

        // Act
        PageReference pr = oe.init();
        System.assertEquals(null, pr);

        oe.signedOut = 'Yes';
        pr = oe.optOut();
        System.assertEquals(true, pr.getUrl().contains('AbmeldenFertig'));

        Lead res = [SELECT Id, Status FROM Lead WHERE Id = :l.Id];
        System.assertEquals('Lost', res.Status);
    }

    @isTest
    public static void testCoverRest() {
        Lead l = TestData.createLead();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Lead'];
        l.recordTypeId = rt.ID;
        l.Token__c = '123';
        l.Assignment_Type__c = 'Direkt';
        insert l;

        PageReference pref = Page.Abmelden;
        test.setCurrentPageReference(pref);
        AbmeldenController oe = new AbmeldenController();

        // Act
        PageReference pr = oe.init();
        oe.getYN();
    }
}