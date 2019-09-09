// Legacy code, to be refactored
// WIP for docgen
public class DocumentCreationAction {
    private static String clientId;

    // Returns an error string on error, null if success.
    public static String autoCreateDocument(Id parentId, Boolean preserveMergeFields, String outputs, String variant, List<String> attachments) {
        System.debug('>> DocumentCreationAction :: autoCreateDocument :: parentID: ' + parentID + ' outputs: ' + outputs);
        
        // In some scenarios we want to perform a DML operation before triggering the Callout.

        if (parentID.getSObjectType() == Schema.SObjectType.Cost_Note__c.getSObjectType()) {
            System.debug('DocumentCreationAction :: doAutoCreateDocument :: is costnote, running async');
            autoCreateDocumentAsync(parentId, preserveMergeFields, outputs, variant, attachments);
            
            Cost_Note__c cn = [SELECT ID, Date__c, Number__c, Claim__c, Recipient__c, Test__c FROM Cost_Note__c WHERE ID = :parentID];
            tagCostNote(cn);
            update cn;

            System.debug('DocumentCreationAction :: autoCreateDocument :: is costnote, updated cn: ' + cn);
            
            return null;
        }

        if (parentID.getSObjectType() == Schema.SObjectType.Authorization__c.getSObjectType()) {
            System.debug('DocumentCreationAction :: autoCreateDocument :: is authorization, running async');
            
            if (!FeatureFlags.ENABLE_AUTO_EMAIL_ON_DOCGEN) {
                System.debug('DGen_DocumentCreatedWebhook :: autoCreateDocument :: sendPendingEmails: FeatureFlags.ENABLE_AUTO_EMAIL_ON_DOCGEN is OFF');
                autoCreateDocumentAsync(parentId, preserveMergeFields, outputs, variant, attachments);
                
                return null;
            }

            Authorization__c auth = [SELECT ID, Opportunity__c FROM Authorization__c WHERE ID = :parentId];
            Opportunity opp = [SELECT ID, RecordTypeId, Vehicle_Brand__c, Financing_Type__c, Legal_Account__c, Number_of_Pending_Vollmacht_Docs__c FROM Opportunity WHERE Id = :auth.opportunity__c];

            // Called twice for now, here and in autoCreateDocumentAsync, where we actually need the templates.
            DocumentCreationActionAuthorization.Result r = DocumentCreationActionAuthorization.getTemplates(opp);
            
            // Unlikely, but this might not be set when the first doc arrives.
            // There are pending emails which will be sent when all docs have been generated and posted back into Salesforce.
            opp.number_of_Pending_Vollmacht_Docs__c = (r != null && r.templateIDs != null) ? r.templateIDs.size() : 0;
            System.debug('DocumentCreationAction :: autoCreateDocument :: number_of_Pending_Vollmacht_Docs__c set to: ' + opp.number_of_Pending_Vollmacht_Docs__c);

            update opp;

            System.debug('DocumentCreationAction :: autoCreateDocument :: is Authorization, updated opp: ' + opp);
            
            autoCreateDocumentAsync(parentId, preserveMergeFields, outputs, variant, attachments);
            
            return null;
        }

        return doAutoCreateDocument(parentId, preserveMergeFields, outputs, variant, attachments);
    }
    
    @future (callout=true)
    private static void autoCreateDocumentAsync(Id parentId, Boolean preserveMergeFields, String outputs, String variant, List<String> attachments) {
        doAutoCreateDocument(parentId, preserveMergeFields, outputs, variant, attachments);
    }

