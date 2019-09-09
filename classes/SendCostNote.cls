// Cost_Note__c "Kostennote versenden" Button
// Kostennote "Kostennote versenden" Button
public class SendCostNote {
    private final Cost_Note__c note;
    private final Opportunity noteOpp;
    private final Opportunity claimOpp;
    private final Claim__c claim;

    public SendCostNote(ApexPages.StandardController stdCtl) {
        this.note = [
            SELECT Id,
            Opportunity_Id__c,
            Claim__c,
            Recipient__c
            FROM Cost_Note__c
            WHERE Id = :stdCtl.getId()
        ];
        this.noteOpp = [
            SELECT Id,
            RecordTypeId,
            Legal_Protection_Insurance__c,
            Contact__c
            FROM Opportunity
            WHERE Id = :this.note.Opportunity_Id__c
        ];
        this.claim = [
            SELECT Id, Opportunity__c
            FROM Claim__c
            WHERE Id = :this.note.Claim__c
        ];
        this.claimOpp = [
            SELECT Id,
            Legal_Account__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (getRec() == null) {
            if (this.note.Recipient__c == 'Legal Protection Insurance') {
                return Errors.page('Bitte tragen Sie eine "Rechtsschutzversicherung" auf der Anfrage ein.');
            }
            return Errors.page('Bitte tragen Sie ein Kontakt auf dem Feld "Kunde" ein.');
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        // Dieselskandal
        if (Opportunities.isDieselSkandal(this.noteOpp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.claimOpp.Legal_Account__c)) { // 0010Y000011MYHW
                if (this.note.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteCustomer);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteInsurance);
            }
            if (Accounts.isLegalLeCom(this.claimOpp.Legal_Account__c)) {
                if (this.note.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteCustomer);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteInsurance);
            }
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteCustomer);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteInsurance);
        }
        // Finanzierung
        if (Opportunities.isFinanzierung(this.noteOpp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.claimOpp.Legal_Account__c)) { // 0010Y000011MYHW
                if (this.note.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.FzJaegerLegalCostNoteCustomer);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.FzJaegerLegalCostNoteInsurance);
            }
            if (Accounts.isLegalLeCom(this.claimOpp.Legal_Account__c)) {
                if (this.note.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteCustomer);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteInsurance);
            }
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.FzKainzLegalCostNoteCustomer);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.FzKainzLegalCostNoteInsurance);
        }
        // Lebensversicherung
        if (Accounts.isJCLegal(this.claimOpp.Legal_Account__c)) {
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteCustomer);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteInsurance);
        }
        if (Accounts.isLegalLeCom(this.claimOpp.Legal_Account__c)) {
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteCustomer);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvLecomLegalCostNoteInsurance);
        }
        if (this.note.Recipient__c == 'Customer') {
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteCustomer);
        }
        return EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteInsurance);
    }

    private string getRec() {
        if (this.note.Recipient__c == 'Legal Protection Insurance') {
            return this.noteOpp.Legal_Protection_Insurance__c;
        }
        return this.noteOpp.Contact__c;
    }

    private string createUrl() {
        return
            '?id=' + this.note.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + getRec() +
            '&hdl=Kostennote versenden' +
            '&showDocumentsList=true' +
            '&showCorrespondenciesList=true' +
            '&showReceiptsList=true' +
            '&showDatesList=true' +
            '&showOpportunityAttachmentsList=true' +
            '&showAuthorizationsList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
    }
}

//  /apex/SendMail
//  ?id={!Cost_Note__c.Id}
//  &recipient={!
//  IF(TEXT(Cost_Note__c.Recipient__c) = 'Legal Protection Insurance',Opportunity.Legal_Protection_InsuranceId__c,Opportunity.ContactId__c)
//  }
//  &tpl={!
//  IF(Cost_Note__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW',IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X0Y000000dmVM','00X0Y000000dmVN'),IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X0Y000001ab0r','00X0Y000001ab0s')),IF(Cost_Note__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW',IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X1v000000SOGg','00X1v000000SOGl'),''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm',IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X0Y000000yAWC','00X0Y000000yAWD'),IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X0Y000000s6zj','00X0Y000000s6zk'))))
//  }
//  &hdl=Kostennote versenden
//  &showDocumentsList=true
//  &showCorrespondenciesList=true
//  &showReceiptsList=true
//  &showDatesList=true
//  &showOpportunityAttachmentsList=true
//  &showAuthorizationsList=true
//  &showCreateFollowUpCheckbox=true
//  &attreq=true