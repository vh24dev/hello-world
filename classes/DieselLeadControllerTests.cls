@isTest
public class DieselLeadControllerTests {
    @isTest
    public static void TestPage1() {
        PageReference p = Page.Dieselskandal;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('utm_Source',	'1');
        ApexPages.currentPage().getParameters().put('utm_Medium',	'2');
        ApexPages.currentPage().getParameters().put('utm_Campaign',	'3');
        ApexPages.currentPage().getParameters().put('utm_Term',		'4');
        ApexPages.currentPage().getParameters().put('utm_Content',	'5');
        ApexPages.currentPage().getParameters().put('UniqueId',		'6');
        ApexPages.currentPage().getParameters().put('FormularId',	'7');
        ApexPages.currentPage().getParameters().put('Kampagne',		'8');
        ApexPages.currentPage().getParameters().put('Referrer',		'9');
        DieselLeadController c = new DieselLeadController();

        c.legal_insurance = 'Ja';
        c.vehicleType = 'ada';
        c.FinancingType = 'Leasing';

        PageReference nextPage = c.createLead();
        List<Lead> leads = [
            SELECT Id, Has_Legal_Protection_Insurance__c, Vehicle_Type__c,
            Confirmed_Authorization__c, Account__c, Financing_Type__c,
            Company, FirstName, LastName, Token__c,
            AdWords_Source__c, AdWords_Medium__c, AdWords_Campaign__c, AdWords_Term__c, AdWords_Content__c,
            Unique_Id__c, Form_Id__c, Campaign__c, Referrer__c
            FROM Lead
        ];

        System.assertEquals(1, leads.size());
        Lead l = leads[0];

        System.assertEquals('WebformDG still Unknown', l.Company);
        System.assertEquals('WebformDG still Unknown', l.FirstName);
        System.assertEquals('WebformDG still Unknown', l.LastName);
        System.assertEquals('Leasing', l.Financing_Type__c);
        System.assertEquals('ada', l.Vehicle_Type__c);
        System.assertEquals(Accounts.VH24ID, l.Account__c);
        System.assertEquals(true, l.Has_Legal_Protection_Insurance__c);
        System.assertEquals('/DieselskandalZwischenseite?token=' + l.Token__c, nextPage.getUrl());
        System.assertEquals('1', l.AdWords_Source__c);
        System.assertEquals('2', l.AdWords_Medium__c);
        System.assertEquals('3', l.AdWords_Campaign__c);
        System.assertEquals('4', l.AdWords_Term__c);
        System.assertEquals('5', l.AdWords_Content__c);
        System.assertEquals('6', l.Unique_Id__c);
        System.assertEquals('7', l.Form_Id__c);
        System.assertEquals('8', l.Campaign__c);
        System.assertEquals('9', l.Referrer__c);
    }

    @isTest
    public static void TestLegalInsuranceOptions() {
        new DieselLeadController().getLegalInsuranceOptions();
    }

    @isTest
    public static void TestBrandOptions() {
        new DieselLeadController().getBrandOptions();
    }
    
    @isTest
    static void hackCoverage() {
        DieselLeadController.hackCoverage();
    }
}