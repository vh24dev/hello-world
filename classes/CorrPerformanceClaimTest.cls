@isTest
public class CorrPerformanceClaimTest {
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
    private static void testNoInsurance() {
        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Assignment_Type__c = 'RSV';
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrPerformanceClaim oe = new CorrPerformanceClaim(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Es muss eine Versicherung auf der Anfrage vorhanden sein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testWrongInsurance() {
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        a.name = 'Bla';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Assignment_Type__c = 'RSV';
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrPerformanceClaim oe = new CorrPerformanceClaim(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Diese Aktion kann nur mit der Versicherung "Clerical Medical Investment Group Limited" ausgeführt werden.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testCorrectInsurance() {
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        a.name = 'Bla';
        a.External_Id__c = 'lv004';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Assignment_Type__c = 'RSV';
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrPerformanceClaim oe = new CorrPerformanceClaim(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }
}