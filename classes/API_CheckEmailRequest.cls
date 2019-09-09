@RestResource(urlMapping='/vh/check_email')
global class API_CheckEmailRequest extends API_Base {
    public class Response {
        public boolean found;
        public string leadId;
        public string contactId;
        public datetime createdDate;
    }
    
    @HttpGet
    global static void check() {
        setJSON();
        
        Response r = new Response();
        r.found = false;
        
        string email = getParam('email');
        
        API_CheckEmailRequest x = new API_CheckEmailRequest(email);
        
        Contact c = x.getContact();
        if (c != null) {
            r.found = true;
            r.contactId = c.Id;
            r.createdDate = c.CreatedDate;
            setResponseObject(r);
            return;
        } 
        
        Lead l = x.getLead();
        if (l != null) {
            r.found = true;
            r.leadId = l.Id;
            r.createdDate = l.CreatedDate;
            setResponseObject(r);
            return;
        }
        
        setResponseObject(r);
    }
    
    public API_CheckEmailRequest(string email) {
        this.email = email;
    }
    
    private string email;
    
    private Contact getContact() {
        List<Contact> c = [
            SELECT 
            Id, CreatedDate
            FROM Contact
            WHERE Email = :email
        ];
        
        if (c.size() == 0) {
            return null;
        }
        
        return c[0];
    }
    
    private Lead getLead() {
        List<Lead> l = [
            SELECT Id, CreatedDate
            FROM Lead
            WHERE Email = :email
        ];
        
        if (l.size() == 0) {
            return null;
        }
        
        return l[0];
    }
}