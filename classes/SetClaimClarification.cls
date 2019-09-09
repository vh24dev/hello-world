// Claim "Nachprüfung" Button
public class SetClaimClarification {
    private final Claim__c claim;

    public SetClaimClarification(ApexPages.StandardController stdCtl) {
        this.claim = [
            select Id, Clarification__c, Opportunity__r.Contact__c,Legal__c, Opportunity__r.Legal_Account__c
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;

        if (this.claim.Legal__c == null) {
            String errorSubject = 'Fehler!';
            String errorMessage = 'Bitte setzten Sie das Feld Anwalt.';
            pageRef = Errors.page(errorSubject, errorMessage);
            pageRef.setRedirect(true);
            return pageRef;
        }

        // Send mail
        Id templateId;
        if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
            // Jäger
            templateId = EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalClaimClarification); // 00X0Y000000mCDG
        } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000013yLnP
            // 21Legal
            templateId = EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalLegalClaimClarification); // 00X0Y000000yAcf
        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
            // LeCom
            templateId = EmailTemplates.idOf(EmailTemplates.claims.DieselLeComLegalClaimClarification);
        } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000010COcm
            // Kainz
            templateId = EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalClaimClarification); // 00X0Y000001ab0K
        } else {
            // Lachmair
            templateId = EmailTemplates.idOf(EmailTemplates.name.DieselLachmairLegalClaimClarification); // 00X0Y000000mCD6
        }

        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
        emailUtilities.addTemplateAttachments = true;
        emailUtilities.noParentAttachment = true;
        String result = emailUtilities.send();
        System.debug('Sent automatic mail with result: ' + result);

        // Update claim
        if (claim.Clarification__c == false){
            claim.Clarification__c = true;
            update claim;
        }

        pageRef = Page.SuccessPage;
        pageRef.setRedirect(true);
        return pageRef;
    }
}