@RestResource(urlMapping='/vh/finanzen')
global class API_Finanzen extends API_Base {
    public class Input {
        public string sex;
        public string firstname;
        public string lastname;
        public string adresse;
        public string postalCode;
        public string city;
        public string dateOfBirth;
        public string email;
        public string phone;
        public integer occupationGroupId;
        public string occupationGroupName;
        public string leadtype;
        public integer leadid;
        // public string translated;
        public integer campaign;
        public string derivation;
        public integer tarif;
        public integer behandlung;
        public integer selbstbeteiligung;
        public integer zahnbehandlung;
        public string tagegeld_betrag;
    }

    @HttpPost
    global static void createLead() {
        Input i = (Input)loadRequest(Input.class);

        Lead l = new Lead(
            RecordTypeId = Leads.dkRtID,
            Account__c = Accounts.VH24ID,
            FirstName = i.firstname,
            LastName = i.lastname,
            Country = 'Deutschland',
            CountryCode = 'DE',
            Street = i.adresse,
            City = i.city,
            PostalCode = i.postalCode,
            Phone = i.phone,
            Email = i.email,
            Company = i.firstname + ' ' + i.lastname,
            AdWords_Medium__c = i.leadtype,
            AdWords_Campaign__c = i.derivation,
            Adwords_Source__c = 'Finanzen.de'
        );

        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
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
}