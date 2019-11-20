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
     	processConvertedLeads(ll);
    }
    
    private void processConvertedLeads(Lead[] leads) {
        List<Id> convertedContactIds = new List<Id>();
        for(Lead lead:leads){
        	if(lead.IsConverted && isLVLead(lead)){
            	convertedContactIds.add(lead.ConvertedContactId);
            }
        }
        LVAGBMailManager.sendAGBMail(convertedContactIds);
    }
    
    private boolean isLVLead(Lead lead){
        RecordType rtlv = [SELECT Id FROM RecordType WHERE DeveloperName = 'Lebensversicherung' AND sObjectType = 'Lead' LIMIT 1].get(0);
        return rtlv.Id == lead.RecordTypeId;
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