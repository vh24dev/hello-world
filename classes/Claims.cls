public class Claims {
    // Record types
    private static String dkRtName = 'Dieselskandal';
    private static String fzRtName = 'Finanzierung';
    private static String lvRtName = 'Lebensversicherung';
    private static ID dkRtID;
    private static ID fzRtID;
    private static ID lvRtID;
    static {
        RecordType[] rts = [
            SELECT ID, DeveloperName
            FROM RecordType
            WHERE (DeveloperName = :dkRtName
                OR DeveloperName = :fzRtName
                OR DeveloperName = :lvRtName)
                AND SObjectType = 'Claim__c'
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

    public static Boolean isDieselSkandal(ID claimRecordTypeID) {
        if (claimRecordTypeID == null) {
            return false;
        }
        return claimRecordTypeID == dkRtID;
    }
    
    public static Id finanzierungRecordType() {
        return fzRtID;
    }
    
    public static Boolean isFinanzierung(ID claimRecordTypeID) {
        if (claimRecordTypeID == null) {
            return false;
        }
        return claimRecordTypeID == fzRtID;
    }

    public static Id lebensversicherungRecordType() {
        return lvRtID;
    }
    
    public static Boolean isLebensversicherung(ID claimRecordTypeID) {
        if (claimRecordTypeID == null) {
            return false;
        }
        return claimRecordTypeID == lvRtID;
    }
    // --

    // cc must contain Opportunity__c, and oppByID is a map of Opportunity IDs to Opportunity,
    // with all the Opportunities related to the Claims in cc.
    // Opportunity must contain RecordTypeID
    public static void setRecordType(Claim__c[] cc, Map<ID, Opportunity> oppByID) {
        Logger.debug('>> Claims :: setRecordType :: cc: ' + cc +  ' oppByID: ' + oppByID);

        for (Claim__c c: cc) {
            Opportunity o = oppByID.get(c.opportunity__c);
            if (o == null) {
                continue;
            }

            if (Opportunities.isDieselSkandal(o.recordTypeID)) {
                c.recordTypeId = Claims.dieselSkandalRecordType();
                continue;
            }
            
            if (Opportunities.isFinanzierung(o.recordTypeID)) {
                c.recordTypeId = Claims.finanzierungRecordType();
                continue;
            }
            
            if (Opportunities.isLebensversicherung(o.recordTypeID)) {
                c.recordTypeId = Claims.lebensversicherungRecordType();
                continue;
            }
        }
        
        Logger.debug('<< Claims :: setRecordType');
    }
    
    // cc must contain Opportunity__c, and oppByID is a map of Opportunity IDs to Opportunity,
    // with all the Opportunities related to the Claims in cc.
    // Opportunity must contain Legal__c and Legal_Account__c
    public static void setUsers(Claim__c[] cc, Map<ID, Opportunity> oppByID) {
        Logger.debug('>> Claims :: setUsers :: cc: ' + cc +  ' oppByID: ' + oppByID);

        for (Claim__c c: cc) {
            Opportunity o = oppByID.get(c.opportunity__c);
            if (o == null) {
                continue;
            }

            if (c.legal__c == null) {
                c.legal__c = o.legal__c;
            }

            if (c.clerk__c == null) {
                if (Accounts.isCLLBLegal(o.legal_Account__c)) {
                    // Kainz, nur Partnerprozess
                    c.clerk__c = Users.cllbClerk();
                }
            }

            if (c.clerk_Appeal__c == null && c.stage__c == 'Appeal') {
                c.clerk_Appeal__c = Users.clerkAppeal();
            }
            
            Logger.debug('Claims :: setUsers :: legal:' + c.legal__c + ' clerk: ' + c.clerk__c);
        }
        
        Logger.debug('<< Claims :: setUsers');
    }
    
    // cc must contain Opportunity__c, RecordTypeID, Lawsuit_Insurance_Date__c, Court__c, and Opportunity_Vehicle_Brand_Id__c.
    public static void setCourt(Claim__c[] cc) {
        Logger.debug('>> Claims :: setCourt :: cc: ' + cc);

        for (Claim__c c: cc) {
            Logger.debug('Claims :: setCourt :: c: ' + c);

            if (!Claims.isDieselSkandal(c.recordTypeId)
                || c.lawsuit_Insurance_Date__c != null
                || c.court__c != null
                || c.opportunity_Vehicle_Brand_Id__c == null) {
                Logger.debug('Claims :: setCourt :: criteria did not match, exiting');
                continue;
            }
            
            if (VehicleBrands.isDaimlerAG(c.opportunity_Vehicle_Brand_Id__c)
                || VehicleBrands.isPorscheAG(c.opportunity_Vehicle_Brand_Id__c)) {
                c.court__c = useCountyCourt(c) ? Courts.stuttgartAmtsgerichtID : Courts.stuttgartLandgerichtID;
                Logger.debug('Claims :: setCourt :: 1');
                return;
            }
            
            if (VehicleBrands.isAudiAG(c.opportunity_Vehicle_Brand_Id__c)) {
                c.court__c = useCountyCourt(c) ? Courts.ingolstadtAmtsgerichtID : Courts.ingolstadtLandgerichtID;
                Logger.debug('Claims :: setCourt :: 2');
                return;
            }
            
            if (VehicleBrands.isOpelAutomobileGmbH(c.opportunity_Vehicle_Brand_Id__c)) {
                c.court__c = useCountyCourt(c) ? Courts.darmstadtAmtsgerichtID : Courts.darmstadtLandgerichtID;
                Logger.debug('Claims :: setCourt :: 3');
                return;
            }
            
            if (VehicleBrands.isVolkswagenAG(c.opportunity_Vehicle_Brand_Id__c)) {
                c.court__c = useCountyCourt(c) ? Courts.wolfsburgAmtsgerichtID : Courts.braunschweigLandgerichtID;
                Logger.debug('Claims :: setCourt :: 4');
                return;
            }
        }
        
        Logger.debug('<< Claims :: setCourt :: no court set');
    }

    private static Boolean useCountyCourt(Claim__c c) {
        return c.opportunity_Amount_In_Dispute__c <= 5000;
    }

    // cc must contain Opportunity__c, RecordTypeID, and Stage__c.
    // oppByID is a map of Opportunity IDs to Opportunity,
    // with all the Opportunities related to the Claims in cc.
    // Opportunity must contain Priority_Level__c.
    public static void setStage(Claim__c[] cc, Map<ID, Claim__c> oldCc, Map<ID, Opportunity> oppByID, boolean isInsert) {
        Logger.debug('>> Claims :: setStage :: cc: ' + cc +  ' oppByID: ' + oppByID);
		ClaimStage.setStage(cc, oldCc, oppByID, isInsert);
        Logger.debug('<< Claims :: setStage');
    }
    
    // cc must contain Form_Hash_1__c, Submission_Date_Before_Claim_Statement__c, and Submission_Date_Before_Lawsuit_Date__c.
    // oldCc is a map of Claims which got updated, where cc is the list of the updated version.
    // oldCc must contain Submission_Date_Before_Claim_Statement__c and Submission_Date_Before_Lawsuit_Date__c.
    public static void setHash(Claim__c[] cc, Map<ID, Claim__c> oldCc) {
        Logger.debug('>> Claims :: setHash :: cc: ' + cc + ' oldCc: ' + oldCc);

        for (Claim__c c: cc) {
            if (c.form_Hash_1__c == null 
                || (c.submission_Date_Before_Claim_Statement__c != null && c.submission_Date_Before_Claim_Statement__c != oldCc.get(c.Id).submission_Date_Before_Claim_Statement__c)
                || (c.submission_Date_Before_Lawsuit_Date__c != null && c.submission_Date_Before_Lawsuit_Date__c != oldCc.get(c.Id).submission_Date_Before_Lawsuit_Date__c)) {
                c.Form_Hash_1__c = GUID.Gen();
                Logger.debug('Claims :: setHash :: hash set: ' + c.Form_Hash_1__c);
                continue;
            }
        }
        
        Logger.debug('<< Claims :: setHash');
    }

    // cc must contain Stage__c.
    // oldCc is a map of Claims which got updated, where cc is the list of the updated version.
    // oldCc must contain Stage__c.
    public static void setLastStageChangedAt(Claim__c[] cc, Map<ID, Claim__c> oldCc) {
        Logger.debug('>> Claims :: setLastStageChangedAt :: cc: ' + cc + ' oldCc: ' + oldCc);

        for (Claim__c c: cc) {
            if (c.Stage__c != oldCc.get(c.Id).Stage__c){
                c.last_Stage_Change__c = System.now();
                Logger.debug('Claims :: setLastStageChangedAt :: to: ' + c.last_Stage_Change__c);
            }
        }
        
        Logger.debug('<< Claims :: setLastStageChangedAt');
    }

    // Legacy note: in the case of a cover note for the claim that has already been made,
    // the process is automatically continued after conversion to "claim".
    // cc must contain cover_Note_Scope__c, opportunity_Record_Type_Id__c, lawsuit_Insurance_Date__c, claim_Letter_Insurance_Date__c,
    // legal_Opposition_Insurance_Date__c, response_Insurance_Lawsuit__c, response_Insurance_Claim_Letter__c, and response_Insurance_Legal_Opposition__c.
    public static void setResponseInsuranceLawsuit(Claim__c[] cc) {
        Logger.debug('>> Claims :: setResponseInsuranceLawsuit :: cc: ' + cc);

        for (Claim__c c: cc) {
            if (c.cover_Note_Scope__c == null || !c.cover_Note_Scope__c.contains('Judicial')) {
                Logger.debug('Claims :: setResponseInsuranceLawsuit :: criteria not met, exit');
                continue;
            }

            if (c.lawsuit_Insurance_Date__c == null) {
                c.lawsuit_Insurance_Date__c = Opportunities.isDieselSkandal(c.opportunity_Record_Type_Id__c)
                    ? c.claim_Letter_Insurance_Date__c
                    : c.legal_Opposition_Insurance_Date__c;
            }

            if (c.response_Insurance_Lawsuit__c == null) {
                c.response_Insurance_Lawsuit__c = Opportunities.isDieselSkandal(c.opportunity_Record_Type_Id__c)
                    ? c.response_Insurance_Claim_Letter__c
                    : c.response_Insurance_Legal_Opposition__c;
            }
        }

        Logger.debug('<< Claims :: setResponseInsuranceLawsuit');
    }

    public static void createInvoices(Claim__c[] cc) {
        Logger.debug('>> Claims :: createInvoices :: cc: ' + cc);
        List<Invoice__c> insertInvoices = ClaimInvoices.create(cc);
        Logger.debug('<< Claims :: createInvoices :: created: ' + insertInvoices);
    }

    public static void createTasks(Claim__c[] cc, Map<ID, Claim__c> oldCc, Boolean isInsertingClaim) {
        Logger.debug('>> Claims :: createTasks :: cc: ' + cc + ' oldCc: ' + oldCc + ' isInsertingClaim: ' + isInsertingClaim);
		List<Task> tt = ClaimTasks.create(cc, oldCc, isInsertingClaim);
        Logger.debug('<< Claims :: createTasks :: created: ' + tt);
    }

    public static void closeTasks(Claim__c[] cc, Map<ID, Claim__c> oldCc) {
        Logger.debug('>> Claims :: closeTasks :: cc: ' + cc + ' oldCc: ' + oldCc);

        cc = [
            SELECT  ID,
                    Next_Court_Date__c,
                    Stage__c,
                    Canceled_Next_Court_Date__c,
                    (SELECT ID FROM Correspondencies__r),
                    (SELECT ID, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE ID IN :cc
        ];
        Correspondence__c[] crr = [
            SELECT  ID,
                    Claim__c,
                    Stage__c,
                    Type__c,
                    (SELECT ID, Status, Subject FROM Tasks) FROM Correspondence__c WHERE Claim__c IN :cc
        ];

        Task[] tt = new Task[]{};
        for (Claim__c c: cc) {            
            if (c.stage__c != oldCc.get(c.Id).stage__c) {
                tt.addAll(Tasks.markAsClosed('Wiedervorlage', c));
                tt.addAll(Tasks.markAsClosed('Ergebnis', c));
                tt.addAll(Tasks.markAsClosed('Weiterführung entscheiden', c));
                for (Correspondence__c cr: crr) {
                    if (cr.claim__c == c.Id) {
                        tt.addAll(Tasks.markAsClosed('Wiedervorlage', cr));
                    }
                }
            }

            if (c.next_Court_Date__c != null && c.next_Court_Date__c != oldCc.get(c.Id).next_Court_Date__c) {
                tt.addAll(Tasks.markAsClosed('Wiedervorlage zu Klage', c));
                tt.addAll(Tasks.markAsClosed('Gerichtstermin vereinbaren', c));
                tt.addAll(Tasks.markAsClosed('Gerichtstermin für Klage hinterlegen', c));
                tt.addAll(Tasks.markAsClosed('Gerichtstermin für Berufung hinterlegen', c));
            }

            if (c.stage__c == 'Finished'){
                tt.addAll(Tasks.markAsClosed('abgeschlossen markieren', c));
            }

            if (c.canceled_Next_Court_Date__c){
                tt.addAll(Tasks.markAsClosed('Gerichtstermin absagen', c));
            }
        }

        if (tt.size() > 0) {
            update tt;
        }

        Logger.debug('<< Claims :: closeTasks :: closed: ' + tt);
    }
    
    public static void createCorrespondences(Claim__c[] cc, Map<ID, Claim__c> oldCc) {
        Logger.debug('>> Claims :: createCorrespondences :: cc: ' + cc);
        Correspondence__c[] crr = ClaimCorrespondences.create(cc, OldCc);
        Logger.debug('<< Claims :: createCorrespondences :: inserted: ' + crr);
    }

    public static void createCostNotes(Claim__c[] cc, Map<ID, Claim__c> oldClaims) {
        Logger.debug('>> Claims :: createCostNotes :: cc: ' + cc + ' oldClaims: ' + oldClaims);
		Map<Cost_Note__c,List<Cost_Note_Line_Item__c>> insertCostNotes = ClaimCostNotes.create(cc, oldClaims);
        Logger.debug('<< Claims :: createCostNotes :: sent costnotes to queue: ' + insertCostNotes); // ' updated costnotes: ' + updateCostNotes);
    }
    
    public static void updateOpportunity(Claim__c[] cc, Map<ID, Claim__c> oldCc) {
        Logger.debug('>> Claims :: updateOpportunity :: cc: ' + cc + ' oldCc: ' + oldCc);

        cc = [
            SELECT  ID,
                    Stage__c,
                    Result__c,
                    Customer_Is_Owner__c,
                    Submission_Date_Before_Lawsuit_Date__c,
                    Submission_Date_Before_Claim_Statement__c,
                    Opportunity__r.StageName,
                    Opportunity__r.Process_Type__c,
                    Opportunity__r.Assignment_Type__c,
                    Opportunity__c
            FROM Claim__c
            WHERE ID IN :cc
        ];

        Opportunity[] oo = new Opportunity[]{};
        Correspondence__c[] crr = new Correspondence__c[]{};
        for (Claim__c c: cc) {
            if (c.stage__c != 'Finished' && c.stage__c != 'Lawsuit') {
                continue;
            }

            if (c.stage__c == 'Finished') {
                if (c.result__c == 'Declined'){
                    if (c.opportunity__r.stageName != 'Lost') {
                        c.opportunity__r.stageName = 'Lost';
                        c.opportunity__r.reason_For_Loss__c = 'Sonstige Gründe (ohne Mail)';
                        oo.add(c.opportunity__r);
                    }
                    
                    continue;
                }
                
                if (c.opportunity__r.stageName != 'Finished') {
                    c.opportunity__r.stageName = 'Finished';
                    oo.add(c.opportunity__r);
                }

                continue;
            } 

            if (c.stage__c == 'Lawsuit') {
                if (!c.customer_Is_Owner__c
                    && ((c.submission_Date_Before_Claim_Statement__c != null
                        && c.submission_Date_Before_Claim_Statement__c != oldCc.get(c.ID).submission_Date_Before_Claim_Statement__c)
                      || (c.submission_Date_Before_Lawsuit_Date__c != null
                        && c.submission_Date_Before_Lawsuit_Date__c != oldCc.get(c.ID).submission_Date_Before_Lawsuit_Date__c))) {
                    if (c.opportunity__r.assignment_Type__c == 'RSV'){
                        Correspondence__c cr = Correspondences.build(c, 'Court', 'Sonstiges', 'Draft', 'NurSchadensersatz');
                        if (cr != null) {
                            crr.add(cr);
                        }
                    } else if (c.opportunity__r.stageName != 'Lost') {
                        c.opportunity__r.stageName = 'Lost';
                        c.opportunity__r.reason_For_Loss__c = 'Kunde nicht Käufer';
                        oo.add(c.opportunity__r);
                    }
                }
            }
        }

        if (!oo.isEmpty()) {
            update oo;
        }

        if (!crr.isEmpty()) {
            insert crr;
        }
        
        Logger.debug('<< Claims :: updateOpportunity :: updated oo: ' + oo + ' inserted crr: ' + crr);
    }

    public static void autoSendMails(Claim__c[] cc, Map<ID, Claim__c> oldClaims) {
        Logger.debug('>> Claims :: autoSendMails :: cc: ' + cc + ' oldClaims: ' + oldClaims);
        ClaimMail.send(cc, oldClaims);
        Logger.debug('<< Claims :: autoSendMails');
    }
}