// DateTriggerHandler ( TerminTriggerHandler )
public class TerminTriggerHandler extends BaseTriggerHandler {
    @testVisible
    private static Boolean deactivate = false;

    public override void beforeInsert() {
        Logger.debug('>> TerminTriggerHandler :: beforeInsert :: termins: ' + Trigger.new);

        Date__c[] tt = Trigger.new;
        setUniqueID(tt);

        Logger.debug('<< TerminTriggerHandler :: beforeInsert');
    }

    protected override Boolean preventFromRunning() { return deactivate; }

    private void setUniqueID(Date__c[] tt) {
        for (Date__c t : tt) {
            if (t.Token__c != null) {
                continue;
            }
            t.Token__c = GUID.Gen();
        }
    }
}