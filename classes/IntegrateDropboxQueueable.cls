public class IntegrateDropboxQueueable implements Queueable, Database.AllowsCallouts {
	
	public List<List<String>> dropboxVariables = new List<List<String>>();

	public void execute(QueueableContext context) {
		Utilities.getConfiguration();

		for (List<String> dropboxVariable : dropboxVariables) {
			// variable[0] == path
			// variable[1] == attachmentId
			// variable[2] == accountId
			IntegrateDropbox.uploadFileToDropbox(dropboxVariable[0], dropboxVariable[1], dropboxVariable[2]);
		}

		dropboxVariables.remove(0);

		if ((dropboxVariables.isEmpty() == false)  && (Test.isRunningTest() == false) && (Utilities.disableQueueableChaining == false)){
			IntegrateDropboxQueueable queueable = new IntegrateDropboxQueueable();
			queueable.dropboxVariables = dropboxVariables;
			System.enqueueJob(queueable);
		}
	}
}