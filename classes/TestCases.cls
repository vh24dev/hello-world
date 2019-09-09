// Unfortunate name, it has nothing to do with Testing, but to a Lawsuit Template (Musterfeststellungsklage).
public class TestCases {
	public static void setHash(Test_Case__c[] tcc) {
		for (Test_Case__c tc: tcc) {
			if (tc.status__c != 'Draft') {
                continue;
            }
            
            if (tc.form_Hash_1__c == null && tc.confirmation_Date__c == null) {
                tc.form_Hash_1__c = GUID.Gen();
            }
            if (tc.form_Hash_2__c == null && tc.assignment_Revocation_Date__c == null) {
                tc.form_Hash_2__c = GUID.Gen();
            }
		}
	}
    
    public static void autoStartAutoFollowUp(Test_Case__c[] tcc) {
        for (Test_Case__c tc : tcc) {
            if (tc.autostart_Auto_Follow_up_Journeys__c != true 
                || tc.status__c != 'Finished'
                || tc.started_Auto_Follow_up_Journey_1__c == true) {
                continue;
            }

            tc.auto_Follow_up_Date__c = Datetime.now().addDays(28);
            tc.auto_Follow_up_Count__c = 0;
            tc.started_Auto_Follow_up_Journey_1__c = true;
        }
	}
    
    // Legacy code, todo: refactor
    public static void autoSendMails(List<Test_Case__c> testCases, Map<Id,Test_Case__c> oldTestCases, Boolean isInsert) {
        System.debug('>> TestCases :: autoSendMails');

		testCases = [select Id, Status__c, Opportunity__c, Opportunity__r.Contact__c, Opportunity__r.Account__r.Name, Opportunity__r.Assignment__c, Opportunity__r.Legal_Account__c, Opportunity__r.Account_Name__c from Test_Case__c where Id IN :testCases];

		for (Test_Case__c testCase : testCases){
			Id templateId;
			Id userId;
			if (testCase.Opportunity__r.Legal_Account__c != Accounts.JCLegalID
                && (testCase.Status__c == 'Draft')
                && ((isInsert == true) || (oldTestCases.get(testCase.Id).Status__c != 'Draft'))) {
				if (Opportunities.isVR24(testCase.Opportunity__r)) {
					// VR24
					userId = Users.vr24diesel();
					if (testCase.Opportunity__r.Assignment__c == true) {
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseNewTestCaseAssignmentVr24));
					} else {
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseNewTestCaseNoAssignmentVr24));
					}
				} else {
					userId = Users.vh24Diesel();
					if (testCase.Opportunity__r.Assignment__c == true) {
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseNewTestCaseAssignmentVh24));
					} else {
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseNewTestCaseNoAssignmentVh24));
					}
				}
			} else if ((testCase.Status__c == 'Finished') && ((isInsert == true) || (oldTestCases.get(testCase.Id).Status__c != 'Finished'))){
				if (Opportunities.isVR24(testCase.Opportunity__r)) {
					// VR24
					userId = Users.vr24diesel();
					templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseFinishedTestCaseVr24));
				} else {
					userId = Users.vh24Diesel();
					templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.DieselskandalGeneralTestCaseFinishedTestCaseVh24));
				}
			}

            if (templateId == null){
            	System.debug('TestCases :: autoSendMails :: templatedID not found :: no email will be sent');
                return;
            }

            System.debug('TestCases :: autoSendMails :: templatedID: ' + templateID);
            EmailUtilities emailUtilities = new EmailUtilities(testCase.Id, testCase.Opportunity__r.Contact__c, templateId, userId);
            emailUtilities.noParentAttachment = true;
            String result = emailUtilities.send();
            System.debug('Sent automatic mail with result: ' + result);
		}
	}
    
    @future (callout=true)
    public static void autoCreateDocuments(Set<Id> ids) {
		Test_Case__c[] tcc = [select Id, Status__c, Opportunity__c, Opportunity__r.Legal_Account__c from Test_Case__c where Id IN :ids];
		for (Test_Case__c tc: tcc) {
			if (Accounts.isJCLegal(tc.opportunity__r.Legal_Account__c) && tc.status__c == 'Draft') {
				DocumentCreationAction.autoCreateDocument(tc.Id,false,'pdf',null,null);
			}
		}
	}
}