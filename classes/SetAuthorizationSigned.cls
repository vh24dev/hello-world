// Authorization__c "Unterschrift erhalten" Button
// Vollmacht "Unterschrift erhalten" Button
public class SetAuthorizationSigned {
    private final Authorization__c auth;

    public SetAuthorizationSigned(ApexPages.Standardcontroller stdCtl) {
        this.auth = [
            SELECT Id,
            Stage__c,
            (SELECT Id, Status, Subject, IsClosed FROM Tasks) 
            FROM Authorization__c
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;

        if (this.auth.Stage__c != 'Signed'){
            this.auth.Stage__c = 'Signed';
            update this.auth;
        }
        List<Task> updateTasks = Tasks.markAsClosed('Unterschriebene Vollmacht hochladen und Erhalt bestätigen', this.auth);
        if (updateTasks.size() > 0) {
            update updateTasks;
        }

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}