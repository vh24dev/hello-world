global class TasksCreate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id, ' +
            'customer_Reached__c, ' +
            'Callcenter__c, ' +
            'Callcenter__r.ID, ' +
            'Callcenter__r.IsActive, ' +
            'customer_interaction_notes__c, ' +
            'Last_follow_up_task__c, ' +
            'Follow_up_Count__c, ' +
            'follow_Up_Period__c ' +
            'FROM Lead ' +
            'WHERE Confirmed_Terms_And_Conditions__c = false ' +
            'AND follow_up_Count__c > 1 AND follow_up_Count__c < 4 '
        );
    }

    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        List<Task> ts = new List<Task>();
        List<Lead> updateLeads = new List<Lead>();
        for (Lead l : scope) {
            Integer delay = l.Customer_Reached__c ? 5 : 3;
            if (l.Last_follow_up_task__c > System.today().addDays(-delay)) {
                continue;
            }
            String subject = l.customer_Reached__c ? 'AGB/Kunde erreicht #' : 'AGB/Kunde nicht erreicht #';
            Task t = Tasks.build(
                subject + l.follow_up_Count__c,
                l.customer_interaction_notes__c,
                l,
                l.callcenter__r,
                l.follow_up_Period__c > 0 ? Date.today() + Integer.valueOf(l.follow_Up_Period__c) : Date.today(),
                true,	// no duplicates
                true // follow up l.follow_up_Count__c > 0
            );
            l.Follow_up_Count__c = l.Follow_up_Count__c + 1;
            updateLeads.add(l);
            if (t != null) {
                ts.add(t);
            }
        }
        update updateLeads;
        insert ts;
    }

    global void finish(Database.BatchableContext BC) {
    }
}