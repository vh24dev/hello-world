@isTest
public class OpportunityReferenceTests {
    @isTest
    private static void testReferenceIsSet() {
        Account vh24Acc = TestData.createVH24Account();
		Account vr24Acc = TestData.createVR24Account();
        insert new Account[]{vh24Acc, vr24Acc};

        // No previous opps with same tag
        Opportunity o1 = TestData.createOpportunity(null, 'On Hold');
        o1.name = '1';
        o1.account__c = vh24Acc.ID;
        o1.recordTypeId = Opportunities.dieselSkandalRecordType();
        Opportunity o2 = TestData.createOpportunity(null, 'On Hold');
        o2.name = '2';
        o2.account__c = vr24Acc.ID;
        o2.recordTypeId = Opportunities.finanzierungRecordType();
        insert new Opportunity[]{o1, o2};
        
        o1 = [SELECT ID, Reference__c FROM Opportunity WHERE Name = :o1.name];
        System.assert(!String.isBlank(o1.Reference__c));
        System.assertEquals('VHD19-000001', o1.Reference__c);
        
        o2 = [SELECT ID, Reference__c FROM Opportunity WHERE Name = :o2.name];
        System.assert(!String.isBlank(o2.Reference__c));
        System.assertEquals('VRF19-000001', o2.Reference__c);
        
        // 1 prev opp with same tag
		Opportunity o3 = TestData.createOpportunity(null, 'On Hold');
        o3.name = '3';
        o3.account__c = vh24Acc.ID;
        o3.recordTypeId = Opportunities.dieselSkandalRecordType();
        insert o3;

        o3 = [SELECT ID, Reference__c FROM Opportunity WHERE Name = :o3.name];
        System.assert(!String.isBlank(o3.Reference__c));
        System.assertEquals('VHD19-000002', o3.Reference__c);
        
        // 1 prev opp with same tag
        Opportunity o4 = TestData.createOpportunity(null, 'On Hold');
        o4.name = '4';
        o4.account__c = vr24Acc.ID;
        o4.recordTypeId = Opportunities.finanzierungRecordType();
        insert o4;
         
        o4 = [SELECT ID, Reference__c FROM Opportunity WHERE Name = :o4.name];
        System.assert(!String.isBlank(o4.Reference__c));
        System.assertEquals('VRF19-000002', o4.Reference__c);
        
        // Updating opp with no previous reference gets set if conditions change
        Opportunity o5 = TestData.createOpportunity(null, 'On Hold');
        o5.name = '5';
        o5.recordTypeId = Opportunities.finanzierungRecordType();
        insert o5;
         
        o5 = [SELECT ID, Name, Reference__c FROM Opportunity WHERE Name = :o5.name];
        System.assert(String.isBlank(o5.Reference__c));
        
        o5.account__c = vh24Acc.ID;
        update o5;
        
        o5 = [SELECT ID, Name, Account__c, Account_Name__c, Reference__c FROM Opportunity WHERE Name = :o5.name];
        System.assertNotEquals(null, o5.Account__c);
        System.assert(!String.isBlank(o5.Reference__c));
        System.assertEquals('VHF19-000001', o5.Reference__c);
        
        // Do not update ref if already set
        String oldRef = o5.reference__c;
        o5.account__c = vr24Acc.ID;
        update o5;
        
        o5 = [SELECT ID, Account__c, Account_Name__c, Reference__c FROM Opportunity WHERE Name = :o5.name];
        System.assertEquals(oldRef, o5.Reference__c);
    }
}