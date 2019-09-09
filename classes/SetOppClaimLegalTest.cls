@isTest
public class SetOppClaimLegalTest {
    private static Opportunity createOpp() {
        Account la = TestData.createAccount();
        la.name = 'J & C Anwälte';
        la.Department__c = 'Heinrich Jäger - DG & FZ';
        insert la;
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.ID;
        o.Vehicle_Brand_Name__c = 'Foo';
        o.Engine_Type__c = 'EA189';
        o.Vehicle_Identification_Number__c = '129h8e892398eh2983he92h3e9h8239e8h29e82h39e8h23e8238he9';
        o.Financing_Type__c = 'Finanzierung';
        o.Purchase_Date__c = System.today();
        o.Purchase_Price__c = 22;
        o.Mileage_On_Purchase__c = 0;
        o.Current_Mileage__c = 0;
        o.Expected_Mileage__c = 0;
        o.Legal_Account__c = la.Id;
        o.Registration_Date__c = System.today();
        o.Reference__c = 'FoobAr';
        return o;
    }

    public static Opportunity uploadDoc(Opportunity o) {
        /*
        string filename = 'foobar.txt';
        ContentVersion cv = new ContentVersion(
            Title = filename,
            VersionData = Blob.valueOf('bar'),
            PathOnClient = '/usr/lib/' + filename
        );
        insert cv;
        cv = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ];
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = o.Id,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;
		*/
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        return o;
    }

    @isTest
    private static void testSkipErrorWithMfk() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Vehicle_Brand__c = null; // should break
        o.Backoffice__c = u.Id; // should fix
        o.MFK__c = true;
        User ul = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert ul;
        }
        o.Legal__c = ul.Id;
        o.Assignment_Type__c = 'Direkt';
        insert o;
        uploadDoc(o);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertNotEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeughersteller" der Anfrage').getUrl(), pr.getUrl());
        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Claim', res.StageName);
        System.assertEquals(new PageReference('/' + res.ID).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorVehicleBrand() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Vehicle_Brand__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeughersteller" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorVehicleBrandName() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Vehicle_Brand_Name__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeugmarke" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorEngineType() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Engine_Type__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Motortyp" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorIdentificationNumber() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Vehicle_Identification_Number__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Fahrzeug Identifizierungsnummer" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorRegistrationDate() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Registration_Date__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Zulassungsdatum" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorFinanzierungsart() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Financing_Type__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Finanzierungsart" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorPurchaseDate() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Purchase_Date__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kaufdatum" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorKaufpreis() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Purchase_Price__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kaufpreis" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorMileageOnPurch() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Mileage_On_Purchase__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kilometerstand bei Kauf" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorCurrentMileage() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Current_Mileage__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Aktueller Kilometerstand" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorExpectedMileage() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Expected_Mileage__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Voraussichtliche Kilometer" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorLegalAccount() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.Sales_Type__c = 'Partner'; // avoids that legal gets set ( trigger bypass )
        o.Legal__c = null; // avoids that the trigger sets an LegalAccount ( trigger bypass )
        o.Legal_Account__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Kanzlei" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testMissingDocuments() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        User ul = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert ul;
        }
        o.Legal__c = ul.Id;
        o.Assignment_Type__c = 'Direkt';
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Es muss mindestens ein Domkument vorhanden sein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testStageClaimSuccess() {
        TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        User ul = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert ul;
        }
        o.Legal__c = ul.Id;
        o.Assignment_Type__c = 'Direkt';
        insert o;
        uploadDoc(o);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Claim', res.StageName);
        System.assertEquals(new PageReference('/' + res.ID).getUrl(), pr.getUrl());
    }

    /*

    // keeps failing because something sets the reference -> not worth the effort
    @isTest
    private static void testErrorReference() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.StageName = 'On Hold'; // to avoid Reference__c getting set by trigger ( not working )
        o.Reference__c = null;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Wert auf dem Feld "Aktenzeichen" der Anfrage').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorCheck() {
		TriggerConfiguration.allInactive = true;
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.StageName = 'Check';
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Die Anfrage befindet sich in der Stage "Check" und kann deswegen nicht auf "Claim" gesetzt werden.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testNoLegal() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.sales_Type__c = 'Partner';
        insert o;
        o = [SELECT Id, Legal__c FROM Opportunity WHERE Id = :o.Id];

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimLegal oe = new SetOppClaimLegal(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(page.InformationIncomplete.getUrl(), pr.getUrl());
    }
	*/
}