@isTest
public class EmailUtilitiesCorrespondenceTest {
    /* * * * * * * * * *
     *  Dieselskandal  *
     * * * * * * * * * */
    // JCLegal - DG
	@isTest
    public static void testDGJCLegalDeckungsanfrageAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateId);
    }

	@isTest
    public static void testDGJCLegalAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateId);
    }

    @isTest
    public static void testDGJCLegalDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateId);
    }

    @isTest
    public static void testDGJCLegalKlageschriftFinanzierung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID,
            Financing_Type__c = 'Finanzierung'
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateId);
    }

    @isTest
    public static void testDGJCLegalKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateId);
    }

    @isTest
    public static void testDGJCLegalDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalReplik() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Replik'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalVollmachtZPO() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Vollmacht §141 ZPO'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }
    
    @isTest
    public static void testDGJCLegalDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGJCLegalFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    // 21Legal - DG
    @isTest
    public static void testDG21LegalDeckungsanfrageAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalReplik() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Replik'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalVollmachtZPO() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Vollmacht §141 ZPO'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDG21LegalSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    // Kainz - DG
    @isTest
    public static void testDGKainzAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzReplik() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Replik'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzVollmachtZPO() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Vollmacht §141 ZPO'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGKainzFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    // LeCom - DG

    @isTest
    public static void testDGLeComDeckungsanfrageAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

	@isTest
    public static void testDGLeComAnspruchsschreiben() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Anspruchsschreiben'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComKlageschriftFz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID,
            Financing_Type__c = 'Finanzierung'
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComReplik() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Replik'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComVollmachtZPO() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Vollmacht §141 ZPO'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testDGLeComDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLeComVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLeComFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LeComLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    // Lachmair
    @isTest
    public static void testDGLachmairKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LegalLachmairID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLachmairGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LegalLachmairID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLachmairReplik() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LegalLachmairID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Replik'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLachmairVollmachtZPO() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LegalLachmairID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Vollmacht §141 ZPO'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testDGLachmairSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='Rechtsanwälte Lachmair & Kollegen'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = Accounts.LegalLachmairID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

	/* * * * * * * * *
	 * Finanzierung  *
	 * * * * * * * * */
	// JCLegal - FZ
    @isTest
    public static void testFZJCLegalWiderspruchKunden() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Widerspruch'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalWiderspruchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    /*
    // TODO: broken
    @isTest
    public static void testFZJCLegalGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }
	*/

    @isTest
    public static void testFZJCLegalSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZJCLegalFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    // Kainz - FZ
    @isTest
    public static void testFZKainzWiderspruchKunden() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Widerspruch'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzWiderspruchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzGerichtskostenrechnung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Gerichtskostenrechnung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    @isTest
    public static void testFZKainzSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
    }

    /* * * * * * * * * * * *
     * Lebensversicherung  *
     * * * * * * * * * * * */

    // 21Legal - LV

    @isTest
    public static void testLV21LegalWiderspruchdurchKunden() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLV21LegalDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Widerspruch'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLV21LegalWiderspruchdurchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLV21LegalDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLV21LegalKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLV21LegalSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='21Legal GmbH'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.Legal21ID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    // Kainz - LV

    @isTest
    public static void testLVKainzWiderspruchdurchKunden() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Widerspruch'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzWiderspruchdurchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVKainzFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.CLLBLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    // JCLegal - LV

    @isTest
    public static void testLVJCLegalWiderspruchdurchKunden() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Kunden'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalDeckungsanfrageWiderspruch() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Widerspruch'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalWiderspruchdurchAnwalt() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Widerspruch durch Anwalt'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalDeckungsanfrageKlage() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Klage'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalKlageschrift() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Klageschrift'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalDeckungsanfrageBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage für Berufung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalSonstiges() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Sonstiges'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalDeckungsanfrageVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalVerteidigungsanzeige() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Verteidigungsanzeige'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }

    @isTest
    public static void testLVJCLegalFrist() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Opportunity o = new Opportunity(
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = Accounts.jcLegalID
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id
        );
        insert cl;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = cl.id,
            Type__c = 'Fristverlängerung'
        );
        insert corr;
        EmailUtilitiesCorrespondence.Result r;
        r = EmailUtilitiesCorrespondence.getTemplate(corr.Id);
        System.assertNotEquals(null, r.templateID);
    }
}