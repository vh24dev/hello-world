public class AutoconvertLead {
    public static void convert(Lead lead) {
        System.debug('Should convert ' + lead);
        System.debug('Should convert ' + shouldConvert(lead));
        if (!shouldConvert(lead)) {
            return;
        }
        System.debug('Should convert converting...');
        
        LeadConversion.convert(new List<Id>{lead.id});
    }
    
    private static boolean shouldConvert(Lead lead) {
        if (lead.IsConverted) {
            return false;
        }
        
        if (lead.LeadSource != 'Webform' && Leads.isLebensversicherung(lead.RecordTypeId)) {
            return true;
        }
        
        return lead.Phone != null && lead.Confirmed_Terms_And_Conditions__c;
    }
}