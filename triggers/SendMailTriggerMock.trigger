trigger SendMailTriggerMock on SendMail__e (after insert) {
     for (SendMail__e event : Trigger.New) {
        // do nothing
    }
}