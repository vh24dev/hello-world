@isTest
public class SendDocViaLetterOrFaxTest {
    private static Opportunity createOpp() {
        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Assignment_Type__c = 'RSV';
        insert o;
		return o;
    }

    @isTest
    private static void testNoCompetetCourtOpponent() {
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Competent_Court__c = 'Opponent';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('ein Gericht des Gegners auf dem Fall', oe.errorMsg);
    }

    @isTest
    private static void testCompetetCourtOpponentFZ() {
        Account a = TestData.createAccount();
        a.Type = 'Gericht';
        insert a;
        Opportunity o = createOpp();
        o.RecordTypeId = Opportunities.finanzierungRecordType();
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Competent_Court__c = 'Opponent';
        claim.Court__c = a.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        c.Type__c = 'Widerspruch durch Kunden';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('ein Gericht des Gegners auf dem Fall', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testCompetetCourtOpponentFZWithEmailUtilities() {
        Account a = TestData.createAccount();
        a.Type = 'Gericht';
        insert a;
        Opportunity o = createOpp();
        o.RecordTypeId = Opportunities.finanzierungRecordType();
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Competent_Court__c = 'Opponent';
        claim.Court__c = a.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        c.Type__c = 'Widerspruch durch Kunden';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('ein Gericht des Gegners auf dem Fall', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);

        Test.setCurrentPage(pr);
        EmailUtilities eu = new EmailUtilities();
    }

    @isTest
    private static void testNoCompetetCourtCustomer() {
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Competent_Court__c = 'Customer';
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('ein Gericht des Kunden auf dem Fall', oe.errorMsg);
    }

    @isTest
    private static void testCompetetCourtCustomer() {
        Account a = TestData.createAccount();
        a.Type = 'Gericht';
        insert a;
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Competent_Court__c = 'Customer';
        claim.Court_Customer__c = a.Id;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Court';
        c.Type__c = 'Deckungsanfrage für Widerspruch';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('ein Gericht des Kunden auf dem Fall', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testInsuranceOpposing() {
        Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = con.ID;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Insurance';
        c.Type__c = 'Widerspruch durch Anwalt';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('einen Korrespondenzanwalt auf dem Fall', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testNoInsuranceOpposing() {
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('einen Korrespondenzanwalt auf dem Fall', oe.errorMsg);
    }

    @isTest
    private static void testVehicle() {
		Account a = TestData.createAccount();
        a.Type = 'Fahrzeughersteller';
        insert a;
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Vehicle Brand';
        c.Type__c = 'Deckungsanfrage für Klage';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('einen Fahrzeughersteller auf dem Fall', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testNoVehcile() {
        Opportunity o = createOpp();
        o.Vehicle_Brand__c = null;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Vehicle Brand';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('einen Fahrzeughersteller auf dem Fall', oe.errorMsg);
    }

    @isTest
    private static void testBank() {
		Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp();
        o.Bank__c = a.Id;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Bank';
        c.Type__c = 'Klageschrift';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('ein Kreditinstitut auf der Anfrage', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
        System.assertEquals(true, pr.getUrl().contains('hdl=Klageschrift+versenden.'));
    }

    @isTest
    private static void testNoBank() {
        Opportunity o = createOpp();
        o.Bank__c = null;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Bank';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('ein Kreditinstitut auf der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testRSV() {
		Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert a;
        Opportunity o = createOpp();
        o.Legal_Protection_Insurance__c = a.Id;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Legal Protection Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('eine RSV auf der Anfrage', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testNoRSV() {
        Opportunity o = createOpp();
        o.Legal_Protection_Insurance__c = null;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Legal Protection Insurance';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('eine RSV auf der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testCustomer() {
		Contact con = new Contact(FirstName = 'Foo', LastName = 'Bar');
        insert con;
        Opportunity o = createOpp();
        o.contact__c = con.Id;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Customer';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertNotEquals('einen Kunden auf der Anfrage', oe.errorMsg);
        System.assertEquals('', oe.errorMsg);
        System.assertNotEquals(null, pr);
    }

    @isTest
    private static void testNoCustomer() {
        Opportunity o = createOpp();
        o.Contact__c = null;
        update o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Customer';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('einen Kunden auf der Anfrage', oe.errorMsg);
    }

    @isTest
    private static void testIndividuell() {
        Opportunity o = createOpp();
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Opposing_Counsel__c = null;
        insert claim;
        Correspondence__c c = TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Partner__c = 'Individuell';
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SendDocViaLetterOrFax oe = new SendDocViaLetterOrFax(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals('den wert "Gericht", "Versicherung", "Fahrzeughersteller", "Kreditinstitut", "Rechtsschutzversicherung" oder "Kunde" als Partner auf der Anfrage', oe.errorMsg);
    }
}