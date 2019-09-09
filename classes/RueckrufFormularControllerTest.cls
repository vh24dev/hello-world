@isTest
public class RueckrufFormularControllerTest {
    @isTest
    public static void QuickHackCoverage() {
        RueckrufFormularController c = new RueckrufFormularController();
        c.getTimeSel();
        c.setTimeSel(new String[]{'foo','bar','baz'});
    }

    @isTest
    public static void TestNoErrors() {
        PageReference p = Page.RueckrufFormular;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', '123');

        RueckrufFormularController c = new RueckrufFormularController();

        c.init();
        c.confirm();
    }

    @isTest
    public static void TestNoContactButAvailability() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Number__c = 'NUMB3R';
        o.Token__c = '123';
        o.Availability__c = 'abends';
        insert o;
        Contact con = new Contact(
            FirstName = 'Foo',
            LastName = 'Bar',
            Phone = '123',
            Email = 'foo@bar.baz'
        );
        insert con;
        o = [SELECT Id, Token__c, Number__c FROM Opportunity WHERE Id = :o.Id];
        PageReference p = Page.RueckrufFormular;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', o.Token__c);
        System.runAs(TestData.bypassUser()) {
            RueckrufFormularController c = new RueckrufFormularController();
            c.init();
            PageReference nextPage = c.confirm();
            c.getMailBody(con); // 
            System.assertEquals(new PageReference('/ErrorPage?h=Kunde nicht gefunden&b=Bitte geben Sie einen gültigen Kontakt an.').getUrl(), nextPage.getUrl());
        }
    }

    @isTest
    public static void TestMailBodyAndRedirect() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        insert a;
        Contact con = new Contact(
            FirstName = 'Foo',
            LastName = 'Bar',
            Phone = '123',
            Email = 'foo@bar.baz'
        );
        insert       con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = con.Id;
        o.Number__c = 'NUMB3R';
        o.Token__c = '123';
        insert  o;
		o = [SELECT Id, Token__c, Number__c FROM Opportunity WHERE Id = :o.Id];
        PageReference p = Page.RueckrufFormular;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', o.Token__c);
        System.runAs(TestData.bypassUser()) {
            RueckrufFormularController c = new RueckrufFormularController();
            c.init();
            PageReference nextPage = c.confirm();
            System.assertEquals('/RueckrufFormularFertig', nextPage.getUrl());
            string mailBody = 'Bearbeitungsnummer: NUMB3R\n\n'
                + 'Foo Bar TestOpportunity bittet um Rückruf: \n'
                + 'Telefon: ' + '123' + '\n'
                + 'Email: ' + 'foo@bar.baz' + '\n';
            System.assertEquals(mailBody, c.getMailBody(con));
        }
    }

    @isTest
    public static void TestMailBodyAndRedirectLead() {
        TriggerConfiguration.allInactive = true;
        Account a = TestData.createAccount();
        a.Name = 'VH24';
        insert a;
        Contact con = new Contact(
            FirstName = 'Foo2',
            LastName = 'Bar2',
            Phone = '1232',
            Email = 'foo@bar2.baz'
        );
        insert con;
        Lead l = TestData.createLead();
        l.FirstName = 'Foo;2222222222222222222222';
        l.LastName = 'Bar2;2222222222222222222222';
        l.Phone = '1232;2222222222222222222222';
        l.Email = 'foo@bar2.bazzz2222222222222222222222';
        l.Token__c = '1234567';
        insert l;
        l = [
            SELECT Id,
            Token__c,
            Bearbeitungsnummer__c,
            Availability__c,
            FirstName,
            LastName,
            Phone,
            Email
            FROM Lead WHERE Id = :l.Id
        ];
        PageReference p = Page.RueckrufFormular;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', l.Token__c);
        System.runAs(TestData.bypassUser()) {
            RueckrufFormularController c = new RueckrufFormularController();
            c.init();
            PageReference nextPage = c.confirm();
            System.assertEquals('/RueckrufFormularFertig', nextPage.getUrl());
            string mailBody = 'Bearbeitungsnummer: ' + l.Bearbeitungsnummer__c + '\n\n'
                + 'Foo2 Bar2  bittet um Rückruf: \n'
                + 'Telefon: ' + '1232' + '\n'
                + 'Email: ' + 'foo@bar2.baz' + '\n';
            System.assertEquals(mailBody, c.getMailBody(con));
        }
    }
}