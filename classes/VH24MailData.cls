public class VH24MailData {
    	// could be any standard object id like contact or opportunity
        public String objectId{get;set;}
        public String mailId{get;set;}
        public String recipientAddress{get;set;}
    	public boolean isAddress{get;set;}
        public String bn{get;set;}
        public String mailType{get;set;}
    
    public static VH24MailData buildMailData(SendMail__e event){
        VH24MailData data = new VH24MailData();
        data.bn = event.Bn__c;
        data.isAddress = event.Is_Recipient_Address__c;
        data.recipientAddress = event.Recipient_Adress__c;
        data.mailId = event.Mail_Id__c;
        data.objectId = event.ObjectId__c;
        data.mailType = event.Mail_Type__c;
        return data;
    }
}