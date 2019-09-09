public class StartPhoneCall {
    private SObject parentObject;
	private Schema.SObjectType parentObjectType;
    public boolean errorNoPhone {get; set;}

    public StartPhoneCall(ApexPages.StandardController stdCtl) {
        parentObject = stdCtl.getRecord();
        parentObjectType = parentObject.getSObjectType();
        errorNoPhone = false;
    }

	public PageReference renderPage() {
        PageReference red;
        string phoneNo = '';
        if (parentObjectType == Schema.SObjectType.Opportunity.getSObjectType()){
            Opportunity opportunity = [SELECT Id, Phone__c FROM Opportunity WHERE Id = :parentObject.Id];
            phoneNo = opportunity.Phone__c;
        } else if (parentObjectType == Schema.SObjectType.Lead.getSObjectType()){
            Lead lead = [SELECT Id, Phone FROM Lead WHERE Id = :parentObject.Id];
            phoneNo = lead.Phone;
        } else {
            System.debug('WARNING unsupported object type');
        }

        if (phoneNo == '' || phoneNo == null) {
            errorNoPhone = true;
            return null;
        }

        red = new PageReference('callto:' + phoneNo);
        red.setRedirect(true);
        return red;
    }

}