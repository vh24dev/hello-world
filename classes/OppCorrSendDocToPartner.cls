// Opportunity_Correspondence__c "Per Email versenden" Button
// Anfrage Korrespondenz "Per Email versenden" Button
public class OppCorrSendDocToPartner {
    private final Opportunity_Correspondence__c oppcorr;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public OppCorrSendDocToPartner(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.oppcorr = [
            SELECT ID,
            Opportunity__c,
            Partner__c
            FROM Opportunity_Correspondence__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT ID,
            RecordTypeId,
            Legal_Account__c,
            Vehicle_Brand__c,
            Legal_Protection_Insurance__c,
            Insurance__c,
            Contact__c,
            Bank__c
            FROM Opportunity
            WHERE ID = :this.oppcorr.Opportunity__c
        ];
    }
    
    public PageReference renderPage() {
        if (errorMsg != '') {
            return Null;
        }
        string url = page.SendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalAnfrageKorrespondenz);
            }
            if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
                return EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalAnfrageKorrespondenz);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.DieselLeComLegalAnfrageKorrespondenz);
            }
            return '';
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.name.FzJaegerLegalAnfrageKorrespondenz);
            }
            if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.FzKainzLegalAnfrageKorrespondenz);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.FzLeComLegalAnfrageKorrespondenz);
            }
            return '';
        }
        if (Accounts.isJCLegalLv(this.opp.Legal_Account__c)) { // 0010Y000010BXGZ
            return EmailTemplates.idOf(EmailTemplates.name.LvJaegerLegalAnfrageKorrespondenz);
        }
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.name.LvKainzLegalAnfrageKorrespondenz);
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.name.LvLeComLegalAnfrageKorrespondenz);
        }
        return '';
    }

    private string getRec() {
        if (this.oppcorr.Partner__c == 'Vehicle Brand') {
            if (this.opp.Vehicle_Brand__c != null) {
                return this.opp.Vehicle_Brand__c;
            }
            errorMsg = 'einen "Fahrzeughersteller" auf der Anfrage';
            return null;
        }
        if (this.oppcorr.Partner__c == 'Bank') {
            if (this.opp.Bank__c != null) {
                return this.opp.Bank__c;
            }
            errorMsg = 'ein "Kreditinstitut" auf der Anfrage';
            return null;
        }
        if (this.oppcorr.Partner__c == 'Legal Protection Insurance') {
            if (this.opp.Legal_Protection_Insurance__c != null) {
                return this.opp.Legal_Protection_Insurance__c;
            }
            errorMsg = 'eine "Rechtsschutzversicherung" auf der Anfrage';
            return null;
        }
        if (this.oppcorr.Partner__c == 'Insurance') {
            if (this.opp.Insurance__c != null) {
                return this.opp.Insurance__c;
            }
            errorMsg = 'eine "Versicherung" auf der Anfrage';
            return null;
        }
        if (this.oppcorr.Partner__c == 'Customer') {
            if (this.opp.Contact__c != null) {
                return this.opp.Contact__c;
            }
            errorMsg = 'einen Kontakt auf dem feld "Kunde" der Anfrage';
            return null;
        }
        errorMsg = '"Versicherung", "Fahrzeughersteller", "Kreditinstitut", "Rechtsschutzversicherung" oder "Kunde" auf der Korrespondenz als Partner';
        return null;
    }

    private string createUrl() {
        return
            '?id=' + oppcorr.Id +
            '&recipient=' + getRec() +
            '&hdl=Korrespondenz versenden' +
            '&showDocumentsList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&tpl=' + getTpl() +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Opportunity_Correspondence__c.Id}
// &recipient={!
// IF(TEXT(Opportunity_Correspondence__c.Partner__c) = 'Vehicle Brand',IF(Opportunity.Vehicle_Brand__c != null,Opportunity.Vehicle_BrandId__c,null),IF(TEXT(Opportunity_Correspondence__c.Partner__c) = 'Bank',IF(Opportunity.Bank__c != null,Opportunity.BankId__c,null),IF(TEXT(Opportunity_Correspondence__c.Partner__c) = 'Legal Protection Insurance',IF(Opportunity.Legal_Protection_Insurance__c != null,Opportunity.Legal_Protection_InsuranceId__c,null),IF(TEXT(Opportunity_Correspondence__c.Partner__c) = 'Insurance',IF(Opportunity.Insurance__c != null,Opportunity.InsuranceId__c,null),IF(TEXT(Opportunity_Correspondence__c.Partner__c) = 'Customer',IF(Opportunity.Contact__c != null,Opportunity.ContactId__c,null),null)))))
// }
// &hdl=Korrespondenz versenden
// &showDocumentsList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &tpl={!
// IF(Opportunity.RecordTypeId = '0120Y000000W0CY',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000OQW8',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X1v000000OQWI','')),IF(Opportunity.RecordTypeId = '0120Y000000KnMH',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000STrh',''),IF(Opportunity.Legal_AccountId__c = '0010Y000010BXGZ','00X1v000000OPoQ',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X1v000000OPoV',''))))
// }
// &showCreateFollowUpCheckbox=true
// &attreq=true