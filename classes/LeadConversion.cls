// Legacy. Refactoring in progress.
public class LeadConversion {
    public class LeadConversionFailedException extends Exception {}

    @InvocableMethod
    public static void convert(List<ID> leadsToConvert) {
        System.debug('>> LeadConversion :: convert :: leadsToConvert: ' + leadsToConvert);
        
        Lead[] ll = fetchLeads(leadsToConvert);
        
        Set<String> companyNames = new Set<String>();
        Set<String> accountIds = new Set<String>();
        Set<String> accountExternalIds = new Set<String>();
        Boolean addedVw = false;
        for (Lead lead : ll){
            System.debug('LeadConversion :: convert :: lead: ' + lead);

            if(lead == null) {
                continue;
            }

            companyNames.add(lead.Company);
            accountIds.add(lead.Insurance_Lookup__c);
            if (lead.Insurance__c != null){
                accountExternalIds.add(lead.Insurance__c);
            }
            if (lead.Legal_Protection_Insurance__c != null){
                accountExternalIds.add(lead.Legal_Protection_Insurance__c);
            }
            if (lead.Vehicle_Brand__c != null){
                accountExternalIds.add(lead.Vehicle_Brand__c);
            }
            if (lead.Partner__c != null){
                accountExternalIds.add(lead.Partner__c);
            }
            if (lead.Bank__c != null){
                accountExternalIds.add(lead.Bank__c);
            }
        }

        Account[] accounts = [
            SELECT Id,
            Type,
            External_Id__c,
            Name
            FROM Account
            WHERE Name IN :companyNames 
            OR External_Id__c IN :accountExternalIds
            OR Id IN :accountIds
        ];
        System.debug('LeadConversion :: convert :: accounts: ' + accounts);

        OpportunityLineItem[] newOpportunityLineItems = new List<OpportunityLineItem>();
        Opportunity[] updateOpportunities = new List<Opportunity>();

        for (Lead lead : ll){
            System.debug('LeadConversion :: convert :: 2 :: lead: ' + lead);

            if(lead == null || lead.Status == 'Converted') {
                System.debug('LeadConversion :: convert :: 2 :: lead is null or in Converted state: ' + lead);
                continue;
            }

            List<Task> tasksToBeClosed = Tasks.markAsClosed('', lead);
            if (tasksToBeClosed.size() > 0) {
                update tasksToBeClosed;
            }

            String personAccountName = '';
            if (lead.FirstName != null) {
                personAccountName = personAccountName + lead.FirstName + ' ';
            }
            personAccountName = personAccountName + lead.LastName;

            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(lead.id);
            lc.setConvertedStatus('Converted');

            String vehicleBrandId = lead.Vehicle_Brand__c;
            if (Leads.isDieselSkandal(lead.recordtypeID)) {
                String vehicleBrandString = '';
                for (Account account : accounts) {
                    if ((account.External_Id__c != null) && (account.External_Id__c != '')) {
                        if (account.External_Id__c == vehicleBrandId) {
                            vehicleBrandString = ', ' + account.Name;
                        }
                    }
                }
                lc.setOpportunityName(personAccountName + vehicleBrandString);
            } else {
                String insurance = '';
                if (lead.Insurance__c != null){
                    for (Account account : accounts){
                        if ((account.External_Id__c != null) && (account.External_Id__c != '')){
                            if (account.External_Id__c == lead.Insurance__c){
                                insurance = ', ' + account.Name;
                            }
                        }
                    }
                } else if (lead.Insurance_Lookup__c != null){
                    for (Account account : accounts){
                        if (account.Id == lead.Insurance_Lookup__c){
                            insurance = ', ' + account.Name;
                        }
                    }
                }
                lc.setOpportunityName(lead.FirstName + ' ' + lead.LastName + insurance);
            }
            
            // Person account creation
            Account personAccount = new Account(
                Name = personAccountName
            );
            insert personAccount;
            lc.setAccountId(personAccount.Id);
            
            System.debug('PersonAccount = ' + personAccount);
            
            Database.LeadConvertResult lcr;
            try {
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.duplicateRuleHeader.allowSave = true;
                lcr = Database.convertLead(lc, dml);
            } catch (System.DmlException e) {
                System.debug('AutoConvertLeads :: convert :: dml failed to convert lead: ' + e.getMessage());
                delete personAccount;
                return;
                // Swallowing the error for now.
                //throw new LeadConversionFailedException('Failed to convert lead: ' + e.getMessage());
                // todo: better UX
            } 

            if (!lcr.isSuccess()) {
               System.debug('AutoConvertLeads :: convert :: actually failed to convert lead : ');
                For(Database.Error e : lcr.getErrors()) {
                    System.debug('error: ' + e.getMessage());
                    
                    system.debug('fields' + e.getFields());
                    system.debug(e.getStatusCode());
             
                    For(string s : e.getFields()) {
                        System.debug('more: ' + s);
                        For(string x : e.fields) {
                        System.debug('x: ' + x);
                        }
                    }
                }
                delete personAccount;
                return; 
            }
            
            Id opportunityId = lcr.getOpportunityId();
            Id contactId = lcr.getContactId();
            
            Opportunity opportunity = [select Id,
                                       Refund__c,
                                       Backoffice__c,
                                       Assignment_Type__c,
                                       Partial_Refund__c,
                                       Legal__c,
                                       Legal_Process_Type__c,
                                       StageName,
                                       Reference__c,
                                       Sales_Type__c,
                                       Account_Id__c,
                                       Process_Type__c,
                                       Priority_Level__c,
                                       Vehicle_Brand__c,
                                       Confirmed_Terms_And_Conditions__c, 
                                       RecordTypeId, 
                                       Callcenter__c, 
                                       AccountId, 
                                       Account__c from Opportunity where Id = :opportunityId];
            
            System.debug('LeadConversion :: convert :: convertedOpp: ' + opportunity);
            System.debug('LeadConversion :: convert :: convertedContact: ' + contactId);
            
            opportunity.Contact__c = contactId;
            if (opportunity.Callcenter__c == null) {
                opportunity.Callcenter__c = lead.Callcenter__c;
            }
            for (Account account : accounts){
                // Company account merging
                if (account.Name == lead.Company){
                    opportunity.AccountId = account.Id;
                }
                if ((account.External_Id__c != null) && (account.External_Id__c != '')){
                    if (account.External_Id__c == lead.Insurance__c){
                        opportunity.Insurance__c = account.Id;  
                    } 
                    if (account.External_Id__c == lead.Legal_Protection_Insurance__c
                       		&& account.Type == 'Rechtsschutzversicherung') { // fix for rsv filter: https://trello.com/c/jOlsJC10/502-lv-agb-anfordern-link
                        opportunity.Legal_Protection_Insurance__c = account.Id;
                    }
                    if (account.External_Id__c == lead.Partner__c){
                        opportunity.Partner__c = account.Id;
                    }
                    if (account.External_Id__c == vehicleBrandId){
                        opportunity.Vehicle_Brand__c = account.Id;
                    }
                    if (account.External_Id__c == lead.Bank__c){
                        opportunity.Bank__c = account.Id;
                    }
                }
            }
            
            // Create CompanyAccount if not existent yet
            if (opportunity.AccountId == null){
                Account account = new Account(
                    Name = lead.Company,
                    Type = 'Anbieter'
                );
                insert account;
                opportunity.AccountId = account.Id;
            }
            
            // Match VH24 or VR24 from Lead to Opp
            if (opportunity.Account__c == null && lead.Account__c != null) {
                opportunity.Account__c = lead.Account__c;
                System.debug('LeadConversion :: matching account__c for lead: ' + lead + ' and opp: ' + opportunity);
            }
            
            // Set product code and record type
            String productCode;
            if (Leads.isDieselSkandal(lead.recordtypeID)){
                productCode = 'sp001';
            } else if (Leads.isFinanzierung(lead.recordtypeID)){
                productCode = 'sp002';
            } else {
                productCode = 'vp001';
            }
            
            if (lead.Product_Code__c != null){
                productCode = lead.Product_Code__c;
            }
            
            if ((productCode == 'sp001') || Leads.isDieselSkandal(lead.recordtypeID)) {
                opportunity.RecordTypeId = Opportunities.dieselSkandalRecordType();
                opportunity.Follow_up_Period__c = 2;
            } else if ((productCode == 'sp002') || Leads.isFinanzierung(lead.recordtypeID)) {
                opportunity.RecordTypeId = Opportunities.finanzierungRecordType();
                opportunity.Follow_up_Period__c = 1;
            } else {
                opportunity.RecordTypeId = Opportunities.lebensversicherungRecordType();
                opportunity.Follow_up_Period__c = 1;
            }
            
            // Set Process Type (muss gemacht werden, da der Convert sonst bei falschem Setzen des Standard-Recordtypes fehlschlägt)
            opportunity.Process_Type__c = lead.Process_Type__c;
            
            try {
                PricebookEntry pricebookEntry = [select Id from PricebookEntry where Product2.ProductCode = :productCode AND Pricebook2Id = :PricebookUtils.getStdPricebookId()];
                newOpportunityLineItems.add(new OpportunityLineItem(
                    OpportunityId = opportunityId,
                    PricebookEntryId = pricebookEntry.Id,
                    Quantity = 1,
                    TotalPrice = 0
                ));
            } catch (Exception e) {
                System.debug('Error on creating opportunity product on lead convert: ' + e.getMessage());
            }
            
            // Vollmacht (Authorization__c) doc hasn't finished being generated at this point. Email will be sent when the doc is posted to Salesforce from our docgen server.
            // https://salesfive.atlassian.net/browse/VH24-78
            ID templID;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) {
                if (FeatureFlags.ENABLE_AUTO_EMAIL_ON_DOCGEN) {
                    templID = EmailTemplates.idOf(EmailTemplates.general.DieselskandalGeneralWebformStep3MessageVh24);
                } else {
                	SendMail.AsyncEmailUtilities(opportunityId, contactId, EmailTemplates.idOf(EmailTemplates.general.DieselskandalGeneralWebformStep3MessageVh24), lead.Callcenter__c);   
                }
            } else if (Opportunities.isLebensversicherung(opportunity.RecordTypeId)) {
                if (FeatureFlags.ENABLE_AUTO_EMAIL_ON_DOCGEN) {
                    templID = EmailTemplates.idOf(EmailTemplates.LvBackoffice.LvBackofficeAuthorizationVh24);
                } else {
                	SendMail.AsyncEmailUtilities(opportunityId, contactId, EmailTemplates.idOf(EmailTemplates.LvBackoffice.LvBackofficeAuthorizationVh24), lead.Callcenter__c);
                }

                opportunity.StageName = 'New'; // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-48
            }
            
            if (templID != null) {
				Logger.debug('LeadConversion :: setting async email templateID vollmacht_Email_TemplateID__c:' + templID);
				opportunity.vollmacht_Email_TemplateID__c = templID;
            }
            
            if(Opportunities.isFinanzierung(opportunity.RecordTypeId) ||
              Opportunities.isDieselskandal(opportunity.RecordTypeId)){
            	createAuthorizations(opportunity);
            }
            
            if(Opportunities.isLebensversicherung(opportunity.RecordTypeId) &&
               lcr.getContactId() != null
              ){
        		Map<Id,String> bnids = new Map<Id, String>();
               	LVAGBMailManager.executeLVAGBMail(lcr.getContactId(),lead.Bearbeitungsnummer__c);
            }

            updateOpportunities.add(opportunity);
            
        }

