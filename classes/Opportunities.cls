public without sharing class Opportunities {
    private static String vh24Company = 'VH24';
    private static String vr24Company = 'VR24';

    private static String dkRtName = 'Dieselskandal'; // 0120Y000000W0CY
    private static String fzRtName = 'Finanzierung'; // 0120Y000000KnMH
    private static String lvRtName = 'Lebensversicherung'; // 0120Y000000W0CT
    public static ID dkRtID;
    public static ID fzRtID;
    public static ID lvRtID;
    static {
        // Use Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(dkRtName); instead?
        RecordType[] rts = [
            SELECT ID, DeveloperName
            FROM RecordType
            WHERE (DeveloperName = :dkRtName
                OR DeveloperName = :fzRtName
                OR DeveloperName = :lvRtName)
                AND SObjectType = 'Opportunity'
        ];
        for (RecordType rt : rts) {
            if (rt.developerName == dkRtName) {
                dkRtID = rt.ID;
                continue;
            }
            if (rt.developerName == fzRtName) {
                fzRtID = rt.ID;
                continue;
            }
            if (rt.developerName == lvRtName) {
                lvRtID = rt.ID;
                continue;
            }
        }
    }

    public static Id dieselSkandalRecordType() {
        return dkRtID;
    }

    public static Boolean isDieselSkandal(ID oppRecordTypeID) {
        if (oppRecordTypeID == null) {
            return false;
        }
        return oppRecordTypeID == dkRtID;
    }
    
    public static Id finanzierungRecordType() {
        return fzRtID;
    }
    
    public static Boolean isFinanzierung(ID oppRecordTypeID) {
        if (oppRecordTypeID == null) {
            return false;
        }
        return oppRecordTypeID == fzRtID;
    }

    public static Id lebensversicherungRecordType() {
        return lvRtID;
    }
    
    public static Boolean isLebensversicherung(ID oppRecordTypeID) {
        if (oppRecordTypeID == null) {
            return false;
        }
        return oppRecordTypeID == lvRtID;
    }
    
    // Account type
    // When "fetch" is true we query the record. Useful for "before updates", passing false as fetch.
    public static Boolean isVH24(Opportunity o, Boolean fetch) {
        if (o == null) {
            return false;
        }

        String v = accountTypeValue(o, fetch);
        return v != null && v == vh24Company;
    }

    public static Boolean isVH24(Opportunity o) {
        return isVH24(o, true);
    }
    
    public static Boolean isVR24(Opportunity o, Boolean fetch) {
        if (o == null) {
            return false;
        }

        String v = accountTypeValue(o, fetch);
        return v != null && v == vr24Company;
    }
    
    public static Boolean isVR24(Opportunity o) {
        return isVR24(o, true);
    }
    
    private static String accountTypeValue(Opportunity o, Boolean fetch) {
        if (o.ID == null) {
            return o.account_name__c;
        }

        if (fetch) {
            o = [SELECT Account_name__c FROM Opportunity WHERE ID = :o.ID];
        }
        
        return o.account_name__c;
    }
    
    public static void setOldDate(Opportunity[] oo) {
        for(Opportunity o : oo) {
            o.created_date_old_org__c = o.createddate;
        }
    }
    //
    
    // todo: extract to a class that gives meaning to the methods below (or above, e.g., OpportunityRecordType)
    
    public static void createAccount(Opportunity[] oo) {
        Logger.debug('>> Opportunities :: createAccount :: oo: ' + oo);
        
        Account[] aa = new Account[]{};
        Map<String, Account> aByName = new Map<String, Account>{};
        for (Opportunity o : oo) {
            if (o.accountId == null) {
                Account a = new Account(Name = o.name);
                aa.add(a);
                if (aByName.get(o.name) != null) {
                    // todo: how to deal with duplicated names? Would have to insert the acc in the for loop
                    Logger.debug('Opportunities :: createAccount :: found duplicated Opp name :: both Opps will be linked to the Account created last :: name: ' + o.name);
                }
                aByName.put(o.name, a);
            }
        }
        insert aa;
        Logger.debug('Opportunities :: createAccount :: inserted aa: ' + aa);
        
        for (Opportunity o: oo) {
            Account a = aByName.get(o.name);
            if (a != null) {
                o.accountId = a.ID;
                Logger.debug('Opportunities :: createAccount :: did set o.accountId: ' + o.accountId + ' for name: ' + o.name);
            }
        }
        
        Logger.debug('<< Opportunities :: createAccount');
    }
    
    public static void setDateStamps(Opportunity[] oo, Map<ID, Opportunity> oldOo, Boolean isInsert) {
        for (Opportunity o: oo) {
            if (isInsert || o.stageName != oldOo.get(o.ID).stageName) {
                if (o.stageName == 'New'){
                    Logger.debug('3');
                    o.set_To_New_Date__c = System.today();
                } else if (o.stageName == 'Check') {
                    Logger.debug('2');
                    o.set_To_Check_Date__c = System.today();
                } else if (o.stageName == 'Claim') {
                    Logger.debug('1');
                    o.set_To_Claim_Date__c = System.today();
                } else if (o.stageName == 'Lost') {
                    o.set_To_Lost_Date__c = System.today();
                } else if (o.stageName == 'On Hold'){
                    o.set_To_On_Hold_Date__c = System.today();
                }
            }

            if (o.backoffice__c != null && (isInsert || o.backoffice__c != oldOo.get(o.ID).backoffice__c)) {
                o.set_Backoffice_Date__c = System.today();
            }

            if (o.callcenter__c != null && (isInsert || o.callcenter__c != oldOo.get(o.ID).callcenter__c)){
                o.set_Callcenter_Date__c = System.today();
            }
        }
    }
    
    public static void setReference(Opportunity[] oo, Boolean isBeforeUpdate) {
        Logger.debug('>> Opportunities :: setReference :: oo: ' + oo + ' isBeforeUpdate: ' + isBeforeUpdate);
        
        new OpportunityReference().setOn(oo, isBeforeUpdate, false);
    
        Logger.debug('<< Opportunities :: setReference');
    }
    
    public static void setAssignmentType(Opportunity[] oo) {
        Logger.debug('>> Opportunities :: setAssignmentType :: oo: ' + oo);
        
        for (Opportunity o: oo) {
            if (o.assignment_Type__c == null && o.legal_Protection_Insurance__c != null) {
                o.has_Legal_Protection_Insurance__c = true;
                o.assignment_Type__c = 'RSV';
            } else if (o.assignment_Type__c == null && o.has_Legal_Protection_Insurance__c) {
                o.assignment_Type__c = 'RSV';
            } else if ((o.confirmed_Terms_And_Conditions__c || !Opportunities.isVH24(o, false))
                       && o.assignment_Type__c == null && !o.has_Legal_Protection_Insurance__c) {
                o.assignment_Type__c = 'Share';
            }
        }
        
        Logger.debug('<< Opportunities :: setAssignmentType');
    }
    
    public static void setHash(Opportunity[] oo) {
        Logger.debug('>> Opportunities :: setHash :: oo: ' + oo);

        for (Opportunity o: oo) {
            if (o.form_Hash_1__c == null) {
                o.form_Hash_1__c = GUID.Gen();
            }
        }
        
        Logger.debug('<< Opportunities :: setHash');
    }
    
    public static void setLegalUser(Opportunity[] newOO, Map<ID, Opportunity> oldOO, LegalDistributor ld, OpportunitiesCache cache) {
        Logger.debug('>> Opportunities :: setLegalUser :: newOO: ' + newOO);

        ID[] ids = cache.getOnClaim();
        Opportunity[] allOpps = [SELECT Id, RecordTypeId, Legal__c, Account__c FROM Opportunity WHERE ID IN :ids];
        Logger.debug('Opportunities :: setLegalUser :: got from cache: ' + allOpps.size());
        for (Opportunity o : newOO) {
            if (o.Legal__c != null || (oldOO != null && oldOO.get(o.ID).Legal__c != null)) { // slack request from Mo 20. Mai 15:55:03 CEST 2019
                continue;
            }

            o.legal__c = ld.get(allOpps, o);
            Logger.debug('Opportunities :: setLegalUser :: did set legal user to: ' + o.legal__c);
        }
    }

    public static void setLegalAccount(Opportunity[] oo, Map<ID,Opportunity> oldOo, Boolean isInsert) {
        Logger.debug('>> Opportunities :: setLegalAccount :: oo: ' + oo + ' oldOo: ' + oldOo + 'isInsert: ' + isInsert);
        
        Opportunity[] oppsToUpdate = new Opportunity[]{};
        Set<Id> legalUserIDs = new Set<Id>();
        for (Opportunity o: oo) {
            if (o.legal__c == null) {
                continue;
            }
            if (isInsert == true || o.legal_Account__c == null || o.legal__c != oldOo.get(o.ID).legal__c) {
                Logger.debug('Opportunities :: setLegalAccount :: updating account for opp: ' + o.ID + ' new legal user: ' + o.legal__c);
                legalUserIDs.add(o.legal__c);
                oppsToUpdate.add(o);
            }
        }

        if (oppsToUpdate.isEmpty()) {
            return;
        }
        
        Map<ID, User> users = new Map<ID, User>([SELECT ID, Account_Id__c, Name FROM User WHERE ID IN :legalUserIDs]);
        for (Opportunity o: oppsToUpdate){
            User u = users.get(o.legal__c);
            if (String.isBlank(u.account_Id__c)) {
                Logger.debug('Opportunities :: setLegalAccount :: User ' + u + ' has no account_Id__c');
                continue;
            }

            ID accID = ID.valueOf(u.account_Id__c);
            o.legal_Account__c = accID;
            Logger.debug('Opportunities :: setLegalAccount :: did set legal account to: ' + o.legal_Account__c);
        }
        
        Logger.debug('<< Opportunities :: setLegalAccount');
    }
    
    public static void setPartner(Opportunity[] oo) {
        Logger.debug('>> Opportunities :: setPartner :: oo: ' + oo);
        
        Set<String> externalIDs = new Set<String>();
        for (Opportunity o: oo) {
            if (o.partner_Id__c != null){
                externalIDs.add(o.partner_Id__c);
            }
        }

        Account[] aa = [SELECT ID, External_Id__c FROM Account WHERE External_Id__c IN :externalIDs];
        for (Opportunity o: oo) {
            if (o.partner__c != null || o.partner_Id__c == null) {
                continue;
            }
            
            for (Account a : aa) {
                if (o.partner_Id__c == a.external_Id__c) {
                    o.partner__c = a.ID;
                    break;        
                }
            }
        }
        
        Logger.debug('<< Opportunities :: setPartner');
    }
    
    public static void setLegalProcessType(Opportunity[] oo) {
        Logger.debug('>> Opportunities :: setLegalProcessType :: oo: ' + oo);
        
        Set<Id> legalAccountIDs = new Set<Id>();
        for (Opportunity o: oo) {
            if (o.legal_Account__c != null) {
                legalAccountIDs.add(o.legal_Account__c);
            }
        }

        if (legalAccountIDs.isEmpty()) {
            return;
        }
        
        Map<Id, Account> relatedAccounts = new Map<ID, Account>([
            SELECT ID, Legal_Process_Type__c
            FROM Account
            WHERE Legal_Process_Type__c != null AND ID IN :legalAccountIds
        ]);
        for (Opportunity o: oo) {
            if (o.legal_Account__c != null) {
                Account a = relatedAccounts.get(o.legal_Account__c);
                if (a != null) {
                    o.legal_Process_Type__c = a.legal_Process_Type__c;   
                }
            }
        }
        
        Logger.debug('<< Opportunities :: setLegalProcessType');
    }

    public static void setStage(Opportunity[] oo, Map<ID,Opportunity> oldOo) {
        Logger.debug('>> Opportunities :: setStage :: oo: ' + oo + ' oldOo: ' + oldOo);
        OpportunitiesStage.setStage(oo, oldOo);
        Logger.debug('<< Opportunities :: setStage');
    }

    public static void setCurrencyFields(Opportunity[] oo) {
        Map<ID, Opportunity> oldOo = (Map<ID, Opportunity>)Trigger.oldMap;
        for (Opportunity o: oo) {
            o.amount_In_Dispute_Clean__c = Decimals.toCurrency(o.amount_In_Dispute__c);
            o.compensation_For_Use_Clean__c = Decimals.toCurrency(o.compensation_For_Use__c);
            o.purchase_Price_Clean__c = Decimals.toCurrency(o.purchase_Price__c);
        }
    }
    
    // TBD
    // From legacy, todo: refactor - nice looking pyramid :)
    /*public static void autoStartAutoFollowUp(Opportunity[] oo,
                                             Map<Id,Opportunity> oldOpportunities,
                                             Boolean isInsert) {
        for (Opportunity opportunity: oo) {
            if (!opportunity.Autostart_Auto_Follow_up_Journeys__c) { continue; }
            
            if (Opportunities.isDieselSkandal(opportunity.recordTypeId)) {
                // DG
                if ((opportunity.StageName == 'On Hold') && (opportunity.Sales_Type__c == 'Online') && (opportunity.Started_Auto_Follow_up_Journey_3__c == false)) {
                    opportunity.Auto_Follow_up_Date__c = System.now().addDays(30);
                    opportunity.Auto_Follow_up_Count__c = 0;
                    opportunity.Started_Auto_Follow_up_Journey_3__c = true;
                } else if ((opportunity.StageName == 'New') && (opportunity.Sales_Type__c == 'Online') && (opportunity.Started_Auto_Follow_up_Journey_6__c == false)) {
                    if (opportunity.Testing_Version__c != 'c'){
                        if ((opportunity.Confirmed_Terms_And_Conditions__c == false) && (opportunity.Started_Auto_Follow_up_Journey_1__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now().addHours(2);
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_1__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        }
                    } else {
                        if ((opportunity.Vehicle_Brand__c == null) && (opportunity.Started_Auto_Follow_up_Journey_4__c == false)){
                            opportunity.Auto_Follow_up_Date__c = System.now().addHours(2);
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_4__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        } else if ((opportunity.Vehicle_Brand__c != null) && (opportunity.Confirmed_Terms_And_Conditions__c == false) && (opportunity.Started_Auto_Follow_up_Journey_1__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now().addHours(2);
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_1__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        }
                    }
                } else if ((opportunity.StageName == 'Lost') && (opportunity.Sales_Type__c == 'Online')) {
                    if (((opportunity.Reason_For_Loss__c == 'Kunde nicht erreichbar') || (opportunity.Reason_For_Loss__c == 'Dokumente nicht geschickt'))) {
                        if (((isInsert == true) || (oldOpportunities.get(opportunity.Id).StageName == 'New')) && (opportunity.Started_Auto_Follow_up_Journey_8__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_8__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        } else if (((isInsert == false) && (oldOpportunities.get(opportunity.Id).StageName == 'Check')) && (opportunity.Started_Auto_Follow_up_Journey_5__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_5__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        }
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunity.recordTypeId)) {
                // FZ
                if ((opportunity.StageName == 'Lost') && (opportunity.Sales_Type__c == 'Online')) {
                    if (((opportunity.Reason_For_Loss__c == 'Kunde nicht erreichbar') || (opportunity.Reason_For_Loss__c == 'Dokumente nicht geschickt'))) {
                        if (((isInsert == true) || (oldOpportunities.get(opportunity.Id).StageName == 'New')) && (opportunity.Started_Auto_Follow_up_Journey_8__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_8__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        } else if (((isInsert == false) && (oldOpportunities.get(opportunity.Id).StageName == 'Check')) && (opportunity.Started_Auto_Follow_up_Journey_5__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_5__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        }
                    }
                }
            } else {
                // LV
                if ((opportunity.StageName == 'Lost') && (opportunity.Sales_Type__c == 'Online')) {
                    if (((opportunity.Reason_For_Loss__c == 'Kunde nicht erreichbar') || (opportunity.Reason_For_Loss__c == 'Dokumente nicht geschickt'))) {
                        if (((isInsert == true) || (oldOpportunities.get(opportunity.Id).StageName == 'New')) && (opportunity.Started_Auto_Follow_up_Journey_8__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_8__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        } else if (((isInsert == false) && (oldOpportunities.get(opportunity.Id).StageName == 'Check')) && (opportunity.Started_Auto_Follow_up_Journey_5__c == false)) {
                            opportunity.Auto_Follow_up_Date__c = System.now();
                            opportunity.Auto_Follow_up_Count__c = 0;
                            opportunity.Started_Auto_Follow_up_Journey_5__c = true;
                            if (opportunity.Form_Hash_1__c == null) {
                                opportunity.Form_Hash_1__c = GUID.Gen();
                            }
                        }
                    }
                }
            }
        }
    }*/
    
    // Legacy code
    public static void createObjects(Opportunity[] oo, Map<ID, Opportunity> oldOpportunities) {
        Logger.debug('>> Opportunities :: createObjects :: oo: ' + oo);

        oo = [
            SELECT Id,
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
            (SELECT Id FROM Contracts__r WHERE Stage__c != 'Canceled'),
            (SELECT Id FROM Welcome_Letters__r WHERE Stage__c != 'Canceled'),
            (SELECT Id, Lawsuit_Date__c FROM Claims__r WHERE Stage__c != 'Canceled'),
            (SELECT Id FROM Authorizations__r WHERE Stage__c != 'Canceled'),
            (SELECT Id, Amount__c FROM Invoices__r WHERE Stage__c != 'Canceled'),
            (SELECT Id FROM Test_Cases__r WHERE Status__c != 'Canceled')
            FROM Opportunity WHERE Id IN :oo
        ];

        List<Welcome_Letter__c> newWelcomeLetters = new List<Welcome_Letter__c>();
        List<Contract__c> newContracts = new List<Contract__c>();
        List<Claim__c> newClaims = new List<Claim__c>();
        List<Correspondence__c> newCorrespondencies = new List<Correspondence__c>();
        List<Authorization__c> newAuthorizations = new List<Authorization__c>();
        List<Invoice__c> newInvoices = new List<Invoice__c>();
        Map<Id, String> legalProcessTypeOpportunityIds= new Map<Id, String>();
        
        for (Opportunity opportunity: oo) {
            if (Opportunities.isDieselSkandal(opportunity.RecordTypeId)) {
                // DG
                // Removed /*(opportunity.Sales_Type__c == 'Online') && (opportunity.StageName == 'Check') &&*/ as per https://salesfive.atlassian.net/browse/VH24-78
                if ((opportunity.Authorizations__r.size() == 0) && (opportunity.Confirmed_Terms_And_Conditions__c == true) && (opportunity.Legal__c != null)){
                    newAuthorizations.add(new Authorization__c(
                        Opportunity__c = opportunity.Id,
                        Stage__c = 'Draft'
                    ));
                }
                if ((opportunity.Sales_Type__c == 'Online') && (opportunity.Welcome_Letters__r.size() == 0) && (opportunity.Legal__c != null) && (opportunity.Assignment_Type__c != null) && (opportunity.Confirmed_Terms_And_Conditions__c == true)){
                    newWelcomeLetters.add(new Welcome_Letter__c(
                        Opportunity__c = opportunity.Id,
                        Stage__c = 'Draft'
                    ));
                }
                if (opportunity.StageName == 'Claim'){
                    // Claim is created in same org
                    if (opportunity.Legal_Process_Type__c != 'External') {
                        if ((opportunity.Claims__r.size() == 0) && (opportunity.Legal__c != null) && (opportunity.Test_Cases__r.size() == 0)) {
                            newClaims.add(new Claim__c(
                                Opportunity__c = opportunity.Id,
                                Stage__c = 'Draft',
                                RecordTypeId = Claims.dieselSkandalRecordType(),
                                Reference__c = opportunity.Reference__c
                            ));
                            legalProcessTypeOpportunityIds.put(opportunity.Id, 'Internal');
                        } else if (opportunity.Claims__r.size() > 0) {
                            for (Claim__c claim : opportunity.Claims__r) {
                                if (claim.Lawsuit_Date__c != null) {
                                    if ((opportunity.Process_Type__c != oldOpportunities.get(opportunity.Id).Process_Type__c) && (opportunity.Process_Type__c == 'DG_Keep')) {
                                        Correspondence__c correspondence = Correspondences.build(claim, 'Customer', 'Sonstiges', 'Draft', 'WechselAnspruchstypZuBehalten');
                                        correspondence.Description__c = 'Wechsel Anspruchstyp zu "Behalten"';
                                        newCorrespondencies.add(correspondence);
                                    } else if ((opportunity.Process_Type__c != oldOpportunities.get(opportunity.Id).Process_Type__c) && (oldOpportunities.get(opportunity.Id).Process_Type__c == 'DG_Keep')) {
                                        Correspondence__c correspondence = Correspondences.build(claim, 'Customer', 'Sonstiges', 'Draft', 'WechselAnspruchstypVonBehalten');
                                        correspondence.Description__c = 'Wechsel Anspruchstyp von "Behalten"';
                                        newCorrespondencies.add(correspondence);
                                    }
                                }
                            }
                        }
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunity.RecordTypeId)) {
                // FZ
                if (opportunity.StageName == 'Claim') {
                    if (opportunity.Claims__r.size() == 0) {
                        newClaims.add(new Claim__c(
                            Opportunity__c = opportunity.Id,
                            Stage__c = 'Draft',
                            RecordTypeId = Claims.finanzierungRecordType(),
                            Reference__c = opportunity.Reference__c
                        ));
                    }
                }
            } else {
                // LV
                // // Removed /*(opportunity.Sales_Type__c == 'Online') && (opportunity.StageName == 'Check') &&*/ as per https://salesfive.atlassian.net/browse/VH24-78
                if ((opportunity.Authorizations__r.size() == 0) && (opportunity.Confirmed_Terms_And_Conditions__c == true) && (opportunity.Legal__c != null)){
                    /*
                    newAuthorizations.add(new Authorization__c(
                        Opportunity__c = opportunity.Id,
                        Stage__c = 'Draft'
                    ));
					*/
                }
                if ((opportunity.Sales_Type__c == 'Online') && (opportunity.Welcome_Letters__r.size() == 0) && (opportunity.Legal__c != null) && (opportunity.Assignment_Type__c != null) && (opportunity.Confirmed_Terms_And_Conditions__c == true)){
                    newWelcomeLetters.add(new Welcome_Letter__c(
                        Opportunity__c = opportunity.Id,
                        Stage__c = 'Draft'
                    ));
                }
                if (opportunity.StageName == 'Claim') {
                    if ((opportunity.Claims__r.size() == 0) && (opportunity.Legal__c != null)) {
                        newClaims.add(new Claim__c(
                            Opportunity__c = opportunity.Id,
                            Stage__c = 'Draft',
                            RecordTypeId = Claims.lebensversicherungRecordType(),
                            Reference__c = opportunity.Reference__c
                        ));
                    }
                }
            }

            // All process types
            if (opportunity.StageName == 'Claim'){
                if ((opportunity.Partial_Refund__c != null) && (oldOpportunities.get(opportunity.Id).Partial_Refund__c == null)){
                    if (opportunity.Assignment_Type__c != 'Direkt'){
                        Decimal amount = OpportunityRevenue.calculate(opportunity.Account_Id__c, opportunity.Partial_Refund__c, opportunity.RecordTypeId, opportunity.Assignment_Type__c);
                        if (amount > 0){
                            newInvoices.add(new Invoice__c(
                                Opportunity__c = opportunity.Id,
                                Stage__c = 'Draft',
                                Amount__c = amount
                            ));
                        }
                    }
                }
            }

            if ((opportunity.StageName == 'Finished') && (oldOpportunities.get(opportunity.Id).StageName != 'Finished')){
                Decimal invoiceAmount = 0;
                for (Invoice__c invoice : opportunity.Invoices__r){
                    if (invoice.Amount__c != null){
                        invoiceAmount += invoice.Amount__c;
                    }
                }
                if (opportunity.Refund__c != null) {
                    if (opportunity.Assignment_Type__c != 'Direkt') {
                        Decimal amount = OpportunityRevenue.calculate(opportunity.Account_Id__c, opportunity.Refund__c, opportunity.RecordTypeId, opportunity.Assignment_Type__c) - invoiceAmount;
                        if (amount > 0) {
                            newInvoices.add(new Invoice__c(
                                Opportunity__c = opportunity.Id,
                                Stage__c = 'Draft',
                                Amount__c = amount
                            ));
                        }
                    }
                }
            }
        }

        if (newWelcomeLetters.size() > 0) {
            insert newWelcomeLetters;
        }
        if (newContracts.size() > 0) {
            insert newContracts;
        }
        if (newClaims.size() > 0) {
            insert newClaims;
        }
        if (newCorrespondencies.size() > 0) {
            insert newCorrespondencies;
        }
        if (newAuthorizations.size() > 0) {
            insert newAuthorizations;
        }
        if (newInvoices.size() > 0) {
            insert newInvoices;
        }
    }
    
    // Legacy code
    public static void calculateRevenue(Opportunity[] oo, Map<ID, Opportunity> oldOo) {
        oo = [select Id, Account_Id__c, RecordTypeId, Potential__c, Refund__c, Assignment_Type__c, (select Id from OpportunityLineItems) from Opportunity where Id IN :oo];
        OpportunityLineItem[] updateOpportunityLineItems = new List<OpportunityLineItem>();
        
        for (Opportunity opportunity: oo){
            if ((opportunity.Refund__c == null) && (opportunity.Potential__c != null) && (oldOo == null || oldOo.isEmpty() || oldOo.get(opportunity.Id).Potential__c != opportunity.Potential__c)){
                for (OpportunityLineItem opportunityLineItem : opportunity.OpportunityLineItems){
                    opportunityLineItem.TotalPrice = OpportunityRevenue.calculate(opportunity.Account_Id__c, opportunity.Potential__c, opportunity.RecordTypeId, opportunity.Assignment_Type__c);
                    updateOpportunityLineItems.add(opportunityLineItem);
                    break;
                }
            }
            if ((opportunity.Refund__c != null) && (oldOo == null || oldOo.isEmpty() || oldOo.get(opportunity.Id).Refund__c != opportunity.Refund__c)){
                for (OpportunityLineItem opportunityLineItem : opportunity.OpportunityLineItems){
                    opportunityLineItem.TotalPrice = OpportunityRevenue.calculate(opportunity.Account_Id__c, opportunity.Refund__c, opportunity.RecordTypeId, opportunity.Assignment_Type__c);
                    updateOpportunityLineItems.add(opportunityLineItem);
                    break;
                }
            }
        }
    
        update updateOpportunityLineItems;
    }
    
    // Legacy code
    public static void processLost(List<Opportunity> opportunities){
        Integer i = 0;
        for (Opportunity opportunity : opportunities){
            if (opportunity.StageName == 'Lost'){
                i++;
            } else {
                system.debug('mi stagename=' + opportunity.stagename);
            }
        }

        if (i <= 0) {
            return;
        }
        System.debug('mi opplost');

        List<Contract__c> contracts = [select Id, Opportunity__c from Contract__c where Stage__c != 'Canceled' AND Opportunity__c IN :opportunities];
        List<Claim__c> claims = [select Id, Opportunity__c from Claim__c where Stage__c != 'Canceled' AND Stage__c != 'Finished' AND Opportunity__c IN :opportunities];
        List<Authorization__c> authorizations = [select Id, Opportunity__c from Authorization__c where Stage__c != 'Canceled' AND Opportunity__c IN :opportunities];
        List<Correspondence__c> correspondencies = [select Id, Claim__c from Correspondence__c where Stage__c != 'Canceled' AND Claim__c IN :claims];
        List<Test_Case__c> testCases = [select Id, Opportunity__c, Status__c from Test_Case__c where Status__c != 'Canceled' AND Opportunity__c IN :opportunities];

        List<SObject> objects = new List<SObject>();
        objects.addAll((List<SObject>)opportunities);
        objects.addAll((List<SObject>)contracts);
        objects.addAll((List<SObject>)claims);
        objects.addAll((List<SObject>)authorizations);
        objects.addAll((List<SObject>)correspondencies);
        objects.addAll((List<SObject>)testCases);
        List<Task> tasks = [select Id, WhatId from Task where WhatId IN :objects AND IsClosed = false];

        List<Contract__c> updateContracts = new List<Contract__c>();
        List<Claim__c> updateClaims = new List<Claim__c>();
        List<Authorization__c> updateAuthorizations = new List<Authorization__c>();
        List<Correspondence__c> updateCorrespondencies = new List<Correspondence__c>();
        List<Test_Case__c> updateTestCases = new List<Test_Case__c>();
        List<Task> updateTasks = new List<Task>();

        for (Opportunity opportunity : opportunities){
            if (opportunity.StageName == 'Lost'){
                for (Contract__c contract : contracts){
                    if (contract.Opportunity__c == opportunity.Id){
                        contract.Stage__c = 'Canceled';
                        updateContracts.add(contract);
                        for (Task task : tasks){
                            if (task.WhatId == contract.Id){
                                task.Status = 'Canceled';
                                updateTasks.add(task);
                            }
                        }
                    }
                }
                for (Authorization__c authorization : authorizations){
                    if (authorization.Opportunity__c == opportunity.Id){
                        authorization.Stage__c = 'Canceled';
                        updateAuthorizations.add(authorization);
                        for (Task task : tasks){
                            if (task.WhatId == authorization.Id){
                                task.Status = 'Canceled';
                                updateTasks.add(task);
                            }
                        }
                    }
                }
                for (Claim__c claim : claims){
                    if (claim.Opportunity__c == opportunity.Id){
                        claim.Stage__c = 'Canceled';
                        system.debug('mi claim cancled');
                        updateClaims.add(claim);
                        for (Task task : tasks){
                            if (task.WhatId == claim.Id){
                                task.Status = 'Canceled';
                                updateTasks.add(task);
                            }
                        }
                        for (Correspondence__c correspondence : correspondencies){
                            if (correspondence.Claim__c == claim.Id){
                                correspondence.Stage__c = 'Canceled';
                                updateCorrespondencies.add(correspondence);
                                for (Task task : tasks){
                                    if (task.WhatId == correspondence.Id){
                                        task.Status = 'Canceled';
                                        updateTasks.add(task);
                                    }
                                }
                            }
                        }
                    }
                }
                for (Test_Case__c testCase : testCases){
                    if (testCase.Opportunity__c == opportunity.Id){
                        testCase.Status__c = 'Canceled';
                        updateTestCases.add(testCase);
                        for (Task task : tasks){
                            if (task.WhatId == testCase.Id){
                                task.Status = 'Canceled';
                                updateTasks.add(task);
                            }
                        }
                    }
                }
                for (Task task : tasks){
                    if (task.WhatId == opportunity.Id){
                        task.Status = 'Canceled';
                        updateTasks.add(task);
                    }
                }
            }
        }

        if (updateContracts.size() > 0) {
            update updateContracts;
        }
        if (updateClaims.size() > 0) {
            update updateClaims;
        }
        if (updateAuthorizations.size() > 0) {
            update updateAuthorizations;
        }
        if (updateCorrespondencies.size() > 0) {
            update updateCorrespondencies;
        }
        if (updateTestCases.size() > 0) {
            update updateTestCases;
        }
        if (updateTasks.size() > 0) {
            update updateTasks;
        }
    }
    
    public static void setContactLastOpportunity(Opportunity[] oo, Map<ID, Opportunity> oldOo, Boolean isInsert) {
        Set<Id> contactIds = new Set<Id>();
        for (Opportunity o: oo) {
            if (o.contact__c != null) {
                contactIds.add(o.contact__c);
            }
        }

        Map<ID, Contact> contacts = new Map<Id,Contact>([SELECT ID FROM Contact WHERE Id IN :contactIds]);
        Contact[] contactsToUpdate = new Contact[]{};
        for (Opportunity o: oo) {
            if ((isInsert || oldOo.get(o.ID).contact__c == null) && (o.contact__c != null)) {
                Contact c = contacts.get(o.contact__c);
                c.last_Opportunity__c = o.ID;
                contactsToUpdate.add(c);
            }
        }

        if (contactsToUpdate.size() > 0) {
            update contactsToUpdate;
        }
    }
    
    public static void setDefaultOwner(Opportunity[] oo) {
        if (String.isBlank(GeneralSettings.DEFAULT_OWNER)) {
            Logger.debug('Opportunities :: setDefaultOwner :: empty GeneralSettings.DEFAULT_OWNER');
            return;
        }
        
        if (String.isBlank(GeneralSettings.REASSIGN_IF_OWNERS)) {
            Logger.debug('Opportunities :: setDefaultOwner :: empty GeneralSettings.REASSIGN_IF_OWNERS');
            return;
        }

		String[] reassignIfOwners = GeneralSettings.REASSIGN_IF_OWNERS.split(';');
        Map<ID, User> rUu = new Map<ID, User>([SELECT ID, Alias FROM User WHERE Username IN :reassignIfOwners AND IsActive = true]);
		if (rUu.size() == 0) {
            Logger.debug('Opportunities :: setDefaultOwner :: no user found with username(s) (GeneralSettings.REASSIGN_IF_OWNERS): ' + GeneralSettings.REASSIGN_IF_OWNERS);
            return;
        }

        User[] dUu = [SELECT ID, Alias FROM User WHERE Username = :GeneralSettings.DEFAULT_OWNER AND IsActive = true];
		if (dUu.size() == 0) {
            Logger.debug('Opportunities :: setDefaultOwner :: no user found with username (GeneralSettings.DEFAULT_OWNER): ' + GeneralSettings.DEFAULT_OWNER);
            return;
        }
        User newOwner = dUu[0];

        for (Opportunity o: oo) {
            if (!rUu.containsKey(o.ownerID)) {
                Logger.debug('Opportunities :: setDefaultOwner :: skipping opp: ' + o.ID + ' ownerID: ' + o.ownerID + ' is not the one of the usernames set in GeneralSettings.REASSIGN_IF_OWNERS: ' + GeneralSettings.REASSIGN_IF_OWNERS);
                continue;
            }

            o.ownerID = newOwner.ID;
            Logger.debug('Opportunities :: setDefaultOwner :: did set to user: ' + newOwner.alias + ' opp: ' + o.ID);
        }
    }
  
    
    private static string getRecordTypeName(Opportunity opp) {
		Map<ID,Schema.RecordTypeInfo> rt_Map = Opportunity.sObjectType.getDescribe().getRecordTypeInfosById(); 
        return rt_map.get(opp.recordTypeID).getName();
    }

    // todo: on hold, we may not need this
    /*public static void syncToExternal(List<Opportunity> opportunities, Map<Id, Opportunity> oldOpportunities){

        List<Opportunity> relatedOpportunities = new List<Opportunity>();

        for (Opportunity opportunity : opportunities) {
            if((opportunity.StageName == 'Claim') && (opportunity.Claim_Count__c == 0) && (opportunity.StageName != oldOpportunities.get(opportunity.Id).StageName) &&
                        (opportunity.Legal_Process_Type__c == 'External') &&
                        (opportunity.Legal__c == Users.LachmairLegal()) && // 0050Y000002Fq9M
                        (Opportunities.isDieselSkandal(opportunity.RecordTypeId))) { // 0120Y000000W0CYQA0
                relatedOpportunities.add(opportunity);
            }
        }
        if (relatedOpportunities.isEmpty() == false) {
            SyncUtilitiesQueueable queueable = new SyncUtilitiesQueueable();
            queueable.opportunities = relatedOpportunities;
            System.enqueueJob(queueable);
        }
    }*/
}