public class UserReferenceTriggerHandler extends BaseTriggerHandler {
    public override void afterInsert() {
        Logger.debug('>> UserReferenceTriggerHandler :: afterInsert :: userreferences: ' + Trigger.new);

        UserReferences.setUserInfo(Trigger.new, (Map<ID, User_Reference__c>)Trigger.oldMap, Trigger.isInsert);
        
        Logger.debug('<< UserReferenceTriggerHandler :: afterInsert');
    }

    public override void afterUpdate() {
        Logger.debug('>> UserReferenceTriggerHandler :: afterUpdate :: new userreferences: ' + Trigger.new + ' old userreferences: ' + Trigger.old);

        UserReferences.setUserInfo(Trigger.new, (Map<ID, User_Reference__c>)Trigger.oldMap, Trigger.isInsert);

        Logger.debug('<< UserReferenceTriggerHandler :: afterUpdate');
    }
}