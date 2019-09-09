public class DefaultLogger implements Log {
    // todo: "Logger" class to be removed
	public void error(String msg) {
        Logger.error(msg);
    }
    
    public void debug(String msg) {
        Logger.debug(msg);
    }
}