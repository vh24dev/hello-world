// Opportunity "Automatisches Follow-up starten" Button
// Anfrage "Automatisches Follow-up starten" Button
public class OppStartAutoFollowUp {
    private final Opportunity opp;

    public OppStartAutoFollowUp(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id,
            RecordTypeId,
            StageName,
            Callcenter__c,
            Callcenter__r.isActive,
            Backoffice__c,
            Backoffice__r.isActive,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        if (!opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
            return Errors.page('Bitte verwenden Sie eine Anfrage mit dem RecordType Lebensversicherung');
        }
        if (this.opp.Callcenter__r.Id == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt im Feld "Callcenter".');
        }
        List<Task> insertTasks = new List<Task>();
        List<Task> updateTasks = new List<Task>();

        if (this.opp.StageName == 'New'|| this.opp.StageName == 'Check' || this.opp.StageName == 'On Hold'){
            this.opp.Auto_Follow_up_Date__c = System.now();
            this.opp.Auto_Follow_up_Count__c = 0;
            this.opp.Started_Auto_Follow_up_Journey_6__c = true;
            Task task = Tasks.build('Auto Follow-up', null, this.opp, this.opp.Callcenter__r, System.today() + 46, false, false, this.opp.ID);
            if (task != null){
                insertTasks.add(task);
            }
        } else if (this.opp.StageName == 'Check'){
            this.opp.Auto_Follow_up_Date__c = System.now();
            this.opp.Auto_Follow_up_Count__c = 0;
            this.opp.Started_Auto_Follow_up_Journey_7__c = true;
            Task task = Tasks.build('Weitere Unterlagen werden nachgereicht', null, this.opp, this.opp.Backoffice__r, System.today() + 46, false, false, this.opp.ID);
            if (task != null) {
                insertTasks.add(task);
            }
        }

        updateTasks.addAll(Tasks.markAsClosed('', this.opp));
        update this.opp;

        if (!insertTasks.isEmpty()){
            insert insertTasks;
        }

        if (!updateTasks.isEmpty()){
            update updateTasks;
        }

        PageReference pageRef;
        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
		return pageRef;
    }
}