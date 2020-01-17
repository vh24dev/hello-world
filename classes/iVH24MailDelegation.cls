public interface iVH24MailDelegation {
    string getSubject();
	EMailTemplate getMailTemplate();
    Id getSenderId();
    list<string> getAddresses();
    string getPlainTextBody();
    Messaging.EmailFileAttachment[] getAttachments(); 
    string getHtmlBody();
    boolean isEnabled();
    void processResult(Messaging.SendEmailResult [] r);
    void processError(String message);
    void prepareMail();
}