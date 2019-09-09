@RestResource(urlMapping='/vh/newsletter')
global class API_Newsletter {
    
    @HttpPost
    global static void Signup() { 
        String uniqueId = RestContext.request.params.get('unique');
        
        if (String.isBlank(uniqueId)) {
            throw new API_Exception('Unique ID is NULL');
        }
        
        Contact c = fetchContact(uniqueId);
        
        if (c != null) {
            updateContact(c);
            return;
        }
        
        Lead l = fetchLead(uniqueId);
		
        if (l != null) {
            updateLead(l);
			return;
        }
        
        throw new API_Exception('Could not find Lead or Account with uniqueId: (' + uniqueId + ')');
    }

    private static void updateContact(Contact c) {
    	c.Newsletter_Registered__c = true;
        c.Newsletter_Registration_Date__c = System.today();
        update c;
    }   
    
    private static void updateLead(Lead l) {
        l.Newsletter_Registration_Date__c = System.today();
        l.Newsletter_Registered__c = true;
        update l;
    }
    
    private static Contact fetchContact(string uniqueId) {
        List<Contact> c = [
            SELECT Id
            FROM Contact
            WHERE Unique_Id__c = :uniqueId
        ];
        
        if (c.size() == 0) {
            return null;
        }
        
        return c[0];
    }
    
    private static Lead fetchLead(string uniqueId) {
		List<Lead> l = [
            SELECT Id
            FROM Lead
            WHERE Unique_Id__c = :uniqueId
            AND IsConverted = false
        ];
        
        if (l.size() == 0) {
            return null;
        }
        
        return l[0];
    }
}