@isTest
public class CreateClassActionTest {
    private static Claim__c createClaim(string accname) {
        ClaimTriggerhandler.Deactivate = true;
        Account a = TestData.createAccount();
        a.name = accname;
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.Account__c = a.Id;
		o.Backoffice__c = u.Id;
        o.Legal_Account__c = accounts.JCLegalID;
		insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Clerk__c = u.Id
        );
        return c;
    }

    @isTest
    private static void TestLachmair() {
        Claim__c c = createClaim('VH24');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        insert c;
        Correspondence__c corr = new Correspondence__c(
        	Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;
        
        List<Claim__c> claims = new List<Claim__c>{c};

        Apexpages.StandardsetController sc = new Apexpages.standardsetController(claims);
        CreateClassAction oe = new CreateClassAction(sc);

        // Act
		Account a = TestData.createAccount();
        a.Type = 'Lebensversicherung';
        insert a;
        oe.parClassAction.Opponent__c = a.Id;
        PageReference pr = oe.renderPage();
        
    }

}