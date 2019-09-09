// Korrespondenz "Per Email versenden" Button
// Correspondence__c "Per Email versenden" Button
public class CorrSendDocToPartner {
    private final Correspondence__c corr;
    private final Claim__c claim;
    private final Opportunity opp;
    string errorMsg;

    public CorrSendDocToPartner(ApexPages.StandardController stdCtl) {
        this.errorMsg = 'Unbekannter Fehler';
        this.corr = [
            SELECT Id, Claim__c, Claim_Competent_Court__c, Partner__c, Opportunity_Account_Id__c, Type__c
            FROM Correspondence__c
            WHERE Id = :stdCtl.getId()
        ];
        this.claim = [
            SELECT Id, Opportunity__c, Court__c, Court_Customer__c, Opposing_Counsel__c
            FROM Claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        this.opp = [
            SELECT Id, Insurance__c, Vehicle_Brand__c, Bank__c, Legal_Protection_Insurance__c, Contact__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        string rec = getRecipient();
        if (rec == null) {
            return Errors.page('Empfänger nicht gefunden.', this.errorMsg);
        }
        string url = page.sendMail.getUrl() + createUrl(rec);
        return new PageReference(url);
    }

    private string getRecipient() {
        if (this.corr.Partner__c == 'Court') {
            if (this.corr.Claim_Competent_Court__c == 'Opponent') {
                if (this.claim.Court__c != null) {
                    return this.claim.Court__c;
                }
                this.errorMsg = 'Bitte tragen Sie ein "Gericht des Gegners" ein.';
                return null;
            }
            if (this.claim.Court_Customer__c != null) {
                return this.claim.Court_Customer__c;
            }
            this.errorMsg = 'Bitte tragen Sie ein "Gericht des Kunden" ein.';
            return null;
        }
        if (this.corr.Partner__c == 'Insurance') {
            if (this.claim.Opposing_Counsel__c != null) {
                return this.claim.Opposing_Counsel__c;
            }
            if (this.opp.Insurance__c != null) {
                return this.opp.Insurance__c;
            }
            this.errorMsg = 'Bitte tragen Sie eine "Versicherung" auf der Anfrage oder ein "Korrespondenzanwalt" auf dem Fall ein.';
            return null;
        }
        if (this.corr.Partner__c == 'Vehicle Brand') {
            if (this.claim.Opposing_Counsel__c != null) {
                return this.claim.Opposing_Counsel__c;
            }
            return this.opp.Vehicle_Brand__c;
        }
        if (this.corr.Partner__c == 'Bank') {
            if (this.opp.Bank__c != null) {
                return this.opp.Bank__c;
            }
            this.errorMsg = 'Bitte hinterlegen Sie ein "Kreditinstitut" auf der Anfrage ein.';
            return null;
        }
        if (this.corr.Partner__c == 'Legal Protection Insurance') {
            if (this.opp.Legal_Protection_Insurance__c != null) {
                return this.opp.Legal_Protection_Insurance__c;
            }
            this.errorMsg = 'Bitte hinterlegen Sie eine "Rechtsschutzversicherung" auf der Anfrage.';
            return null;
        }
        if (this.corr.Partner__c == 'Customer') {
            if (this.opp.Contact__c != null) {
                return this.opp.Contact__c;
            }
            this.errorMsg = 'Bitte tragen Sie einen "Kunden" auf der Anfrage ein.';
            return null;
        }
        if (this.corr.Partner__c == null) {
            this.errorMsg = 'Bitte tragen Sie einen "Partner" auf der Korrespondenz ein.';
            return null;
        }
        this.errorMsg = 'Es wurde kein Empfänger gefunden.';
        return null;
    }

    private string getHDL() {
        return this.corr.Type__c + ' versenden.';
    }

    private string getBCC() {
        if (Accounts.isVH24(this.corr.Opportunity_Account_Id__c)) { // 0010Y00000eCUS9
            return 'RA-abgas@verbraucherhilfe24.de';
        }
        return '';
    }

    private string createUrl(string rec) {
        return
            '?id=' + corr.Id +
            '&tpl=auto' +
            '&recipient=' + rec +
            '&hdl=' + getHDL() +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showCostNotesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&bcc=' + getBCC() +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Correspondence__c.Id}
// &recipient={!
// IF(TEXT(Correspondence__c.Partner__c) = 'Court',IF(Correspondence__c.Claim_Competent_Court__c = 'Opponent',IF(Claim__c.Court__c != null,Claim__c.CourtId__c,null),IF(Claim__c.Court_Customer__c != null,Claim__c.Court_CustomerId__c,null)),IF(TEXT(Correspondence__c.Partner__c) = 'Insurance',IF(Claim__c.Opposing_Counsel__c != null,Claim__c.Opposing_CounselId__c,Opportunity.InsuranceId__c),IF(TEXT(Correspondence__c.Partner__c) = 'Vehicle Brand',IF(Claim__c.Opposing_Counsel__c != null,Claim__c.Opposing_CounselId__c,Opportunity.Vehicle_BrandId__c),IF(TEXT(Correspondence__c.Partner__c) = 'Bank',IF(Opportunity.Bank__c != null,Opportunity.BankId__c,null),IF(TEXT(Correspondence__c.Partner__c) = 'Legal Protection Insurance',IF(Opportunity.Legal_Protection_Insurance__c != null,Opportunity.Legal_Protection_InsuranceId__c,null),IF(TEXT(Correspondence__c.Partner__c) = 'Customer',IF(Opportunity.Contact__c != null,Opportunity.ContactId__c,null),null))))))
// }
// &hdl={!Correspondence__c.Type__c} versenden
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showCostNotesList=true
// &showReceiptsList=true
// &showDatesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &&bcc={!IF(Correspondence__c.Opportunity_Account_Id__c = '0010Y00000eCUS9','RA-abgas@verbraucherhilfe24.de','')}
// &tpl=auto
// &showCreateFollowUpCheckbox=true
// &attreq=true