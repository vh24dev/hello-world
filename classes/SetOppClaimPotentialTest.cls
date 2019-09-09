@isTest
public class SetOppClaimPotentialTest {
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
        return o;
    }

    @isTest
    private static void testError() {
        Opportunity o = createOpp();
        o.Assignment_Type__c = 'Share'; // not RSV
        o.Has_Legal_Protection_Insurance__c = false;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        o.Legal__c = u.Id;
        insert o;
        uploadDoc(o);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimPotential oe = new SetOppClaimPotential(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        PageReference pageRef;
        String errorSubject = 'Fehler bei Übergabe des Prozesses.';
        String errorMessage = 'Anfragen ohne Rechtsschutzversicherung und Motortyp EA189 können nicht an Anwalt oder Finanzierungsprozess übergeben werden.';
        pageRef = Errors.page(errorSubject, errorMessage);
        System.assertEquals(pageRef.getUrl(), pr.getUrl());
    }

    @isTest
    private static void testMissingBackoffice() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        o.Legal__c = u.Id;
        insert o;
        uploadDoc(o);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimPotential oe = new SetOppClaimPotential(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        System.assertEquals(Errors.page('Bitte tragen Sie einen Backoffice Mitarbeiter ein.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testStageNoClaim() {
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
        insert o;
        uploadDoc(o);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimPotential oe = new SetOppClaimPotential(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Claim', res.StageName);
        System.assertEquals(new PageReference('/' + res.ID).getUrl(), pr.getUrl());
    }

    @isTest
    private static void testStageClaim() {
        Opportunity o = createOpp();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        User u = TestData.createUser();
        insert u;
        o.Backoffice__c = u.Id;
        o.StageName = 'Claim';
        User ul = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert ul;
        }
        o.Legal__c = ul.Id;
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        SetOppClaimPotential oe = new SetOppClaimPotential(sc);

        // Act
        PageReference pr = oe.renderPage();

        // test
        // nothing updated everything should stay the same
        Opportunity res = [SELECT Id, StageName FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Claim', res.StageName);
        System.assertEquals(new PageReference('/' + res.ID).getUrl(), pr.getUrl());
    }
}