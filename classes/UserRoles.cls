public class UserRoles {
    public static ID AccountingID; // 00E0Y000000s2mRUAQ (old)
    public static ID AdminID; // 00E0Y000000xuZ9UAI (old)
    public static ID BackofficeID; // 00E0Y000000HvlxUAC (old)
    public static ID CallcenterID; // 00E0Y000000HvlnUAC (old)
    public static ID LegalID; // 00E0Y000000Hvm7UAC (old)
    public static ID ManagementID; // 00E0Y000000HvliUAC (old)

	// TODO: fetch this info from Configuration, allowing an Admin to set the names for certain roles

    static {
        UserRole[] roles = [
            SELECT ID, DeveloperName
            FROM UserRole
            WHERE DeveloperName = 'Accounting'
			OR DeveloperName = 'Admin'
            OR DeveloperName = 'Backoffice'
            OR DeveloperName = 'Callcenter'
            OR DeveloperName = 'Legal'
            OR DeveloperName = 'Management'
        ];
        for (UserRole rol : roles) {
            if (rol.DeveloperName == 'Accounting') {
                AccountingID = rol.ID;
            } else if (rol.DeveloperName == 'Admin') {
                AdminID = rol.ID;
            } else if (rol.DeveloperName == 'Backoffice') {
                BackofficeID = rol.ID;
            } else if (rol.DeveloperName == 'Callcenter') {
                CallcenterID = rol.ID;
            } else if (rol.DeveloperName == 'Legal') {
                LegalID = rol.ID;
            } else if (rol.DeveloperName == 'Management') {
                ManagementID = rol.ID;
            }
        }
    }

    public static Boolean isAccounting(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AccountID;
    }

    public static Boolean isAdmin(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AdminID;
    }

    public static Boolean isBackoffice(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == BackofficeID;
    }

    public static Boolean isCallcenter(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == CallcenterID;
    }

    public static Boolean isLegal(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LegalID;
    }

    public static Boolean isManagement(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ManagementID;
    }

    /*
    // old
    private static id idByName(string name) {
        UserRole ur = [SELECT Id FROM UserRole WHERE DeveloperName = :name LIMIT 1];
        return ur.Id;
    }

    public static Id Accounting() {
        return idByName('Accounting');
    }

    public static Id Admin() {
        return idByName('Admin');
    }

    public static Id Backoffice() {
        return IdByName('Backoffice');
    }

    public static Id Callcenter() {
        return idByName('Callcenter');
    }

    public static Id legal() {
		return idByName('Legal');
    }

    public static Id Management() {
        return idByName('Management');
    }
	*/
}