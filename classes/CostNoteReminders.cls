public class CostNoteReminders {
    @future (callout=true)
    public static void autoCreateDocuments(Set<Id> ids) {
        Logger.debug('>> CostNoteReminders :: autoCreateDocuments :: cnrr: ' + ids);
        List<Cost_Note_Reminder__c> costNoteReminders = [select Id, Stage__c from Cost_Note_Reminder__c where Id in :ids];

		for (Cost_Note_Reminder__c costNoteReminder : costNoteReminders){
			if (costNoteReminder.Stage__c == 'Draft') {
				DocumentCreationAction.autoCreateDocument(costNoteReminder.Id,false,'pdf',null,null);
			}
		}
        
        Logger.debug('<< CostNoteReminders :: autoCreateDocuments');
	}
    
    // Legacy code
	public static void setNumber(List<Cost_Note_Reminder__c> cnrr) {
        Logger.debug('>> CostNoteReminders :: setNumber :: cnrr: ' + cnrr);
        
		List<Cost_Note_Reminder__c> oldDgCostNoteReminders = [select Number__c from Cost_Note_Reminder__c where Cost_Note__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%RDG' ORDER BY Number__c DESC NULLS LAST LIMIT 1];
		List<Cost_Note_Reminder__c> oldVhCostNoteReminders = [select Number__c from Cost_Note_Reminder__c where Cost_Note__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE '%RVH' ORDER BY Number__c DESC NULLS LAST LIMIT 1];

		Set<Id> costNoteIds = new Set<Id>();
		for (Cost_Note_Reminder__c cnr : cnrr){
			costNoteIds.add(cnr.Cost_Note__c);
		}

		Map<Id,Cost_Note__c> costNotes = new Map<Id,Cost_Note__c>([select Id, Test__c, Claim__r.Opportunity__r.Account_Id__c from Cost_Note__c where Id IN :costNoteIds]);

		Integer oldDgCostNoteRemindersCount = 0;
		Integer oldVhCostNoteRemindersCount = 0;
		if (oldDgCostNoteReminders.Size() > 0){
			oldDgCostNoteRemindersCount = Integer.valueOf(oldDgCostNoteReminders[0].Number__c.substring(4,10));
		}
		if (oldVhCostNoteReminders.Size() > 0){
			oldVhCostNoteRemindersCount = Integer.valueOf(oldVhCostNoteReminders[0].Number__c.substring(4,10));
		}

		Integer i = 0;
		for (Cost_Note_Reminder__c costNoteReminder : cnrr){
            if (costNoteReminder.Number__c != null) { continue; }
			
            Cost_Note__c costNote = costNotes.get(costNoteReminder.Cost_Note__c);
            if (costNote.Test__c == false){
                i++;
            }
            
            Integer dgCount = oldDgCostNoteRemindersCount + i;
            Integer vhCount = oldVhCostNoteRemindersCount + i;
            String year = System.now().date().year().format().replace('.','');
            
            if (costNote.Test__c == true){
                costNoteReminder.Number__c = year + dgCount.format().replace('.','').leftPad(6,'0') + '/Test';
            } else if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                costNoteReminder.Number__c = year + vhCount.format().replace('.','').leftPad(6,'0') + '/RVH';
            } else {
                costNoteReminder.Number__c = year + dgCount.format().replace('.','').leftPad(6,'0') + '/RDG';
            }
		}
        
        Logger.debug('<< CostNoteReminders :: setNumber');
	}
}