public class DocumentAction {
    public static void createTasks(List<Document__c> documents){
        documents = [
            SELECT Id,
            Opportunity__c,
            (SELECT Id,Status,Subject from Tasks)
            FROM Document__c
            WHERE Id IN :documents
        ];
        Set<Id> opportunityIds = new Set<Id>();
        for (Document__c document : documents) {
            opportunityIds.add(document.Opportunity__c);
        }
        Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>([
            SELECT Id,
            Backoffice__c,
            Backoffice__r.isActive,
            (SELECT Id,Status,Subject FROM Tasks)
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ]);
        List<Task> ts = new List<Task>();
        List<Task> newTasks = new List<Task>();
        for (Document__c document : documents){
            Opportunity opportunity = opportunities.get(document.Opportunity__c);
            if (opportunity.Backoffice__r == null || opportunity.Backoffice__r.isActive == false) {
                Logger.debug('DocumentAction :: createTasks :: error: backoffice inactive or null (opportunity=' + opportunity.id + ').');
                continue;
            }
            ts.add(Tasks.build(
                'Neue Unterlagen', // subject
                null, // description
                opportunity, // parent object
                opportunity.Backoffice__r, // owner
                System.today(), // due date
                true, // no duplicates
                false, // followup
                opportunity.ID
            ));
        }
        for (Task task : ts){
            if (task != null){
                newTasks.add(task);
            }
        }
        if (newTasks.size() > 0) {
            insert newTasks;
        }
    }

    public static void deactivateFollowUpJourneys(List<Document__c> documents){
        Set<Id> opportunityIds = new Set<Id>();
        for (Document__c document : documents) {
            opportunityIds.add(document.Opportunity__c);
        }
        Map<Id,Opportunity> opportunities = new Map<Id,Opportunity>([
            SELECT Id,
            Auto_Follow_up_Count__c,
            Auto_Follow_up_Date__c,
            Backoffice__c,
            Backoffice__r.isActive,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ]);
        List<Opportunity> updateOpportunities = new List<Opportunity>();
        for (Document__c document : documents){
            Opportunity opportunity = opportunities.get(document.Opportunity__c);
            Boolean updateOpportunity = false;
            if (opportunity.Auto_Follow_up_Count__c != 0){
                opportunity.Auto_Follow_up_Count__c = 0;
                updateOpportunity = true;
            }
            if (opportunity.Auto_Follow_up_Date__c != null){
                opportunity.Auto_Follow_up_Date__c = null;
                updateOpportunity = true;
            }
            if (updateOpportunity == true){
                updateOpportunities.add(opportunity);
            }
        }
        if (!updateOpportunities.isEmpty()){
            update updateOpportunities;
        }
    }

    public static void setRecordType(List<Document__c> docs){
        Set<Id> opportunityIds = new Set<Id>();
        for (Document__c document : docs){
            opportunityIds.add(document.Opportunity__c);
        }
        Map<Id,Opportunity> opps = new Map<Id,Opportunity>([SELECT Id, RecordTypeId FROM Opportunity WHERE Id IN :opportunityIds]);
        for (Document__c document : docs) {
            Opportunity opportunity = opps.get(document.Opportunity__c);
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                document.RecordTypeId = Documents.dieselSkandalRecordType(); // 0120Y000000W0t2
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                document.RecordTypeId = Documents.finanzierungRecordType(); // 0120Y000000KnMM
            } else {
                document.RecordTypeId = Documents.lebensversicherungRecordType(); // 0120Y000000W0sx
            }
        }
    }
}