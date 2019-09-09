public class Documents {
    private static String dkRtName = 'Dieselskandal'; // 0120Y000000W0t2QAC (old)
    private static String fzRtName = 'Finanzierung'; // 0120Y000000KnMMQA0 (old)
    private static String lvRtName = 'Lebensversicherung'; // 0120Y000000W0sxQAC (old)
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
                AND SObjectType = 'Document__c'
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
}