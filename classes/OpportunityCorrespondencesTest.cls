@isTest
public class OpportunityCorrespondencesTest {
    @isTest
    public static void testSetTerm() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Opportunity_Correspondence__c oc = TestData.createOpportunityCorrespondence(o.Id, 'Customer', 'Sent');
        oc.Follow_up_Period__c = 2;
        oc.Date__c = System.today();
        insert oc;

        // test
        oc = [SELECT Id, Term__c FROM Opportunity_Correspondence__c WHERE Id = :oc.Id];
        System.assertEquals(System.today().addDays(2), oc.Term__c);
    }

    @isTest
    public static void testNoSetTerm() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Opportunity_Correspondence__c oc = TestData.createOpportunityCorrespondence(o.Id, 'Customer', 'Sent');
        oc.Follow_up_Period__c = 2;
        oc.Date__c = System.today();
        oc.Term__c = System.today();
        insert oc;

        // test
        oc = [SELECT Id, Term__c FROM Opportunity_Correspondence__c WHERE Id = :oc.Id];
        System.assertEquals(System.today(), oc.Term__c);
    }

    @isTest
    public static void testSetTypeLv() {
        Account a = TestData.createAccount();
        insert a;
        List<Account> accs = new List<Account>{               
            new Account(Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'),
            new Account(Name='21Legal GmbH'),
            new Account(Name='Rechtsanwälte Lachmair & Kollegen'),
			new Account(Name='Something Else')
        };
		insert accs;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < accs.size(); i++){
            Opportunity newOpp = TestData.createOpportunity(accs[i].Id, 'On Hold');
            newOpp.Legal_Account__c = accs[i].Id;
			newOpp.RecordTypeId = Opportunities.lebensversicherungRecordType();
            opps.add(newOpp);
        }
        insert opps;

        List<Opportunity_Correspondence__c> ocs = new List<Opportunity_Correspondence__c>();
        for (Integer i = 0; i < opps.size(); i++){
            ocs.add(TestData.createOpportunityCorrespondence(opps[i].Id, 'Customer', 'Sent'));
        }

		Test.startTest();
        insert ocs;
        Test.stopTest();

        List<Id> ocsIds = new List<Id>();
        for (Integer i = 0; i < ocs.size(); i++){
            ocsIds.add(ocs[i].Id);
        }
        List<Opportunity_Correspondence__c> ocsResult = [SELECT Id, RecordTypeId FROM Opportunity_Correspondence__c WHERE Id IN :ocsIds];
        for (Integer i = 0; i < ocsResult.size(); i++){
        	System.assertEquals(OpportunityCorrespondences.lebensversicherungRecordType(), ocsResult[i].RecordTypeId);
        }
    }

    @isTest
    public static void testSetTypeDg() {
        List<Account> accs = new List<Account>{
            new Account(Name='J & C Anwälte', Department__c='Heinrich Jäger - DG & FZ'),
            new Account(Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'),
            new Account(Name='21Legal GmbH'),
            new Account(Name='CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB'),
			new Account(Name='Something Else')
        };
		insert accs;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < accs.size(); i++){
            Opportunity newOpp = TestData.createOpportunity(accs[i].Id, 'On Hold');
            newOpp.Legal_Account__c = accs[i].Id;
			newOpp.RecordTypeId = Opportunities.dieselskandalRecordType();
            opps.add(newOpp);
        }
        insert opps;

        List<Opportunity_Correspondence__c> ocs = new List<Opportunity_Correspondence__c>();
        for (Integer i = 0; i < opps.size(); i++){
            ocs.add(TestData.createOpportunityCorrespondence(opps[i].Id, 'Customer', 'Sent'));
        }

		Test.startTest();
        insert ocs;
        Test.stopTest();

        List<Id> ocsIds = new List<Id>();
        for (Integer i = 0; i < ocs.size(); i++){
            ocsIds.add(ocs[i].Id);
        }
        List<Opportunity_Correspondence__c> ocsResult = [SELECT Id, RecordTypeId FROM Opportunity_Correspondence__c WHERE Id IN :ocsIds];
        for (Integer i = 0; i < ocsResult.size(); i++){
        	System.assertEquals(OpportunityCorrespondences.dieselskandalRecordType(), ocsResult[i].RecordTypeId);
        }
    }

    @isTest
    public static void testSetTypeFz() {

		List<Account> accs = new List<Account>{
            new Account(Name='J & C Anwälte', Department__c='Heinrich Jäger - DG & FZ'),
            new Account(Name='LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH'),
			new Account(Name='Something Else')
        };
		insert accs;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < accs.size(); i++){
            Opportunity newOpp = TestData.createOpportunity(accs[i].Id, 'On Hold');
            newOpp.Legal_Account__c = accs[i].Id;
			newOpp.RecordTypeId = Opportunities.finanzierungRecordType();
            opps.add(newOpp);
        }
        insert opps;

        List<Opportunity_Correspondence__c> ocs = new List<Opportunity_Correspondence__c>();
        for (Integer i = 0; i < opps.size(); i++){
            Opportunity_Correspondence__c newOC = TestData.createOpportunityCorrespondence(opps[i].Id, 'Customer', 'Sent');
            newOC.Text_Modules__c = OpportunityCorrespondencesTest.getPicklistValues('Opportunity_Correspondence__c', 'Text_Modules__c')[0];
            ocs.add(newOC);
        }

		Test.startTest();
        insert ocs;
        Test.stopTest();

        List<Id> ocsIds = new List<Id>();
        for (Integer i = 0; i < ocs.size(); i++){
            ocsIds.add(ocs[i].Id);
        }
        List<Opportunity_Correspondence__c> ocsResult = [SELECT Id, RecordTypeId FROM Opportunity_Correspondence__c WHERE Id IN :ocsIds];
        for (Integer i = 0; i < ocsResult.size(); i++){
        	System.assertEquals(OpportunityCorrespondences.finanzierungRecordType(), ocsResult[i].RecordTypeId);
        }
    }

    @IsTest
    public static void checkOCRTs(){
        String oppIdRT = OpportunityCorrespondences.dieselskandalRecordType();
        System.assertEquals(true, OpportunityCorrespondences.isDieselSkandal(oppIdRT));
        System.assertEquals(false, OpportunityCorrespondences.isDieselSkandal(null));
        
        oppIdRT = OpportunityCorrespondences.finanzierungRecordType();
        System.assertEquals(true, OpportunityCorrespondences.isFinanzierung(oppIdRT));
        System.assertEquals(false, OpportunityCorrespondences.isFinanzierung(null));
        
        oppIdRT = OpportunityCorrespondences.lebensversicherungRecordType();
        System.assertEquals(true, OpportunityCorrespondences.isLebensversicherung(oppIdRT));
        System.assertEquals(false, OpportunityCorrespondences.isLebensversicherung(null));
    }

    private static List<String> getPicklistValues(String objectName, String objectField) {
        List<String> picklistValues = new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult sObjDescribe = targetType.newSObject().getSObjectType().getDescribe();
        Map<String, Schema.SObjectField> fieldMap = sObjDescribe.fields.getMap();
        List<Schema.PicklistEntry> picklistEntries = fieldMap.get(objectField).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : picklistEntries) {
            picklistValues.add(a.getValue());
        }
        return picklistValues;
    }
}