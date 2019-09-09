public class TestCaseTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> TestCaseTriggerHandler :: beforeInsert :: testcases: ' + Trigger.new);

        TestCases.setHash(Trigger.new);
        TestCases.autoStartAutoFollowUp(Trigger.new);
        setUniqueID(Trigger.new);
        
        Logger.debug('<< TestCaseTriggerHandler :: beforeInsert');
    }

    public override void afterInsert() {
        Logger.debug('>> TestCaseTriggerHandler :: afterInsert :: new testcases: ' + Trigger.new + ' old testcases: ' + Trigger.old);

        TestCases.autoSendMails(Trigger.new, (Map<ID, Test_Case__c>)Trigger.oldMap, Trigger.isInsert);
        TestCases.autoCreateDocuments(Trigger.newMap.keySet());

        Logger.debug('<< TestCaseTriggerHandler :: afterInsert');
    }
    
    public override void beforeUpdate() {
        Logger.debug('>> TestCaseTriggerHandler :: beforeUpdate :: testcases: ' + Trigger.new);

        TestCases.setHash(Trigger.new);
		TestCases.autoStartAutoFollowUp(Trigger.new);
        
        Logger.debug('<< TestCaseTriggerHandler :: beforeUpdate');
    }

    public override void afterUpdate() {
        Logger.debug('>> TestCaseTriggerHandler :: afterUpdate :: new testcases: ' + Trigger.new + ' old testcases: ' + Trigger.old);
		if(!Test.isRunningTest())//System.EmailException: SendEmail failed. First exception on row 0; first error: SINGLE_EMAIL_LIMIT_EXCEEDED, Email limit exceeded: []
       	   TestCases.autoSendMails(Trigger.new, (Map<ID, Test_Case__c>)Trigger.oldMap, Trigger.isInsert);

        Logger.debug('<< TestCaseTriggerHandler :: afterUpdate');
    }

    private void setUniqueID(Test_Case__c[] tt) {
        for (Test_Case__c t : tt) {
            if (t.Token__c != null) {
                continue;
            }
            t.Token__c = GUID.Gen();
        }
    }
}