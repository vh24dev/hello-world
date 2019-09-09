@isTest
public class AuthorizationsTests {
    @isTest
    private static void testRecordType() {
        TriggerConfiguration.allInactive = true;
        
        Account acc = TestData.createAccount();
        insert acc;

        Opportunity dgOpp = TestData.createOpportunity(acc.ID, 'New');
        dgOpp.recordTypeId = Opportunities.dieselSkandalRecordType();
        Opportunity fzOpp = TestData.createOpportunity(acc.ID, 'New');
        fzOpp.recordTypeId = Opportunities.finanzierungRecordType();
        Opportunity lvOpp = TestData.createOpportunity(acc.ID, 'New');
        lvOpp.recordTypeId = Opportunities.lebensversicherungRecordType();
        insert new Opportunity[]{dgOpp, fzOpp, lvOpp};

		Authorization__c dgAuth = new Authorization__c(Opportunity__c = dgOpp.ID);
        Authorization__c fzAuth = new Authorization__c(Opportunity__c = fzOpp.ID);
        Authorization__c lvAuth = new Authorization__c(Opportunity__c = lvOpp.ID);
        Authorization__c[] auths = new Authorization__c[]{dgAuth, fzAuth, lvAuth};
		insert auths;

        Test.startTest();
        Authorizations.setRecordType(auths);
        Test.stopTest();

        ID dgRt = authRecordType('Dieselskandal');
        ID fzRt = authRecordType('Finanzierung');
        ID lvRt = authRecordType('Lebensversicherung');

        for (Authorization__c auth: auths) {
            if (auth.opportunity__c == dgOpp.ID) {
                System.assertEquals(dgRt, auth.recordTypeID);
            } else if (auth.opportunity__c == fzOpp.ID) {
                System.assertEquals(fzRt, auth.recordTypeID);
            } else if (auth.opportunity__c == lvOpp.ID) {
                System.assertEquals(lvRt, auth.recordTypeID);
            }
        }
    }
    
    private static ID authRecordType(String devName) {
		RecordType rt = [
            SELECT  DeveloperName,
            		SObjectType
            FROM RecordType
            WHERE SObjectType = 'Authorization__c' AND DeveloperName = :devName
        ];
		return rt.ID;
    }

    @isTest
    private static void testDocGen() {
        // todo:
    }
}