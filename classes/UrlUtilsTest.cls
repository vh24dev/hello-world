@isTest
public class UrlUtilsTest {
    @isTest
    public static void testFieldsPage() {
        Lead l = new Lead();
        PageReference pageRef = Page.Dieselskandal;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('utm_Source',	'1');
        ApexPages.currentPage().getParameters().put('utm_Medium',	'2');
        ApexPages.currentPage().getParameters().put('utm_Campaign',	'3');
        ApexPages.currentPage().getParameters().put('utm_Term',		'4');
        ApexPages.currentPage().getParameters().put('utm_Content',	'5');
        ApexPages.currentPage().getParameters().put('UniqueId',			'6');
        ApexPages.currentPage().getParameters().put('FormularId',		'7');
        ApexPages.currentPage().getParameters().put('Kampagne',			'8');
        ApexPages.currentPage().getParameters().put('Referrer',			'9');
		l = UrlUtils.setLeadFields(l);
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
    public static void testFieldsPageDML() {
        Lead l = TestData.createLead();
        insert l;
        PageReference pageRef = Page.Dieselskandal;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('utm_Source',	'1');
        ApexPages.currentPage().getParameters().put('utm_Medium',	'2');
        ApexPages.currentPage().getParameters().put('utm_Campaign',	'3');
        ApexPages.currentPage().getParameters().put('utm_Term',		'4');
        ApexPages.currentPage().getParameters().put('utm_Content',	'5');
        ApexPages.currentPage().getParameters().put('UniqueId',			'6');
        ApexPages.currentPage().getParameters().put('FormularId',		'7');
        ApexPages.currentPage().getParameters().put('Kampagne',			'8');
        ApexPages.currentPage().getParameters().put('Referrer',			'9');
		l = UrlUtils.setLeadFields(l);
        System.assertEquals('1', l.AdWords_Source__c);
        System.assertEquals('2', l.AdWords_Medium__c);
        System.assertEquals('3', l.AdWords_Campaign__c);
        System.assertEquals('4', l.AdWords_Term__c);
        System.assertEquals('5', l.AdWords_Content__c);
        System.assertEquals('6', l.Unique_Id__c);
        System.assertEquals('7', l.Form_Id__c);
        System.assertEquals('8', l.Campaign__c);
        System.assertEquals('9', l.Referrer__c);
        update l;
        l = [
            SELECT ID,
            AdWords_Source__c,
            AdWords_Medium__c,
            AdWords_Campaign__c,
            AdWords_Term__c,
            AdWords_Content__c,
            Unique_Id__c,
            Form_Id__c,
            Campaign__c,
            Referrer__c
            FROM Lead
            WHERE ID = :l.Id
        ];
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
    public static void testFieldsUrl() {
        Lead l = new Lead();
        string url = '/apex/dieselskandal';
        url += '?utm_Source=1';
        url += '&utm_Medium=2';
        url += '&utm_Campaign=3';
        url += '&utm_Term=4';
        url += '&utm_Content=5';
        url += '&UniqueId=6';
        url += '&FormularId=7';
        url += '&Kampagne=8';
        url += '&Referrer=9';
		l = UrlUtils.setLeadFields(url, l);
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
    public static void testError() {
        Lead l = null;
        string url = UrlUtils.getAgbFromLead(l);
        System.assert(url.contains('error'));
    }

	@isTest
    public static void testDgRsv() {
        Lead l = new Lead(
            RecordTypeId = Leads.dkRtID,
            Has_Legal_Protection_Insurance__c = true
        );
        string url = UrlUtils.getAgbFromLead(l);
        System.assertEquals('https://www.verbraucherhilfe24.de/agb/dg/AGB_VH24_mitRSV.pdf', url);
    }

	@isTest
    public static void testDgNoRsv() {
        Lead l = new Lead(
            RecordTypeId = Leads.dkRtID,
            Has_Legal_Protection_Insurance__c = false
        );
        string url = UrlUtils.getAgbFromLead(l);
        System.assertEquals('https://www.verbraucherhilfe24.de/agb/dg/AGB_VH24_ohneRSV.pdf', url);
    }

	@isTest
    public static void testLvRsv() {
        Lead l = new Lead(
            RecordTypeId = Leads.lvRtID,
            Has_Legal_Protection_Insurance__c = true
        );
        string url = UrlUtils.getAgbFromLead(l);
        System.assertEquals('https://www.verbraucherhilfe24.de/agb/lv/AGB_VH24_mitRSV.pdf', url);
    }

	@isTest
    public static void testLvNoRsv() {
        Lead l = new Lead(
            RecordTypeId = Leads.lvRtID,
            Has_Legal_Protection_Insurance__c = false
        );
        string url = UrlUtils.getAgbFromLead(l);
        System.assertEquals('https://www.verbraucherhilfe24.de/agb/lv/AGB_VH24_ohneRSV.pdf', url);
    }
}