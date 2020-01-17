@isTest(SeeAllData=true)
public class VH24MailTest {

    @isTest
    private static void testSendMail(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        iVH24MailDelegation delegation = (MandateAsMailDelegation) mocks.mock(MandateAsMailDelegation.Class); 
        mocks.startStubbing();
        mocks.when(delegation.getAttachments()).thenReturn(null);
        mocks.when(delegation.getMailTemplate()).thenReturn(null);
        mocks.when(delegation.gethtmlBody()).thenReturn(null);
        mocks.when(delegation.getSenderId()).thenReturn('0061t00000AnrXSAAZ');
        mocks.when(delegation.getPlainTextBody()).thenReturn('only for testing purposes');
        mocks.when(delegation.getAddresses()).thenReturn(new list<string> {'n.holland-cunz@verbraucherhilfe24.de'});        
        mocks.stopStubbing();
        VH24Mail executor = new VH24Mail();
        executor.setDelegation(delegation);
        executor.sendMail();
        ((iVH24MailDelegation)mocks.verify(delegation)).getAttachments();
        ((iVH24MailDelegation)mocks.verify(delegation)).getAddresses();
        ((iVH24MailDelegation)mocks.verify(delegation)).getPlainTextBody();        
        ((iVH24MailDelegation)mocks.verify(delegation)).prepareMail();
        ((iVH24MailDelegation)mocks.verify(delegation)).getSubject();
        ((iVH24MailDelegation)mocks.verify(delegation)).getSenderId();
    }

    @isTest    
    private static void testIsSpecificMailEnabled() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        iVH24MailDelegation delegation = (MandateAsMailDelegation) mocks.mock(MandateAsMailDelegation.Class); 
        mocks.startStubbing();
        mocks.when(delegation.isEnabled()).thenReturn(true);
        mocks.stopStubbing();
        VH24Mail executor = new VH24Mail();
        executor.setDelegation(delegation);
        System.assertEquals(true, executor.isSpecificMailEnabled());	
    }        
}