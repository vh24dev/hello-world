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
    private Map<String,String> mergeMappings;
    private String bn;

    public LVSendAGBDelegation(String bn,Contact contact) {
        this.bn = bn;
        this.contact = contact;
    }
    
    public LVSendAGBDelegation(VH24MailData data) {
        this.bn = data.bn;
        mapIdToContact(data.objectId);  
    }
    
    private void  mapIdToContact(Id contactId) {
        this.contact = [Select EMail,Id,Salutation__c FROM Contact WHERE Id =: contactId];
    }
    
    public void prepareMail() {
        this.userId = Users.vh24Lv();
        this.eMailMapping = fetchConfig();
        this.template = fetchTemplate();
        this.attachment = fetchAndMapAttachment();
        fileAttachment = mapToFile();
        this.subject = buildSubject();
        buildBody();
        buildHtmlBody();
        prepareMergeMappings();
        mergeFields();
        getSenderAdress();
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
    
    public void processResult(Messaging.SendEmailResult [] r) {
        
    }
        
    public void processError(String message) {
            
    }
    
    private EMailMapping__mdt fetchConfig(){
       return [Select Attachment__c, 
                              Template__c, 
                              UniqueName__c,
               				  IsEnabled__c
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
         this.body = template.Body;
     }
    
    private void buildHtmlBody() {
        Id recipientId = contact.Id;
        Id parentId = template.Id;
        this.htmlBody = template.HtmlValue.replace('{text_body}',body.replace('\n','<br/>'));
    }
    
    private string buildSubject(){
        Id recipientId = contact.Id;
        Id parentId = template.Id;
        return template.subject;
    }
    
    private void getSenderAdress(){
    	OrgWideEmailAddress orgWideEmailAddresses = [select Id, 
                                                     Address 
                                                     from OrgWideEmailAddress 
                                                     Where Address = 'lebensversicherung@verbraucherhilfe24.de' LIMIT 1];
        senderAdressId = (Id)orgWideEmailAddresses.Id;
    }
    
    private void prepareMergeMappings(){
        this.mergeMappings = new Map<String,String>();
        this.mergeMappings.put('{!Opportunity.Number__c}',this.bn);
        if(Contact.Salutation__c != null) {
        	this.mergeMappings.put('{!Contact.Salutation__c}',Contact.Salutation__c);  
        } else {
          	this.mergeMappings.put('{!Contact.Salutation__c}',''); 
        }    
    }
    
    private void mergeFields(){
        for (String key : this.mergeMappings.keySet()) {
            this.htmlBody = this.htmlBody.replace(key,this.mergeMappings.get(key));
            this.body = this.body.replace(key,this.mergeMappings.get(key));
            this.subject = this.subject.replace(key,this.mergeMappings.get(key));            
		}
    }
    
    public void processResult(){
        
    }
    
}