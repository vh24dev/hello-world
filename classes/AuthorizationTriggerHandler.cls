public class AuthorizationTriggerHandler  extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> AuthorizationTriggerHandler :: beforeInsert :: Authorizations: ' + Trigger.new);
        Authorizations.setRecordType(Trigger.new);
        Logger.debug('<< AuthorizationTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Logger.debug('>> AuthorizationTriggerHandler :: afterInsert :: Authorizations: ' + Trigger.new);
        Authorizations.autoCreateDocuments(Trigger.newMap.keySet());
        Logger.debug('<< AuthorizationTriggerHandler :: afterInsert');
    }
}