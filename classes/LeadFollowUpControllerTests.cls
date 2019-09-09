@isTest
public class LeadFollowUpControllerTests {
    @isTest
    private static void testNoLeadID() {
        try {
            LeadFollowUpController.followUpOnLead(null);
            System.assert(false);
        } catch(LeadFollowUpController.InvalidInputException e) {
            System.assert(true);
        }
    }
    
    @isTest
    private static void testFollowUpVariablesAreUpdated() {
        Lead l = new Lead(lastName='Test lead', company='Test Comp');
        insert l;
        l = [SELECT Follow_up_Count__c, Follow_up_Period__c FROM Lead];
        
        LeadFollowUpController.followUpOnLead(l.ID);
        l = [SELECT Follow_up_Count__c, Follow_up_Period__c FROM Lead];
        System.assertEquals(1, l.Follow_up_Count__c);
        System.assertEquals(1, l.Follow_up_Period__c);
        
        LeadFollowUpController.followUpOnLead(l.ID);
        l = [SELECT Follow_up_Count__c, Follow_up_Period__c FROM Lead];
        System.assertEquals(2, l.Follow_up_Count__c);
        System.assertEquals(1, l.Follow_up_Period__c);
        
        LeadFollowUpController.followUpOnLead(l.ID);
        l = [SELECT Follow_up_Count__c, Follow_up_Period__c FROM Lead];
        System.assertEquals(3, l.Follow_up_Count__c);
        System.assertEquals(5, l.Follow_up_Period__c);
        
        LeadFollowUpController.followUpOnLead(l.ID);
        l = [SELECT Follow_up_Count__c, Follow_up_Period__c FROM Lead];
        System.assertEquals(4, l.Follow_up_Count__c);
        System.assertEquals(5, l.Follow_up_Period__c);
    }
}