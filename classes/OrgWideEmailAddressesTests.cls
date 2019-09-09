@isTest
public class OrgWideEmailAddressesTests {
    // DG
    // 
	@isTest
    private static void testDGVollmachtSenderEmptySettings() {
        Account a = TestData.createAccount();
        insert a;        
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.dkRtID;
        insert o;
        
        OrgWideEmailSettings.DG_VOLLMACHT_SENDER = null;
        OrgWideEmailAddress[] oweas = orgWideAddrs();
        // If there's an OrgWide Email Address setup we use it for LV (no DML for OrgWide Addrs)
        // and assert that it is not used when the Opp is DG.
        if (oweas.size() > 0) {
        	OrgWideEmailSettings.LV_VOLLMACHT_SENDER = oweas[0].Address;
        }
        
        System.assertEquals(null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }
    
    @isTest
    private static void testDGVollmachtUnknownSender() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.dkRtID;
        insert o;
        
        OrgWideEmailSettings.LV_VOLLMACHT_SENDER = null;
        OrgWideEmailSettings.DG_VOLLMACHT_SENDER = 'kajskjas';
        
        System.assertEquals(null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }
    
    @isTest
    private static void testDGVollmachtSenderSet() {
        Account a = TestData.createAccount();
        insert a;        
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.dkRtID;
        insert o;
        
        OrgWideEmailSettings.LV_VOLLMACHT_SENDER = null;
        OrgWideEmailAddress[] oweas = orgWideAddrs();
        if (oweas.size() > 0) {
        	OrgWideEmailSettings.DG_VOLLMACHT_SENDER = oweas[0].Address;
        }

        System.assertEquals(oweas.size() > 0 ? oweas[0].ID : null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }
    
    // LV
    // 
    @isTest
    private static void testLVVollmachtSenderEmptySettings() {
        Account a = TestData.createAccount();
        insert a;        
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.lvRtID;
        insert o;
        
        OrgWideEmailSettings.LV_VOLLMACHT_SENDER = null;
        OrgWideEmailAddress[] oweas = orgWideAddrs();
        // If there's an OrgWide Email Address setup we use it for DG (no DML for OrgWide Addrs)
        // and assert that it is not used when the Opp is LV.
        if (oweas.size() > 0) {
        	OrgWideEmailSettings.DG_VOLLMACHT_SENDER = oweas[0].Address;
        }
        
        System.assertEquals(null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }
    
    @isTest
    private static void testLVVollmachtUnknownSender() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.lvRtID;
        insert o;
        
        OrgWideEmailSettings.DG_VOLLMACHT_SENDER = null;
        OrgWideEmailSettings.LV_VOLLMACHT_SENDER = 'kajskjas';
        
        System.assertEquals(null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }
    
    @isTest
    private static void testLVVollmachtSenderSet() {
        Account a = TestData.createAccount();
        insert a;        
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.recordTypeID = Opportunities.lvRtID;
        insert o;
        
        OrgWideEmailSettings.DG_VOLLMACHT_SENDER = null;
        OrgWideEmailAddress[] oweas = orgWideAddrs();
        if (oweas.size() > 0) {
        	OrgWideEmailSettings.LV_VOLLMACHT_SENDER = oweas[0].Address;
        }

        System.assertEquals(oweas.size() > 0 ? oweas[0].ID : null, OrgWideEmailAddresses.vollmachtSender(o.recordTypeID));
    }

    private static OrgWideEmailAddress[] orgWideAddrs() {
        return [SELECT ID, Address FROM OrgWideEmailAddress];
    }
}