        if (updateOpportunities.size() > 0){
            update updateOpportunities;
        }

        if (newOpportunityLineItems.size() > 0){
            insert newOpportunityLineItems;
        }
    }
    
    private static void createAuthorizations(Opportunity opp){
    	if ((opp.Authorizations__r.size() == 0) && 
            (opp.Confirmed_Terms_And_Conditions__c == true) && 
            (opp.Legal__c != null) 
            ){
				Authorization__c auth = new Authorization__c(
                	Opportunity__c = opp.Id,
                    Stage__c = 'Draft'
                );	
                insert auth;
             }      
    }

    private static Lead[] fetchLeads(ID[] ll) {
        return [
            SELECT  ID,
            Bearbeitungsnummer__c,
            ConvertedContactId,
            IsConverted,
            RecordTypeID,
            FirstName,
            LastName,
            Company,
            Callcenter__c,
            Callcenter__r.id,
            Callcenter__r.isActive,
            Account__c,
            Insurance_Lookup__c,
            Insurance__c,
            Legal_Protection_Insurance__c,
            Vehicle_Brand__c,
            Partner__c,
            Bank__c,
            Product_Code__c,
            Process_Type__c,
            Status,
            (SELECT ID, Subject, Status FROM Tasks)
            FROM Lead
            WHERE ID IN :ll
        ];    
    }
   
}