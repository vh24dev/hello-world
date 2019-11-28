@IsTest
public class AutoconvertLeadtest {
    @IsTest
    private static void testShoudConvert() {
        Lead lead = TestData.createLead();
        lead.Phone = '089123123';
        lead.Confirmed_Terms_And_Conditions__c = true;
        insert lead;
        lead = [Select Bearbeitungsnummer__c FROM Lead Where Id =: lead.Id];
        Opportunity opp = [Select Id From Opportunity Where Number__c = : lead.Bearbeitungsnummer__c];
      	System.assertNotEquals(null,opp);
    }
    
    @IsTest
    private static void testShoudNotConvertPhoneMissing() {
        Lead lead = TestData.createLead();
        lead.Confirmed_Terms_And_Conditions__c = true;
        insert lead;
        lead = [Select Bearbeitungsnummer__c FROM Lead Where Id =: lead.Id];
      	try {
            Opportunity opp = [Select Id From Opportunity Where Number__c = : lead.Bearbeitungsnummer__c];
        } catch (Exception e) {
            System.assertNotEquals(null,e);
        }

    }
    
    @IsTest
    private static void testShoudNotConvertAGBMissing() {
        Lead lead = TestData.createLead();
        lead.Phone = '089123123';
        insert lead;
        lead = [Select Bearbeitungsnummer__c FROM Lead Where Id =: lead.Id];
        try {
            Opportunity opp = [Select Id From Opportunity Where Number__c = : lead.Bearbeitungsnummer__c];
        } catch (Exception e) {
            System.assertNotEquals(null,e);
        }
    }
}