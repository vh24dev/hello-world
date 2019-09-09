@RestResource(urlMapping='/vh/diesel_lead')
global class API_DieselLeadRequest extends API_Base {
    public class Input {      
        public string name;
        public string brand;
        public string engine;
        public string model;
        public string year;
        public string financed;
        public string finance_type;
        public string finance_amount;
        public string other_finance_type;
        public string insurance; // bool
        public string first_name;
        public string last_name;
        public string salutation;
        public string coupon;
        public string email;
        public string phone;
        public string contact_preference;
        public string gdpr; // bool
        public string newsletter; // bool
        public string tos; // bool
        public string auth; // bool
        public string unique;
        public string availability;
        
        public string utm_source;
        public string utm_medium;
        public string utm_campaign;
        public string utm_term;
        public string utm_content;
        public string unique_id;
        public string formular_id;
        public string kampagne;
        public string referrer;
        
        public boolean allow_duplicates;
    }
    
    private static id getRecordTypeId() {
        RecordType rt = [
            SELECT Id
            FROM RecordType
            WHERE Name = 'Dieselskandal'
            AND SObjectType = 'Lead'
        ];
        return rt.Id;
    }
    
    @HttpPost
    global static void createLead() {
        Input i = (Input)loadRequest(Input.class);

        Lead l = new Lead();
        l.FirstName = i.first_name;
        l.LastName = i.last_name;
        l.Vehicle_Type__c = i.brand;
        l.Account__c = Accounts.VH24ID;
        l.RecordTypeId = getRecordTypeId();
        l.Has_Legal_Protection_Insurance__c = (i.insurance == 'Ja');
        
        if (i.financed == 'Ja') {
            l.Financing_Type__c = 'Finanzierung';
        } else {
            l.Financing_Type__c = 'Eigenkapital';
        }
        
        l.Has_Financing__c = (i.financed == '1');
        l.Modell__c = i.model;
        l.Purchase_Date_Category__c = i.year;
        l.HerokuID__c = i.unique;
        
        if (i.brand == null) {
            throw new API_Exception('Brand NULL (' + i.brand + ')');
        }
        
        l.VehicleBrandAccount__c = vehicleAccountId(i.brand);

        //l.Diesel_Code__c = i.coupon;
        l.Confirmed_Terms_And_Conditions__c = (i.tos == '1');
        l.Confirmed_Authorization__c = (i.auth == '1');
        l.Confirmed_Privacy_Statement__c = (i.gdpr == '1');
        l.Follow_up_Period__c = 2;
        l.Phone = i.phone;
        l.Email = i.email;
        l.Title = i.salutation;
        l.Company = i.first_name + ' ' + i.last_name;
        l.Availability__c = i.availability;
        
        // advertising tracking
        l.AdWords_Source__c = i.utm_source;
        l.AdWords_Medium__c = i.utm_medium;
        l.AdWords_Campaign__c = i.utm_campaign;
        l.AdWords_Term__c = i.utm_term;
        l.AdWords_Content__c = i.utm_content;
        l.Unique_Id__c = i.unique_id;
        l.Form_Id__c = i.formular_id;
        l.Campaign__c = i.kampagne;
        l.Referrer__c = i.referrer;
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = (i.allow_duplicates == true);
        dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.SaveResult sr = Database.insert(l, dml);
        
        if (sr.isSuccess()) {
            System.debug('lead created');
        } else {
            string errors = '';
            for(Database.Error e : sr.getErrors()) {
                errors += e.getMessage();
            }
            
            throw new API_Exception('failed to create lead: ' + errors);
        }
    }
    
    private static string vehicleAccountId(string brand) {
        Map<string, string> accountIdMap = new Map<string,string>();
        accountIdMap.put('Volkswagen (VW)', VehicleBrands.VolkswagenAGID);
        accountIdMap.put('Mercedes', VehicleBrands.DaimlerAGID);
        accountIdMap.put('Porsche', VehicleBrands.PorscheAGID);
        accountIdMap.put('Opel', VehicleBrands.OpelAutomobileGmbHID);
        accountIdMap.put('Audi', VehicleBrands.AudiAGID);
        accountIdMap.put('Daimler', VehicleBrands.DaimlerAGID);
        accountIdMap.put('Seat', VehicleBrands.VolkswagenAGID);
        accountIdMap.put('Skoda', VehicleBrands.VolkswagenAGID);
        accountIdMap.put('BMW', VehicleBrands.BMWAGID);
        return accountIdMap.get(brand);
    }
}