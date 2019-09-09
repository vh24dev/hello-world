public class LeadPickNextExtension {
    private final String leadID;
	public LeadPickNextExtension(ApexPages.StandardController stdCtl) {
        this.leadID = stdCtl.getId();
    }

	// Grab the next oldest "New" lead with the same LeadSource, with availability set to the current time of time,
    // i.e., morning, afternoon, evening.
    // Get any "New" lead with no "CallCenter" if none matching availability has been found.    
    public PageReference pickNext() {
        Integer morning = 0;
        Integer noon = 12;
        Integer afternoon = 18;
		Integer hour = System.now().hour();
        String partOfDay;

        Lead[] leads = new Lead[]{};
        Lead l = [SELECT ID, LeadSource FROM Lead WHERE Id = :this.leadID];
        if (hour >= morning && hour < noon){
            leads = leads('vormittags', l.leadSource, new String[]{this.leadID});
        } else if (hour >= noon && hour < afternoon){
            leads = leads('nachmittags', l.leadSource, new String[]{this.leadID});
        } else if (hour >= afternoon && hour < morning){
            leads = leads('abends', l.leadSource, new String[]{this.leadID});
        }

        if (leads.size() == 0){
            leads = leads = leads(null, l.leadSource, new String[]{this.leadID});
            if (leads.size() == 0) {
                return Page.NothingToPick;
            }
        }
        Lead oldestLead = leads[0];

        String managementRoleID = UserRoles.ManagementID; // 00E1t000000DktIEAS
        String callcenterRoleID = UserRoles.CallcenterID; // 00E1t000000Dkt8EAC
        String adminRoleID = UserRoles.AdminID; // 00E1t000000DksyEAC
        String userRoleID = UserInfo.getUserRoleId();
        if (!String.isBlank(userRoleID)
            && userRoleID != Id.valueOf(managementRoleID)
            && userRoleID != Id.valueOf(callcenterRoleID)
            && userRoleID != Id.valueOf(adminRoleID)) {
            return Page.WrongUserRole;
        }
        
        oldestLead.Callcenter__c = UserInfo.getUserId();
        update oldestLead;
        
        PageReference pr = new PageReference('/' + oldestLead.ID);
        pr.setRedirect(true);
        return pr;
    }
    
    private Lead[] leads(String availability, String leadSource, String[] notLeadIDs) {
        String availabilityCriteria = String.isBlank(availability) ? '' : 'AND Availability__c INCLUDES (:availability)';
        String query = 
            'SELECT ID, CreatedDate ' + 
            'FROM Lead ' + 
            'WHERE Status = \'New\' ' + 
            	'AND Callcenter__c = null ' + 
            	'AND LeadSource = :leadSource ' +
            	'AND ID NOT IN :notLeadIDs ' +
            	availabilityCriteria +
            'ORDER BY CreatedDate ASC ' + 
            'NULLS LAST ' + 
            'LIMIT 1';
        try {
        	Lead[] ls = Database.query(query);
            return ls;
        } catch(Exception e) {
            System.debug('LeadPickNextExtension :: ex: ' + e.getMessage());
        }
        return new Lead[]{};
    }
}