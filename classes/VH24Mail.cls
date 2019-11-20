public class VH24Mail {
    
    private iVH24MailDelegation delegation;
    private Messaging.EmailAttachment attachment;
    private Messaging.SingleEmailMessage mail;    
    private EMailTemplate template;
    
    public void setDelegation(iVH24MailDelegation delegation) {
        this.delegation = delegation;
    }
    
    public boolean isSpecificMailEnabled(){
        return delegation.isEnabled();
    }
    
    public Messaging.SendEmailResult [] sendMail() {
        mail = new Messaging.SingleEmailMessage();
        mail.setSubject(
           delegation.getSubject()             
        );
        mail.setToAddresses(
            delegation.getAddresses()
        );
		mail.setPlainTextBody(
            delegation.getPlainTextBody()
        );
        mail.setHtmlBody(
            delegation.getHtmlBody()
            
        );
        mail.setFileAttachments(
			this.delegation.getAttachments()            
        );
        mail.setOrgWideEmailAddressId (
        	this.delegation.getSenderId()
        );
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});  
        return r;
    }
    
}