public class LVSendAGBDelegation implements iVH24MailDelegation {
    
    private EmailTemplate template;
    private Id templateId;
    private EMailMapping__mdt  eMailMapping;
    private Attachment attachment;
    private Messaging.EmailFileAttachment fileAttachment;
    private Contact contact;
    private string body;
    private string htmlBody;
    private Id parentId;
    private Id UserId;
    private Id senderAdressId;
    private string subject;
    
    public LVSendAGBDelegation(Contact contact) {
        this.contact = contact;
        this.userId = Users.vh24Lv();
        this.eMailMapping = fetchConfig();
        this.template = fetchTemplate();
        this.attachment = fetchAndMapAttachment();
        fileAttachment = mapToFile();
        buildBody();
        buildHtmlBody();
        getSenderAdress();
        this.subject = buildSubject();
    }
    
    public string getPlainTextBody(){
        return body;
    }
    
    public string getHtmlBody(){
		return htmlBody;
    }
    
    public list<string> getAddresses() {
    	return new list<string> {contact.EMail};
    }
    
    public string getSubject(){
    	return this.subject;    
    }

    public Messaging.EmailFileAttachment[] getAttachments() {
        return new Messaging.EmailFileAttachment[]{this.fileAttachment};
    } 
    
    public EMailTemplate getMailTemplate() {
        return this.template;
    }
    
    public Id getSenderId() {
        return senderAdressId;
    }
    
    public string getRecipientAddress() {
        return contact.Email;
    }
    
    public boolean isEnabled(){
        return eMailMapping.isEnabled__c;
    }
    
    private EMailMapping__mdt fetchConfig(){
       return [Select Attachment__c, 
                              Template__c, 
                              UniqueName__c,
               				  IsEnabled__C
                              FROM  EMailMapping__mdt 
                              WHERE UniqueName__c = 'LVLeadOppConversion' LIMIT 1];
    }
    
    private EmailTemplate fetchTemplate(){
        return [SELECT Id,
                         Subject,
                         Body,
                         Name,
                         HtmlValue 
                         FROM EmailTemplate 
                         WHERE DeveloperName =: eMailMapping.Template__c];
        
    } 
    
    private Attachment fetchAndMapAttachment(){
     		 return [select Id,
                                Name,
                                Body,
                                BodyLength FROM Attachment where ParentId =: this.template.id LIMIT 1];            
    }
      
    private Messaging.Emailfileattachment mapToFile() {
          this.fileAttachment = new Messaging.Emailfileattachment();
          this.fileAttachment.setFileName(this.attachment.Name);
          this.fileAttachment.setBody(this.attachment.Body);
        	return this.fileAttachment;
          //attachmentSize += attachment.BodyLength;
    }
    
    private void buildBody() {
         Id recipientId = contact.Id;
         Id parentId = template.Id;
         body = Utilities.mergeText(template.Body, new Map<Id, String>{
             		parentId => parentId.getSObjectType().getDescribe().Name, 
             		recipientId => recipientId.getSObjectType().getDescribe().Name, 
                	userId => 'User'});
    }
    
    private void buildHtmlBody() {
        Id recipientId = contact.Id;
        Id parentId = template.Id;
        this.htmlBody = template.HtmlValue.replace('{text_body}',body.replace('\n','<br/>'));
        this.htmlBody = Utilities.mergeText(this.htmlBody,new Map<Id,String>{
            parentId => parentId.getSObjectType().getDescribe().Name,
            recipientId => recipientId.getSObjectType().getDescribe().Name,
            userId => 'User'
    	});
    }
    
    private string buildSubject(){
        Id recipientId = contact.Id;
        Id parentId = template.Id;
    	return Utilities.mergeText(template.Subject,new Map<Id,String>{parentId => parentId.getSObjectType().getDescribe().Name,
            recipientId => recipientId.getSObjectType().getDescribe().Name,
            userId => 'User'});
    }
    
    private void getSenderAdress(){
    	OrgWideEmailAddress orgWideEmailAddresses = [select Id, 
                                                     Address 
                                                     from OrgWideEmailAddress 
                                                     Where Address = 'lebensversicherung@verbraucherhilfe24.de' LIMIT 1];
        senderAdressId = (Id)orgWideEmailAddresses.Id;
    }
}