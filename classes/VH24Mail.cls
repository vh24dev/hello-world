public class VH24Mail {
    
    private iVH24MailDelegation delegation;
    private Messaging.EmailAttachment attachment;
    private Messaging.SingleEmailMessage mail;    
    private EMailTemplate template;
    
    public void setDelegation(iVH24MailDelegation delegation) {
        this.delegation = delegation;
    }
    
    public boolean isSpecificMailEnabled() {
        return delegation.isEnabled();
    }
    
    public Messaging.SendEmailResult [] sendMail() {
        delegation.prepareMail();
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
        mail.setOrgWideEmailAddressId (
        	this.delegation.getSenderId()
        );
        mail.setFileAttachments(
			this.delegation.getAttachments()            
        );
 
        
        sendMail(new Messaging.SingleEmailMessage[] {mail});  
        return null;
    }
    
    private void sendMail (Messaging.SingleEmailMessage[] mails) {
        try{
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(mails);
            for (Messaging.SendEmailResult result : r ) {
                delegation.processResult(r);
            }
        } catch(EmailException e) {
             delegation.processError('EMAIL EXCEPTION ' + e.getMessage());            
        } catch(DmlException e) {
             delegation.processError('DML EXCEPTION ' + e.getMessage());
        } catch(Exception e) {
             delegation.processError('GENERAL EXCEPTION ' + e.getMessage());
        }
    } 
    
    /*
    private void prepareMail() {
        
    }
    
    private void prepareAttachment() {
        
    }
    
    public void processResult(Messaging.SendEmailResult [] r) {
		// not used at present
    }
    */
}