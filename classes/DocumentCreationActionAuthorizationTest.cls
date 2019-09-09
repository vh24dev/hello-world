@isTest
public class DocumentCreationActionAuthorizationTest {
    /* * * * * * * * *
     * Dieselskandal *
     * * * * * * * * */

    // DAIMLER - Leasing
    @isTest
    public static void testDGDaimlerJCLegalLeasing() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtohneGegner),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGDaimlerLachmairLeasing() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtohneGegner),
            r.templateIds[0]
        );
    }

    // DAIMLER
    @isTest
    public static void testDGDaimlerJCLegal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtDaimler),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGDaimler21Legal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtDaimler),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGDaimlerKainz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtDaimler),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGDaimlerLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtDaimler),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGDaimlerLachmair() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtDaimler),
            r.templateIds[0]
        );
    }

    // PROSCHE
    @isTest
    public static void testDGPorscheJCLegal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Porsche AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtPorsche),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGPorsche21Legal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Account av = new Account(
            Name='Porsche AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtPorsche),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGPorscheKainz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Porsche AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtPorsche),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGPorscheLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Porsche AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtPorsche),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGPorscheLachmair() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Account av = new Account(
            Name='Porsche AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtPorsche),
            r.templateIds[0]
        );
    }

    // AUDI
    @isTest
    public static void testDGAudiJCLegal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtAudi),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGAudi21Legal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtAudi),
            r.templateIds[0]
        );
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtVW),
            r.templateIds[1]
        );
    }

    @isTest
    public static void testDGAudiKainz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtAudi),
            r.templateIds[0]
        );
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtVW),
            r.templateIds[1]
        );
    }

    @isTest
    public static void testDGAudiLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtAudi),
            r.templateIds[0]
        );
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtVW),
            r.templateIds[1]
        );
    }

    @isTest
    public static void testDGAudiLachmair() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtAudi),
            r.templateIds[0]
        );
    }

    // OPEL
    @isTest
    public static void testDGOpelJCLegal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Opel Automobile GmbH',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtOpel),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testDGOpelLachmair() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Account av = new Account(
            Name='Opel Automobile GmbH',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtOpel),
            r.templateIds[0]
        );
    }

	/* * * * * * * * *
	 * Finanzierung  *
	 * * * * * * * * */

    @isTest
    public static void testFZAudiJCLegal() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerVollmacht),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testFZAudiKainz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzVollmacht),
            r.templateIds[0]
        );
    }

    @isTest
    public static void testFZAudiLeCom() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Audi AG',
            Type = 'Fahrzeughersteller',
            Created_Date_Old_Org__c = System.today()
        );
        insert av;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id,
            Vehicle_Brand__c = av.Id
        );
        insert o;
        DocumentCreationActionAuthorization.Result r;
        r = DocumentCreationActionAuthorization.getTemplates(o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComVollmacht),
            r.templateIds[0]
        );
    }
}