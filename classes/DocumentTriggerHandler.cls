public class DocumentTriggerHandler extends BaseTriggerHandler {
    @testVisible
    private static Boolean deactivate = false;

    public override void beforeInsert() {
        Logger.debug('>> DocumentTriggerHandler :: beforeInsert :: documents: ' + Trigger.new);
        DocumentAction.setRecordType(Trigger.new);
        Logger.debug('<< DocumentTriggerHandler :: beforeInsert');
    }

    public override void afterInsert() {
        Logger.debug('>> DocumentTriggerHandler :: afterInsert :: documents: ' + Trigger.new);
        DocumentAction.createTasks(Trigger.new);
        DocumentAction.deactivateFollowUpJourneys(Trigger.new);
        Logger.debug('<< DocumentTriggerHandler :: afterInsert');
    }

    public override void beforeUpdate() {
        Logger.debug('>> DocumentTriggerHandler :: beforeUpdate :: new documents: ' + Trigger.new + ' old documents: ' + Trigger.old);
        DocumentAction.setRecordType(Trigger.new);
        Logger.debug('<< DocumentTriggerHandler :: beforeUpdate');
    }

    public override void afterUpdate() {
        // Logger.debug('>> DocumentTriggerHandler :: afterUpdate :: new documents: ' + Trigger.new + ' old documents: ' + Trigger.old);

        // Logger.debug('<< DocumentTriggerHandler :: afterUpdate');
    }

    protected override Boolean preventFromRunning() { return deactivate; }
}