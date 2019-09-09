// API_AvailableOptions exposes an endpoint which lists
// the possible values for various fields that can be set
// from the Landing Pages.
@RestResource(urlMapping='/vh/available_options')
global class API_AvailableOptions {
    
    public class KV {
        public string k;
        public string v;
    }
    
    public class Options {
        public List<KV> life_insurers;
        public List<KV> banks;
    }
    
    @HttpGet
    global static void run() {
     	Options o = new Options();
        o.life_insurers = getLifeInsurers();
        o.banks = getBanks();
        
        RestContext.response.headers.put('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(o));
    }

    private static List<KV> getBanks() {
        List<Account> accs = [
            SELECT Id, Name
            FROM Account
            WHERE Type = 'Kreditinstitut'
        ];
        
        List<KV> kvs = new List<KV>();
        for(Account a : accs) {
            KV x = new KV();
            x.k = a.Name;
            x.v = a.Id;
         	kvs.add(x);   
        }
        
        return kvs;
    }
    
    private static List<KV> getLifeInsurers() {
        RecordType rt = [
            SELECT Id
            FROM RecordType
            WHERE Name = 'Lebensversicherung'
            AND SObjectType = 'Lead'
        ];
        
        Lead obj = new Lead(RecordTypeId = rt.Id);
        List<SelectOption> sos = SObjectIntrospection.getSelectOptions(obj, 'Versicherung_LV_RV__c');
        
        List<KV> kvs = new List<KV>();
        for(SelectOption so : sos) {
            KV x = new KV();
            x.k = so.getLabel();
            x.v = so.getValue();
            kvs.add(x);
        }
        
        return kvs;
    }
}