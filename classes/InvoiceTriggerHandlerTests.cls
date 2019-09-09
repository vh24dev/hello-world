@isTest
public class InvoiceTriggerHandlerTests {
    @isTest
    static void testVH24() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createVH24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
        insert opportunity;
        
        Invoice__c oldInvoice = TestData.createInvoice(opportunity.Id);
        oldInvoice.Number__c = '2017000001/IVH';
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i=0;i<20;i++){
            invoices.add(TestData.createInvoice(opportunity.Id));
        }
        
        TriggerConfiguration.allInactive = false;
        
        // Test
        Test.startTest();
        
        insert oldInvoice;

        TriggerConfiguration.allInactive = false;
        insert invoices;

        Test.stopTest();

        // Assertion
        invoices = [select Id,Number__c from Invoice__c where Id IN :invoices];
        Integer i = 1;
        for (Invoice__c invoice : invoices) {
            System.assert(!String.isBlank(invoice.Number__c));
            System.assert(invoice.Number__c.endsWith(String.valueOf(i+1) + '/IVH'));
            i++;
        }
    }

    @isTest
    static void testVR24() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createVR24Account();
        insert account;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
        insert opportunity;
        Invoice__c oldInvoiceVh = TestData.createInvoice(opportunity.Id);
        oldInvoiceVh.Number__c = '2017000001/IVH';
        Invoice__c oldInvoice = TestData.createInvoice(opportunity.Id);
        oldInvoice.Number__c = '2017000001/IVR';
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i=0;i<20;i++){
            invoices.add(TestData.createInvoice(opportunity.Id));
        }

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert oldInvoiceVh;
        insert oldInvoice;

        TriggerConfiguration.allInactive = false;
        insert invoices;

        Test.stopTest();

        // Assertion
        invoices = [select Id,Number__c from Invoice__c where Id IN :invoices];

        Integer i = 1;
        for (Invoice__c invoice : invoices) {
            System.assert(!String.isBlank(invoice.Number__c));
            System.assert(invoice.Number__c.endsWith(String.valueOf(i+1) + '/IVR'));
            i++;
        }
    }

    @isTest
    static void testTest() {
        // Testsetup
        TriggerConfiguration.allInactive = true;

        Account account = TestData.createVR24Account();
        insert account;
        Contact contact = TestData.createContact(account.Id);
        insert contact;
        Opportunity opportunity = TestData.createOpportunity(null,'New');
        opportunity.Account__c = account.ID;
        opportunity.Test__c = true;
        insert opportunity;
        Invoice__c oldInvoiceVh = TestData.createInvoice(opportunity.Id);
        oldInvoiceVh.Number__c = '2017000001/IVH';
        Invoice__c oldInvoice = TestData.createInvoice(opportunity.Id);
        oldInvoice.Number__c = '2017000001/IVR';
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i=0;i<20;i++){
            invoices.add(TestData.createInvoice(opportunity.Id));
        }

        TriggerConfiguration.allInactive = false;

        // Test
        Test.startTest();

        insert oldInvoiceVh;
        insert oldInvoice;

        insert invoices;

        Test.stopTest();

        // Assertion
        invoices = [select Id,Number__c from Invoice__c where Id IN :invoices];

        for (Invoice__c invoice : invoices){
            System.assert(!String.isBlank(invoice.Number__c));
            System.assert(invoice.Number__c.endsWith('00/Test'));
        }
    }
}