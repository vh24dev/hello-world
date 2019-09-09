// Fall "Vergleich geprüft" Button
// Claim__c "Vergleich geprüft" Button
public class ArrangementAudited {
    private final Claim__c claim;
    private final Opportunity opp;
    public boolean errorContact {get; set;}

    public ArrangementAudited(ApexPages.StandardController stdCtl) {
        this.claim = [
            SELECT Id,
            Opportunity__c,
            RecordTypeID,
            Legal__c,
            Clerk__c,
            Clerk__r.isActive,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Claim__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT Id,
            Contact__c,
            Legal_Protection_Insurance__c,
            Bank__c,
            AccountId,
            Legal_Account__c,
            RecordTypeId
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public void HandleTasks() {
        Task t = Tasks.build(
            'Erstattungsbetrag hinterlegen und als abgeschlossen markieren', // subject
            null, // description
            this.claim, // parentObj
            this.claim.Clerk__r, // owner
            System.today(), // activityDate
            true, // noDuplicates
            false, // isFollowUpTask
            this.opp.ID
        );
        if (t != null) {
            insert t;
        }
        List<Task> closeTasks = Tasks.markAsClosed('Vergleich prüfen', this.claim);
        if (closeTasks.size() > 0) {
            update closeTasks;
        }
    }

    public PageReference renderPage() {
        if (this.claim.Clerk__c == null || !this.claim.Clerk__r.IsActive) {
            return Errors.page('Bitte hinterlegen Sie einen aktiven "Sachbearbeiter" auf dem Fall.');
        }
        if (this.opp.Contact__c == null) {
            errorContact = true;
            return null;
        }
        if (this.opp.Bank__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen "Kreditinstitut" auf der Anfrage.');
        }
        if (this.opp.Legal_Protection_Insurance__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen "Rechtsschutzversicherung" auf der Anfrage.');
        }
        HandleTasks();
        sendAutoEmails();
        return Page.SuccessPage;
    }

    private void sendMail(Id parentId, Id recipientId, Id templateId, Id userId) {
        EmailUtilities emailUtilities = new EmailUtilities(parentId, recipientId, templateId, userId);
        String result = emailUtilities.send();
        System.debug('Sent automatic mail with result: ' + result);
    }

    private void sendAutoEmails() {
        string templateId;
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            // Bank
            sendMail(claim.Id, this.opp.Bank__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzLeComLegalClaimComparisonunderReviewBank), claim.Legal__c);
            // RSV
            sendMail(claim.Id, this.opp.Legal_Protection_Insurance__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzLeComLegalClaimComparisonunderReviewRechtsschutzversicherung), claim.Legal__c);
            // Kunde
            sendMail(claim.Id, this.opp.Contact__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzLeComLegalClaimComparisonunderReviewKunde), claim.Legal__c);
        } else if (Accounts.isJCLegal(this.opp.Legal_Account__c)) {
            // Bank
            sendMail(claim.Id, this.opp.Bank__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzJaegerLegalClaimComparisonunderReviewBank), claim.Legal__c);
            // RSV
            sendMail(claim.Id, this.opp.Legal_Protection_Insurance__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzJaegerLegalClaimComparisonunderReviewRechtsschutzversicherung), claim.Legal__c);
            // Kunde
            sendMail(claim.Id, this.opp.Contact__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzJaegerLegalClaimComparisonunderReviewKunde), claim.Legal__c);
        } else if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
            // Bank
            sendMail(claim.Id, this.opp.Bank__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzKainzLegalClaimComparisonunderReviewBank), claim.Legal__c);
            // RSV
            sendMail(claim.Id, this.opp.Legal_Protection_Insurance__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzKainzLegalClaimComparisonunderReviewRechtsschutzversicherung), claim.Legal__c);
            // Kunde
            sendMail(claim.Id, this.opp.Contact__c, EmailTemplates.idOf(EmailTemplates.ClaimComparison.FzKainzLegalClaimComparisonunderReviewKunde), claim.Legal__c);
        } else {
            System.debug('ArrangementAudited: WARNING no email sent unsupported legalaccount=' + this.opp.Legal_Account__c);
        }
    }
}