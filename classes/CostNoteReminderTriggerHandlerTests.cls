@isTest
public class CostNoteReminderTriggerHandlerTests {
    @isTest
    private static void testNumber() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        insert o;
        Claim__c c = TestData.createClaim(o.ID, 'Draft');
        insert c;
        Cost_Note__c cn = TestData.createCostNote(c.ID, 'Draft');
        cn.type__c = 'Außergerichtlich';
        insert cn;
        Cost_Note_Reminder__c cnr = TestData.createCostNoteReminder(cn.ID, 'Draft');

        Test.startTest();
        insert cnr;
        Test.stopTest();

        cnr = [SELECT ID, Number__c FROM Cost_Note_Reminder__c WHERE ID = :cnr.ID];
        System.assert(!String.isBlank(cnr.number__c));
        System.assert(cnr.number__c.contains('000001/RDG'));
    }
}