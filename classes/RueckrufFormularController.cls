public class RueckrufFormularController {
    private Opportunity o;
    private Lead l;
    private boolean isLead;

    public PageReference init() {
        getObject();
        if (!isLead && this.o == null) {
            return new PageReference('/NotFound');
        }
        if (isLead && this.l == null) {
            return new PageReference('/NotFound');
        }
        return null;
    }
    
    public String[] getTimeSel() {
        string timeSel;
        if (this.o == null) {
            timeSel = this.l.Availability__c;
        } else {
            timeSel = this.o.Availability__c;
        }
        
        if (timeSel == null) {
            return new List<String>();
        } else {
            return timeSel.split(';');
        }
    }
    
    public void setTimeSel(String[] timeSel) {
        string timeSelStr = String.join(timeSel, ';');
        if (this.o == null) {
            if (this.l != null) {
                this.l.Availability__c = timeSelStr;   
            }
        } else {
            this.o.Availability__c = timeSelStr;
        }
    }
     
    public List<SelectOption> getTimeOptions() {
        List<SelectOption> o = new List<SelectOption>();
        o.add(new SelectOption('vormittags', '9 bis 12 Uhr'));
        o.add(new SelectOption('mittags', '12 bis 15 Uhr'));
        o.add(new SelectOption('nachmittags', '15 bis 18 Uhr'));
        o.add(new SelectOption('abends', 'nach 18 Uhr'));
        return o;
    }

    public string getMailBody(Contact con) {
        string availability = '';
        string num = '';
        string name = '';
        if (this.l != null) {
            availability = this.l.Availability__c;
            num = this.l.Bearbeitungsnummer__c;
        } else if (this.o != null) {
            availability = this.o.Availability__c;
            name = this.o.Name;
            num = this.o.Number__c;
        }
        string mailBody = 'Bearbeitungsnummer: ' + num + '\n\n'
            + con.FirstName + ' ' + con.LastName + ' ' + name + ' bittet um Rückruf: \n'
            + 'Telefon: ' + con.Phone + '\n'
            + 'Email: ' + con.Email + '\n';
        if (availability != null && availability != '') {
            mailBody += 'Verfügbarkeit: ' + availability + '\n';
        }
        return mailBody;
    }

    public PageReference confirm() {
        if (!isLead && this.o == null) {
            return new PageReference('/NotFound');
        }
        if (isLead && this.l == null) {
            return new PageReference('/NotFound');
        }
        Contact con;
        if (isLead) {
            con = new Contact(
                FirstName = this.l.FirstName,
                LastName = this.l.LastName,
                Phone = this.l.Phone,
                Email = this.l.Email
            );
        } else {
            List<Contact> cons = [
                SELECT Id,
                FirstName,
                LastName,
                Phone,
                Email
                FROM Contact
                WHERE Id = :this.o.Contact__c
            ];
            if (cons.size() == 0) {
                return new PageReference('/ErrorPage?h=Kunde nicht gefunden&b=Bitte geben Sie einen gültigen Kontakt an.');
            }
            con = cons[0];
        }
        SendMail s = new SendMail();
        string bearbeitungsNummer = isLead ? this.l.Bearbeitungsnummer__c : this.o.Number__c;
        string mailSubject = 'Fwd: ' + bearbeitungsNummer + ': Rückruf an ' + con.Phone;
        s.Send('callbackvh24@gmail.com', mailSubject, getMailBody(con));
        return new PageReference('/RueckrufFormularFertig');
    }

    private Opportunity getOpp(string objID) {
        List<Opportunity> opps = [
            SELECT Id, Contact__c, Availability__c, Number__c, Name
            FROM Opportunity
            WHERE Token__c = :objID
        ];
        if (opps.size() == 0) {
            return null;
        }
        return opps[0];
    }

    private Lead getLead(string objID) {
        List<Lead> leads = [
            SELECT Id,
            Availability__c,
            Name,
            FirstName,
            LastName,
            Bearbeitungsnummer__c,
            Phone,
            Email
            FROM Lead
            WHERE Token__c = :objID
        ];
        if (leads.size() == 0) {
            return null;
        }
        return leads[0];
    }

    private boolean getObject() {
        isLead = true;
        string objId = ApexPages.currentPage().getParameters().get('token');
        if (objId == null) {
            return false;
        }
        o = getOpp(objID);
        if (o != null) {
            isLead = false;
            return true;
        }
        this.l = getLead(objID);
        return this.l != null;
    }
}