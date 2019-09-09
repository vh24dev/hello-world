public class QuestionToCallcenter {
    private final Opportunity opp;
    public boolean errorRendered {get; set;}
    public string parDescription {get; set;}

    public QuestionToCallcenter(ApexPages.StandardController stdCtl) {
        errorRendered = false;
        this.opp = [
            SELECT Id, Callcenter__c, Callcenter__r.Id, Callcenter__r.isActive, Backoffice__c, Backoffice__r.isActive,
            (SELECT Id,Status,Subject,OwnerId,IsClosed FROM Tasks)
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;
        List<Task> updateTasks = new List<Task>();

        if (this.opp.Callcenter__r.Id == null) {
            errorRendered = true;
            return null;
        }

        // Create task
        Task task = Utilities.createTask('Frage des Backoffices', parDescription, this.opp, this.opp.Callcenter__r, System.today(), false, false);
        task.Type = 'Q&A';
        insert task;

        // Set tasks for backoffice on hold
        for (Task existingTask : this.opp.Tasks) {
            if ((existingTask.OwnerId == this.opp.Backoffice__c) && (existingTask.IsClosed == false)){
                existingTask.Status = 'On hold';
                updateTasks.add(existingTask);
            }
        }

        if (updateTasks.size() > 0) {
            update updateTasks;
        }

        // Return page reference
        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}