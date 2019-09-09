public class TriggerLeadPhoneCallExtension {
    private final String phoneNr;
	public TriggerLeadPhoneCallExtension(ApexPages.StandardController stdCtl) {
        String lID = stdCtl.getId();
        Lead l = [SELECT Phone FROM Lead WHERE ID = :lID];
		this.phoneNr = l.phone;
    }
    
    public PageReference triggerPhoneCall() {
        if (String.isBlank(this.phoneNr)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Dieser Anruf kann nicht gestartet werden. Bitte tragen sie zuerst eine gültige Telefonnumer auf dem Lead ein.'));
            return null;
        }
        
        PageReference pr = new PageReference('callto:' + this.phoneNr);
        pr.setRedirect(true);
        return pr;
    }
}