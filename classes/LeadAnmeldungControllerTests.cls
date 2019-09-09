@isTest
public class LeadAnmeldungControllerTests {
    @isTest
    public static void SuccessPathTest() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        Lead l = new Lead(
            LastName = 'foo',
            Company = 'bar',
            Email = '123@daw.com'
        );
        insert l;
        l.Token__c = '123';
        update l;
        ApexPages.currentPage().getParameters().put('token', '123');
        LeadAnmeldungController c = new LeadAnmeldungController();
        c.dieselCode = 'DIESEL1';
        c.firstname = 'foo';
        c.lastname = 'bar';
        c.email = 'foo@bar.com';
        c.newsletter = true;
        c.title = 'Herr';

        PageReference nextPage = c.updateLead();

        List<Lead> leads = [
            SELECT Id,
            Diesel_Code__c,
            FirstName, LastName, Email,
            Newsletter_Registered__c, Newsletter_Registration_Date__c,
            Vehicle_Brand__c, Purchase_Date_Category__c, Token__c, Title
            FROM Lead
        ];

        System.assertEquals(1, leads.size());
        l = leads[0];

        System.assertEquals('DIESEL1', l.Diesel_Code__c);
        System.assertEquals('foo', l.FirstName);
        System.assertEquals('bar', l.LastName);
        System.assertEquals('foo@bar.com', l.Email);
        System.assertEquals(true, l.Newsletter_Registered__c);
        System.assertEquals('Herr', l.Title);
        System.assert(l.Newsletter_Registration_Date__c != null);
        System.assertEquals('/Dieselskandal3', nextPage.getUrl());

        //

        System.assertEquals('https://www.verbraucherhilfe24.de/agb/dg/AGB_VH24_ohneRSV.pdf', c.getAgbUrl());
        System.assertEquals('Dieselskandal', c.pageConfig.getPageTitle());
        System.assertEquals('Betroffen vom Dieselskandal', c.pageConfig.getPageHeader());
        System.assertEquals('ANGABEN ZUM AUTO', c.pageConfig.getStepName());
    }

    @isTest
    public static void SuccessPathTestLv() {
        TriggerConfiguration.allInactive = true;
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        Lead l = new Lead(
            LastName = 'foo',
            Company = 'bar',
            Email = '123@daw.com',
            RecordTypeId = Leads.LvRtId
        );
        insert l;
        l.Token__c = '123';
        update l;
        ApexPages.currentPage().getParameters().put('token', '123');
        LeadAnmeldungController c = new LeadAnmeldungController();
        c.dieselCode = 'DIESEL2';
        c.firstname = 'foo';
        c.lastname = 'bar';
        c.email = 'foo@bar.com';
        c.newsletter = true;
        c.title = 'Herr';

        PageReference nextPage = c.updateLead();

        List<Lead> leads = [
            SELECT Id,
            Diesel_Code__c,
            FirstName, LastName, Email,
            Newsletter_Registered__c, Newsletter_Registration_Date__c,
            Vehicle_Brand__c, Purchase_Date_Category__c, Token__c, Title
            FROM Lead
        ];

        System.assertEquals(1, leads.size());
        l = leads[0];

        System.assertEquals('DIESEL2', l.Diesel_Code__c);
        System.assertEquals('foo', l.FirstName);
        System.assertEquals('bar', l.LastName);
        System.assertEquals('foo@bar.com', l.Email);
        System.assertEquals(true, l.Newsletter_Registered__c);
        System.assertEquals('Herr', l.Title);
        System.assert(l.Newsletter_Registration_Date__c != null);
        System.assertEquals('/LebensversicherungErgebniss', nextPage.getUrl());

        //

        System.assertEquals('https://www.verbraucherhilfe24.de/agb/lv/AGB_VH24_ohneRSV.pdf', c.getAgbUrl());
        System.assertEquals('Lebensversicherung', c.pageConfig.getPageTitle());
        System.assertEquals('Lebensversicherung widerrufen', c.pageConfig.getPageHeader());
        System.assertEquals('ANGABEN ZUR LEBENSVERSICHERUNG', c.pageConfig.getStepName());
    }

    @isTest
    public static void TestMissingToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'nonexistent');

        LeadAnmeldungController c = new LeadAnmeldungController();
        c.firstname = 'foo';
        c.lastname = 'bar';
        c.email = 'foo@bar.com';
        c.newsletter = true;
        PageReference nextPage = c.updateLead();
        System.assertEquals('/NotFound', nextPage.getUrl());
    }
    
    @isTest
    public static void TestNonExistentMissingToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);

        LeadAnmeldungController c = new LeadAnmeldungController();
        c.firstname = 'foo';
        c.lastname = 'bar';
        c.email = 'foo@bar.com';
        c.newsletter = true;
        PageReference nextPage = c.updateLead();
        System.assertEquals('/NotFound', nextPage.getUrl());
    }
    
    @isTest
    public static void TestEnsureLeadExistsWithoutToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);

        LeadAnmeldungController c = new LeadAnmeldungController();
        PageReference nextPage = c.ensureLeadExists();
        System.assertEquals('/NotFound', nextPage.getUrl());
    }
    
    @isTest
    public static void TestEnsureLeadExistsWithEmptyToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', '');

        LeadAnmeldungController c = new LeadAnmeldungController();
        PageReference nextPage = c.ensureLeadExists();
        System.assertEquals('/NotFound', nextPage.getUrl());
    }
    
    @isTest
    public static void TestEnsureLeadExistsWithUnexistentToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'unexistent');

        LeadAnmeldungController c = new LeadAnmeldungController();
        PageReference nextPage = c.ensureLeadExists();
        System.assertEquals('/NotFound', nextPage.getUrl());
    }
    
    @isTest
    public static void TestEnsureLeadExistsWithValidToken() {
        PageReference p = Page.Step2;
        Test.setCurrentPage(p);
        
        Lead l = createLead();
        ApexPages.currentPage().getParameters().put('token', l.Token__c);

        LeadAnmeldungController c = new LeadAnmeldungController();
        PageReference nextPage = c.ensureLeadExists();
        System.assertEquals(null, nextPage);
    }

    @isTest
    public static void DummyTestOptions() {
        LeadAnmeldungController c = new LeadAnmeldungController();
        c.getTimeSel();
        c.setTimeSel(new List<String>());
        c.getTitleOptions();
        c.getCommOptions();
        c.getTimeOptions();
        c.getCodeOptions();
    }
    
    private static Lead createLead() {
        Lead l = new Lead(
            LastName = 'foo',
            Company = 'bar',
            Email = '123@daw.com'
        );

        insert l;
        l.Token__c = '123';
        update l;
        return l;
    }
}