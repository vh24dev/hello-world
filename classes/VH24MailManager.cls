public class VH24MailManager {
    
    String eventName;
    VH24Mail executor;
    VH24MailData  data;
    
    public VH24MailManager(VH24MailData data) {
        this.data = data;
        this.eventName = data.mailType;
        executor = new VH24Mail();
        iVH24MailDelegation delegation = buildDelegation();
        executor.setDelegation(delegation);
    }

    // constructor for testing purposes
    public VH24MailManager(VH24Mail mockExecutor,iVH24MailDelegation delegation) {
        executor = mockExecutor;
        executor.setDelegation(delegation);
    } 
    
    public void execute() {
        executor.sendMail();
    }
    
    @TestVisible
    private iVH24MailDelegation buildDelegation( ) {
        switch on eventName {
   			when 'LVAGBLeadConversion' {
       			return new LVSendAGBDelegation(this.data);
   			}
   			when 'MandateAsMail' {
       			return new MandateAsMailDelegation(this.data);
   			}
   			when else {
       			System.debug('Event not registered!');
                return null;
   			}
		}
    }  
}