@isTest
public class TESTAPI_CheckEmailRequest {
    @isTest
    public static void TestEmailDoesExistOnContact() {
        Account a = new Account(
        	Name = 'test'
        );
        
        insert a;
        
        Contact c = new Contact(
            FirstName = 'test',
            LastName = 'test',
            Email = 'test@site.com'
        );
        
        insert c;
        
        API_TestHelper.setParam('email', c.Email);
        API_CheckEmailRequest.check();
        
        System.assertEquals(200, API_TestHelper.getStatusCode());
        API_CheckEmailRequest.Response r = (API_CheckEmailRequest.Response)API_TestHelper.getResponseObject(API_CheckEmailRequest.Response.class);
        
        c = [
            SELECT Id, CreatedDate
            FROM Contact
            WHERE Id = :c.Id
        ];
        
        System.assertEquals(true, r.found);
        System.assertEquals(c.Id, r.contactId);
        System.assertEquals(null, r.leadId);
        System.assertEquals(c.CreatedDate, r.createdDate);
    }
    
    @isTest
    public static void TestEmailDoesExistOnLead() {
        Lead l = new Lead(
        	Email = 'test@site.com',
            LastName = 'test',
            Company = 'test'
        );
        
        insert l;
        
        API_TestHelper.setParam('email', l.Email);
        API_CheckEmailRequest.check();
        
        System.assertEquals(200, API_TestHelper.getStatusCode());
        API_CheckEmailRequest.Response r = (API_CheckEmailRequest.Response)API_TestHelper.getResponseObject(API_CheckEmailRequest.Response.class);
        
        l = [
            SELECT Id, CreatedDate
            FROM Lead
            WHERE Id = :l.Id
        ];
        
        System.assertEquals(true, r.found);
        System.assertEquals(null, r.contactId);
        System.assertEquals(l.Id, r.leadId);
        System.assertEquals(l.CreatedDate, r.createdDate);
    }
    
	@isTest
    public static void TestEmailDoesNotExist() {
        API_TestHelper.setParam('email', 'test');
        API_CheckEmailRequest.check();
        
        System.assertEquals(200, API_TestHelper.getStatusCode());
        
        API_CheckEmailRequest.Response r = (API_CheckEmailRequest.Response)API_TestHelper.getResponseObject(API_CheckEmailRequest.Response.class);
        
        System.assertEquals(false, r.found);
        System.assertEquals(null, r.contactId);
        System.assertEquals(null, r.leadId);
        System.assertEquals(null, r.createdDate);
    }
}