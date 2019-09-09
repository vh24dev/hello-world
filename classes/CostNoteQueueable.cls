// Legacy
public class CostNoteQueueable implements Queueable, Database.AllowsCallouts {

	public Map<Cost_Note__c,List<Cost_Note_Line_Item__c>> insertCostNotes = new Map<Cost_Note__c,List<Cost_Note_Line_Item__c>>();

	public void execute(QueueableContext context) {
		for (Cost_Note__c insertCostNote : insertCostNotes.keySet()){
			List<Cost_Note_Line_Item__c> costNoteLineItems = insertCostNotes.get(insertCostNote);
			insertCostNotes.remove(insertCostNote);

			insert insertCostNote;

			if (costNoteLineItems != null){
				for (Cost_Note_Line_Item__c costNoteLineItem : costNoteLineItems){
					costNoteLineItem.Cost_Note__c = insertCostNote.Id;
				}
				insert costNoteLineItems;
			}
			break;
		}

		if (!insertCostNotes.isEmpty() && !Test.isRunningTest()) {
			CostNoteQueueable queueable = new CostNoteQueueable();
			queueable.insertCostNotes = insertCostNotes;
			System.enqueueJob(queueable);
		}
	}
}