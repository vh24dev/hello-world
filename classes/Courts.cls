// todo: [refactor] find a way to make this better
public class Courts {
	public static ID stuttgartAmtsgerichtID;
    public static ID stuttgartLandgerichtID;
    public static ID ingolstadtAmtsgerichtID;
    public static ID ingolstadtLandgerichtID;
    public static ID darmstadtAmtsgerichtID;
    public static ID darmstadtLandgerichtID;
    public static ID wolfsburgAmtsgerichtID;
    public static ID braunschweigLandgerichtID;
    private static final String stuttgartAmtsgericht = 'AG Stuttgart';
    private static final String stuttgartLandgericht = 'Landgericht Stuttgart';
    private static final String ingolstadtAmtsgericht = 'AG Ingolstadt';
    private static final String ingolstadtLandgericht = 'LG Ingolstadt';
    private static final String darmstadtAmtsgericht = 'AG Darmstadt';
    private static final String darmstadtLandgericht = 'LG Darmstadt';
    private static final String wolfsburgAmtsgericht = 'AG Wolfsburg';
    private static final String braunschweigLandgericht = 'Landgericht Braunschweig';
    static {
        // Saving on SOQL queries for the same transaction.
        Account[] accs = [
            SELECT ID, Name
            FROM Account
            WHERE Name = :stuttgartAmtsgericht
            	OR Name = :stuttgartLandgericht
            	OR Name = :ingolstadtAmtsgericht
            	OR Name = :ingolstadtLandgericht
            	OR Name = :darmstadtAmtsgericht
            	OR Name = :darmstadtLandgericht
            	OR Name = :wolfsburgAmtsgericht
            	OR Name = :braunschweigLandgericht
        ];
        for (Account acc : accs) {
            if (acc.name == stuttgartAmtsgericht) {
                stuttgartAmtsgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == stuttgartLandgericht) {
                stuttgartLandgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == ingolstadtAmtsgericht) {
                ingolstadtAmtsgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == ingolstadtLandgericht) {
                ingolstadtLandgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == darmstadtAmtsgericht) {
                darmstadtAmtsgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == darmstadtLandgericht) {
                darmstadtLandgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == wolfsburgAmtsgericht) {
                wolfsburgAmtsgerichtID = acc.ID;
                continue;
            }
            
            if (acc.name == braunschweigLandgericht) {
                braunschweigLandgerichtID = acc.ID;
                continue;
            }
        }
    }
    
    public static Boolean isStuttgartAmtsgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == stuttgartAmtsgerichtID;
    }
    
    public static Boolean isStuttgartLandgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == stuttgartLandgerichtID;
    }
    
    public static Boolean isIngolstadtAmtsgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ingolstadtAmtsgerichtID;
    }
    
    public static Boolean isIngolstadtLandgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ingolstadtLandgerichtID;
    }
    
    public static Boolean isDarmstadtAmtsgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == darmstadtAmtsgerichtID;
    }
    
    public static Boolean isDarmstadtLandgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == darmstadtLandgerichtID;
    }
    
    public static Boolean isWolfsburgAmtsgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == wolfsburgAmtsgerichtID;
    }
    
    public static Boolean isBraunschweigLandgericht(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == braunschweigLandgerichtID;
    }
}