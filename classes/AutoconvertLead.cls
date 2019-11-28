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
    
    @TestVisible
    private static boolean shouldConvert(Lead lead) {
        if (lead.IsConverted) {
            System.debug('Should convert lead.isConverted = ' + lead.IsConverted);
            return false;
        }
        
        // NHC -- 29.11.2019 -- disabled
        /*
        if (lead.LeadSource != 'Webform' && Leads.isLebensversicherung(lead.RecordTypeId)) {
            return true;
        }
        */
        
        System.debug('Should convert lead.termsandconditions = ' + lead.Confirmed_Terms_And_Conditions__c);
        System.debug('Should convert lead.phone = ' + lead.phone);
        return lead.Phone != null && lead.Confirmed_Terms_And_Conditions__c;
    }
}