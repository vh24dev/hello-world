@isTest
public class NewsletterControllerTest {
    @isTest
    public static void TestInvalidToken() {
        PageReference p = Page.ConfirmNewsletter;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', '123');
        NewsletterController c = new NewsletterController();
        PageReference ref = c.init();
        System.assertEquals(new PageReference('/apex/ErrorPage?h=Objekt nicht gefunden&b=Bitte geben Sie einen gültigen Token an.').getUrl(), ref.getUrl());
    }

    @isTest
    public static void TestNullToken() {
        PageReference p = Page.ConfirmNewsletter;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', null);
        NewsletterController c = new NewsletterController();
        PageReference ref = c.init();
        System.assertEquals(new PageReference('/apex/ErrorPage?h=Objekt nicht gefunden&b=Bitte geben Sie einen gültigen Token an.').getUrl(), ref.getUrl());
    }

    @isTest
    public static void TestNoContact() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'New');
        o.Token__c = '123';
        insert o;
        o = [SELECT Id, Token__c, Contact__c FROM Opportunity WHERE Id = :o.Id];
        PageReference p = Page.ConfirmNewsletter;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', o.Token__c);
        System.runAs(TestData.bypassUser()) {
            NewsletterController c = new NewsletterController();
            PageReference ref = c.init();
            System.assertEquals(new PageReference('/apex/ErrorPage?h=Objekt nicht gefunden&b=Bitte geben Sie einen gültigen Token an.').getUrl(), ref.getUrl());
        }
    }

    @isTest
    public static void TestConfirm() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        insert a;
        Contact con = new Contact(LastName = 'Foo');
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'New');
        o.Contact__c = con.Id;
        o.Token__c = '123';
        insert o;
        o = [SELECT Id, Token__c, Contact__c FROM Opportunity WHERE Id = :o.Id];
        PageReference p = Page.ConfirmNewsletter;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', o.Token__c);
        System.runAs(TestData.bypassUser()) {
            Test.startTest();
            NewsletterController c = new NewsletterController();
            PageReference ref = c.init();
            System.assertEquals(null, ref);
            Test.stopTest();
            c = new NewsletterController();
            ref = c.init();
            System.assertNotEquals(null, ref);
            System.assertEquals(new PageReference('/apex/ErrorPage?h=Sie haben bereits bestätigt').getUrl(), ref.getUrl());
        }
        Contact resCon = [
            SELECT id, Email_Opt_In__c, Newsletter_Confirmation_Date__c
            FROM Contact
            WHERE Id = :o.Contact__c
        ];
        Datetime dateConfirm = resCon.Newsletter_Confirmation_Date__c;
        Datetime dateNow = Datetime.now();
        System.assertEquals(true, resCon.Email_Opt_In__c);
        System.assertNotEquals(null, dateConfirm);
        System.assertEquals(dateNow.year(), dateConfirm.year());
        System.assertEquals(dateNow.day(), dateConfirm.day());
    }
}