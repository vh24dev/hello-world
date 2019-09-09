global class UpdateVehicleOwnership implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(
            'SELECT Id, Date_Link_Ownership__c, Claim__r.Customer_Is_Owner__c, Claim__r.Customer_Is_Not_Owner__c ' +
            'FROM Correspondence__c'
        );
    }

    global void execute(Database.BatchableContext BC, List<Correspondence__c> scope) {
        List<Claim__c> claims = new List<Claim__c>();
        for (Correspondence__c corr : scope) {
            if (corr.Date_Link_Ownership__c == null || corr.Date_Link_Ownership__c.daysBetween(System.today()) <= 2) {
                continue;
            }
            if (corr.Claim__r.Customer_Is_Owner__c == true || corr.Claim__r.Customer_Is_Not_Owner__c == true) {
                continue;
            }
            corr.Claim__r.Customer_Is_Owner__c = true;
            corr.Claim__r.Ownership_Request_Date__c = System.today();
            claims.add(corr.Claim__r);
        }
        update claims;
    }

    global void finish(Database.BatchableContext BC) {
    }
}