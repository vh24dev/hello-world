@isTest
public class PickInvoiceTest {
	@isTest
    public static void testCover() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        insert o;
        Invoice__c i = new Invoice__c(
            Opportunity__c = o.Id
        );
        insert i;

        List<Invoice__c> invs = new List<Invoice__c>{i};

		Apexpages.StandardSetController sc = new Apexpages.StandardSetController(invs);
        PickInvoice oe = new PickInvoice(sc);

        PageReference pr = oe.renderPage();
        System.assertEquals(new PageReference('/' + i.Id).getUrl(), pr.getUrl());
    }
}