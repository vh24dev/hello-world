// Opportunity__c "Vertrag anfordern" Button
// Anfrage "Vertrag anfordern" Button
public class OppRequestContract {
    private final Opportunity opp;

    public OppRequestContract(ApexPages.StandardController stdCtl) {
        this.opp = [
            SELECT ID,
            RecordTypeId,
            StageName,
            Legal__c,
            Legal_Account__c,
            Contact__c,
            Priority_Level__c,
            Insurance_Status__c,
            Backoffice__c,
            Backoffice__r.isActive
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    private string getTemplate() {
        if (Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
            if (Accounts.isJCLegalLv(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.LvJaegerLegalAnfrageKorrespondenz);
            } else if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.LvLeComLegalAnfrageKorrespondenz);
            } else if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.LvKainzLegalAnfrageKorrespondenz);
            }
        } else if (Opportunities.isDieselskandal(this.opp.RecordTypeId)) {
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalAnfrageKorrespondenz);
            } else if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.DieselLeComLegalAnfrageKorrespondenz);
            } else if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalAnfrageKorrespondenz);
            }
        } else if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) {
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.FzJaegerLegalAnfrageKorrespondenz);
            } else if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.FzLeComLegalAnfrageKorrespondenz);
            } else if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.name.FzKainzLegalAnfrageKorrespondenz);
            }
        } else {
            System.debug('OppRequestContract :: getTemplate: error invalid recordtype=' + this.opp.RecordTypeId);
            return null;
        }
        System.debug('OppRequestContract :: getTemplate: error invalid legal account');
        return null;
    }

    private void sendEmail(Opportunity_Correspondence__c oppCorr) {
        string templateId = getTemplate();
        if (templateId == null) {
            System.debug('OppRequestContract :: sendMail: error templateId is null');
            return;
        } else if (templateId == '') {
            System.debug('OppRequestContract :: sendMail: error templateId is empty');
            return;
        }
        System.debug('OppRequestContract :: sendMail: setting templateID=' + templateID);
        oppCorr.Send_Mail_TemplateID__c = templateId; // sends a mail after oppcorr attachement insert
        /*
        List<attachment> atts = [select Id from Attachment where ParentId = :oppCorr.Id];
        List<id> attsIds = new List<Id>();
        for (attachment a : atts) {
            attsIds.add(a.Id);
            System.debug('OppRequestContract :: sendMail: found attachment id=' + a.Id);
        }
        EmailUtilities emailUtilities = new EmailUtilities(oppCorr.ID, this.opp.Contact__c, templateId, this.opp.Legal__c);
        emailUtilities.createFollowUp = true;
        if (atts.size() > 0) {
            emailUtilities.additionalAttachmentIds.addAll(attsIds);
            System.debug('OppRequestContract :: sendMail: attaching atts=' + atts);
        } else {
            System.debug('OppRequestContract :: sendMail: warning no attachments found for oppcorr=' + oppCorr.Id);
        }
        String result = emailUtilities.send();
        System.debug('Sent automatic mail with result: ' + result + ' templateID: ' + templateId);
        */
    }

    public PageReference renderPage() {
        PageReference pageRef;

        if (this.opp.Contact__c == null) {
            return Errors.page('Bitte tragen Sie ein Kontakt auf dem Feld "Kunde" ein.');
        } else if (this.opp.Backoffice__c == null || this.opp.Backoffice__r.isActive == false) {
            return Errors.page('Bitte tragen Sie einen aktiven Backoffice Mitarbeiter auf der Anfrage ein.');
        }
        String partner;
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            partner = 'Bank';
        } else if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            partner = 'Bank';
            /*
            // commented this task out again and use the code in emailutilities:
            // https://trello.com/c/2bC3rqlQ/339-anfrage-vertrag-anfordern-button-feedback
            // added this task here:
            // https://trello.com/c/Ob5aJmfP/311-create-task-wiedervorlage-bzgl-darlehensvertrag
            Task t = Tasks.build(
                'Wiedervorlage bzgl. Darlehensvertrag', // subject
                null, // description
                this.opp,
                this.opp.Backoffice__r,
                Date.today().addDays(14), // ActivityDate
                true, // no duplicates
                false // followup
            );
            if (t != null) {
                insert t;
            }
            */
        } else { // if (Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
            partner = 'Insurance';
            /*
            // commented this task out again and use the code in emailutilities:
            // https://trello.com/c/2bC3rqlQ/339-anfrage-vertrag-anfordern-button-feedback
            if ((opp.Priority_Level__c == 'I') || (opp.Priority_Level__c == 'II')) {
                if ((opp.Insurance_Status__c == 'beitragsfrei gestellt') || (opp.Insurance_Status__c == 'noch aktiv')) {
                    Task t = Tasks.build('Wiedervorlage bzgl. Vertrag', null, this.opp, this.opp.Backoffice__r, Date.today()+14, true, false);
                    if (t != null) {
                        insert t;
                    }
                }
            }
            */
        }

        Opportunity_Correspondence__c oppCorr = new Opportunity_Correspondence__c(
            Opportunity__c = this.opp.Id,
            Date__c = System.today(),
            Stage__c = 'Draft',
            Partner__c = partner,
            Autocreate_Document__c = true,
            Autosend_Email__c = true,
            Text_Modules__c = 'AnforderungVertrag'
        );
        // send automatic email: https://trello.com/c/2bC3rqlQ/339-anfrage-vertrag-anfordern-button-feedback
        sendEmail(oppCorr);
        insert oppCorr;
        // System.debug('OppRequestContract :: created Opportunity_Correspondence__c=' + oppCorr.Id);

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}