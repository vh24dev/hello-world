public interface iVH24MailDelegation {
    string getSubject();
	EMailTemplate getMailTemplate();
    string getRecipientAddress(); 
    Id getSenderId();
    list<string> getAddresses();
    string getPlainTextBody();
    Messaging.EmailFileAttachment[] getAttachments(); 
    string getHtmlBody();
    boolean isEnabled();
}