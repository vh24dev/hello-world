public class SetClaimReview {
    private final Claim__c claim;
  
    public SetClaimReview(ApexPages.StandardController stdCtl) {
        this.claim = [
            select Id, Review__c, Legal__c, Opportunity__r.Legal_Account__c, Opportunity__r.Contact__c 
            FROM Claim__c
            WHERE Id = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;

		// Send mail
		Id templateId;
		if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
			// Jäger
            templateId = EmailTemplates.idOf(EmailTemplates.name.DieselJaegerLegalClaimReview);	// 00X0Y000000mCDL
		} else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)){
			// LeCom
            templateId = EmailTemplates.idOf(EmailTemplates.claims.DieselLeComLegalClaimReview);
		} else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)){
			// 21Legal
            templateId = EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalLegalClaimReview); // 00X0Y000000yAcW
		} else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)){
			// Kainz
            templateId = EmailTemplates.idOf(EmailTemplates.name.DieselKainzLegalClaimReview); // 00X0Y000001ab0h
		} else {
			// Lachmair
            templateID = EmailTemplates.idOf(EmailTemplates.name.DieselLachmairLegalClaimReview); //00X0Y000000mCDB
		}

		EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
		emailUtilities.addTemplateAttachments = true;
		emailUtilities.noParentAttachment = true;
		String result = emailUtilities.send();
		System.debug('Sent automatic mail with result: ' + result);

		// Update claim
		if (claim.Review__c == false){
			claim.Review__c = true;
			update claim;
		}

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}