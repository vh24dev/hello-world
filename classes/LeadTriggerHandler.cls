public class LeadTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
        Lead[] ll = Trigger.new;
        Logger.debug('>> LeadTriggerHandler :: beforeInsert :: leads: ' + ll);
        
        new LeadReference().setOn(ll, Trigger.isBefore && Trigger.isUpdate);
        setUniqueID(ll);
        
        Logger.debug('<< LeadTriggerHandler :: beforeInsert');
    }
    
    public override void afterInsert() {
        Lead[] ll = Trigger.new;
        Logger.debug('>> LeadTriggerHandler :: afterInsert :: leads: ' + ll);
        for (Lead l : ll) {
            AutoconvertLead.convert(l);
        }
        Logger.debug('<< LeadTriggerHandler :: afterInsert');
    }
    
    public override void beforeUpdate() {
        Lead[] ll = Trigger.new;
        Logger.debug('>> LeadTriggerHandler :: beforeUpdate :: leads: ' + ll);
        
        new LeadReference().setOn(ll, Trigger.isBefore && Trigger.isUpdate);

        Logger.debug('<< LeadTriggerHandler :: beforeUpdate');
    }
    
    public override void afterUpdate() {
        Lead[] ll = Trigger.new;
        Logger.debug('>> LeadTriggerHandler :: afterUpdate :: leads: ' + ll);
        for (Lead l : ll) {
            AutoconvertLead.convert(l);
        }
        Logger.debug('<< LeadTriggerHandler :: afterUpdate');
    }
    
    private void setUniqueID(Lead[] ll) {
        for (Lead l: ll) {
            if (l.Token__c != null) {
                continue;
            }
            l.Token__c = GUID.Gen();
        }
    }
}