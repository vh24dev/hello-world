public class SendMail {
    @future
    public static void AsyncEmailUtilities(Id parentId, Id recipientId, Id templateId, Id userId) {
        EmailUtilities emailUtilities = new EmailUtilities(parentId, recipientId, templateId, userId);
		String result = emailUtilities.send();
		// System.debug('Sent automatic mail with result: ' + result);
    }

    public Messaging.SingleEmailMessage Send(string toAddr, string subject, string body) {
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { toAddr };
        // message.optOutPolicy = 'FILTER';
        message.subject = subject;
        message.plainTextBody = body;
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult [] results;
        if(!Test.isRunningTest()){
        	results = Messaging.sendEmail(messages);

            System.debug('resutlts: ' + results[0]);
    
            if (results[0].success) {
                System.debug('The email was sent successfully.');
                return message;
            }
                
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        return null;
    }
}