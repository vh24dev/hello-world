public class Leads {
    private static String vh24Company = 'VH24';
    private static String vr24Company = 'VR24';
    private static String dkRtName = 'Dieselskandal';
    private static String fzRtName = 'Finanzierung';
    private static String lvRtName = 'Lebensversicherung';
    public static ID dkRtID;
    public static ID fzRtID;
    public static ID lvRtID;

    // When "fetch" is true we query the record. Useful for "before updates", passing false as fetch.
    public static Boolean isVH24(Lead l, Boolean fetch) {
        if (l == null) {
            return false;
        }

        String v = accountTypeValue(l, fetch);
        return v != null && v == vh24Company;
    }

    public static Boolean isVH24(Lead l) {
        return isVH24(l, true);
    }
    
    public static Boolean isVR24(Lead l, Boolean fetch) {
        if (l == null) {
            return false;
        }

        String v = accountTypeValue(l, fetch);
        return v != null && v == vr24Company;
    }
    
    public static Boolean isVR24(Lead l) {
        return isVR24(l, true);
    }
    
    private static String accountTypeValue(Lead l, Boolean fetch) {
        if (l.ID == null) {
            return l.account_name__c;
        }

        if (fetch) {
            l = [SELECT Account_name__c FROM Lead WHERE ID = :l.ID];
        }
        
        return l.account_name__c;
    }

    static {
        // Use Schema.SObjectType.Lead.getRecordTypeInfosByName().get(dkRtName); instead?
        RecordType[] rts = [
            SELECT ID, DeveloperName
            FROM RecordType
            WHERE (DeveloperName = :dkRtName
                OR DeveloperName = :fzRtName
                OR DeveloperName = :lvRtName)
                AND SObjectType = 'Lead'
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

    public static Boolean isDieselSkandal(ID leadRecordTypeID) {
        if (leadRecordTypeID == null) {
            return false;
        }
        return leadRecordTypeID == dkRtID;
    }
    
    public static Boolean isFinanzierung(ID leadRecordTypeID) {
        if (leadRecordTypeID == null) {
            return false;
        }
        return leadRecordTypeID == fzRtID;
    }
    
    public static Boolean isLebensversicherung(ID leadRecordTypeID) {
        if (leadRecordTypeID == null) {
            return false;
        }
        return leadRecordTypeID == lvRtID;
    }    
}