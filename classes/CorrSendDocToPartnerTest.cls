@isTest
public class CorrSendDocToPartnerTest {
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
    private static void testRecCourt() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Gericht';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Court__c = a.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(a.Id));
    }

    @isTest
    private static void testRecCourtCustomer() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Gericht';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Court_Customer__c = a.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.debug('url:' + pr.getUrl());
        System.assertEquals(true, pr.getUrl().contains(a.Id));
    }

    @isTest
    private static void testInsuranceOpposing() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        claim.Opposing_Counsel__c = con.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(true, pr.getUrl().contains(con.Id));
    }

    @isTest
    private static void testInsurance() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(true, pr.getUrl().contains(a.Id));
    }

    @isTest
    private static void testNoInsurance() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte tragen Sie eine "Versicherung" auf der Anfrage oder ein "Korrespondenzanwalt" auf dem Fall ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testVehicleBrandOpposing() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        claim.Opposing_Counsel__c = con.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Vehicle Brand';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(true, pr.getUrl().contains(con.Id));
    }

    @isTest
    private static void testVehicleBrand() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        Account VehicleAcc = TestData.createAccount();
        VehicleAcc.Type = 'Fahrzeughersteller';
        insert VehicleAcc;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Insurance__c = a.Id;
        o.Vehicle_Brand__c = VehicleAcc.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        Contact con = new Contact(LastName = 'bar');
        insert con;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Vehicle Brand';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(true, pr.getUrl().contains(VehicleAcc.Id));
    }

    @isTest
    private static void testBank() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Bank__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Bank';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
		System.assertEquals(true, pr.getUrl().contains(a.Id));
    }

    @isTest
    private static void testMissingCourt() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.debug('url: ' + pr.getUrl());
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte tragen Sie ein "Gericht des Gegners" ein.').getUrl(), pr.getUrl());
        // System.assertEquals(null, oe.getRecipient());
    }

    @isTest
    private static void testMissingCourtCustomer() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte tragen Sie ein "Gericht des Kunden" ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testMissingBank() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Bank';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte hinterlegen Sie ein "Kreditinstitut" auf der Anfrage ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testLegal() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Legal_Protection_Insurance__c = a.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Legal Protection Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(a.Id));
    }

    @isTest
    private static void testMissingLegal() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Legal Protection Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte hinterlegen Sie eine "Rechtsschutzversicherung" auf der Anfrage.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testCustomer() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = createOpp(a.ID, 'On Hold');
        o.Contact__c = con.Id;
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(true, pr.getUrl().contains(con.Id));
    }

    @isTest
    private static void testMissingCustomer() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Bitte tragen Sie einen "Kunden" auf der Anfrage ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testElseError() {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        User u = TestData.createUser();
        insert u;
        claim.Clerk__c = u.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Individuell';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrSendDocToPartner oe = new CorrSendDocToPartner(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Errors.page('Empfänger nicht gefunden.', 'Es wurde kein Empfänger gefunden.').getUrl(), pr.getUrl());
    }
}