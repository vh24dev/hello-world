// Think of creating our own logging records, to overcome the 5MB limit.
// We would lose the different perspectives, though.
public class Logger {
    public static void error(String msg) {
        System.debug(System.LoggingLevel.ERROR, msg);
    }
    
    public static void debug(String msg) {
        System.debug(System.LoggingLevel.DEBUG, msg);
    }
}