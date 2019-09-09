public class NonContributoryPeriods {
    public static void setFields(Non_contributory_Period__c[] ncpp, Map<ID, Non_contributory_Period__c> oldNcpp, Boolean isInsert) {
        for (Non_contributory_Period__c ncp : ncpp) {
            if (isInsert || ncp.active__c != oldNcpp.get(ncp.ID).active__c) {
                ncp.active_Clean__c = ncp.Active__c;
            }
        }
    }
}