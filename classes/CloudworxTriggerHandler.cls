public class CloudworxTriggerHandler extends BaseTriggerHandler {
    @testVisible
    private static Boolean deactivate = false;

    public override void beforeInsert() {
        Logger.debug('>> CloudworxTriggerHandler :: beforeInsert :: docs: ' + Trigger.new);
        cloudworx_document_template__c[] cc = Trigger.new;
        CloudworxDocuments.setDeveloperName(cc);
        Logger.debug('<< CloudworxTriggerHandler :: beforeInsert');
    }

    protected override Boolean preventFromRunning() { return deactivate; }
}