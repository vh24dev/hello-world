public interface  iVH24MailTemplateDelegation {    
    string getSubject();
    Id getSenderId();
    string getHtmlBody();
    string getPlainTextBody();
    list<string> getAddresses();
}