@isTest
public class ConfirmAppointmentControllerTest {
    @isTest
    public static void TestInitInvalidObject() {
        PageReference p = Page.ConfirmAppointment;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', '123');

        ConfirmAppointmentController c = new ConfirmAppointmentController();

        c.init();
    }

    /*@isTest
    public static void TestUpdateObject() {
        TriggerConfiguration.allInactive = true;
		Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        User u = TestData.legalUser();
        User bUser = TestData.bypassUser();
        insert bUser;
        System.runAs(bUser) {
			
            Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
            o.Account__c = a.Id;
            o.Backoffice__c = u.Id;
            insert o;
            Claim__c c = new Claim__c(
                Opportunity__c = o.Id,
                Clerk__c = u.Id,
                Legal__c = u.Id
            );
            insert c;
            Date__c app = new Date__c(
                Claim__c = c.Id,
                Date__c = System.today(),
                Subject__c = 'Foo'
            );
           
            insert app;
            app = [SELECT Id, Token__c FROM Date__c WHERE Id = :app.Id];
            PageReference p = Page.ConfirmAppointment;
            Test.setCurrentPage(p);
            ApexPages.currentPage().getParameters().put('token', app.Token__c);
    
           // System.runAs(bUser) {
                ConfirmAppointmentController cn = new ConfirmAppointmentController();
                cn.init();
            //}
            app = [
                SELECT Id,
                Date_confirmed__c,
                Representative_Confirmation_Date__c
                FROM Date__c
                WHERE Id = :app.Id
            ];
            System.assertEquals(true, app.Date_confirmed__c);
            Datetime confirmDate = app.Representative_Confirmation_Date__c;
            Datetime nowDate = Datetime.now();
            System.assertEquals(nowDate.year(), confirmDate.year());
            System.assertEquals(nowDate.month(), confirmDate.month());
            System.assertEquals(nowDate.day(), confirmDate.day());
            System.assertEquals(nowDate.hour(), confirmDate.hour());
        }
    }*/
}