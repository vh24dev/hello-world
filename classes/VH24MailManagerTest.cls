@IsTest
public class VH24MailManagerTest {

	@IsTest
	private static void testExecuteNew() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        VH24Mail testExecutor = (VH24Mail)mocks.mock(VH24Mail.Class);
        iVH24MailDelegation delegation = (MandateAsMailDelegation) mocks.mock(MandateAsMailDelegation.Class); 
        mocks.startStubbing();
        mocks.stopStubbing();
        VH24MailManager manager = new VH24MailManager(testExecutor,delegation);
        manager.execute();
        ((VH24Mail)mocks.verify(testExecutor)).sendMail();
    }
    
    @IsTest
	private static void testBuildDelegation() {
        SendMail__e event = new SendMail__e();
        event.Is_Recipient_Address__c = true;
        event.Mail_Id__c = '123124124-123123-123123123';
        event.Mail_Type__c = 'MandateAsMail';
        VH24MailData data = VH24MailData.buildMailData(event);
        VH24MailManager manager = new VH24MailManager(data);
        iVH24MailDelegation delegation = manager.buildDelegation();
        System.assertEquals(true, delegation instanceOf MandateAsMailDelegation);
    }
}