@isTest
public class LeadReferenceTests {
    @isTest
    private static void testReferenceIsSet() {
        Account vh24Acc = TestData.createVH24Account();
		Account vr24Acc = TestData.createVR24Account();
        insert new Account[]{vh24Acc, vr24Acc};

        // No previous leads with same tag
        Lead l1 = TestData.createLead(vh24Acc.ID, 'Dieselskandal', '1');
        Lead l2 = TestData.createLead(vr24Acc.ID, 'Finanzierung', '2');
        insert new Lead[]{l1, l2};
        
        l1 = [SELECT ID, Reference__c FROM Lead WHERE LastName = :l1.lastName];
        System.assert(!String.isBlank(l1.Reference__c));
        System.assertEquals('VHD19-000001', l1.Reference__c);
        
        l2 = [SELECT ID, Reference__c FROM Lead WHERE LastName = :l2.lastName];
        System.assert(!String.isBlank(l2.Reference__c));
        System.assertEquals('VRF19-000001', l2.Reference__c);
        
        // 1 prev lead with same tag
        Lead l3 = TestData.createLead(vh24Acc.ID, 'Dieselskandal', '3');
        insert l3;
         
        l3 = [SELECT ID, Reference__c FROM Lead WHERE LastName = :l3.lastName];
        System.assert(!String.isBlank(l3.Reference__c));
        System.assertEquals('VHD19-000002', l3.Reference__c);
        
        // 1 prev lead with same tag
        Lead l4 = TestData.createLead(vr24Acc.ID, 'Finanzierung', '4');
        insert l4;
         
        l4 = [SELECT ID, Reference__c FROM Lead WHERE LastName = :l4.lastName];
        System.assert(!String.isBlank(l4.Reference__c));
        System.assertEquals('VRF19-000002', l4.Reference__c);
        
        // Updating lead with no previous reference gets set if conditions change
        Lead l5 = TestData.createLead(null, 'Finanzierung', '5');
        insert l5;
         
        l5 = [SELECT ID, LastName, Reference__c FROM Lead WHERE LastName = '5'];
        System.assert(String.isBlank(l5.Reference__c));
        
        l5.account__c = vh24Acc.ID;
        update l5;
        
        l5 = [SELECT ID, Account__c, Account_Name__c, Reference__c FROM Lead WHERE LastName = :l5.lastName];
        System.assertNotEquals(null, l5.Account__c);
        System.assert(!String.isBlank(l5.Reference__c));
        System.assertEquals('VHF19-000001', l5.Reference__c);
    }
}