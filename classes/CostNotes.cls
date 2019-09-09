public class CostNotes {
    public class InvalidInputException extends Exception {}
    public static Cost_Note__c build(Claim__c claim, string rec, string sub, string typ) {
        Logger.debug('>> Costnotes :: build :: claim: ' + claim);
        if (claim == null) {
            throw new InvalidInputException('Claim is mandatory');
        }
        
        if (sub == null) {
            throw new InvalidInputException('Subject is mandatory');
        }

        Cost_Note__c cn = new Cost_Note__c(
            Claim__c = claim.Id,
            Recipient__c = rec,
            Subject__c = sub,
            Type__c = typ
        );

        // Check for duplicates
        for (Cost_Note__c ecn : claim.Cost_Notes__r) {
            if (cn.type__c == ecn.type__c && cn.Subject__c == ecn.Subject__c) {
                // Found duplicate, do not build the object
                return null;
            }
        }

        Logger.debug('<< Costnotes :: build :: cn: ' + cn);
        return cn;
    }

    // Legacy code
    public static void setNumber(List<Cost_Note__c> cnn, Map<Id,Cost_Note__c> oldCostNotes, Boolean isInsert) {
        Logger.debug('>> CostNotes :: setNumber :: cnn: ' + cnn);
        Set<Id> claimIds = new Set<Id>();
        for (Cost_Note__c cn: cnn) {
            claimIds.add(cn.claim__c);
        }

        Map<ID, Claim__c> claims = new Map<ID, Claim__c>([
            SELECT ID,
            Opportunity__r.Legal_Account__c,
            Opportunity__r.RecordTypeId,
            Opportunity__r.Account_Id__c
            FROM Claim__c
            WHERE ID IN :claimIds
        ]);
        
        Set<String> postfixes = new Set<String>();
        for (Claim__c claim : claims.values()){
            if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) {
                // DG
                if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                    // Jäger
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                        // VH24
                        postfixes.add('JVH');
                    } else {
                        // VR24
                        postfixes.add('JDG');
                    }
                } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                    // Kainz
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                        // VH24
                        postfixes.add('CVH');
                    } else {
                        // VR24
                        postfixes.add('CVR');
                    }
                } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                    // 21Legal
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                        // VH24
                        postfixes.add('21VH');
                    } else {
                        // VR24
                        postfixes.add('21DG');
                    }
                } else {
                    // Lachmair
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                        // VH24
                        postfixes.add('VH');
                    } else {
                        // VR24
                        postfixes.add('DG');
                    }
                }
            } else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)) {
                // FZ
                if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                    // Jäger
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('JVHFZ');
                    } else {
                        // VR24
                        postfixes.add('JVRFZ');
                    }
                } else {
                    // Kainz
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                        // VH24
                        postfixes.add('CVHFZ');
                    } else {
                        // VR24
                        postfixes.add('CVRFZ');
                    }
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)){
                    // Jäger
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('JVHLV');
                    } else {
                        // VR24
                        postfixes.add('JVRLV');
                    }
                } else {
                    // 21Legal
                    if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('21VHLV');
                    } else {
                        // VR24
                        postfixes.add('21VRLV');
                    }
                }
            }
        }

        System.debug('postfixes' + postfixes);
        Map<String,Cost_Note__c> lastCostNotes = new Map<String,Cost_Note__c>();
        // Gets existing costnotes from this year matching the postfix
        for (String postfix : postfixes){
            if (lastCostNotes.get(postfix) == null){
                List<Cost_Note__c> queriedCostNotes = Database.query('SELECT Id,Number__c FROM Cost_Note__c where Recipient__c != \'Customer\' AND Test__c = false AND Date__c = THIS_YEAR AND Number__c LIKE \'%/' + postfix + '\' ORDER BY Number__c DESC NULLS LAST LIMIT 1');
                if (queriedCostNotes.size() > 0){
                    lastCostNotes.put(postfix,queriedCostNotes[0]);
                }
            }
        }

        Map<String,Integer> lastCostNoteCount = new Map<String,Integer>();
        Map<String,Integer> thisCostNoteCount = new Map<String,Integer>();
        for (String postfix : postfixes) {
            Integer count = 0;
            if (lastCostNotes.get(postfix) != null) {
                count = Integer.valueOf(lastCostNotes.get(postfix).Number__c.substring(4,10));
            }
            lastCostNoteCount.put(postfix,count);
            thisCostNoteCount.put(postfix,1);
        }

        for (Cost_Note__c costNote : cnn) {
            if (costNote.Recipient__c != 'Customer' && costNote.Number__c == null && costNote.Date__c != null && (isInsert == true || (costNote.Date__c != oldCostNotes.get(costNote.Id).Date__c && costNote.Number__c == oldCostNotes.get(costNote.Id).Number__c))) {
                Logger.debug('here');
                Claim__c claim = claims.get(costNote.Claim__c);
                String postfix;
    
                if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000W0CY
                    // DG
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'JVH';
                        } else {
                            // VR24
                            postfix = 'JDG';
                        }
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'CVH';
                        } else {
                            // VR24
                            postfix = 'CVR';
                        }
                    } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = '21VH';
                        } else {
                            // VR24
                            postfix = '21DG';
                        }
                    } else {
                        // Lachmair
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'VH';
                        } else {
                            // VR24
                            postfix = 'DG';
                        }
                    }
                } else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000KnMH
                    // FZ
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'JVHFZ';
                        } else {
                            // VR24
                            postfix = 'JVRFZ';
                        }
                    } else {
                        // Kainz
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'CVHFZ';
                        } else {
                            // VR24
                            postfix = 'CVRFZ';
                        }
                    }
                } else {
                    // LV
                    if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = 'JVHLV';
                        } else {
                            // VR24
                            postfix = 'JVRLV';
                        }
                    } else {
                        // 21Legal
                        if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                            // VH24
                            postfix = '21VHLV';
                        } else {
                            // VR24
                            postfix = '21VRLV';
                        }
                    }
                    System.debug('fixpsot: ' + postfix);
                }
                Integer count = lastCostNoteCount.get(postfix) + thisCostNoteCount.get(postfix);
                String year = System.now().date().year().format().replace('.','');
    
                if (costNote.Test__c == true){
                    costNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/Test';
                } else {
                    costNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/' + postfix;
                    thisCostNoteCount.put(postfix,thisCostNoteCount.get(postfix) + 1);
                }
            }
        }
        Logger.debug('<< CostNotes :: setNumber');
    }

    // todo: refactor, part of the CostNote Hack on DocumentCreationAction
    public static String computeNumber(Cost_Note__c costNote) {
        Logger.debug('>> CostNotes :: computeNumber :: cn: ' + costNote);
        
        Claim__c[] cc = [
            SELECT ID,
            Opportunity__r.Legal_Account__c,
            Opportunity__r.RecordTypeId,
            Opportunity__r.Account_Id__c
            FROM Claim__c
            WHERE ID = :costNote.claim__c
        ];
        if (cc.size() == 0) {
            Logger.debug('CostNotes :: computeNumber :: no claims for costnote: ' + costNote.ID);
            return null;
        }

        Claim__c claim = cc[0];
        Set<String> postfixes = new Set<String>();
        if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) {
            // DG
            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                    // VH24
                    postfixes.add('JVH');
                } else {
                    // VR24
                    postfixes.add('JDG');
                }
            } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                // Kainz
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                    // VH24
                    postfixes.add('CVH');
                } else {
                    // VR24
                    postfixes.add('CVR');
                }
            } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                // 21Legal
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                    // VH24
                    postfixes.add('21VH');
                } else {
                    // VR24
                    postfixes.add('21DG');
                }
            } else {
                // Lachmair
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                    // VH24
                    postfixes.add('VH');
                } else {
                    // VR24
                    postfixes.add('DG');
                }
            }
        } else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)) {
            // FZ
            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                    // VH24
                    postfixes.add('JVHFZ');
                } else {
                    // VR24
                    postfixes.add('JVRFZ');
                }
            } else {
                // Kainz
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
                    // VH24
                    postfixes.add('CVHFZ');
                } else {
                    // VR24
                    postfixes.add('CVRFZ');
                }
            }
        } else {
            // LV
            if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)){
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                    // VH24
                    postfixes.add('JVHLV');
                } else {
                    // VR24
                    postfixes.add('JVRLV');
                }
            } else {
                // 21Legal
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
                    // VH24
                    postfixes.add('21VHLV');
                } else {
                    // VR24
                    postfixes.add('21VRLV');
                }
            }
        }

        System.debug('postfixes' + postfixes);
        Map<String,Cost_Note__c> lastCostNotes = new Map<String,Cost_Note__c>();
        for (String postfix : postfixes){
            if (lastCostNotes.get(postfix) == null){
                List<Cost_Note__c> queriedCostNotes = Database.query('SELECT Id,Number__c FROM Cost_Note__c where Recipient__c != \'Customer\' AND Test__c = false AND Date__c = THIS_YEAR AND Number__c LIKE \'%/' + postfix + '\' ORDER BY Number__c DESC NULLS LAST LIMIT 1');
                if (queriedCostNotes.size() > 0){
                    lastCostNotes.put(postfix,queriedCostNotes[0]);
                }
            }
        }

        Map<String,Integer> lastCostNoteCount = new Map<String,Integer>();
        Map<String,Integer> thisCostNoteCount = new Map<String,Integer>();
        for (String postfix : postfixes) {
            Integer count = 0;
            if (lastCostNotes.get(postfix) != null) {
                count = Integer.valueOf(lastCostNotes.get(postfix).Number__c.substring(4,10));
            }
            lastCostNoteCount.put(postfix,count);
            thisCostNoteCount.put(postfix,1);
        }

        if (costNote.Recipient__c == 'Customer') {
            Logger.debug('recipient is customer');
            return null;
        }
        
        if (costNote.Date__c == null) {
            Logger.debug('date is null');
            return null;
        }
        
        String postfix;
        if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000W0CY
            // DG
            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'JVH';
                } else {
                    // VR24
                    postfix = 'JDG';
                }
            } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000010COcm
                // Kainz
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'CVH';
                } else {
                    // VR24
                    postfix = 'CVR';
                }
            } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000013yLnP
                // 21Legal
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = '21VH';
                } else {
                    // VR24
                    postfix = '21DG';
                }
            } else {
                // Lachmair
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'VH';
                } else {
                    // VR24
                    postfix = 'DG';
                }
            }
        } else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000KnMH
            // FZ
            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'JVHFZ';
                } else {
                    // VR24
                    postfix = 'JVRFZ';
                }
            } else {
                // Kainz
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'CVHFZ';
                } else {
                    // VR24
                    postfix = 'CVRFZ';
                }
            }
        } else {
            // LV
            if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000010BXGZ
                // Jäger
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = 'JVHLV';
                } else {
                    // VR24
                    postfix = 'JVRLV';
                }
            } else {
                // 21Legal
                if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) { // 0010Y00000eCUS9
                    // VH24
                    postfix = '21VHLV';
                } else {
                    // VR24
                    postfix = '21VRLV';
                }
            }
        }
        Integer count = lastCostNoteCount.get(postfix) + thisCostNoteCount.get(postfix);
        String year = System.now().date().year().format().replace('.','');
        
        if (costNote.Test__c == true){
            costNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/Test';
        } else {
            costNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/' + postfix;
            thisCostNoteCount.put(postfix,thisCostNoteCount.get(postfix) + 1);
        }
        //update costNote;

        Logger.debug('<< CostNotes :: computeNumber: ' + costNote.number__c);
        
        return costNote.number__c;
    }
    
    // Legacy code
    public static void setUser(List<Cost_Note__c> cnn) {
        Logger.debug('>> CostNotes :: setUser :: cnn: ' + cnn);
        Set<Id> claimIds = new Set<Id>();
        for (Cost_Note__c costNote : cnn){
            claimIds.add(costNote.Claim__c);
        }
        Map<Id,Claim__c> claims = new Map<Id,Claim__c>([select Id, Opportunity_Legal_Account_Id__c, Clerk__c from Claim__c where Id IN :claimIds]);
        for (Cost_Note__c costNote : cnn){
            Claim__c claim = claims.get(costNote.Claim__c);
            if (costNote.Accounting__c == null) {
                if (Accounts.isJCLegal(claim.Opportunity_Legal_Account_Id__c)) {
                    // Bei H. Jäger Maria Gorzna setzen
                    costNote.Accounting__c = Users.MariaGorzna();
                } else {
                    // Rest
                    costNote.Accounting__c = claim.Clerk__c;
                }
            }
        }
        Logger.debug('<< CostNotes :: setUser');
    }

    public static void setRemindersCanceled(Cost_Note__c[] cnn, Map<ID, Cost_Note__c> oldCnn) {
        cnn = [
            SELECT  ID,
            Stage__c,
            Amount_Open__c,
            (SELECT ID, Stage__c FROM Cost_Note_Reminders__r)
            FROM Cost_Note__c
            WHERE ID IN: cnn
        ];

        Cost_Note_Reminder__c[] cnnrToUpdate = new Cost_Note_Reminder__c[]{};
        for (Cost_Note__c cn: cnn) {
            if (cn.stage__c != 'Paid' || oldCnn.get(cn.ID).stage__c != 'Sent') {
                continue;
            }
            for (Cost_Note_Reminder__c cnr : cn.cost_Note_Reminders__r) {
                if (cnr.Stage__c == 'Draft') {
                    cnr.Stage__c = 'Canceled';
                    cnnrToUpdate.add(cnr);
                }
            }
        }
        update cnnrToUpdate;
    }

    public static void setClaimAmountInDispute(List<Cost_Note__c> costNotes, Map<Id,Cost_Note__c> oldCostNotes) {
        costNotes = [
            SELECT Id,
            Type__c,
            Stage__c,
            Claim__c,
            Claim__r.Amount_In_Dispute__c,
            Claim__r.Amount_In_Dispute_Claim_Letter__c,
            Claim__r.Amount_In_Dispute_Lawsuit__c
            FROM Cost_Note__c
            WHERE Id IN :costNotes
        ];
        List<Claim__c> updateClaims = new List<Claim__c>();

        for (Cost_Note__c costNote : costNotes) {
            if ((costNote.Stage__c == 'Sent') && (costNote.Stage__c != oldCostNotes.get(costNote.Id).Stage__c)) {
                if (costNote.Type__c == 'Außergerichtlich') {
                    // Außergerichtlich
                    costNote.Claim__r.Amount_In_Dispute_Claim_Letter__c = costNote.Claim__r.Amount_In_Dispute__c;
                } else {
                    // Gerichtlich
                    costNote.Claim__r.Amount_In_Dispute_Lawsuit__c = costNote.Claim__r.Amount_In_Dispute__c;
                }
                updateClaims.add(costNote.Claim__r);
            }
        }
        if (!updateClaims.isEmpty()) {
            update updateClaims;
        }
    }

    public static void setClaimExtrajudicialCostNoteNumber(Cost_Note__c[] cnn, Map<ID, Cost_Note__c> oldCnn) {
        cnn = [
            SELECT  ID,
            Type__c,
            Stage__c,
            Number__c,
            Claim__c,
            Claim__r.Extrajudicial_Cost_Note_Number__c
            FROM Cost_Note__c
            WHERE ID IN :cnn
        ];

        Claim__c[] claimsToUpdate = new Claim__c[]{};
        for (Cost_Note__c cn: cnn) {
            if (cn.stage__c != 'Sent' || cn.stage__c == oldCnn.get(cn.ID).stage__c) {
                continue;
            }
            if (cn.type__c == 'Außergerichtlich') {
                cn.claim__r.Extrajudicial_Cost_Note_Number__c = cn.number__c;
                claimsToUpdate.add(cn.claim__r);
            }
        }
        update claimsToUpdate;
    }
 
    public static void uploadToDropbox(List<Cost_Note__c> costNotes, Map<Id,Cost_Note__c> oldCostNotes) {
        List<Id>relatedCostNoteIds = new List<Id>();

        for (Cost_Note__c costNote : costNotes){
            if ((costNote.Stage__c != oldCostNotes.get(costNote.Id).Stage__c) && (costNote.Stage__c == 'Sent') && (costNote.Uploaded_To_Dropbox__c == false)){
                relatedCostNoteIds.add(costNote.Id);
            }
        }

        if (relatedCostNoteIds.isEmpty() == false){

            Map<Id, String> paths = new Map<Id, String>{
                    Accounts.CLLBLegalID => '/CLLB/Kostennoten/',
                    Accounts.JCLegalLvID => '/Jäger/Kostennoten/',
                    Accounts.JCLegalID => '/Accounting/DATEV/Jäger/',
                    Accounts.LegalLachmairID => '/Lachmair/Kostennoten/',
                    Accounts.LegalVortmannID => '/Vortmann/Kostennoten/',
                    Accounts.Legal21ID => '/21Legal/Kostennoten/'
            };

            List<Cost_Note__c> relatedCostNotes = [select Id,Stage__c,Claim__r.Opportunity__r.Legal_Account__c,Claim__r.Test__c,Date__c from Cost_Note__c where Id IN :relatedCostNoteIds];
            List<Attachment> attachments = [select Id,ParentId from Attachment where ParentId IN :costNotes];

            for (Cost_Note__c costNote : relatedCostNotes){
                for (Attachment attachment : attachments){
                    if (attachment.ParentId == costNote.Id){
                        Date folderDate;                        
                        if (costNote.Date__c == null) {
                            folderDate = System.now().date();
                        } else {
                            folderDate = costNote.Date__c;
                        }
                        String path;
                        if ((paths.containsKey(costNote.Claim__r.Opportunity__r.Legal_Account__c)) && (costNote.Claim__r.Test__c == false)) {
                            path = paths.get(costNote.Claim__r.Opportunity__r.Legal_Account__c) + folderDate.year() + '/' + folderDate.month() + '/';
                        } else {
                            path = '/Technik/Testdaten/Cost Notes/' + folderDate.year() + '/' + folderDate.month() + '/';
                        }
                        IntegrateDropbox.uploadFileToDropboxAsync(path, attachment.Id,costNote.Claim__r.Opportunity__r.Legal_Account__c);
                    }
                }
            }
        }
    }
}