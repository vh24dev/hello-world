trigger SendMailTrigger on SendMail__e (after insert) {
    for (SendMail__e event : Trigger.New) {
        String mailType = event.Mail_Type__c;
        String objectId = event.ObjectId__c;
        String mailId = event.Mail_Id__c;
        String recipientAddress = event.Recipient_Adress__c;
        VH24MailData data = VH24MailData.buildMailData(event);
		VH24MailManager manager = new VH24MailManager(data);        
        //VH24MailManager manager = new VH24MailManager(objectId, mailType, mailId, recipientAddress);
        manager.execute();
    }
}