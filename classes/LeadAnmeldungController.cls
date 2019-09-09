public class LeadAnmeldungController {
    class DieselskandalPageConfig implements ILeadAnmeldungPresenter {
        public PageReference nextPage() {
            return new PageReference('/Dieselskandal3');
        }
        
        public string getPageTitle() {
            return 'Dieselskandal';
        }
        
        public string getPageHeader() {
            return 'Betroffen vom Dieselskandal';
        }
        
        public string getStepName() {
            return 'ANGABEN ZUM AUTO';
        }
    }
    
    class LebensversicherungPageConfig implements ILeadAnmeldungPresenter {
        public PageReference nextPage() {
            return new PageReference('/LebensversicherungErgebniss');
        }
        
        public string getPageTitle() {
            return 'Lebensversicherung';
        }
        
        public string getPageHeader() {
            return 'Lebensversicherung widerrufen';
        }
        
        public string getStepName() {
            return 'ANGABEN ZUR LEBENSVERSICHERUNG';
        }
    }

    public string dieselCode { get; set; }
    public string firstname { get; set; }
    public string lastname { get; set; }
    public string email { get; set; }
    public boolean newsletter { get; set; }
    public boolean privacy { get; set; }
    public boolean errorPrivacy { get; set; }
    public string title { get; set; }
    public string commType { get; set; }
    public string[] timeSel;
    public boolean tos { get; set; }
    public boolean authorization { get; set; }
    public string phone { get; set; }

    @testvisible
    private ILeadAnmeldungPresenter pageConfig;

    public LeadAnmeldungController() {
        this.timeSel = new List<String>();
    }
    
    public PageReference ensureLeadExists() {
        if (fetchLeadFromToken() == null) {
            return new PageReference('/NotFound');
        }
        return null;
    }
    
    public string getToken() {
        return ApexPages.currentPage().getParameters().get('token');
    }

    public string getAgbUrl() {
		Lead l = fetchLeadFromToken();
        return UrlUtils.getAgbFromLead(l);
    }
    
    public ILeadAnmeldungPresenter getPageConfig() {
        if (this.pageConfig == null) {
            initPageConfig();
        }
        
        return this.pageConfig;
    }
    
    private void initPageConfig() {
        Lead l = fetchLeadFromToken();
        
        if (l == null) {
            return;
        }
        
        if (Leads.isLebensversicherung(l.RecordTypeId)) {
            this.pageConfig = new LebensversicherungPageConfig();
        } else {
            this.pageConfig = new DieselskandalPageConfig();
        }
    }

    private Lead fetchLeadFromToken() {
        string token = getToken();
        if (token == null || token == '') {
            return null;
        }
        List<Lead> leads = [
            SELECT Id,
            Name,
            RecordTypeId,
            Has_Legal_Protection_Insurance__c 
            FROM Lead
            WHERE Token__c = :token
        ];
        if (leads.size() == 0) {
            return null;
        }
        return leads[0];
    }

    public PageReference updateLead() {
        Lead l = fetchLeadFromToken();
        if (this.privacy == false) {
            errorPrivacy = true;
            return null;
        }
        if (l == null) {
            return new PageReference('/NotFound');
        }
        l.Diesel_Code__c = this.dieselCode;
        l.Confirmed_Terms_And_Conditions__c = (this.tos == true);
        l.Confirmed_Authorization__c = (this.authorization == true);
        l.Confirmed_Privacy_Statement__c = (this.privacy == true);
        l.Follow_up_Period__c = 2;
        l.Phone = this.phone;
        l.Email = this.email;
        l.FirstName = this.firstName;
        l.LastName = this.LastName;
        l.Title = this.title;
        l.Company = this.firstName + ' ' + this.lastName;
        l.Availability__c = String.join(this.timeSel, ';');
        if (this.newsletter) {
            l.Newsletter_Registration_Date__c = System.today();
            l.Newsletter_Registered__c = true;
        }
        update l;

        if (Leads.isLebensversicherung(l.RecordTypeId)) { // 0121t000000EBhLAAW
            LeadConversion.convert(new List<Id>{l.Id});
        }

        return getPageConfig().nextPage();
    }
    
    public String[] getTimeSel() {
        return this.timeSel;
    }
    
    public void setTimeSel(String[] timeSel) {
        this.timeSel = timeSel;
    }

    public List<SelectOption> getCodeOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('kein Code', 'kein Code'));
        o.add(new SelectOption('DIESEL1', 'DIESEL1'));
        o.add(new SelectOption('DIESEL2', 'DIESEL2'));
        o.add(new SelectOption('DIESEL3', 'DIESEL3'));
        return o;
    }

    public List<SelectOption> getTitleOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Herr', 'Herr'));
        o.add(new SelectOption('Frau', 'Frau'));
        o.add(new SelectOption('Divers', 'Ich möchte keine Angaben machen'));
        return o;
    }

    public List<SelectOption> getCommOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('E-Mail', 'E-Mail'));
        o.add(new SelectOption('Telefon', 'Telefon'));
        return o;
    }
     
    public List<SelectOption> getTimeOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('vormittags', '9 bis 12 Uhr'));
        o.add(new SelectOption('mittags', '12 bis 15 Uhr'));
        o.add(new SelectOption('nachmittags', '15 bis 18 Uhr'));
        o.add(new SelectOption('abends', 'nach 18 Uhr'));
        return o;
    }
}