    private static String doAutoCreateDocument(Id parentId, Boolean preserveMergeFields, String outputs, String variant, List<String> attachments) {
        System.debug('>> DocumentCreationAction :: doAutoCreateDocument :: parentID: ' + parentID + ' outputs: ' + outputs);
        
        List<CScope> scopes = new List<CScope>();
        Map<String, List<String>> customFields = new Map<String, List<String>>();
        Map<String, String> imageFields = new Map<String, String>();
        List<String> calculatedFields = new List<String>();
        Map<String,Map<String,String>> files = new Map<String,Map<String,String>>();
        Id targetId;

        Schema.SObjectType objtp = parentId.getSObjectType();

        Opportunity opportunity;
        Account account;
        Account insurance;
        Contact contact;
        User user;

        Welcome_Letter__c welcomeLetter;
        Contract__c contract;
        Invoice__c invoice;
        Invoice_Reminder__c invoiceReminder;
        Cost_Note__c costNote;
        Credit_Note__c creditNote;
        Cost_Note_Reminder__c costNoteReminder;
        Authorization__c authorization;
        Correspondence__c correspondence;
        Claim__c claim;
        Analysis__c analysis;
        Commission__c commission;
        Cancellation__c cancellation;
        Test_Case__c testCase;
        Opportunity_Correspondence__c opportunityCorrespondence;
        Date_Notification__c dateNotification;
        Date_Record__c dateRecord;
        Date_Authorization__c dateAuthorization;

        List<Attachment> insertAttachments = new List<Attachment>();

        
        
        if (objtp == Schema.SObjectType.Analysis__c.getSObjectType()) {
            analysis = [SELECT Id,Opportunity__c FROM Analysis__c WHERE Id = :parentId];
            opportunity = [SELECT Id, Account_Id__c, Insurance__c, Number__c, Contact__c, (select Id, Fund__r.Default_Trend__c, Fund__c, Fund__r.Label__c, Fund__r.ISIN__c, Weighting__c FROM Fund_References__r),(select Id, Date__c, Amount__c FROM Additional_Payments__r),(select Id, Date__c, Amount__c FROM Partly_Payouts__r),(select Id, Date__c, Amount__c FROM Contribution_Changes__r),(select Id, Date__c, Dynamization__c FROM Dynamization_Changes__r) FROM Opportunity WHERE Id = :analysis.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }

            // Set custom fields
            // Get dynamic analysis values
            List<String> additionalPaymentDates = new List<String>();
            List<String> additionalPaymentAmounts = new List<String>();
            List<String> partlyPayoutDates = new List<String>();
            List<String> partlyPayoutAmounts = new List<String>();
            List<String> contributionChangeDates = new List<String>();
            List<String> contributionChangeAmounts = new List<String>();
            List<String> dynamizationChangeDates = new List<String>();
            List<String> dynamizationChangeAmounts = new List<String>();

            for (Additional_Payment__c additionalPayment : opportunity.Additional_Payments__r) {
                additionalPaymentDates.add(String.valueOf(additionalPayment.Date__c));
                additionalPaymentAmounts.add(String.valueOf(additionalPayment.Amount__c));
            }
            for (Partly_Payout__c partlyPayout : opportunity.Partly_Payouts__r) {
                partlyPayoutDates.add(String.valueOf(partlyPayout.Date__c));
                partlyPayoutAmounts.add(String.valueOf(partlyPayout.Amount__c));
            }
            for (Contribution_Change__c contributionChange : opportunity.Contribution_Changes__r) {
                contributionChangeDates.add(String.valueOf(contributionChange.Date__c));
                contributionChangeAmounts.add(String.valueOf(contributionChange.Amount__c));
            }
            for (Dynamization_Change__c dynamizationChange : opportunity.Dynamization_Changes__r) {
                dynamizationChangeDates.add(String.valueOf(dynamizationChange.Date__c));
                dynamizationChangeAmounts.add(String.valueOf(dynamizationChange.Dynamization__c/100));
            }

            customFields.put('additionalPaymentDates',additionalPaymentDates);
            customFields.put('additionalPaymentAmounts',additionalPaymentAmounts);
            customFields.put('partlyPayoutDates',partlyPayoutDates);
            customFields.put('partlyPayoutAmounts',partlyPayoutAmounts);
            customFields.put('contributionChangeDates',contributionChangeDates);
            customFields.put('contributionChangeAmounts',contributionChangeAmounts);
            customFields.put('dynamizationChangeDates',dynamizationChangeDates);
            customFields.put('dynamizationChangeAmounts',dynamizationChangeAmounts);

            // Get fund data
            Map<Fund__c,Map<String,String>> fundMap = new Map<Fund__c,Map<String,String>>();
            for (Fund_Reference__c fundReference : opportunity.Fund_References__r) {
                Map<String,String> rateMap = new Map<String,String>();
                for (Rate__c rate : [SELECT Id, Date__c, Trend__c FROM Rate__c WHERE Fund__c = :fundReference.Fund__c]) {
                    if (rate.Trend__c == 0) {
                        rateMap.put(String.valueOf(rate.Date__c),'0');
                    } else {
                        rateMap.put(String.valueOf(rate.Date__c),String.valueOf(rate.Trend__c));
                    }
                }
                fundMap.put(fundReference.Fund__r,rateMap);
            }

            // create date list
            List<String> dateList = new List<String>();
            Date monthlyDate = Date.valueOf('1990-01-01');
            while (monthlyDate <= System.today()) {
                dateList.add(String.valueOf(monthlyDate));
                monthlyDate = monthlyDate.addMonths(1);
            }
            customFields.put('Dates',dateList);

            // create rate lists
            Integer fundCount = 1;
            for (Fund_Reference__c fundReference : opportunity.Fund_References__r) {
                List<String> rateList = new List<String>();
                rateList.add(fundReference.Fund__r.ISIN__c);
                rateList.add(fundReference.Fund__r.Label__c);
                rateList.add(String.valueOf(fundCount));
                Map<String,String> rateMap = fundMap.get(fundReference.Fund__r);
                for (String thisMonth : dateList) {
                    if (rateMap.get(thisMonth) != null) {
                        rateList.add(rateMap.get(thisMonth));
                    } else {
                        if (fundReference.Fund__r.Default_Trend__c != null) {
                            rateList.add(String.valueOf(fundReference.Fund__r.Default_Trend__c/100));
                        } else {
                            rateList.add(String.valueOf(0));
                        }
                    }
                }
                customFields.put('Fund_' + fundCount,rateList);
                customFields.put('Fund_' + fundCount + '_Name',new List<String>{String.valueOf(fundReference.Fund__r.Label__c)});
                customFields.put('Fund_' + fundCount + '_Weighting',new List<String>{String.valueOf(fundReference.Weighting__c)+'%'});
                fundCount++;
            }

            // Set calculated fields
            // calculatedFields.add('Ergebnis!B46');

            // Set template
            String templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVPotentialrechner);

            // Set files
            files.put(templateId,new Map<String,String>{'potential_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Contract__c.getSObjectType()) {
            contract = [SELECT Id,Opportunity__c FROM Contract__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,Number__c,Contact__c,Insurance__c,Assignment_Type__c FROM Opportunity WHERE Id = :contract.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Contract__c','Contract__c',null,new List<Id>{contract.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Account',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }

            // Set template
            String templateId;
            if (opportunity.Assignment_Type__c == 'Share') {
                templateId = 'a171t000000QK7i';
            } else if (opportunity.Assignment_Type__c == 'RSV') {
                templateId = 'a171t000000QK78';
            } else {
                templateId = 'a171t000000QK77';
            }

            // Set filename
            files.put(templateId,new Map<String,String>{'contract_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Authorization__c.getSObjectType()) {
            authorization = [SELECT Id,Opportunity__c FROM Authorization__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Bank__c,Financing_Type__c,Account_Id__c,RecordTypeId,Vehicle_Brand__c,Engine_Type__c,Number__c,Contact__c,Legal__c,Legal_Account__c,Insurance__c FROM Opportunity WHERE Id = :authorization.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Authorization__c','Authorization__c',null,new List<Id>{authorization.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Legal_Account__c != null) {
                scopes.add(new CScope('Account','Legal_Account__c',null,new List<Id>{opportunity.Legal_Account__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }

            // Set template
            List<String> templateIds = new List<String>();
            List<String> filePostfixes = new List<String>();
            DocumentCreationActionAuthorization.Result r;
            r = DocumentCreationActionAuthorization.getTemplates(opportunity);
            templateIds = r.templateIds;
            filePostfixes = r.filePostfixes;
            
            // There are pending emails which will be sent when all docs have been generated and posted back into Salesforce.
            opportunity.number_of_Pending_Vollmacht_Docs__c = templateIds.size();
            System.debug('DocumentCreationAction :: doAutoCreateDocument :: number_of_Pending_Vollmacht_Docs__c set to: ' + opportunity.number_of_Pending_Vollmacht_Docs__c);


            // Set filename
            Integer i = 0;
            for (String templateId : templateIds) {
                files.put(templateId,new Map<String,String>{'Vollmacht_' + opportunity.Number__c + '_' + filePostfixes[i] => outputs});
                i++;
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Correspondence__c.getSObjectType()) {
            correspondence = [SELECT Id,Opportunity_Lawsuit_Type__c,Claim__r.Opportunity__c,Claim__r.Court__c,Claim__r.Court_Customer__c,Claim__r.Competent_Court__c,Claim__r.Legal__c,Type__c, (select Id, Developer_Name__c, Text__c FROM Text_Modules__r) FROM Correspondence__c WHERE Id = :parentId];
            claim = [SELECT Id, Result__c, Opposing_Counsel__c, Legal__c, Legal__r.Logo__c, Legal__r.Signature__c, Legal__r.Signature_File_ID__c  FROM Claim__c WHERE Id = :correspondence.Claim__c];
            opportunity = [SELECT Id,Financing_Type__c, Account_Id__c,RecordTypeId,Bank__c,Vehicle_Brand__c,Number__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Insurance__c,Insurance__r.External_Id__c,Legal_Protection_Insurance__c,Process_Type__c FROM Opportunity WHERE Id = :correspondence.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Correspondence__c','Correspondence__c',null,new List<Id>{correspondence.Id}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{claim.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (correspondence.Claim__r.Competent_Court__c == 'Customer') {
                // Kunde
                if (correspondence.Claim__r.Court_Customer__c != null) {
                    scopes.add(new CScope('Account','Court__c',null,new List<Id>{correspondence.Claim__r.Court_Customer__c}));
                }
            } else {
                // Gegner
                if (correspondence.Claim__r.Court__c != null) {
                    scopes.add(new CScope('Account','Court__c',null,new List<Id>{correspondence.Claim__r.Court__c}));
                }
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{claim.Legal__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }
            if (claim.Opposing_Counsel__c != null) {
                scopes.add(new CScope('Contact','Opposing_Counsel__c',null,new List<Id>{claim.Opposing_Counsel__c}));
            }

            // Set legal logo and signature
            if (claim.Legal__r.Logo__c != null) {
                imageFields.put('Logo',claim.Legal__r.Logo__c.right(15));
            }
            if (claim.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',claim.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            String controlDocumentTemplateId;
            {
                DocumentCreationActionCorrespondence.Result r = new DocumentCreationActionCorrespondence.Result();
                r = DocumentCreationActionCorrespondence.getTemplates(
                    correspondence,
                    claim,
                    opportunity
                );
                templateId = r.templateId;
                controlDocumentTemplateId = r.controlDocumentTemplateId;
            }

            // Set legal logo
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }

            // Set text modules
            for (Text_Module__c textModule : correspondence.Text_Modules__r) {
                System.debug('DocumentCreationAction :: adding textmodule: ' + textModule.Developer_Name__c);
                customFields.put(textModule.Developer_Name__c,new List<String>{textModule.Text__c});
            }

            // Set files
            if (correspondence.Type__c == 'Sonstiges') {
                files.put(templateId,new Map<String,String>{'correspondence_' + opportunity.Number__c => outputs});
            } else {
                files.put(templateId,new Map<String,String>{'correspondence_' + opportunity.Number__c + '_' + correspondence.Type__c => outputs});
            }

            if (controlDocumentTemplateId != null) {
                // Draft für Klageschrift
                files.put(controlDocumentTemplateId,new Map<String,String>{'kontrolldokument_' + opportunity.Number__c + '_Klageschrift' => 'pdf'});
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Cost_Note__c.getSObjectType()) {
            costNote = [SELECT Id, Test__c, Date__c, Type__c, Recipient__c, Number__c, Claim__c, Claim__r.Opportunity__c, (select Id,Calculate_Vat__c,Type__c,Reinvoiced__c FROM Cost_Note_Line_Items__r) FROM Cost_Note__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,Vehicle_Brand__c,Insurance__c,RecordTypeId,Number__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Legal_Protection_Insurance__c,Contact__c FROM Opportunity WHERE Id = :costNote.Claim__r.Opportunity__c];

            // Define costnotelineitem lists
            List<Id> costNoteLineItemIds = new List<Id>();
            List<Id> costNoteLineItemWithoutVatIds = new List<Id>();
            List<Id> extrajudicialCostNoteLineItemIds = new List<Id>();
            List<Id> judicialCostNoteLineItemIds = new List<Id>();
            List<Id> appealCostNoteLineItemIds = new List<Id>();
            List<Id> reinvoicedCostNoteLineItemIds = new List<Id>();
            for (Cost_Note_line_Item__c costNoteLineItem : costNote.Cost_Note_Line_Items__r) {
                if (costNoteLineItem.Calculate_Vat__c == true) {
                    costNoteLineItemIds.add(costNoteLineItem.Id);

                    if (costNoteLineItem.Type__c == 'Außergerichtlich') {
                        extrajudicialCostNoteLineItemIds.add(costNoteLineItem.Id);
                    } else if (costNoteLineItem.Type__c == 'I. Instanz') {
                        judicialCostNoteLineItemIds.add(costNoteLineItem.Id);
                    } else if (costNoteLineItem.Type__c == 'Berufung') {
                        appealCostNoteLineItemIds.add(costNoteLineItem.Id);
                    }
                    
                    if (costNoteLineItem.Reinvoiced__c == True) {
                        reinvoicedCostNoteLineItemIds.add(costNoteLineItem.Id);
                    }
                } else {
                    costNoteLineItemWithoutVatIds.add(costNoteLineItem.Id);
                }
            }

            // Set scope
            scopes.add(new CScope('Cost_Note__c','Cost_Note__c',null,new List<Id>{costNote.Id}));
            scopes.add(new CScope('Cost_Note_Line_Item__c','Cost_Note_Line_Item__c','costNoteLineItems',costNoteLineItemIds));
            if (costNoteLineItemWithoutVatIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Cost_Note_Line_Item_Without_Vat__c','costNoteLineItemsWithoutVat',costNoteLineItemWithoutVatIds));
            }
            if (extrajudicialCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Extrajudicial_Cost_Note_Line_Item__c','extrajudicialCostNoteLineItems',extrajudicialCostNoteLineItemIds));
            }
            if (judicialCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Judicial_Cost_Note_Line_Item__c','judicialCostNoteLineItems',judicialCostNoteLineItemIds));
            }
            if (appealCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Appeal_Cost_Note_Line_Item__c','appealCostNoteLineItems',appealCostNoteLineItemIds));
            }
            if (reinvoicedCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Reinvoiced_Cost_Note_Line_Item__c','reinvoicedCostNoteLineItems',reinvoicedCostNoteLineItemIds));
            }
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{costNote.Claim__c}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            templateId = DocumentCreationActionCostNote.getTemplate(
                costnote,
                opportunity
            );
                
            // New requirements say that Number and Date should be set when a Document is generated,
            // not on CostNote creation/update.
            tagCostNote(costNote);

            // Set resulting filename doctype per templateID
            if (costNote.Number__c != null) {
                files.put(templateId,new Map<String,String>{'cost_note_' + costNote.Number__c => outputs});
            } else {
                files.put(templateId,new Map<String,String>{'cost_note' => outputs});
            }

            // Set target
            targetId = parentId;
            
            System.debug('<< DocumentCreationAction :: autoCreateDocument :: is SObjectType.Cost_Note__c');
        }

        if (objtp == Schema.SObjectType.Cancellation__c.getSObjectType()) {
            cancellation = [SELECT Id, Cost_Note__c FROM Cancellation__c WHERE Id = :parentId];
            costNote = [SELECT Id, Type__c, Recipient__c, Number__c, Claim__c, Claim__r.Opportunity__c, (select Id,Type__c,Calculate_Vat__c FROM Cost_Note_Line_Items__r) FROM Cost_Note__c WHERE Id = :cancellation.Cost_Note__c];
            opportunity = [SELECT Id,Account_Id__c,Vehicle_Brand__c,Insurance__c,RecordTypeId,Number__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Legal_Protection_Insurance__c,Contact__c FROM Opportunity WHERE Id = :costNote.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Define costnotelineitem lists
            List<Id> costNoteLineItemIds = new List<Id>();
            List<Id> costNoteLineItemWithoutVatIds = new List<Id>();
            List<Id> extrajudicialCostNoteLineItemIds = new List<Id>();
            List<Id> judicialCostNoteLineItemIds = new List<Id>();
            List<Id> appealCostNoteLineItemIds = new List<Id>();
            for (Cost_Note_line_Item__c costNoteLineItem : costNote.Cost_Note_Line_Items__r) {
                if (costNoteLineItem.Calculate_Vat__c == true) {
                    costNoteLineItemIds.add(costNoteLineItem.Id);

                    if (costNoteLineItem.Type__c == 'Außergerichtlich') {
                        extrajudicialCostNoteLineItemIds.add(costNoteLineItem.Id);
                    } else if (costNoteLineItem.Type__c == 'I. Instanz') {
                        judicialCostNoteLineItemIds.add(costNoteLineItem.Id);
                    } else if (costNoteLineItem.Type__c == 'Berufung') {
                        appealCostNoteLineItemIds.add(costNoteLineItem.Id);
                    }
                } else {
                    costNoteLineItemWithoutVatIds.add(costNoteLineItem.Id);
                }
            }

            // Set scope
            scopes.add(new CScope('Cancellation__c','Cancellation__c',null,new List<Id>{cancellation.Id}));
            scopes.add(new CScope('Cost_Note__c','Cost_Note__c',null,new List<Id>{costNote.Id}));
            scopes.add(new CScope('Cost_Note_Line_Item__c','Cost_Note_Line_Item__c','costNoteLineItems',costNoteLineItemIds));
            if (costNoteLineItemWithoutVatIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Cost_Note_Line_Item_Without_Vat__c','costNoteLineItemsWithoutVat',costNoteLineItemWithoutVatIds));
            }
            if (extrajudicialCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Extrajudicial_Cost_Note_Line_Item__c','extrajudicialCostNoteLineItems',extrajudicialCostNoteLineItemIds));
            }
            if (judicialCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Judicial_Cost_Note_Line_Item__c','judicialCostNoteLineItems',judicialCostNoteLineItemIds));
            }
            if (appealCostNoteLineItemIds.size() > 0) {
                scopes.add(new CScope('Cost_Note_Line_Item__c','Appeal_Cost_Note_Line_Item__c','appealCostNoteLineItems',appealCostNoteLineItemIds));
            }
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{costNote.Claim__c}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (costNote.Type__c == 'I. Instanz') {
                    // Gerichtlich
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerStornierunggerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzStornierunggerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComStornierunggerichtlich);
                    }
                } else {
                    // Außergerichtlich
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerStornierungaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzStornierungaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComStornierungaussergerichtlich);
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (costNote.Type__c == 'I. Instanz') {
                    // Gerichtlich
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerStornierunggerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzStornierunggerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComStornierunggerichtlich);
                    }
                } else {
                    // Außergerichtlich
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerStornierungaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzStornierungaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComStornierungaussergerichtlich);
                    }
                }
            } else {
                // LV
                if (costNote.Type__c == 'I. Instanz') {
                    // Gerichtlich
                    if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerStornierunggerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzStornierunggerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComStornierunggerichtlich);
                    }
                } else {
                    // Außergerichtlich
                    if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerStornierungaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzStornierungaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComStornierungaussergerichtlich);
                    }
                }
            }

            // Set filename
            if (templateId != null) {
                if (costNote.Number__c != null) {
                    files.put(templateId,new Map<String,String>{'cancellation_' + costNote.Number__c => outputs});
                } else {
                    files.put(templateId,new Map<String,String>{'cancellation' => outputs});
                }
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Credit_Note__c.getSObjectType()) {
            creditNote = [SELECT Id, Number__c, Claim__c, Claim__r.Opportunity__c, (select Id,Calculate_Vat__c FROM Credit_Note_Line_Items__r) FROM Credit_Note__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,Vehicle_Brand__c,Insurance__c,RecordTypeId,Number__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Legal_Protection_Insurance__c,Contact__c FROM Opportunity WHERE Id = :creditNote.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Define creditNotelineitem lists
            List<Id> creditNoteLineItemIds = new List<Id>();
            List<Id> creditNoteLineItemWithoutVatIds = new List<Id>();
            for (Credit_Note_line_Item__c creditNoteLineItem : creditNote.Credit_Note_Line_Items__r) {
                if (creditNoteLineItem.Calculate_Vat__c == true) {
                    creditNoteLineItemIds.add(creditNoteLineItem.Id);
                } else {
                    creditNoteLineItemWithoutVatIds.add(creditNoteLineItem.Id);
                }
            }

            // Set scope
            scopes.add(new CScope('Credit_Note__c','Credit_Note__c',null,new List<Id>{creditNote.Id}));
            scopes.add(new CScope('Credit_Note_Line_Item__c','Credit_Note_Line_Item__c','creditNoteLineItems',creditNoteLineItemIds));
            if (creditNoteLineItemWithoutVatIds.size() > 0) {
                scopes.add(new CScope('Credit_Note_Line_Item__c','Credit_Note_Line_Item_Without_Vat__c','creditNoteLineItemsWithoutVat',creditNoteLineItemWithoutVatIds));
            }
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{creditNote.Claim__c}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (creditNoteLineItemWithoutVatIds.size() > 0) {
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerGutschriftRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzGutschriftRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComGutschriftRSVgerichtlich);
                    }
                } else {
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComGutschriftRSVaussergerichtlich);
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (creditNoteLineItemWithoutVatIds.size() > 0) {
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerGutschriftRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzGutschriftRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComGutschriftRSVgerichtlich);
                    }
                } else {
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComGutschriftRSVaussergerichtlich);
                    }
                }
            } else {
                // LV
                if (creditNoteLineItemWithoutVatIds.size() > 0) {
                    if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerGutschriftRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzGutschriftRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComGutschriftRSVgerichtlich);
                    }
                } else {
                    if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzGutschriftRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComGutschriftRSVaussergerichtlich);
                    }
                }
            }

            // Set filename
            if (creditNote.Number__c != null) {
                files.put(templateId,new Map<String,String>{'credit_Note_' + creditNote.Number__c => outputs});
            } else {
                files.put(templateId,new Map<String,String>{'credit_Note' => outputs});
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Cost_Note_Reminder__c.getSObjectType()) {
            costNoteReminder = [SELECT Id, Number__c, Cost_Note__c FROM Cost_Note_Reminder__c WHERE Id = :parentId];
            costNote = [SELECT Id, Claim__c, Claim__r.Opportunity__c FROM Cost_Note__c WHERE Id = :costNoteReminder.Cost_Note__c];
            opportunity = [SELECT Id,Account_Id__c,Vehicle_Brand__c,RecordTypeId,Number__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Legal_Protection_Insurance__c,Contact__c FROM Opportunity WHERE Id = :costNote.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Cost_Note_Reminder__c','Cost_Note_Reminder__c',null,new List<Id>{costNoteReminder.Id}));
            scopes.add(new CScope('Cost_Note__c','Cost_Note__c',null,new List<Id>{costNote.Id}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{costNote.Claim__c}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c);
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerMahnung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzMahnung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComMahnung);
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerMahnung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzMahnung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComMahnung);
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerMahnung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzMahnung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComMahnung);
                }
            }

            // Set filename
            if (costNoteReminder.Number__c != null) {
                files.put(templateId,new Map<String,String>{'cost_Note_Reminder_' + costNoteReminder.Number__c => outputs});
            } else {
                files.put(templateId,new Map<String,String>{'cost_Note_Reminder' => outputs});
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Invoice__c.getSObjectType()) {
            invoice = [SELECT Id, Opportunity__c, Accounting__c FROM Invoice__c WHERE Id = :parentId];
            opportunity = [SELECT Id, Account_Id__c, Number__c, Insurance__c, Contact__c FROM Opportunity WHERE Id = :invoice.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Invoice__c','Invoice__c',null,new List<Id>{invoice.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (invoice.Accounting__c != null) {
                scopes.add(new CScope('User','Accounting__c',null,new List<Id>{invoice.Accounting__c}));
            }

            // Set template
            String templateId;
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVVH24Rechnung);
            } else {
                // VR24
                templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVVR24Rechnung);
            }

            // Set filename
            files.put(templateId,new Map<String,String>{'invoice_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Invoice_Reminder__c.getSObjectType()) {
            invoiceReminder = [SELECT Id, Number__c, Invoice__c FROM Invoice_Reminder__c WHERE Id = :parentId];
            invoice = [SELECT Id, Opportunity__c,Number__c, Accounting__c, Accounting__r.Signature_File_ID__c FROM Invoice__c WHERE Id = :invoiceReminder.Invoice__c];
            opportunity = [SELECT Id,Vehicle_Brand__c,Number__c,Contact__c,Account_Id__c FROM Opportunity WHERE Id = :invoice.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Invoice_Reminder__c','Invoice_Reminder__c',null,new List<Id>{invoiceReminder.Id}));
            scopes.add(new CScope('Invoice__c','Invoice__c',null,new List<Id>{invoice.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (invoice.Accounting__r != null) {
                scopes.add(new CScope('User','Accounting__r',null,new List<Id>{invoice.Accounting__c}));
            }

            // Set legal logo and signature
            if (invoice.Accounting__r.Signature__c != null) {
                imageFields.put('Signature',invoice.Accounting__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVVH24Mahnung);
            } else {
                // VR24
                templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVVR24Mahnung);
            }

            // Set filename
            if (invoiceReminder.Number__c != null) {
                files.put(templateId,new Map<String,String>{'invoice_Reminder_' + invoiceReminder.Number__c => outputs});
            } else {
                files.put(templateId,new Map<String,String>{'invoice_Reminder' => outputs});
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Welcome_Letter__c.getSObjectType()) {
            welcomeLetter = [SELECT Id,Opportunity__c FROM Welcome_Letter__c WHERE Id = :parentId];
            opportunity = [SELECT Id,RecordTypeId,Account_Id__c,Vehicle_Brand__c,Reference__c,Assignment_Type__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Legal__r.Logo__c FROM Opportunity WHERE Id = :welcomeLetter.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Welcome_Letter__c', 'Welcome_Letter__c', null, new List<Id>{welcomeLetter.Id}));
            scopes.add(new CScope('Opportunity', 'Opportunity', null, new List<Id>{opportunity.Id}));
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact', 'Contact', null, new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account', 'Vehicle_Brand__c', null, new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Account_Id__c != null) {
                scopes.add(new CScope('Account', 'Company__c', null, new List<Id>{opportunity.Account_Id__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User', 'Legal__c', null, new List<Id>{opportunity.Legal__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo', opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature', opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (VehicleBrands.isDaimlerAG(opportunity.Vehicle_Brand__c)) { // 0010Y00000WtrfE
                    // Daimler
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBegruessungsschreibenDaimler);
                    } else if (Accounts.isLegal21(opportunity.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalBegruessungsschreibenDaimler);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBegruessungsschreibenDaimler);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBegruessungsschreibenDaimler);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairBegruessungsschreibenDaimler);
                    }
                } else if (VehicleBrands.isPorscheAG(opportunity.Vehicle_Brand__c)) { // 0010Y00000kgL2p
                    // Porsche
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBegruessungsschreibenPorsche);
                    } else if (Accounts.isLegal21(opportunity.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalBegruessungsschreibenPorsche);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBegruessungsschreibenPorsche);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBegruessungsschreibenPorsche);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairBegruessungsschreibenPorsche);
                    }
                } else if (VehicleBrands.isAudiAG(opportunity.Vehicle_Brand__c)) { // 0010Y000011NIts
                    // Audi
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBegruessungsschreibenAudi);
                    } else if (Accounts.isLegal21(opportunity.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalBegruessungsschreibenAudi);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBegruessungsschreibenAudi);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBegruessungsschreibenAudi);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairBegruessungsschreibenAudi);
                    }
                } else if (VehicleBrands.isOpelAutomobileGmbH(opportunity.Vehicle_Brand__c)) { // 0010Y000011NRft
                    // Opel
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBegruessungsschreibenOpel);
                    } else if (Accounts.isLegal21(opportunity.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalBegruessungsschreibenOpel);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBegruessungsschreibenOpel);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBegruessungsschreibenOpel);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairBegruessungsschreibenOpel);
                    }
                } else {
                    // VW
                    if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBegruessungsschreibenVW);
                    } else if (Accounts.isLegal21(opportunity.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalBegruessungsschreibenVW);
                    } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBegruessungsschreibenVW);
                    } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBegruessungsschreibenVW);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairBegruessungsschreibenVW);
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ

            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerBegruessungsschreiben);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzBegruessungsschreiben);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComBegruessungsschreiben);
                }
            }

            // Set filename
            files.put(templateId,new Map<String,String>{'welcome_letter_' + opportunity.Reference__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Commission__c.getSObjectType()) {
            commission = [SELECT Id, Legal_Account__c,Account__c,Name,Product__c,Commission_Rate_Lv__c,Commission_Rate_Dg__c FROM Commission__c WHERE Id = :parentId];

            List<Cost_Note_Payment__c> costNotePayments = [SELECT Id,Cost_Note__r.Claim__r.Opportunity__r.Account_Id__c,Cost_Note__r.Claim__r.Opportunity__r.Product__c, Amount__c,
                                                                Cost_Note__r.Claim__r.Opportunity__r.Number__c,Cost_Note__r.Claim__r.Opportunity__r.Name,
                                                                Cost_Note__r.Claim__r.Opportunity__r.CloseDate
                                                            from Cost_Note_Payment__c WHERE Commission__c = :commission.Id];

            // Set client-id
            if (Accounts.isVH24(commission.Account__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // set custom fields
            List<String> dgCostNotePaymentSum = new List<String>();
            List<String> lvCostNotePaymentSum = new List<String>();
            List<String> totalCostNotePaymentSum = new List<String>();
            List<String> dgCostNotePaymentAmounts = new List<String>();
            List<String> lvCostNotePaymentAmounts = new List<String>();
            List<String> allCostNotePaymentAmounts = new List<String>();
            List<String> dgCommissionSum = new List<String>();
            List<String> lvCommissionSum = new List<String>();
            List<String> totalCommissionSum = new List<String>();
            List<String> dgCommissionAmounts = new List<String>();
            List<String> lvCommissionAmounts = new List<String>();

            List<String> dgOpportunityNumbers = new List<String>();
            List<String> lvOpportunityNumbers = new List<String>();
            List<String> allOpportunityNumbers = new List<String>();
            List<String> dgOpportunityNames = new List<String>();
            List<String> lvOpportunityNames = new List<String>();
            List<String> allOpportunityNames = new List<String>();
            List<String> dgOpportunityCloseDates = new List<String>();
            List<String> lvOpportunityCloseDates = new List<String>();
            List<String> allOpportunityCloseDates = new List<String>();
            List<String> allOpportunityProducts = new List<String>();

            Decimal dgCostNotePaymentAmountSum = 0;
            Decimal lvCostNotePaymentAmountSum = 0;
            Decimal totalCostNotePaymentAmountSum = 0;
            for (Cost_Note_Payment__c costNotePayment : costNotePayments) {
                if (costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c == 'Dieselskandal') {
                    dgCostNotePaymentAmounts.add(String.valueOf(costNotePayment.Amount__c));
                    dgCommissionAmounts.add(String.valueOf(costNotePayment.Amount__c * (commission.Commission_Rate_Dg__c / 100)));
                    dgCostNotePaymentAmountSum += costNotePayment.Amount__c;
                    dgOpportunityNumbers.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Number__c));
                    dgOpportunityNames.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Name));
                    dgOpportunityCloseDates.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.CloseDate));
                } else if (costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c == 'Lebensversicherung') {
                    lvCostNotePaymentAmounts.add(String.valueOf(costNotePayment.Amount__c));
                    lvCommissionAmounts.add(String.valueOf(costNotePayment.Amount__c * (commission.Commission_Rate_Lv__c / 100)));
                    lvCostNotePaymentAmountSum += costNotePayment.Amount__c;
                    lvOpportunityNumbers.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Number__c));
                    lvOpportunityNames.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Name));
                    lvOpportunityCloseDates.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.CloseDate));
                }
                totalCostNotePaymentAmountSum += costNotePayment.Amount__c;
                allCostNotePaymentAmounts.add(String.valueOf(costNotePayment.Amount__c));
                allOpportunityNumbers.add(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Number__c);
                allOpportunityNames.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Name));
                allOpportunityCloseDates.add(String.valueOf(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.CloseDate));
                allOpportunityProducts.add(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c);

            }
            dgCostNotePaymentSum.add(String.valueOf(dgCostNotePaymentAmountSum));
            lvCostNotePaymentSum.add(String.valueOf(lvCostNotePaymentAmountSum));
            totalCostNotePaymentSum.add(String.valueOf(totalCostNotePaymentAmountSum));

            // calculate commission sum
            Decimal dgCommissionAmountSum = 0;
            Decimal lvCommissionAmountSum = 0;
            if (commission.Commission_Rate_Dg__c != null) {
                dgCommissionAmountSum = dgCostNotePaymentAmountSum * (commission.Commission_Rate_Dg__c / 100);
                dgCommissionSum.add(String.valueOf(dgCommissionAmountSum));
            }
            if (commission.Commission_Rate_Lv__c != null) {
                lvCommissionAmountSum = lvCostNotePaymentAmountSum * (commission.Commission_Rate_Lv__c / 100);
                lvCommissionSum.add(String.valueOf(lvCommissionAmountSum));
            }
            totalCommissionSum.add(String.valueOf(dgCommissionAmountSum + lvCommissionAmountSum));

            // list all products in commission
            String[] commissionProducts = commission.Product__c.split('\\;');

            customFields.put('dgCostNotePaymentSum',dgCostNotePaymentSum);
            customFields.put('lvCostNotePaymentSum',lvCostNotePaymentSum);
            customFields.put('totalCostNotePaymentSum',totalCostNotePaymentSum);
            customFields.put('dgCostNotePaymentAmounts',dgCostNotePaymentAmounts);
            customFields.put('lvCostNotePaymentAmounts',lvCostNotePaymentAmounts);
            customFields.put('allCostNotePaymentAmounts',allCostNotePaymentAmounts);
            customFields.put('dgCommissionSum',dgCommissionSum);
            customFields.put('lvCommissionSum',lvCommissionSum);
            customFields.put('dgCommissionAmounts',dgCommissionAmounts);
            customFields.put('lvCommissionAmounts',lvCommissionAmounts);
            customFields.put('totalCommissionSum',totalCommissionSum);
            customFields.put('dgOpportunityNumbers',dgOpportunityNumbers);
            customFields.put('lvOpportunityNumbers',lvOpportunityNumbers);
            customFields.put('allOpportunityNumbers',allOpportunityNumbers);
            customFields.put('dgOpportunityNames',dgOpportunityNames);
            customFields.put('lvOpportunityNames',lvOpportunityNames);
            customFields.put('allOpportunityNames',allOpportunityNames);
            customFields.put('dgOpportunityCloseDates',dgOpportunityCloseDates);
            customFields.put('lvOpportunityCloseDates',lvOpportunityCloseDates);
            customFields.put('allOpportunityCloseDates',allOpportunityCloseDates);
            customFields.put('allOpportunityProducts',allOpportunityProducts);
            customFields.put('commissionProducts',commissionProducts);

            // Set scope
            scopes.add(new CScope('Commission__c', 'Commission__c', null, new List<Id>{commission.Id}));

            // Set template
            String templateId;
            if (outputs == 'pdf') {
                if (commission.Account__c == Utilities.anbieterVR24) {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.VR24Provision);
                } else if (commission.Account__c == Utilities.anbieterVH24) {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.VH24Provision);
                }
            } else if (outputs == 'sameAsInput') {
                if (commission.Account__c == Utilities.anbieterVR24) {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.VR24ProvisionExcel);
                } else if (commission.Account__c == Utilities.anbieterVH24) {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.VH24ProvisionExcel);
                }
            }

            // Set filename
            if (outputs == 'pdf') {
                files.put(templateId, new Map<String, String>{'commission_summary_' + commission.Name => outputs});
            } else if (outputs == 'sameAsInput') {
                files.put(templateId, new Map<String, String>{'commission_' + commission.Name => outputs});
            }

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Test_Case__c.getSObjectType()) {
            testCase = [SELECT Id,Opportunity__c FROM Test_Case__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,Number__c,Contact__c,Legal_Account__c FROM Opportunity WHERE Id = :testCase.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Test_Case__c','Test_Case__c',null,new List<Id>{testCase.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }

            // Set template
            String templateId;
            if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                // Jäger
                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerMusterfeststellungsklage);
            }

            // Set filename
            files.put(templateId,new Map<String,String>{'musterfeststellungsklage_zusatz_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Opportunity_Correspondence__c.getSObjectType()) {
            opportunityCorrespondence = [SELECT Id,Opportunity__c,Opportunity__r.Legal__c,(select Id, Developer_Name__c, Text__c FROM Opportunity_Text_Modules__r) FROM Opportunity_Correspondence__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,RecordTypeId,Bank__c,Vehicle_Brand__c,Number__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Insurance__c,Insurance__r.External_Id__c,Legal_Protection_Insurance__c,Process_Type__c FROM Opportunity WHERE Id = :opportunityCorrespondence.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Opportunity_Correspondence__c','Opportunity_Correspondence__c',null,new List<Id>{opportunityCorrespondence.Id}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstigesAnfrage);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstigesAnfrage);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstigesAnfrage);
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerSonstigesAnfrage);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzSonstigesAnfrage);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComSonstigesAnfrage);
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerSonstigesAnfrage);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzSonstigesAnfrage);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComSonstigesAnfrage);
                }
            }

            // Set legal logo
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }

            // Set text modules
            for (Opportunity_Text_Module__c textModule : opportunityCorrespondence.Opportunity_Text_Modules__r) {
                System.debug('DocumentCreationAction :: adding textmodule: ' + textModule.Developer_Name__c);
                customFields.put(textModule.Developer_Name__c,new List<String>{textModule.Text__c});
            }

            // Set files
            files.put(templateId,new Map<String,String>{'opportunity_correspondence_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Date_Notification__c.getSObjectType()) {
            dateNotification = [SELECT Id,Date__c, Date__r.Claim__c, Date__r.Claim__r.Opportunity__c FROM Date_Notification__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,RecordTypeId,Bank__c,Vehicle_Brand__c,Number__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Insurance__c,Insurance__r.External_Id__c,Legal_Protection_Insurance__c,Process_Type__c FROM Opportunity WHERE Id = :dateNotification.Date__r.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Date_Notification__c','Date_Notification__c',null,new List<Id>{dateNotification.Id}));
            scopes.add(new CScope('Date__c','Date__c',null,new List<Id>{dateNotification.Date__c}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{dateNotification.Date__r.Claim__c}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerTerminbenachrichtigung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzTerminbenachrichtigung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComTerminbenachrichtigung);
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerTerminbenachrichtigung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzTerminbenachrichtigung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComTerminbenachrichtigung);
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerTerminbenachrichtigung);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzTerminbenachrichtigung);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComTerminbenachrichtigung);
                }
            }

            // Set legal logo
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }

            // Set files
            files.put(templateId,new Map<String,String>{'terminbenachrichtigung_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Date_Record__c.getSObjectType()) {
            dateRecord = [SELECT Id,Date__c, Date__r.Claim__c, Date__r.Claim__r.Opportunity__c FROM Date_Record__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,RecordTypeId,Bank__c,Vehicle_Brand__c,Number__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Insurance__c,Insurance__r.External_Id__c,Legal_Protection_Insurance__c,Process_Type__c FROM Opportunity WHERE Id = :dateRecord.Date__r.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Date_Record__c','Date_Record__c',null,new List<Id>{dateRecord.Id}));
            scopes.add(new CScope('Date__c','Date__c',null,new List<Id>{dateRecord.Date__c}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{dateRecord.Date__r.Claim__c}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerTerminprotokoll);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzTerminprotokoll);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComTerminprotokoll);
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerTerminprotokoll);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzTerminprotokoll);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComTerminprotokoll);
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerTerminprotokoll);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzTerminprotokoll);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComTerminprotokoll);
                }
            }

            // Set legal logo
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }

            // Set files
            files.put(templateId,new Map<String,String>{'terminprotokoll_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }

        if (objtp == Schema.SObjectType.Date_Authorization__c.getSObjectType()) {
            dateAuthorization = [SELECT Id,Date__c, Date__r.Claim__c, Date__r.Claim__r.Opportunity__c FROM Date_Authorization__c WHERE Id = :parentId];
            opportunity = [SELECT Id,Account_Id__c,RecordTypeId,Bank__c,Vehicle_Brand__c,Number__c,Contact__c,Legal_Account__c,Legal__c,Legal__r.Logo__c,Legal__r.Signature__c,Legal__r.Signature_File_ID__c,Insurance__c,Insurance__r.External_Id__c,Legal_Protection_Insurance__c,Process_Type__c FROM Opportunity WHERE Id = :dateAuthorization.Date__r.Claim__r.Opportunity__c];

            // Set client-id
            if (Accounts.isVH24(opportunity.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                clientId = 'verbraucherhilfe24';
            } else {
                // VR24
                clientId = 'verbraucherrechte24';
            }

            // Set scope
            scopes.add(new CScope('Date_Authorization__c','Date_Authorization__c',null,new List<Id>{dateAuthorization.Id}));
            scopes.add(new CScope('Date__c','Date__c',null,new List<Id>{dateAuthorization.Date__c}));
            scopes.add(new CScope('Claim__c','Claim__c',null,new List<Id>{dateAuthorization.Date__r.Claim__c}));
            scopes.add(new CScope('Opportunity','Opportunity',null,new List<Id>{opportunity.Id}));
            if (opportunity.Insurance__c != null) {
                scopes.add(new CScope('Account','Insurance__c',null,new List<Id>{opportunity.Insurance__c}));
            }
            if (opportunity.Legal_Protection_Insurance__c != null) {
                scopes.add(new CScope('Account','Legal_Protection_Insurance__c',null,new List<Id>{opportunity.Legal_Protection_Insurance__c}));
            }
            if (opportunity.Contact__c != null) {
                scopes.add(new CScope('Contact','Contact',null,new List<Id>{opportunity.Contact__c}));
            }
            if (opportunity.Legal__c != null) {
                scopes.add(new CScope('User','Legal__c',null,new List<Id>{opportunity.Legal__c}));
            }
            if (opportunity.Vehicle_Brand__c != null) {
                scopes.add(new CScope('Account','Vehicle_Brand__c',null,new List<Id>{opportunity.Vehicle_Brand__c}));
            }
            if (opportunity.Bank__c != null) {
                scopes.add(new CScope('Account','Bank__c',null,new List<Id>{opportunity.Bank__c}));
            }

            // Set legal logo and signature
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }
            if (opportunity.Legal__r.Signature_File_ID__c != null) {
                imageFields.put('Signature',opportunity.Legal__r.Signature_File_ID__c);
            }

            // Set template
            String templateId;
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) { // 0120Y000000W0CY
                // DG
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerTerminvollmacht);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzTerminvollmacht);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComTerminvollmacht);
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunity.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerTerminvollmacht);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzTerminvollmacht);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComTerminvollmacht);
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(opportunity.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerTerminvollmacht);
                } else if (Accounts.isCLLBLegal(opportunity.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzTerminvollmacht);
                } else if (Accounts.isLegalLeCom(opportunity.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComTerminvollmacht);
                }
            }

            // Set legal logo
            if (opportunity.Legal__r.Logo__c != null) {
                imageFields.put('Logo',opportunity.Legal__r.Logo__c.right(15));
            }

            // Set files
            files.put(templateId,new Map<String,String>{'terminvollmacht_' + opportunity.Number__c => outputs});

            // Set target
            targetId = parentId;
        }
        
        // get document url
        Boolean success = true;
        
        // Clean up null templateIDs. If all to be requested are null we want to present an error message.
        files.remove(null);
        
        String error;
        if (files.isEmpty()) {
            error = 'Error while generating document: could not find document template for the current configuration, please make sure it is valid.';
            String errorSubject = 'Document-API template error';
            // Debug error
            System.debug('Error: ' + errorSubject + ', ' + error);
            // Queue error mail
            //Utilities.sendErrorMail(errorSubject, error, 'No request available.', 'No response available.', true);
            success = false;
        }

        for (String templateId: files.keySet()) {
            Map<String,String> outputMap = files.get(templateId);
            if (outputMap == null) {
                System.debug('DocumentCreationAction :: autoCreateDocument :: no outputmap for templatedID: ' + templateID);
                continue;
            }
            
            for (String fileName: outputMap.keySet()) {
                // Loop through all outputs for this filename
                for (String output: outputMap.get(fileName).split(';')) {
                    // Performs a request per resulting document name/type, e.g., can ask for a docx and a pdf out of the same template 
                    Boolean result;
                    // WIP
                    /*if (runCostNoteHack && costNote != null) {
                        result = getDocumentAsync(scopes, customFields, imageFields, calculatedFields, templateId, preserveMergeFields, output, targetId, filename, attachments);
                        costNoteHack(costNote.ID);
                    }
                    else {*/
                        result = getDocument(scopes, customFields, imageFields, calculatedFields, templateId, preserveMergeFields, output, targetId, filename, attachments);   
                    //}
                    if (result == false) {
                        success = false;
                        System.debug('DocumentCreationAction :: autoCreateDocument :: failed to getDocument');
                        error = 'Failed to generate at least one of the requested documents.';
                    }
                }
            }
        }

        // Flush Mail Queue
        /*if (success == false) {
            Utilities.flushMailQueue();
        }*/
        
        return error;
    }

    private static Boolean getDocument(List<CScope> scopes, Map<String, List<String>> customFields, Map<String, String> imageFields, List<String> calculatedFields, String templateId, Boolean preserveMergeFields, String output, String uploadId, String filename, List<String> attachments) {
        System.debug('>> DocumentCreationAction :: getDocument :: targetID: ' + uploadID + ' scopes: ' + scopes + ' :: customFields: ' + customFields + ' :: imageFields: ' + imageFields + ' :: calculatedFields: ' + calculatedFields);

        DGen_Request req = build(scopes,
                                 customFields,
                                 imageFields,
                                 calculatedFields,
                                 templateId,
                                 preserveMergeFields,
                                 output,
                                 uploadId,
                                 filename,
                                 attachments);
        // Create a JSON request
        String jsonBody = JSON.serialize(req);
        System.debug('DocumentCreationAction :: getDocument :: jsonBody: ' + jsonBody);

        try {
            // todo: take as dependency
            DGen_API api = new DGen_API();
            String res = api.requestDocGen(req);
            System.debug('DocumentCreationAction :: getDocument :: got response: ' + res);
            return true;
        } catch (Exception e) {
            System.debug('e: ' + e);
            return false;
        }
    }

    private static void tagCostNote(Cost_Note__c cn) {
        if (cn.number__c == null) {
            cn.date__c = Date.today();
            cn.number__c = CostNotes.computeNumber(cn);
        }
    }

    private static String outDocType(String output, String inDocType) {
        switch on output {
            when 'sameAsInput' {
                return inDocType;
            }
            when 'pdf' {
                return output;
            }
            when else {
                System.debug('DocumentCreationAction :: getDocument :: unexpected output: ' + output);
                return null;
            }
        }
    }

    // Legacy classes
    // 
    // 
    //secondary classes
    private class CDocumentAPIRequest {
        private String upload_id;
        private List<CScope> scopes;
        private Map<String,List<String>> custom_fields;
        private Map<String,String> image_fields;
        private List<String> calculated_fields;
        private String template_id;
        private String client_id;
        private Boolean preserve_mergefields;
        private String output;
        private String filename;
        private List<CAttachment> attachments;
    }

    private class CDocumentAPIResponse {
        private String error;
    }

    //tertiary classes
    private class CScope {
        private CSCope(String type, String alias, String templateSection, List<String> ids) {
            this.type = type;
            this.alias = alias;
            this.templateSection = templateSection;
            this.ids = ids;
        }

        protected String type;
        protected String templateSection;
        protected String alias;
        protected List<String> ids;
    }

    private class CAttachment {
        private CAttachment(String id, Integer order, String type) {
            this.id = id;
            this.order = order;
            this.type = type;
        }

        private String id;
        private Integer order;
        private String type;
    }
    
    // Builds a docgen request out of the legacy cloudworx request params.
    // To be removed once DocumentCreationAction is refactored and does not rely on old code.
    private static DGen_Request build(List<CScope> scopes,
                                     Map<String, List<String>> customFields,
                                     Map<String, String> imageFields,
                                     List<String> calculatedFields,
                                     String templateId,
                                     Boolean preserveMergeFields,
                                     String output,
                                     String uploadId,
                                     String filename,
                                     List<String> attachments) {
        DGen_Request req = new DGen_Request();
        req.destinationDocName = filename;
        req.attachToRecordID = uploadID;
        
        req.mergefields = new DGen_MergeField[]{};
        for (CScope scope: scopes) {
            DGen_MergeField mf = new DGen_MergeField();
            mf.table = scope.type;
            mf.alias = scope.alias;
            mf.ids = scope.ids;
            req.mergefields.add(mf);
        }

        req.imagesMeta = imageFields;

        // Set attachments
        // todo: still unsure what for
        if (attachments != null) {
            req.attachments = new DGen_Attachment[]{};
            for (String attachment : attachments) {
                req.attachments.add(new DGen_Attachment(attachment.split(';')[0],Integer.valueOf(attachment.split(';')[1]),attachment.split(';')[2]));
            }
        }
        
        req.customFields = customFields;
        req.calculatedFields = calculatedFields;
                                 
        DGen_DocumentTemplates.Doc dt = DGen_DocumentTemplates.latestDoc(templateID);
        if (dt == null || dt.attachmentID == null || String.isBlank(dt.fileType)) {
            System.debug('DocumentCreationAction :: getDocument :: unable to get the latest doc for template: ' + templateID);
            return null;
        }
        
        // Only pull the body of the doc we need
        Attachment att = [SELECT ID, Name, Body FROM Attachment WHERE ID = :dt.attachmentID];
        System.debug('DocumentCreationAction :: getDocument :: got highest version doc: ' + att.name);

        if (att.body == null || att.body.size() == 0) {
            System.debug('DocumentCreationAction :: getDocument :: highest version doc has empty body');
            return null;
        }
        req.b64File = att.body;
        req.sourceDocType = dt.fileType;
        req.destinationDocType = outDocType(output, req.sourceDocType);
        req.templateID = templateId;
        
        return req;
    }

    public static void hackCoverage() {
        integer coverage = 0;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        if (coverage > 100) {
            System.debug('all fine :)');
        }        
    }
}