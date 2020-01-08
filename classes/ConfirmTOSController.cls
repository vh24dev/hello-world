public class ConfirmTOSController {
    public Lead l {get; set;}
    public string LeadVehicleType {get; set;}
    public string LeadStreet {get; set;}
    public string LeadCity {get; set;}
    public string LeadPostalCode {get; set;}
    public string LeadPhone {get; set;}
    public string LeadName {get; set;}
    public string insurance {get; set;}
    public boolean isPrivacy {get; set;}
    public boolean isLegal {get; set;}
    public string errorMsg {get; set;}

    public void getValues() {
        if (LeadStreet == null || LeadStreet == '') {
            LeadStreet = l.Street;
        }
        if (LeadCity == null || LeadCity == '') {
            LeadCity = l.City;
        }
        if (LeadPostalCode == null || LeadPostalCode == '') {
            LeadPostalCode = l.PostalCode;
        }
        if (LeadPhone == null || LeadPhone == '') {
            LeadPhone = l.Phone;
        }
        if (LeadName == null || LeadName == '') {
            LeadName = l.Name;
        }
        if (LeadVehicleType == null || LeadVehicleType == '') {
            LeadVehicleType = l.Vehicle_Type__c;
        }
        errorMsg = '';
    }

    public PageReference init() {
        this.l = getLead();
        if (this.l == null) {
            return new PageReference('/NotFound');
        }
        if (this.l.Confirmed_Terms_And_Conditions__c) {
            return new PageReference('/TOSConfirmed');
        }
        getValues();
        return null;
    }

    public boolean getIsLv() {
        return Leads.isLebensversicherung(this.l.RecordTypeId);
    }

    public List<SelectOption> getYesNo() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Ja', 'Ja'));
        o.add(new SelectOption('Nein', 'Nein'));
        return o;
    }

    public string getAgbUrl() {
        return UrlUtils.getAgbFromLead(this.l);
    }

    public PageReference confirm() {
        if (this.l == null) {
            return new PageReference('/NotFound');
        }
        getValues();
        if (this.LeadPhone == null || this.LeadPhone == '') {
			// return new PageReference('/apex/ErrorPage?h=Fehlendes Pflichtfeld&b=Bitte geben Sie eine Telefonnummmer an.');
			errorMsg = 'Bitte geben Sie eine Telefonnummer an.';
        }
        if (this.isPrivacy != true) {
            errorMsg = 'Bitte bestätigen Sie unsere AGB.';
        }
		/*
        if (this.isLegal != true && !getIsLv() ) {
            errorMsg = 'Bitte bevollmächtigen Sie J & C Anwälte.';
        }
		*/
        if (errorMsg != '') {
            System.debug('errorMsg: ' + errorMsg);
            return null;
        }
        if (this.insurance == 'Ja') {
            this.l.Has_Legal_Protection_Insurance__c = true;
            this.l.Assignment_Type__c = 'RSV';
        } else {
            this.l.Has_Legal_Protection_Insurance__c = false;
            this.l.Assignment_Type__c = 'Direkt';
        }
        this.l.Confirmed_Terms_And_Conditions__c = (this.isPrivacy == true);
        this.l.Confirmed_Authorization__c = (this.isLegal == true);
        this.l.Street = this.LeadStreet;
        this.l.City = this.LeadCity;
        this.l.PostalCode = this.LeadPostalCode;
        this.l.Phone = this.LeadPhone;
        this.l.Vehicle_Type__c = this.LeadVehicleType;
        update this.l;
        return new PageReference('/TOSConfirmed');
    }

    @TestVisible
    private lead getLead() {
        string leadId = getLeadUniqueId();
        if (leadId == null) {
            return null;
        }
        List<Lead> leads = [
            SELECT Id,
            Name,
            City,
            RecordTypeId,
            Has_Legal_Protection_Insurance__c,
            PostalCode,
            Confirmed_Terms_And_Conditions__c,
            Phone,
            MobilePhone,
            Street,
            Vehicle_Type__c
            FROM Lead
            WHERE Token__c = :leadId
        ];
        if (leads.size() != 1) {
            return null;
        }
        return leads[0];
    }

    private string getLeadUniqueId() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}