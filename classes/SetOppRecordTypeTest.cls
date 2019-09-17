@isTest
public class SetOppRecordTypeTest {
    private static Opportunity createOpp() {
        PageReference p = Page.SetOppRecordType;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
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
        return o;
    }

    @isTest
    private static void testErrorFinanzierung() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Finanzierung' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        // a.Type = 'Rechtsschutzversicherung';
        insert a;
        o.Backoffice__c = u.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.debug('url: ' + pr.getUrl());
        System.assertEquals(true, pr.getUrl().contains('Finanzierung'));
    }

    @isTest
    private static void testErrorEngine() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Engine_Type__c = 'EA189';
        o.Assignment_Type__c = 'Direkt'; // 'Share';
        User u = TestData.createUser();
        insert u;
        Account a = TestData.createAccount();
        // a.Type = 'Rechtsschutzversicherung';
        insert a;
        o.Backoffice__c = u.Id;
        o.Has_Legal_Protection_Insurance__c = false;
        // o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.debug('url: ' + pr.getUrl());
        System.assertEquals(true, pr.getUrl().contains('Anfragen+ohne+Rechtsschutzversicherung+und+Motortyp+EA189'));
    }

    @isTest
    private static void testErrorBackoffice() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Backoffice'));
    }

    /*
    @isTest
    private static void testErrorProtInsurance() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Rechtsschutzversicherung'));
    }
	*/
    /*
    @isTest
    private static void testErrorBank() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Kreditinstitut'));
    }
	*/
    /*
    @isTest
    private static void testErrorConDate() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Finanzierungsvertragsdatum'));
    }
	*/
    /*
    @isTest
    private static void testErrorFianceTotal() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Finanzierungsvertrag+Gesamtbetrag'));
    }
	*/
    /*
    @isTest
    private static void testErrorPaidInstall() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Bisher+geleistete+Rate'));
    }
	*/
    /*
    @isTest
    private static void testErrorMonthlyRate() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Monatliche+Raten'));
    }
	*/
    /*
    @isTest
    private static void testErrorCreditContract() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        insert o;
        Id oppID = o.Id;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Kreditvertragsnummer'));
    }
	*/
    @isTest
    private static void testErrorReference() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = 'gha9wd89w';
        insert o;
        Id oppID = o.Id;
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        System.assertEquals(true, pr.getUrl().contains('Aktenzeichen'));
    }

    @isTest
    private static void testSuccess() {
	TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.Legal_Protection_Insurance__c = a.Id;
        o.Financing_Contract_Date__c = System.today();
        o.Bank__c = a.Id;
        o.Finanzierungsvertrag_Gesamtbetrag__c = 2;
        o.Paid_Installments__c = 2;
        o.Monthly_Rate__c = 2;
        o.Credit_Contract_Numbe__c = '4242';
        o.Reference__c = 'foo';
        insert o;
	TriggerConfiguration.allInactive = false;
        Id oppID = o.Id;
		System.debug('Id of recently inserted opp is ' + oppID);
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppRecordType oe = new SetOppRecordType(sc);

        // Act
        PageReference pr = oe.renderPage();

        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppID];
        System.assertEquals('Claim', res.StageName);
    }
}
