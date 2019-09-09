public class ValidationCatch {
    public static string insertObj(sObject o) {
        Savepoint sp = Database.setSavepoint();
        return insertObj(o, sp);
    }
    public static string updateObj(sObject o) {
        Savepoint sp = Database.setSavepoint();
        return updateObj(o, sp);
    }
    public static string insertObj(sObject o, Savepoint sp) {
        try {
            insert o;
        } catch (DmlException e) {
            Database.rollback(sp);
            return e.getDmlMessage(0);
        }
        return '';
    }
    public static string updateObj(sObject o, Savepoint sp) {
        try {
            update o;
        } catch (DmlException e) {
            Database.rollback(sp);
            return e.getDmlMessage(0);
        }
        return '';
    }
}