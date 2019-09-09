// Invoice__c "Nächste Rechnung aufrufen" List Button
public class PickInvoice {
	private final List<Invoice__c> invs;
    private final List<SObject> objects;
    public PickInvoice(ApexPages.StandardSetController stdSetController) {
        objects = stdSetController.getRecords().clone();
        invs = [
            SELECT Id, CreatedDate
            FROM Invoice__c
            WHERE Id IN :objects ORDER BY CreatedDate ASC NULLS LAST LIMIT 1
		];
    }

    public PageReference renderPage() {
		PageReference pageRef;
        Invoice__c oldestInvoice;
        for (Invoice__c invoice : this.invs) {
	        oldestInvoice = invoice;
        }

        if (oldestInvoice != null) {
            if ((UserRoles.isManagement(UserInfo.getUserRoleId())) || // 00E0Y000000Hvli
                (UserRoles.isAdmin(UserInfo.getUserRoleId())) || // 00E0Y000000xuZ9
                (UserRoles.isAccounting(UserInfo.getUserRoleId()))) { // 00E0Y000000s2mR
            oldestInvoice.Accounting__c = UserInfo.getUserId();
                update oldestInvoice;
                pageRef = new PageReference('/' + oldestInvoice.Id);
            } else {
	            pageRef = Page.WrongUserRole;
            }
        } else {
            pageRef = Page.NothingToPick;
        }

        pageRef.setRedirect(true);
        return pageRef;
    }
}