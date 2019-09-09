// Opportunity "Übergabe zu MFK" Button
public class OppCreateTestCase {
    private final Opportunity opp;

    public OppCreateTestCase(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        Savepoint sp = Database.setSavepoint();
        this.opp.MFK__c = true;
        update this.opp;
        if (this.opp.StageName != 'Claim') {
            this.opp.StageName = 'Claim';
            string err = ValidationCatch.updateObj(this.opp, sp);
            if (err != '') {
                return Errors.page(err);
            }
        }
        Test_Case__c testCase = new Test_Case__c(
            Opportunity__c = this.opp.Id
        );
        insert testCase;
        return new PageReference('/' + this.opp.Id);
    }
}