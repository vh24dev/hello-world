@isTest
public class ClaimSetOppPartialRefundTest {
    public static Opportunity createOpp(Id accountId, String stageName) {
        Account vehicleBrand = new Account(
            Name = 'TestVehicleBrand',
            Type = 'Fahrzeughersteller'
        );
        insert vehicleBrand;
        Opportunity opp = new Opportunity(
            Name = 'TestOpportunity',
            AccountId = accountId,
            CloseDate = System.today(),
            StageName = stageName,
            Sent_Mail_Flag_1__c = true,
            Sent_Mail_Flag_2__c = true,
            Assignment_Type__c = 'RSV',
            Has_Legal_Protection_Insurance__c = true,
            Auto_Follow_up_Count__c = 0,
            Sales_Type__c = 'Online',
            Vehicle_Brand__c = vehicleBrand.Id
        );
        return opp;
    }

    @isTest
    private static void testRefundUpdate() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = createOpp(a.ID, 'On Hold');
        insert o;
        Claim__c c = new Claim__c();
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        c.recordTypeId = rt.ID;
        c.Opportunity__c = o.Id;
        insert c;
        Correspondence__c corr = new Correspondence__c(
            Claim__c = c.Id,
            Type__c = 'Deckungsanfrage Verteidigungsanzeige'
        );
        insert corr;

        Apexpages.StandardController sc = new Apexpages.standardController(c);
        ClaimSetOppPartialRefund oe = new ClaimSetOppPartialRefund(sc);

        // Act
        oe.parOpportunity.Partial_Refund__c = 22;
        PageReference pr = oe.renderPage();

        Opportunity res = [SELECT Id, Partial_Refund__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(oe.parOpportunity.Partial_Refund__c, res.Partial_Refund__c);
    }
}