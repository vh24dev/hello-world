public class LebensversicherungLeadController {
    public string satisfaction { get; set; }
    public string insuranceDate { get; set; }
    public string companyRetirementPlan { get; set; }
    public string insuranceCompany { get; set; }
    public string hasLegalInsurance { get; set; }
    public string legalInsuranceCompany { get; set; }

    public LebensversicherungLeadController() {
    }

    public PageReference ensureLeadExists() {
        if (fetchLeadFromToken() == null) {
            return new PageReference('/NotFound');
        }
        return null;
    }

    public List<SelectOption> getSatisfactionOptions() {
        return SObjectIntrospection.getUnsortedSelectOptions(new Lead(), 'Zufriedenheit_Renditenentwicklung__c');
    }

    public List<SelectOption> getInsuranceDateOptions() {
        return SObjectIntrospection.getSelectOptions(new Lead(), 'Abschluss_zwischen_1991_2007__c');
    }

    public List<SelectOption> getCompanyRetirementPlanOptions() {
        return SObjectIntrospection.getSelectOptions(new Lead(), 'Bestandteil_betriebl_Altersvorsorge__c');
    }

    public List<SelectOption> getInsuranceCompanyOptions() {
        return SObjectIntrospection.getSelectOptions(new Lead(RecordTypeId = getRecordTypeId()), 'Versicherung_LV_RV__c');
    }

    public List<SelectOption> getLegalInsuranceOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Ja', 'Ja'));
        o.add(new SelectOption('Nein', 'Nein'));
        return o;
    }

    private Lead fetchLeadFromToken() {
        string token = getToken();
        if (token == null || token == '') {
            return null;
        }
        List<Lead> leads = [
            SELECT Name
            FROM Lead
            WHERE Token__c = :token
        ];
        if (leads.size() == 0) {
            return null;
        }
        return leads[0];
    }

    private id getRecordTypeId() {
        RecordType rt = [
            SELECT Id
            FROM RecordType
            WHERE Name = 'Lebensversicherung'
            AND SObjectType = 'Lead'
        ];
        return rt.Id;
    }

    public PageReference createLead() {
        Lead l = new Lead(
            Company = 	'WebformLV still Unknown',
            FirstName = 'WebformLV still Unknown',
            LastName = 	'WebformLV still Unknown',
            Account__c = Accounts.VH24ID,
            LeadSource = 'Webform',
            RecordTypeId = getRecordTypeId(),
            Zufriedenheit_Renditenentwicklung__c = this.satisfaction,
            Abschluss_zwischen_1991_2007__c = this.insuranceDate,
            Bestandteil_betriebl_Altersvorsorge__c = this.companyRetirementPlan,
            Versicherung_LV_RV__c = this.insuranceCompany,
            Has_Legal_Protection_Insurance__c = (this.hasLegalInsurance == 'Ja'),
            Legal_Protection_Insurance__c = this.legalInsuranceCompany
        );
        l = UrlUtils.setLeadFields(l);
        insert l;
        l = [SELECT id, Token__c FROM Lead WHERE Id = :l.Id];
        return new PageReference('/LebensversicherungZwischenseite?token=' + l.Token__c);
    }

    public string getToken() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}