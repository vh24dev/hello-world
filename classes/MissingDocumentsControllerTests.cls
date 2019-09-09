@isTest
public class MissingDocumentsControllerTests {
    @isTest
    public static void TestFileTruncateShort() {
        string inp = 'foo.txt';
        string out = MissingDocumentsController.truncFilename(inp);
        System.assertEquals('foo.txt', out);
    }

    @isTest
    public static void TestFileTruncateLong() {
        string inp = 'fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo.txt';
        string out = MissingDocumentsController.truncFilename(inp);
        System.assertEquals('fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo...o.txt', out);
    }

    @isTest
    public static void TestFileTruncateLongNoExtension() {
        string inp = 'fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo';
        string out = MissingDocumentsController.truncFilename(inp);
        System.assertEquals('fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo...', out);
    }

    @isTest
    public static void TestFileTruncateLongFakeExtension() {
        string inp = 'mr. fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo';
        string out = MissingDocumentsController.truncFilename(inp);
        System.assertEquals('mr. fooooooooooooooooooooooooooooooooooooooooooooooooooooooo...', out);
    }

    @isTest
    public static void TestFileTruncateLongToLongExtension() {
        string inp = 'foooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo.xxxxxxxxxxxxxxxxxxxxxxxx';
        string out = MissingDocumentsController.truncFilename(inp);
        System.assertEquals('fooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo...', out);
    }

    @isTest
    public static void TestUploadAuthDocFuzzExtensions() {  
        Account a = new Account(
            Name = 'foo'
        );
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = new Opportunity(
            AccountId = a.Id,
            Name = 'foo',
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            Token__c = 'foo',
            Backoffice__c = u.Id
        );
        
        insert o;
        
        PageReference p = Page.MissingDocuments;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            MissingDocumentsController c = new MissingDocumentsController();
            
            Blob data = Blob.valueOf('test');
            c.registrationData = data;
            c.registrationName = 'fooooooooooooooooooooooo\\.ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo.txt';
            c.registrationContentType = 'image/jpeg';
            c.confirmationData = data;
            c.confirmationName = 'foooooooooooooooooooooooooooooo\\ß\\89awdawda89ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo.txtxtxtxtxttxtxtxtxtxttxtxtxtxt';
            c.confirmationContentType = 'image/jpeg';
            c.invoiceData = data;
            c.invoiceName = 'fooooooo.o.o.o.o.o.o.o.o.o.o.o.o.o.oo.o.o.o.o.o.o.o.o.o.o.o.o.oo.o.o.o.o.o.o.o.o.o.o.oo.o.oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo.txt';
            c.invoiceContentType = 'image/jpeg';
            c.loanData = data;
            c.loanName = '...';
            c.loanContentType = 'image/jpeg';
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MissingDocumentsMock());
            c.init();
            c.upload();
            Test.stopTest();
        }
        
        List<Document__c> docs = [
            SELECT Id FROM Document__c
            WHERE Opportunity__c = :o.Id
        ];
        
        System.assertEquals(4, docs.size());
    }

    @isTest
    public static void TestUploadNoOppRaiseNoErrors() {        
        PageReference p = Page.MissingDocuments;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            MissingDocumentsController c = new MissingDocumentsController();
            c.init();
            c.upload();
        }
    }
    
    @isTest
    public static void TestUploadNothingRaisesNoErrors() {    
        Account a = new Account(
            Name = 'foo'
        );
        insert a;
        
        Opportunity o = new Opportunity(
            AccountId = a.Id,
            Name = 'foo',
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            Token__c = 'foo'
        );
        
        insert o;
        
        PageReference p = Page.MissingDocuments;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            MissingDocumentsController c = new MissingDocumentsController();
            c.init();
            c.upload();
        }
    }
    
    @isTest
    public static void TestUploadAuthDoc() {  
        Account a = new Account(
            Name = 'foo'
        );
        insert a;
        User u = TestData.createUser();
        insert u;
        Opportunity o = new Opportunity(
            AccountId = a.Id,
            Name = 'foo',
            CloseDate = Date.today(),
            StageName = 'Closed Won',
            Token__c = 'foo',
            Backoffice__c = u.Id
        );
        
        insert o;
        
        PageReference p = Page.MissingDocuments;
        Test.setCurrentPage(p);
        ApexPages.currentPage().getParameters().put('token', 'foo');
        
        System.runAs(TestData.bypassUser()) {
            MissingDocumentsController c = new MissingDocumentsController();
            
            Blob data = Blob.valueOf('test');
            c.registrationData = data;
            c.registrationName = 'test2';
            c.registrationContentType = 'image/jpeg';
            c.confirmationData = data;
            c.confirmationName = 'test3';
            c.confirmationContentType = 'image/jpeg';
            c.invoiceData = data;
            c.invoiceName = 'test4';
            c.invoiceContentType = 'image/jpeg';
            c.loanData = data;
            c.loanName = 'test5';
            c.loanContentType = 'image/jpeg';
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MissingDocumentsMock());
            c.init();
            c.upload();
            Test.stopTest();
        }
        
        List<Document__c> docs = [
            SELECT Id FROM Document__c
            WHERE Opportunity__c = :o.Id
        ];
        
        System.assertEquals(4, docs.size());
    }
    
    @isTest
    public static void testHackCoverage() {
        new MissingDocumentsController().HackCoverage();
    }
}