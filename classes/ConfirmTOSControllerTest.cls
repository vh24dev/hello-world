@isTest
public class ConfirmTOSControllerTest {
  @isTest
    public static void TestInitInvalidObject() {
        Lead lead = TestData.createLead();
        PageReference p = Page.ConfirmTOS;
        Test.setCurrentPage(p);
        lead.Street = 'teststreet';
        lead.PostalCode = '123456';
		lead.Phone = '123456';
        lead.Vehicle_Type__c = 'werwer';
        lead.Token__c ='1234-123123';
        
        insert lead;
        ApexPages.currentPage().getParameters().put('token', '1234-123123');

        ConfirmTOSController controller = new ConfirmTOSController();
        controller.l = lead;
        controller.insurance = 'ja';
    	controller.isPrivacy = true;
    	controller.isLegal = true;
        controller.init();
        controller.getValues();
        controller.confirm();
        controller.getLead();
        controller.getIsLv();
        controller.getYesNo();
		controller.getAgbUrl();
        controller.isPrivacy = false;
        controller.confirm();
    }

}