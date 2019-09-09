// Mahnung "Mahnung versenden" Button
// Cost_Note_Reminder__c "Mahnung versenden" Button
public class SendReminder {
    private final Cost_Note_Reminder__c reminder;
    private final Cost_Note__c note;
    private final Opportunity opp;

    public SendReminder(ApexPages.StandardController stdCtl) {
		this.reminder = [
            SELECT Id,
            Recipient__c,
            Opportunity_Id__c,
            Cost_Note__c
            FROM Cost_Note_Reminder__c
            WHERE Id = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id,
            RecordTypeId,
            Legal_Account__c,
            Legal_Protection_Insurance__c,
            Contact__c
            FROM Opportunity
            WHERE Id = :this.reminder.Opportunity_Id__c
        ];
        this.note = [
            SELECT Id, Recipient__c
            FROM Cost_Note__c
            WHERE Id = :this.reminder.Cost_Note__c
        ];
    }

    public PageReference renderPage() {
        if (getRec() == null) {
            if (Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
                if (this.note.Recipient__c == 'Customer') {
                    return Errors.page('Bitte tragen Sie einen Kontakt auf dem Feld "Kunde" ein (Kostennote).');
                }
            } else {
                if (this.reminder.Recipient__c == 'Customer') {
                    return Errors.page('Bitte tragen Sie einen Kontakt auf dem Feld "Kunde" ein (Mahnung).');
                }
            }
            return Errors.page('Bitte tragen Sie eine Reschtsschutzversicherung auf der Anfrage ein.');
        }
        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }
    
    private string getTpl() {
        // DG
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                if (this.reminder.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteReminderContact);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselJaegerLegalCostNoteReminderAccount);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                if (this.reminder.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteReminderContact);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselLeComLegalCostNoteReminderAccount);
            }
            if (this.reminder.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteReminderContact);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.DieselKainzLegalCostNoteReminderAccount);
        }
        // FZ
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                if (this.reminder.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.FzJaegerLegalCostNoteReminderContact);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.FzJaegerLegalCostNoteReminderAccount);
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                if (this.reminder.Recipient__c == 'Customer') {
                    return EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteReminderContact);
                }
                return EmailTemplates.idOf(EmailTemplates.CostNote.FzLeComLegalCostNoteReminderAccount);
            }
            return '';
        }
        // LV
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteReminderContact);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvKainzLegalCostNoteReminderAccount);
        }
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
            if (this.note.Recipient__c == 'Customer') {
                return EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteReminderContact);
            }
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvJaegerLegalCostNoteReminderAccount);
        }
        if (this.note.Recipient__c == 'Customer') { // LeCom
            return EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteReminderContact);
        }
        return EmailTemplates.idOf(EmailTemplates.CostNote.LvLeComLegalCostNoteReminderAccount);
    }

    private string getRec() {
        if (Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
            if (this.note.Recipient__c == 'Customer') {
                return this.opp.Contact__c;
            }
        } else {
            if (this.reminder.Recipient__c == 'Customer') {
                return this.opp.Contact__c;
            }
        }
        return this.opp.Legal_Protection_Insurance__c;
    }

    private string createUrl() {
        return
            '?id=' + this.reminder.Id +
            '&recipient=' + getRec() +
            '&tpl=' + getTpl() +
            '&hdl=Mahnung versenden' +
            '&showCostNotesList=true' +
            '&showCreateFollowUpCheckbox=true' +
            '&attreq=true';
    }
}

// 	/apex/SendMail?
// 	id={!Cost_Note_Reminder__c.Id}
// 	&recipient={!IF(TEXT(Cost_Note_Reminder__c.Recipient__c) = 'Customer',Opportunity.ContactId__c,Opportunity.Legal_Protection_InsuranceId__c)}
// 	&tpl={!
// 	IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000W0CY',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW',IF(TEXT(Cost_Note_Reminder__c.Recipient__c) = 'Customer','00X0Y000000m3TW','00X0Y000000m3F0'),IF(TEXT(Cost_Note_Reminder__c.Recipient__c) = 'Customer','00X0Y000001ab0I','00X0Y000001ab0E')),IF(Claim__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000011MYHW',IF(TEXT(Cost_Note_Reminder__c.Recipient__c) = 'Customer','00X1v000000SOGv','00X1v000000SOGq'),''),IF(Claim__c.Opportunity_Legal_Account_Id__c = '0010Y000010COcm',IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X1v000000SPnH','00X1v000000SPnC'),IF(TEXT(Cost_Note__c.Recipient__c) = 'Customer','00X1v000000SPmd','00X1v000000SPmY'))))
// 	}
// 	&hdl=Mahnung versenden
// 	&showCostNotesList=true
// 	&showCreateFollowUpCheckbox=true
// 	&attreq=true