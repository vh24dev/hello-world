public class TaskRelatedOpportunity {
    public static void setOn(Task[] tt) {
        System.debug('>> TaskRelatedOpportunity :: setOn :: tt: ' + tt);

        for (Task t: tt) {
            if (t.whatID == null) {
                System.debug('>> TaskRelatedOpportunity :: setOn :: whatID is null for t: ' + t);
                continue;
            }
            
            if (t.related_Opportunity__c != null) {
                System.debug('>> TaskRelatedOpportunity :: setOn :: related_Opportunity__c is not null for t: ' + t);
                continue;
            }
            
            Schema.SObjectType ot = t.whatID.getSObjectType();
            if (t.whatID.getSObjectType() == Schema.SObjectType.Opportunity.getSObjectType()) {
                t.related_Opportunity__c = t.whatID;
            } else if (t.whatID.getSObjectType() == Schema.SObjectType.Claim__c.getSObjectType()) {
                Claim__c c = [SELECT Opportunity__c FROM Claim__c WHERE ID = :t.whatID];
                t.related_Opportunity__c = c.opportunity__c;
            } else if (t.whatID.getSObjectType() == Schema.SObjectType.Correspondence__c.getSObjectType()) {
                Correspondence__c c = [SELECT Claim__r.Opportunity__c FROM Correspondence__c WHERE ID = :t.whatID];
                t.related_Opportunity__c = c.claim__r.opportunity__c;
            } else if (t.whatID.getSObjectType() == Schema.SObjectType.Opportunity_Correspondence__c.getSObjectType()) {
                Opportunity_Correspondence__c c = [SELECT Opportunity__c FROM Opportunity_Correspondence__c WHERE ID = :t.whatID];
                t.related_Opportunity__c = c.opportunity__c;
            }
            
            System.debug('TaskRelatedOpportunity :: setOn :: did set related_Opportunity__c: ' + t.related_Opportunity__c + ' for t: ' + t);
        }
        
        System.debug('<< TaskRelatedOpportunity :: setOn');
    }
}