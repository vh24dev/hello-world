@isTest
public class DocumentCreationActionCostNoteTest {
    /* * * * * * * * *
     * Dieselskandal *
     * * * * * * * * */

    //
    // Customer
    //

    @isTest
    public static void DGJCLegalCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGKainzCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGLeComCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    //
    // Legal Protection Insurance
    // 

    // 1 Instanz
    @isTest
    public static void DGJCLegalRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGKainzRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGLeComRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // berufung
    @isTest
    public static void DGJCLegalRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGKainzRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGLeComRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // Sonstiges

    @isTest
    public static void DGJCLegalRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGKainzRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void DGLeComRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.dieselskandalRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    /* * * * * * * * *
     * Finanzierung  *
     * * * * * * * * */

    @isTest
    public static void FZJCLegalCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZKainzCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZLeComCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    //
    // Legal Protection Insurance
    // 

    // 1 Instanz
    @isTest
    public static void FZJCLegalRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZKainzRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZLeComRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // berufung
    @isTest
    public static void FZJCLegalRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZKainzRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZLeComRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // Sonstiges

    @isTest
    public static void FZJCLegalRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - DG & FZ'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZKainzRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void FZLeComRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.finanzierungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    /* * * * * * * * * * * *
     * Lebensversicherung  *
     * * * * * * * * * * * */


    @isTest
    public static void LVJCLegalCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVKainzCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVLeComCustomer() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Customer',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteKunde),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    //
    // Legal Protection Insurance
    // 

    // 1 Instanz
    @isTest
    public static void LVJCLegalRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVKainzRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVLeComRSVInstanz() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'I. Instanz'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVgerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // berufung
    @isTest
    public static void LVJCLegalRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVKainzRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVLeComRSVBerufung() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Berufung'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVberufung),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    // Sonstiges

    @isTest
    public static void LVJCLegalRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='J & C Anwälte',
            Department__c = 'Heinrich Jäger - LV'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVKainzRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }

    @isTest
    public static void LVLeComRSVaussergerichtlich() {
        TriggerConfiguration.allInactive = true;
        Account a = new Account(
            Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        );
        insert a;
        Account av = new Account(
            Name='Daimler AG'
        );
        insert av;
        Opportunity o = new Opportunity(
            Financing_Type__c = 'Leasing',
            AccountID = a.Id,
            Name = 'aaaa',
            CloseDate = System.today(),
            StageName = 'On Hold',
            RecordTypeId = Opportunities.lebensversicherungRecordType(),
            Legal_Account__c = a.Id
        );
        insert o;
        Claim__c cl = new Claim__c(
            Opportunity__c = o.Id,
            Result__c = 'No Response'
        );
        insert cl;
        Cost_Note__c cn = new Cost_Note__c(
            Subject__c = 'foo',
            Claim__c = cl.Id,
            Recipient__c = 'Legal Protection Insurance',
            Type__c = 'Sonstiges'
        );
        insert cn;
        System.assertEquals(
            CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVaussergerichtlich),
            DocumentCreationActionCostNote.getTemplate(cn, o)
        );
    }
}