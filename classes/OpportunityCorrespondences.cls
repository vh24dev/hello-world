public class OpportunityCorrespondences {
    private static String dkRtName = 'Dieselskandal';
    private static String fzRtName = 'Finanzierung';
    private static String lvRtName = 'Lebensversicherung';
    public static ID dkRtID;
    public static ID fzRtID;
    public static ID lvRtID;
    static {
        RecordType[] rts = [
            SELECT ID, DeveloperName
            FROM RecordType
            WHERE (DeveloperName = :dkRtName
                OR DeveloperName = :fzRtName
                OR DeveloperName = :lvRtName)
                AND SObjectType = 'Opportunity_Correspondence__c'
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

    public static Boolean isDieselSkandal(ID oppcorrRecordTypeID) {
        if (oppcorrRecordTypeID == null) {
            return false;
        }
        return oppcorrRecordTypeID == dkRtID;
    }

    public static Id finanzierungRecordType() {
        return fzRtID;
    }

    public static Boolean isFinanzierung(ID oppcorrRecordTypeID) {
        if (oppcorrRecordTypeID == null) {
            return false;
        }
        return oppcorrRecordTypeID == fzRtID;
    }

    public static Id lebensversicherungRecordType() {
        return lvRtID;
    }

    public static Boolean isLebensversicherung(ID oppcorrRecordTypeID) {
        if (oppcorrRecordTypeID == null) {
            return false;
        }
        return oppcorrRecordTypeID == lvRtID;
    }

    public static void setTerm(List<Opportunity_Correspondence__c> oppCorrs, Map<Id,Opportunity_Correspondence__c> oldOppCorrs, Boolean isUpdate) {
        for (Opportunity_Correspondence__c oppCorr : oppCorrs) {
            if ((oppCorr.Term__c == null) || ((isUpdate == true) && (oppCorr.Date__c != oldOppCorrs.get(oppCorr.Id).Date__c))) {
                oppCorr.Term__c = oppCorr.Date__c + (Integer)oppCorr.Follow_up_Period__c;
            }
        }
    }

    public static void setRecordType(List<Opportunity_Correspondence__c> oppCorrs) {
        boolean missingRecType = false;
        Set<Id> opportunityIds = new Set<Id>();
        for (Opportunity_Correspondence__c oppCorr : oppCorrs){
            opportunityIds.add(oppCorr.Opportunity__c);
        }

        Map<Id, Opportunity> opps = new Map<Id, Opportunity>([
            SELECT Id,
            RecordTypeId
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ]);
        for (Opportunity_Correspondence__c oppCorr : oppCorrs){
            Opportunity opp = opps.get(oppCorr.Opportunity__c);

            if (Opportunities.isDieselSkandal(opp.RecordTypeId)){
                // DG
                oppCorr.RecordTypeId = OpportunityCorrespondences.dieselskandalRecordType(); // 0121v0000007HG0
            } else if (Opportunities.isFinanzierung(opp.RecordTypeId)) {
                // FZ
                oppCorr.RecordTypeId = OpportunityCorrespondences.finanzierungRecordType(); // 0121v00000032wu
            } else {
                // LV
                oppCorr.RecordTypeId = OpportunityCorrespondences.lebensversicherungRecordType(); // 0121v0000007HEd
            }
        }
    }
    
    public static void manageTextModules(List<Opportunity_Correspondence__c> opportunityCorrespondencies) {        
        System.debug('>> OpportunityCorrespondences :: manageTextModules');

        opportunityCorrespondencies = [
            SELECT Id,
            Text_Modules__c,
            Stage__c,
            Opportunity__c,
            Opportunity__r.Contact__c,
            Opportunity__r.Insurance__c,
            Opportunity__r.Legal__c,
            Opportunity__r.Legal_Protection_Insurance__c,
            Opportunity__r.Account_Id__c,
            Opportunity__r.Legal_Account__c,
            Opportunity__r.RecordTypeId,
            (SELECT Id, Developer_Name__c, Name FROM Opportunity_Text_Modules__r)
            FROM Opportunity_Correspondence__c
            WHERE Id IN :opportunityCorrespondencies
        ];
        List<EmailTemplate> templates = [
            SELECT Id,
            Name,
            DeveloperName,
            Subject,
            Body
            FROM EmailTemplate
            WHERE FolderId IN (select Id FROM Folder WHERE DeveloperName LIKE '%TextModule%')
        ];

        List<Opportunity_Text_Module__c> newTextModules = new List<Opportunity_Text_Module__c>();
        List<Opportunity_Text_Module__c> deleteTextModules = new List<Opportunity_Text_Module__c>();

        for (Opportunity_Correspondence__c opportunityCorrespondence : opportunityCorrespondencies){
            // filter templates
            List<EmailTemplate> filteredTemplates = new List<EmailTemplate>();
            if (Opportunities.isDieselSkandal(opportunityCorrespondence.Opportunity__r.RecordTypeId)) { // 0120Y000000W0CY
                // Diesel
                if (Accounts.isJCLegal(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Diesel')) && (template.DeveloperName.contains('Jaeger'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isLegalLeCom(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) {
                    // LeCom
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Diesel')) && (template.DeveloperName.contains('LeCom'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isLegal21(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000013yLnP
                    // 21Legal
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Diesel')) && (template.DeveloperName.contains('21Legal'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isCLLBLegal(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Diesel')) && (template.DeveloperName.contains('Kainz'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else {
                    // Lachmair
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Diesel')) && (template.DeveloperName.contains('Lachmair'))) {
                            filteredTemplates.add(template);
                        }
                    }
                }
            } else if (Opportunities.isFinanzierung(opportunityCorrespondence.Opportunity__r.RecordTypeId)) { // 0120Y000000KnMH
                // FZ
                if (Accounts.isJCLegal(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Fz')) && (template.DeveloperName.contains('Jaeger'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isLegalLeCom(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) {
                    // LeCom
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Fz')) && (template.DeveloperName.contains('LeCom'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else {
                    // Kainz
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Fz')) && (template.DeveloperName.contains('Kainz'))) {
                            filteredTemplates.add(template);
                        }
                    }
                }
            } else {
                // LV
                if (Accounts.isLegal21(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000013yLnP
                    // 21Legal
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Lv')) && (template.DeveloperName.contains('21Legal'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isCLLBLegal(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Lv')) && (template.DeveloperName.contains('Kainz'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else if (Accounts.isLegalLeCom(opportunityCorrespondence.Opportunity__r.Legal_Account__c)) {
                    // LeCom
                    for (EmailTemplate template : templates) {
                        if ((template.DeveloperName.contains('Lv')) && (template.DeveloperName.contains('LeCom'))) {
                            filteredTemplates.add(template);
                        }
                    }
                } else {
                    // Jäger
                    for (EmailTemplate template : templates) {
                        // System.debug(' mi LVJAEAGER CMP TPL=' + template);
                        if ((template.DeveloperName.contains('Lv')) && (template.DeveloperName.contains('Jaeger'))) {
                            filteredTemplates.add(template);
                        }
                    }
                }
            }

            // Create new text modules
            System.debug('OpportunityCorrespondences :: manageTextModules :: filteredTemplates: ' + filteredTemplates);
            System.debug('OpportunityCorrespondences :: manageTextModules :: opportunityCorrespondence.Text_Modules__c: ' + opportunityCorrespondence.Text_Modules__c);
            System.debug('OpportunityCorrespondences :: manageTextModules :: opportunityCorrespondence.Opportunity_Text_Modules__r: ' + opportunityCorrespondence.Opportunity_Text_Modules__r);

            if (opportunityCorrespondence.Text_Modules__c != null){
                for (String textModuleName : opportunityCorrespondence.Text_Modules__c.split(';')){
                    Boolean alreadyExisting = false;
                    for (Opportunity_Text_Module__c textModule : opportunityCorrespondence.Opportunity_Text_Modules__r){
                        if (textModule.Developer_Name__c.contains(textModuleName)){
                            System.debug('OpportunityCorrespondences :: manageTextModules :: text module ' + textModuleName + ' already existing in correspondence');
                            alreadyExisting = true;
                            break;
                        }
                    }

                    if (alreadyExisting == false){
                        String templateText;
                        for (EmailTemplate template : filteredTemplates){
                            if (template.DeveloperName.contains(textModuleName)){
                                System.debug('OpportunityCorrespondences :: manageTextModules :: found matching email template (devname): ' + template.DeveloperName);
                                templateText = Utilities.mergeText(template.Body,new Map<Id,String>{
                                    opportunityCorrespondence.Id => 'Opportunity_Correspondence__c',
                                    opportunityCorrespondence.Opportunity__c => 'Opportunity',
                                    opportunityCorrespondence.Opportunity__r.Legal__c => 'Legal__c',
                                    opportunityCorrespondence.Opportunity__r.Contact__c => 'Contact',
                                    opportunityCorrespondence.Opportunity__r.Insurance__c => 'Insurance__c',
                                    opportunityCorrespondence.Opportunity__r.Legal_Protection_Insurance__c => 'Legal_Protection_Insurance__c'
                                });
                                Opportunity_Text_Module__c textModule = new Opportunity_Text_Module__c(
                                    Opportunity_Correspondence__c = opportunityCorrespondence.Id,
                                    Name = template.Subject,
                                    Developer_Name__c = template.DeveloperName.replace('DieselLachmair','')
                                    .replace('Diesel21Legal','')
                                    .replace('DieselJaeger','')
                                    .replace('DieselKainz','')
                                    .replace('DieselLeCom', '')
                                    .replace('FzJaeger','')
                                    .replace('FzLeCom', '')
                                    .replace('FzKainz','')
                                    .replace('Lv21Legal','')
                                    .replace('LvKainz','')
                                    .replace('LvJaeger','')
                                    .replace('LvLeCom', '')
                                    .replace('TextModule',''),
                                    Text__c = templateText
                                );
                                newTextModules.add(textModule);
                            }
                        }
                    }
                }
            }

            // Delete old text modules
            for (Opportunity_Text_Module__c textModule : opportunityCorrespondence.Opportunity_Text_Modules__r){
                Boolean isInList = false;
                if (opportunityCorrespondence.Text_Modules__c != null){
                    for (String textModuleName : opportunityCorrespondence.Text_Modules__c.split(';')){
                        if ((textModule.Developer_Name__c != null) && (textModule.Developer_Name__c.contains(textModuleName))){
                            isInList = true;
                        }
                    }
                }
                if (isInList == false){
                    deleteTextModules.add(textModule);
                }
            }
        }

        System.debug('OpportunityCorrespondence :: manageTextModules :: newTextModules: ' + newTextModules);
        if (newTextModules.size() > 0){
            insert newTextModules;
        }

        if (deleteTextModules.size() > 0){
            delete deleteTextModules;
        }
    }

    @future (callout=true)
    public static void autoCreateDocuments(Set<Id> ids) {
        List<Opportunity_Correspondence__c> opportunityCorrespondencies = [select Id, Autocreate_Document__c from Opportunity_Correspondence__c where id in :ids];
        for (Opportunity_Correspondence__c opportunityCorrespondence : opportunityCorrespondencies) {
            if (opportunityCorrespondence.Autocreate_Document__c == true) {
                DocumentCreationAction.autoCreateDocument(opportunityCorrespondence.Id,false,'pdf',null,null);
            }
        }
    }
}