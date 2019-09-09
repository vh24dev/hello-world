// Correspondence__c "Per Brief oder Fax versenden" Button
// Korrespondenz "Per Brief oder Fax versenden" Button
public class SendDocViaLetterOrFax {
    private final Correspondence__c corr;
    private final Claim__c claim;
    private final Opportunity opp;
    public string errorMsg {get; set;}
    private string recipient;

    public SendDocViaLetterOrFax(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.corr = [
            SELECT ID,
            Claim__c,
            Type__c,
            Partner__c,
            Claim_Competent_Court__c
            FROM Correspondence__c
            WHERE ID = :stdCtl.getId()
        ];
        this.claim = [
            SELECT Id,
            Opportunity__c,
            RecordTypeId,
            Opposing_Counsel__c,
            Court_Customer__c,
            Court__c,
            Vehicle_Brand__c
            FROM Claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        this.opp = [
            SELECT Id,
            Contact__c,
            Insurance__c,
            Bank__c,
            RecordTypeId,
            Vehicle_Brand__c,
            Legal_Protection_Insurance__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        this.recipient = getRec();
        if (errorMsg != '') {
            return Null;
        }
        string url = page.SendLetterOrFax.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getHdl() {
        if (this.corr.Type__c == 'Widerspruch durch Kunden') {
            return 'Widerspruch durch Kunden versenden.';
        }
        if (this.corr.Type__c == 'Deckungsanfrage für Widerspruch') {
            return 'Deckungsanfrage für Widerspruch versenden.';
        }
        if (this.corr.Type__c == 'Widerspruch durch Anwalt') {
            return 'Widerspruch durch Anwalt versenden.';
        }
        if (this.corr.Type__c == 'Deckungsanfrage für Klage') {
            return 'Deckungsanfrage für Klage versenden.';
        }
        if (this.corr.Type__c == 'Klageschrift') {
            return 'Klageschrift versenden.';
        }
        return 'Dokument versenden.';
    }

    private string getRec() {
        if (this.corr.Partner__c == 'Court') {
            if (this.corr.Claim_Competent_Court__c == 'Opponent') {
                if (this.claim.Court__c != null) {
                    return this.claim.Court__c;
                }
                errorMsg = 'ein Gericht des Gegners auf dem Fall';
                return null;
            }
            if (this.claim.Court_Customer__c != null) {
                return this.claim.Court_Customer__c;
            }
            errorMsg = 'ein Gericht des Kunden auf dem Fall';
            return null;
        }
        if (this.corr.Partner__c == 'Insurance') {
            if (this.claim.Opposing_Counsel__c != null) {
                return this.claim.Opposing_Counsel__c;
            }
            errorMsg = 'einen Korrespondenzanwalt auf dem Fall';
            return this.opp.Insurance__c;
        }
        if (this.corr.Partner__c == 'Vehicle Brand') {
            if (this.claim.Vehicle_Brand__c != null) {
                return this.claim.Vehicle_Brand__c;
            }
            errorMsg = 'einen Fahrzeughersteller auf dem Fall';
            return this.opp.Vehicle_Brand__c;
        }
        if (this.corr.Partner__c == 'Bank') {
            if (this.opp.Bank__c != null) {
                return this.opp.Bank__c;
            }
            errorMsg = 'ein Kreditinstitut auf der Anfrage';
            return null;
        }
        if (this.corr.Partner__c == 'Legal Protection Insurance') {
            if (this.opp.Legal_Protection_Insurance__c != null) {
                return this.opp.Legal_Protection_Insurance__c;
            }
            errorMsg = 'eine RSV auf der Anfrage';
            return null;
        }
        if (this.corr.Partner__c == 'Customer') {
            if (this.opp.Contact__c != null) {
                return this.opp.Contact__c;
            }
            errorMsg = 'einen Kunden auf der Anfrage';
            return null;
        }
        errorMsg = 'den wert "Gericht", "Versicherung", "Fahrzeughersteller", "Kreditinstitut", "Rechtsschutzversicherung" oder "Kunde" als Partner auf der Anfrage';
        return null;
    }

    private string getBcc() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) {
            return 'RA-abgas@verbraucherhilfe24.de';
        }
        return '';
    }

    private string createUrl() {
        return
            '?id=' + corr.Id +
            '&recipient=' + this.recipient +
            '&hdl=' + getHdl() + 
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCostNotesList' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&restrictFileTypes=true' +
            '&bcc=' + getBcc();
    }
}

// /apex/SendLetterOrFax?id={!Correspondence__c.Id}
// &recipient={!IF(TEXT(Correspondence__c.Partner__c) = 'Court',IF(Correspondence__c.Claim_Competent_Court__c = 'Opponent',IF(Claim__c.Court__c != null,Claim__c.CourtId__c,null),IF(Claim__c.Court_Customer__c != null,Claim__c.Court_CustomerId__c,null)),IF(TEXT(Correspondence__c.Partner__c) = 'Insurance',IF(Claim__c.Opposing_Counsel__c != null,Claim__c.Opposing_CounselId__c,Opportunity.InsuranceId__c),IF(TEXT(Correspondence__c.Partner__c) = 'Vehicle Brand',IF(Claim__c.Opposing_Counsel__c != null,Claim__c.Opposing_CounselId__c,Opportunity.Vehicle_BrandId__c),IF(TEXT(Correspondence__c.Partner__c) = 'Bank',IF(Opportunity.Bank__c != null,Opportunity.BankId__c,null),IF(TEXT(Correspondence__c.Partner__c) = 'Legal Protection Insurance',IF(Opportunity.Legal_Protection_Insurance__c != null,Opportunity.Legal_Protection_InsuranceId__c,null),IF(TEXT(Correspondence__c.Partner__c) = 'Customer',IF(Opportunity.Contact__c != null,Opportunity.ContactId__c,null),null))))))}
// &hdl={!IF(TEXT(Correspondence__c.Type__c) = 'Widerspruch durch Kunden','Widerspruch durch Kunden versenden.',IF(TEXT(Correspondence__c.Type__c) = 'Deckungsanfrage für Widerspruch','Deckungsanfrage für Widerspruch versenden.',IF(TEXT(Correspondence__c.Type__c) = 'Widerspruch durch Anwalt','Widerspruch durch Anwalt versenden.',IF(TEXT(Correspondence__c.Type__c) = 'Deckungsanfrage für Klage','Deckungsanfrage für Klage versenden.',IF(TEXT(Correspondence__c.Type__c) = 'Klageschrift','Klageschrift versenden.','Dokument versenden.')))))}
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &showCostNotesList
// &showReceiptsList=true
// &showDatesList=true
// &restrictFileTypes=true
// &bcc={!IF(Correspondence__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY','RA-abgas@verbraucherhilfe24.de','')}