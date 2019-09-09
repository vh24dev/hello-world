public class Accounts {
    public static ID VH24ID; // 0010Y00000eCUS9 (old)
    public static ID VR24ID; // 0010Y00000EjR2X (old)
    public static ID JCLegalID; // 0010Y000011MYHW (old)
    public static ID JCLegalLvID; // 0010Y000010BXGZ (old)
    public static ID Legal21ID;  // 0010Y000013yLnP (old)
    public static ID CLLBLegalID; // 0010Y000010COcm (old)
    public static ID LegalLachmairID; // 0010Y000010BXEO (old)
    public static ID LegalVortmannID; // 0010Y000011MXtK (old)
    public static ID LeComLegalID; // new account

    static {
        System.debug('static account init');
        // Saving on SOQL queries for the same transaction.
        Account[] accs = [
            SELECT ID, Name, Department__c
            FROM Account
            WHERE Name = 'VH24'
                OR Name = 'VR24'
                OR Name = 'J & C Anwälte'
                OR Name = '21Legal GmbH'
                OR Name = 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'
                OR Name = 'Rechtsanwälte Lachmair & Kollegen'
                OR Name = 'Rechtsanwaltskanzlei Dr. Vortmann & Kollegen'
            	OR Name = 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'
        ];
        for (Account acc : accs) {
            if (acc.name == 'VH24') {
                VH24ID = acc.ID;
            } else if (acc.name == 'VR24') {
                VR24ID = acc.ID;
            } else if (acc.name == 'J & C Anwälte' && acc.Department__c == 'Heinrich Jäger - DG & FZ') {
                JCLegalID = acc.ID;
            } else if (acc.name == 'J & C Anwälte' && acc.Department__c == 'Heinrich Jäger - LV') {
                JCLegalLvID = acc.ID;
            } else if (acc.name == '21Legal GmbH'){
                Legal21ID = acc.ID;
            } else if (acc.name == 'CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'){
                CLLBLegalID = acc.ID;
            } else if (acc.name == 'Rechtsanwälte Lachmair & Kollegen') {
                LegalLachmairID = acc.ID;
            } else if (acc.name == 'Rechtsanwaltskanzlei Dr. Vortmann & Kollegen') {
                LegalVortmannID = acc.ID;
            } else if (acc.name == 'LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH') {
                LeComLegalID = acc.ID;
            }
        }
    }

    public static Boolean isVH24(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == VH24ID;
    }

    public static Boolean isVR24(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == VR24ID;
    }

    public static Boolean isJCLegal(ID accountID) {
        if (accountID == null) {
            return false;
        }
        System.debug('isJCLegal accountID: ' + accountID + ' JCLegaID: ' + JCLegalID);
        return accountID == JCLegalID;
    }

    public static Boolean isJCLegalLv(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == JCLegalLvID;
    }

    public static Boolean isLegal21(ID accountID) {
        if (accountID == null){
            return false;
        }
        return accountID == Legal21ID;
    }

    public static Boolean isCLLBLegal(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == CLLBLegalID;
    }

    public static Boolean isLegalLachmair(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LegalLachmairID;
    }

    public static Boolean isLegalVortmann(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LegalVortmannID;
    }

    public static Boolean isLegalLeCom(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LeComLegalID;
    }
}