public class CorrespondenceTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Logger.debug('>> CorrespondenceTriggerHandler :: beforeInsert :: correspondences: ' + Trigger.new);

        Correspondences.setTerm(Trigger.new, (Map<ID, Correspondence__c>)Trigger.oldMap, Trigger.isUpdate);
        
        Logger.debug('<< CorrespondenceTriggerHandler :: beforeInsert');
    }

    public override void afterInsert() {
        Logger.debug('>> CorrespondenceTriggerHandler :: afterInsert :: new correspondences: ' + Trigger.new + ' old correspondences: ' + Trigger.old);

        Correspondences.manageTextModules(Trigger.new);
		Correspondences.autoCreateDocuments(Trigger.newMap.keySet());
        CorrespondencesTasks.create(Trigger.new);
        CorrespondencesTasks.close(Trigger.new);

        Logger.debug('<< CorrespondenceTriggerHandler :: afterInsert');
    }
    
    public override void beforeUpdate() {
        Logger.debug('>> CorrespondenceTriggerHandler :: beforeUpdate :: new correspondences: ' + Trigger.new + ' old correspondences: ' + Trigger.old);

        Correspondences.setTerm(Trigger.new, (Map<ID, Correspondence__c>)Trigger.oldMap, Trigger.isUpdate);
    
        Logger.debug('<< CorrespondenceTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Logger.debug('>> CorrespondenceTriggerHandler :: afterUpdate :: new correspondences: ' + Trigger.new + ' old correspondences: ' + Trigger.old);

        Correspondences.createCorrespondence(Trigger.new);
        Correspondences.manageTextModules(Trigger.new);
        Correspondences.autoSendMails(Trigger.new, (Map<ID, Correspondence__c>)Trigger.oldMap);
        CorrespondencesTasks.create(Trigger.new);
        CorrespondencesTasks.close(Trigger.new);
        
        Logger.debug('<< CorrespondenceTriggerHandler :: afterUpdate');
    }
}