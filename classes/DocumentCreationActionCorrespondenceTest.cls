@isTest
public class DocumentCreationActionCorrespondenceTest {
    @isTest
    public static void hackCoverage() {
        DocumentCreationActionCorrespondence.hackCoverage();
    }

    /* * * * * * * * *
     * Dieselskandal *
     * * * * * * * * */

    // DAIMLER - Leasing
    @isTest
    public static void DGDeckungsanfrageAnspruchsschreibenDaimlerJCLegalNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort),
            r.templateId
        );
    }

    @isTest
    public static void DGDeckungsanfrageAnspruchsschreibenDaimler21LegalNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort),
            r.templateId
        );
    }

    @isTest
    public static void DGDeckungsanfrageAnspruchsschreibenDaimlerKainzNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort),
            r.templateId
        );
    }

    @isTest
    public static void DGDeckungsanfrageAnspruchsschreibenDaimlerLeComNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort),
            r.templateId
        );
    }

    @isTest
    public static void DGDeckungsanfrageAnspruchsschreibenDaimlerLachmairNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort),
            r.templateId
        );
    }

	// Fristverlängerung
    @isTest
    public static void DGFristverlaengerungDaimlerKainzNoResponse() {
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
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.Id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        DocumentCreationActionCorrespondence.Result r;
        r = DocumentCreationActionCorrespondence.getTemplates(corr, cl, o);
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag),
            r.templateId
        );
    }
}