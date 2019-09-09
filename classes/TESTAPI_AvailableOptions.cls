@isTest
public class TESTAPI_AvailableOptions {
    @isTest
    public static void TestEndpoint() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        
        Account a = new Account(
        	Name = 'test',
            Type = 'kreditinstitut'
        );
        
        insert a;
        
        Test.startTest();
        API_AvailableOptions.run();
        Test.stopTest();
    }
}