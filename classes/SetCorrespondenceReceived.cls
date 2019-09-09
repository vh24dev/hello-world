public class SetCorrespondenceReceived {
    private final Correspondence__c corr;

    public SetCorrespondenceReceived(ApexPages.StandardController stdCtl) {
        this.corr = [
            SELECT Id, Stage__c
            FROM Correspondence__c
            WHERE ID = :stdCtl.getId()
        ];
    }

    public pageReference renderPage() {
        PageReference pageRef;
        if (this.corr.Stage__c != 'Received') {
            this.corr.Stage__c = 'Received';
            update this.corr;
        }

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}