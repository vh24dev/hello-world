public class OpportunitiesStage {
    public static Opportunity[] setStage(Opportunity[] oo, Map<ID,Opportunity> oldOo) {
        Map<Id, Opportunity> ooQ = new Map<Id, Opportunity>([
            select Id,
            Priority_Level__c,
            Vehicle_Brand__c,
            Process_Type__c,
            Account_Id__c,
            Sales_Type__c,
            Reference__c,
            RecordTypeId,
            Confirmed_Terms_And_Conditions__c,
            StageName,
            Legal_Process_Type__c,
            Legal__c,
            Assignment_Type__c,
            Partial_Refund__c,
            Refund__c,
            Backoffice__c,
            Termination_Date__c,
            Expiration_Date__c,
            Insurance_Status__c,
            Insurance__c,
            Insurance__r.External_Id__c
            from Opportunity
            where Id IN :oo
        ]);
        for (Opportunity o : oo) {
            OpportunitiesStage.setClaim(o, oldOo.get(o.Id), ooQ.get(o.Id));
        }
        return oo;
    }

    private static Opportunity setClaim(Opportunity opp, Opportunity oldOpp, Opportunity oQ) {
        if (Opportunities.isLebensversicherung(opp.RecordTypeId)) {
            if (oQ.priority_Level__c == 'I' || oQ.priority_Level__c == 'II') {
                if (oQ.Insurance_Status__c == 'bereits gekündigt') {
                    if (opp.Confirmed_Terms_And_Conditions__c == true) {
                        if (oldOpp.Confirmed_Terms_And_Conditions__c != opp.Confirmed_Terms_And_Conditions__c) {
                            opp.StageName = 'Claim';
                            System.debug('OpportunitiesStage :: setClaim :: opp: ' + opp);
                        }
                    }
                }
            }
        }
        return opp;
    }
}