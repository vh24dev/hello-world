// LeadFollowUpController is the controller of LeadFollowUp lightning component.
public class LeadFollowUpController {
    public class InvalidInputException extends Exception {}
    
    // followUpOnLead bumps the Lead FollowUp count and sets the FollowUp Period
    // depending on the count.
    @AuraEnabled
    public static void followUpOnLead(String leadID) {
        System.debug('>> LeadFollowUpController :: followUpOnLead :: leadID: ' + leadID);
        if (String.isBlank(leadID)) {
            throw new InvalidInputException('LeadID is mandatory.');
        }
        
        Lead lead = [SELECT ID, Follow_up_Count__c FROM Lead WHERE ID = :leadID];
        lead.Follow_up_Count__c = lead.Follow_up_Count__c == null ? 1 : (lead.Follow_up_Count__c + 1);
        
        // Set Follow-up Period dependend on Count
        switch on lead.follow_up_Count__c.intValue() {
            when 1, 2 {
                lead.follow_up_Period__c = 1;
            }
            when else {
                lead.follow_up_Period__c = 5;
            }
        }
        
        update lead;

        System.debug('<< LeadFollowUpController :: followUpOnLead :: lead: ' + lead);
    }
}