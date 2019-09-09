@isTest
public class CreateCreditNoteFromCostNoteTest {
    @isTest
    private static void test() {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
		insert o;
		RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Claim__c'];
        Claim__c cl = new Claim__c(
        	Opportunity__c = o.Id,
            recordTypeId = rt.Id
        );
        insert cl;
        Cost_Note__c c = new Cost_Note__c(
        	Claim__c = cl.Id,
            Subject__c = 'Foo bar',
            Type__c = 'Sonstiges'
        );
        insert c;
        Apexpages.StandardController sc = new Apexpages.standardController(c);
        CreateCreditNoteFromCostNote oe = new CreateCreditNoteFromCostNote(sc);

        // Act
		Cost_Note_Line_Item__c note = new Cost_Note_Line_Item__c(
        	Cost_Note__c = c.Id,
            Price__c = 22,
            Subject__c = 'foo bar',
            Type__c = 'Sonstiges'
        );
        insert note;
        CreateCreditNoteFromCostNote.CCostNoteLineItem cc = new CreateCreditNoteFromCostNote.CCostNoteLineItem(note);
        List<CreateCreditNoteFromCostNote.CCostNoteLineItem> items = new List<CreateCreditNoteFromCostNote.CCostNoteLineItem>{cc};
        oe.parCostNoteLineItems = items;

		oe.parCreditNote.Claim__c = cl.Id;
        PageReference pr = oe.renderPage();
    }
}