@isTest
public class CostNotePaymentTriggerHandlerTests {
    @isTest
    private static void testPreventUpdateOrDelete() {
        TriggerConfiguration.allInactive = true;
        
        Account a = TestData.createAccount();
        Account la = TestData.createAccount();
        la.name = 'legal acc';
        insert new Account[]{a, la};
            
        Commission__c c = TestData.createCommission(a.ID, la.ID, 10, 15, Date.today(), Date.today().addDays(10));
        insert c;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        insert o;
        Claim__c cl = TestData.createClaim(o.ID, 'Draft');
        insert cl;
        Cost_Note__c cn = TestData.createCostNote(cl.ID, 'Draft');
        cn.type__c = 'Außergerichtlich';
        insert cn;
        Cost_Note_Payment__c cnp = TestData.createCostNotePayment(cn.ID, 1000);
        cnp.Commission__c = c.ID;
        insert cnp;
        
        TriggerConfiguration.allInactive = false;
		// Update
        try {
            cnp.Date__c = Date.today().addDays(10);
            update cnp;
            
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
        
        // Delete
        try {
            delete cnp;
            
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
    }
}