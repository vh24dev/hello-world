@isTest
public class SetCorrespondenceReceivedTest {
    private static Correspondence__c createCorr() {
        PageReference p = Page.SetCorrespondenceReceived;
        Test.setCurrentPage(p);

        Account a = TestData.createAccount();
        a.name = 'Bla';
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        insert o;
        Claim__c claim = new Claim__c(Opportunity__c = o.Id);
        insert claim;
        return TestData.createCorrespondence(claim.Id, 'Customer', 'Sonstiges', 'Sent');
    }

    @isTest
    private static void testStage() {
        Correspondence__c c = createCorr();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name = 'Anspruchsschreiben (Dieselskandal)' AND sObjectType = 'Correspondence__c'];
        c.recordTypeId = rt.ID;
        insert c;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        SetCorrespondenceReceived oe = new SetCorrespondenceReceived(sc);

        // Act
        PageReference pr = oe.renderPage();
        Correspondence__c res = [SELECT Id, Stage__c FROM Correspondence__c WHERE Id = :c.Id];
        System.assertEquals('Received', res.Stage__c);
    }
}