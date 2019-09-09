// Opportunity "an Extern übergeben" Button
// old name "Zu extern synchronisieren"
public class OppSyncToLegal {
    private final Opportunity opp;
    public string legal {get; set;}

    public OppSyncToLegal(ApexPages.StandardController stdCtl) {
		this.opp = [
            SELECT Id, Legal__c, RecordTypeId, Account_Id__c
            FROM Opportunity
            WHERE Id = :stdCtl.getId()
        ];
    }

    public List<SelectOption> getLegals() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Lachmair', 'Lachmair'));
        // options.add(new SelectOption('Declined', 'Abgelehnt'));
        return options;
    }

    public PageReference renderPage() {
		PageReference pageRef;
        // removed from list:
        // 0050Y000000KLqXQAW User cloudworx
        Set<Id> userIds = new Set<Id> {
            Users.CarmenHornung(), // 0050Y000002lYiV User Carmen Hornung
            Users.LachmairLegal() // 0050Y000002Fq9M
		};
        System.debug('current user\'s Id: ' + UserInfo.getUserId());
        if((this.opp.Legal__c == Users.LachmairLegal()) && (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) && (userIds.contains(UserInfo.getUserId()))) {
            String clientId = 'verbraucherhilfe24';
            if (Accounts.isVR24(this.opp.Account_Id__c)) { // 0010Y00000EjR2X
                clientId = 'verbraucherrechte24';
            }
            // TODO:
            Boolean success = false;
            // success = SyncUtilities.mapObjects(parentObject.Id, clientId);
            if (success == false) {
                // pageRef = Page.ErrorWithSyncTo21legal;
                pageRef = Errors.Page('Failed to sync'); // TODO
                pageRef.setRedirect(true);
                return pageRef;
            }
        }
		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}