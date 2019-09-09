@isTest
public class LeadsTests {
    @isTest
    private static void testIsVH24OrVR24() {
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        insert new Account[]{vh24, vr24};
        
        Lead l = TestData.createLead();
        insert l;
        System.assert(!Leads.isVH24(l));
        System.assert(!Leads.isVR24(l));
        
        l.account__c = vh24.ID;
        update l;
        System.assert(Leads.isVH24(l));
        System.assert(!Leads.isVR24(l));
        
        l.account__c = vr24.ID;
        update l;
        System.assert(!Leads.isVH24(l));
        System.assert(Leads.isVR24(l));
    }
    
    @isTest
    private static void testIsFzOrLv() {
        Account vh24 = TestData.createVH24Account();
        insert vh24;
        
        // FZ
        Lead l = TestData.createLead();
        l.recordTypeId = Leads.fzRtID;
        insert l;
        
        l = [SELECT RecordTypeID FROM Lead];
        System.assert(Leads.isFinanzierung(l.recordTypeId));
        System.assert(!Leads.isLebensversicherung(l.recordTypeId));
        
        // LV
        l.recordTypeId = Leads.lvRtID;
        update l;
        l = [SELECT RecordTypeID FROM Lead];
        System.assert(Leads.isLebensversicherung(l.recordTypeId));
        System.assert(!Leads.isFinanzierung(l.recordTypeId));
    }
}