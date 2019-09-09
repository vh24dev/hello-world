public class WiderrufLeadController {
    public string question_a { get; set; }
    public string question_b { get; set; }
    public string question_c { get; set; }
    public string question_d { get; set; }

    public string firstname { get; set; }
    public string lastname { get; set; }
    public string email { get; set; }
    public string phone { get; set; }

    public boolean legalInsurance { get; set; }
    public boolean privacy { get; set; }
    public boolean newsletter { get; set; }

    public boolean isError {get; set;}
    public string errorMsg {get; set;}

    public List<SelectOption> getYesNo() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Ja', 'Ja'));
        o.add(new SelectOption('Nein', 'Nein'));
        return o;
    }

    public List<SelectOption> getNoYes() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Nein', 'Nein'));
        o.add(new SelectOption('Ja', 'Ja'));
        return o;
    }

    public List<SelectOption> getNoYesNope() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('Nein', 'Nein'));
        o.add(new SelectOption('Ja', 'Ja'));
        o.add(new SelectOption('Kann ich nicht beurteilen', 'Kann ich nicht beurteilen'));
        return o;
    }

    public List<SelectOption> getInsurersDynamic()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.Versicherung_LV_RV__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
            System.debug('label [' + f.getLabel() + '] value [' + f.getValue() + ']');
        }       
        return options;
    }

    private boolean isEmpty(string s) {
        if (s == null  || s == '') {
            return true;
        }
        return false;
    }

    public PageReference createLead() {
        errorMsg = '';
        if (isEmpty(this.question_a)) {
            errorMsg = 'Bitte geben Sie an ob Sie mit der Entwicklung der Rendite zufrieden sind.';
        }
        if (isEmpty(this.question_b)) {
            errorMsg = 'Bitte geben Sie an wann Sie ihre Versicherung abgeschlossen haben.';
        }
        if (isEmpty(this.question_c)) {
            errorMsg = 'Bitte geben Sie an ob Ihre Versicherung Bestandteil einer betrieblichen Altersvorsorge ist.';
        }
        if (isEmpty(this.question_d)) {
            errorMsg = 'Bitte geben Sie an bei welcher Versicherung Sie Ihre Lebens- oder Rentenversicherung abgeschlossen haben.';
        }
        if (isEmpty(this.firstname)) {
			errorMsg = 'Vorname ist ein Pflichtfeld.';
        }
        if (isEmpty(this.lastname)) {
            errorMsg = 'Nachname ist ein Pflichtfeld.';
        }
        if (isEmpty(this.email)) {
            errorMsg = 'Email ist ein Pflichtfeld.';
        }
        if (isEmpty(this.phone)) {
            errorMsg = 'Telefonnummer ist ein Pflichtfeld.';
        }
        if (this.legalInsurance == null) {
            errorMsg = 'Rechtschutzversicherung ist ein Pflichtfeld.';
        }
        if (this.privacy != true) {
            errorMsg = 'Bitte bestätigen Sie die Datenschutzerklärung.';
        }
        if (errorMsg != '') {
            isError = true;
            return null;
        }
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Lebensversicherung' AND sObjectType = 'Lead'];
        Lead l = new Lead(
            RecordTypeId = rt.Id,
            LeadSource = 'Webform',
            Status = 'New',
            Company = this.firstname + ', ' + this.lastname + ', Lebensversicherung',
            Sales_Type__c = 'Online',
            Zufriedenheit_Renditenentwicklung__c = this.question_a,
            Abschluss_zwischen_1991_2007__c = this.question_b,
            Bestandteil_betriebl_Altersvorsorge__c = this.question_c,
            Versicherung_LV_RV__c = this.question_d,
            FirstName = this.firstname,
            LastName = this.lastname,
            Email = this.email,
            Phone = this.phone,
            Has_Legal_Protection_Insurance__c = (this.legalInsurance == true),
            Confirmed_Privacy_Statement__c = (this.privacy == true)
        );
        if (this.newsletter == true) {
            l.Newsletter_Registered__c = true;
            l.Newsletter_Registration_Date__c = System.Today();
        }
        insert l;
        PageReference pr = new PageReference('/WiderrufLead2');
        return pr;
    }

    public PageReference goBack() {
        return new PageReference('/WiderrufLead');
    }
}