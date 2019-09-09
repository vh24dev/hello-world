public class Authorizations {
    //@future (callout=true)
    public static void autoCreateDocuments(Set<Id> ids) {
        Authorization__c[] aa = [select Id from Authorization__c where id in :ids];
        for (Authorization__c auth: aa) {
            DocumentCreationAction.autoCreateDocument(auth.Id,false,'pdf',null,null);
        }
    }

    public static void setRecordType(List<Authorization__c> authorizations){
        Set<Id> opportunityIds = new Set<Id>();
        for (Authorization__c authorization : authorizations){
            opportunityIds.add(authorization.Opportunity__c);
        }

        Map<Id,Opportunity> oppos= new Map<Id,Opportunity>([SELECT Id, RecordTypeId FROM Opportunity WHERE Id IN :opportunityIds]);
        RecordType rt_dg = [SELECT developername, sobjecttype FROM recordtype WHERE sobjecttype = 'Authorization__c' AND developername = 'Dieselskandal'];
        RecordType rt_fz = [SELECT developername, sobjecttype FROM recordtype WHERE sobjecttype = 'Authorization__c' AND developername = 'Finanzierung'];
        RecordType rt_lv = [SELECT developername, sobjecttype FROM recordtype WHERE sobjecttype = 'Authorization__c' AND developername = 'Lebensversicherung'];

        for (Authorization__c authorization : authorizations) {
            Opportunity opportunity = oppos.get(authorization.Opportunity__c);
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY (old)
                // Dieselskandal
                authorization.RecordTypeId = rt_dg.Id; // 0121t000000DzQTAA0 (new)
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) {
                // Finanzierung
                authorization.RecordTypeId = rt_fz.Id; // 0121t000000DzQUAA0 (new)
            } else {
                // Lebensversicherung
                authorization.RecordTypeId = rt_lv.Id; // 0121t000000DzQVAA0 (new)
            }
        }
    }
    
}