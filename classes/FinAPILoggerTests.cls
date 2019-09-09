@isTest
public class FinAPILoggerTests {
    @isTest
    private static void testPersistentLog() {
        Test.startTest();
        new FinAPILogger().debug('bu');
        new FinAPILogger().error('bla');
        Test.stopTest();
        
        FinAPI_Log__c[] ll = [SELECT Type__c, Message__c FROM FinAPI_Log__c];
        System.assertEquals(2, ll.size());
        
        FinAPI_Log__c l = [SELECT Type__c, Message__c FROM FinAPI_Log__c WHERE Type__c = 'debug'];
        System.assertEquals('bu', l.message__c);
        
        l = [SELECT Type__c, Message__c FROM FinAPI_Log__c WHERE Type__c = 'err'];
        System.assertEquals('bla', l.message__c);
    }
}