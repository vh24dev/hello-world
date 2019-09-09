@isTest
public class CorrLegalDocumentsCompleteTest {
    private static Correspondence__c createCorr(boolean isLegal, string scope) {
        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Assignment_Type__c = 'RSV';
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        claim.Cover_Note_Scope__c = scope;
        if (isLegal) {
			User u = TestData.createUser();
            u.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
            System.runAs(TestData.bypassUser()) {
                insert u;
            }
            claim.Legal__c = u.Id;
        }
        insert claim;
        return TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
    }

    @isTest
    private static void testNoLegal() {
        Correspondence__c c = createCorr(false, '');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalDocumentsComplete oe = new CorrLegalDocumentsComplete(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }

    /*
    // claim is mandatory for inserting
    @isTest
    private static void testNoClaim() {
        Correspondence__c c = createCorr(false, '');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        c.Claim__c = null;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalDocumentsComplete oe = new CorrLegalDocumentsComplete(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(null, pr);
    }
	*/

    @isTest
    private static void testCorrespondence() {
        Correspondence__c c = createCorr(true, '');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalDocumentsComplete oe = new CorrLegalDocumentsComplete(sc);

        // Act
        PageReference pr = oe.renderPage();
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());
    }

    @isTest
    private static void testTask() {
        Correspondence__c c = createCorr(true, 'Judicial');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CorrLegalDocumentsComplete oe = new CorrLegalDocumentsComplete(sc);

        List<Task> ts = [SELECT Id FROM Task WHERE Subject = 'Klageschrift versenden'];
        System.assertEquals(0, ts.size());

        PageReference pr = oe.renderPage();
        System.assertEquals(Page.SuccessPage.getUrl(), pr.getUrl());

        ts = [SELECT Id FROM Task WHERE Subject = 'Klageschrift versenden'];
        System.assertEquals(1, ts.size());
    }
}