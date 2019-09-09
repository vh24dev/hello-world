@isTest
public class ErrorControllerTests {
	@isTest
    private static void testParams() {
        PageReference pr = Page.Error;
        pr.getParameters().put('t', 'title');
        pr.getParameters().put('m', 'msg');
        Test.setCurrentPage(pr);
        
        ErrorController epc = new ErrorController();
        epc.title = 'title';
        epc.message = 'msg';
    }
}