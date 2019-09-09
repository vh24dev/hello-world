public class FinAPILogger implements Log { // Logger is taken
    // todo: batch without losing timestamp
    private void log(String type, String msg) {
		FinAPI_Log__c l = new FinAPI_Log__c();
		l.type__c = type;
        l.message__c = msg;
        insert l;
        Logger.debug('inserted log: ' + l);
    }

	public void error(String msg) {
        log('err', msg);
    }
    
    public void debug(String msg) {
        log('debug', msg);
    }
}