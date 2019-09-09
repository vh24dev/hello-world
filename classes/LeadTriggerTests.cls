@isTest
public class LeadTriggerTests {
    @isTest
    public static void TestLeadGetsUniqueID() {
    	Lead l = new Lead(
        	LastName = 'foo',
            Company = 'bar'
        );
        
        insert l;
        
        l = [SELECT Id, Token__c FROM Lead WHERE Id = :l.Id];
        
        System.assert(l.Token__c != null);
    }
}