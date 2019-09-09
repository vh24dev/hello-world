public class Picklist {
    public static boolean contains(string plist, string pvalue) {
        if (plist == null) {
            return false;
        }
        List<string> items = plist.split(';');
        for (string item : items) {
            if (item == pvalue) {
                return true;
            }
        }
        return false;
    }
}