// Opportunity "AGB/Dokumentenerhalt prüfen" Button
public class IncreaseFollowUpCountDoc {
    private final Opportunity opp;

    public IncreaseFollowUpCountDoc(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT ID,
            Follow_up_Variant__c,
            Follow_up_Count__c,
            Confirmed_Terms_And_Conditions__c,
            Callcenter__c,
            Callcenter__r.isActive,
            StageName,
            RecordTypeId,
            (SELECT ID, Status, Subject FROM Tasks)
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public void CreateTask() {
        if (this.opp.StageName == 'Claim') {
            return;
        }
        if (!Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
			return;
        }
        if (this.opp.Callcenter__c == null) {
            return;
        }
        if (this.opp.Confirmed_Terms_And_Conditions__c != false) {
            return;
        }

        Task[] ts = Tasks.markAsClosed('AGB/Dokumentenerhalt prüfen #', this.opp);
        if (ts.size() > 0) {
            update ts;
        }
        Task t = Tasks.build(
            'AGB/Dokumentenerhalt prüfen #' + this.opp.Follow_up_Count__c, // subject
            null, // description
            this.opp, // parentObj
            this.opp.Callcenter__r, // owner
            Date.today() + 5, // due date
            true, // noDuplicates
            this.opp.Follow_up_Count__c > 0, // isFollowUpTask
            this.opp.ID
        );
        if (t != null) {
            insert t;
        }
    }

    public PageReference renderPage() {
        if ((opp.Follow_up_Variant__c == null) || ('2' != opp.Follow_up_Variant__c)) {
            opp.Follow_up_Variant__c = '2';
            opp.Follow_up_Count__c = 1;
        } else {
            opp.Follow_up_Count__c++;
        }

        CreateTask();

        // AGB/Follow-up
        opp.Follow_up_Period__c = 5;
        update opp;

        return new PageReference('/' + this.opp.Id);
    }
}