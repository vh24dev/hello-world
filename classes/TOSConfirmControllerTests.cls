@isTest
public class TOSConfirmControllerTests {
    @isTest
    public static void TestConfirmNoLeadHasNoErrors() {
        PageReference p = Page.ConfirmTOS;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', '123');

        ConfirmTOSController c = new ConfirmTOSController();

        //System.runAs()
        c.init();
        c.confirm();
    }

    @isTest
    public static void TestConfirmLeadUpdatesField() {
        TriggerConfiguration.allInactive = true;
        Lead l = new Lead(
            LastName = 'foo',
            Company = 'bar',
            Token__c = 'foo',
            Phone = '1231',
            Confirmed_Terms_And_Conditions__c = false,
            Confirmed_Authorization__c = false
        );
        insert l;
        l = [SELECT Id, Token__c FROM Lead WHERE Id = :l.Id];
        PageReference p = Page.ConfirmTOS;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', l.Token__c);
        System.runAs(TestData.bypassUser()) {
            ConfirmTOSController c = new ConfirmTOSController();
            c.init();
            c.isPrivacy = true;
            c.isLegal = true;
            PageReference nextPage = c.confirm();
            System.assertEquals('/TOSConfirmed', nextPage.getUrl());
        }
        l = [
            SELECT id, Confirmed_Terms_And_Conditions__c, Confirmed_Authorization__c
            FROM Lead
            WHERE Id = :l.Id
        ];
        System.assertEquals(true, l.Confirmed_Terms_And_Conditions__c);
        System.assertEquals(true, l.Confirmed_Authorization__c);
    }
}