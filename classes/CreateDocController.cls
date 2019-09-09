// Legacy code, to be refactored
// WIP for docgen
// As we discover the requirements remove as much old code as possible.
public class CreateDocController {
    private final ID objID;
    
	public CreateDocController() {
        this.objID = ApexPages.currentPage().getParameters().get('id');
    }
    
	public PageReference createDoc() {
        System.debug('>> CreateDocExtension :: createDoc');
        
        // todo: extract to some class or have the same extension for all doc gen buttons
        // This comes form Legacy PageButtonAction

        Boolean parPreserveMergefields;
        if (ApexPages.currentPage().getParameters().get('preserveMergeFields') != null){
	        parPreserveMergefields = Boolean.valueOf(ApexPages.currentPage().getParameters().get('preserveMergeFields'));
        } else {
            parPreserveMergefields = false;
        }
        
        String parOutput;
        if (ApexPages.currentPage().getParameters().get('output') != null){
	        parOutput = ApexPages.currentPage().getParameters().get('output');
        } else {
            parOutput = 'pdf';
        }
        
        String parVariant;
        if (ApexPages.currentPage().getParameters().get('variant') != null){
	        parVariant = ApexPages.currentPage().getParameters().get('variant');
        }
        //--
        
        PageReference r;
        try {
        	String error = DocumentCreationAction.autoCreateDocument(this.objID, parPreserveMergefields, parOutput, parVariant, null/*parDocumentAttachment - only for correspondences*/);   
            r = String.isBlank(error) ? Page.SuccessPage : Errors.page('Unable to create doc: ' + error);
        } catch (Exception e) { 
        	System.debug('CreateDocExtension :: createDoc :: e: '+ e.getMessage());   
            r = Errors.page('Unable to create doc', e.getMessage());
        }
        r.setRedirect(true);
        return r;

        /*PageReference red;
        if (parentObject.Id.getSObjectType() == Schema.SObjectType.Analysis__c.getSObjectType()){
	        Analysis__c analysis = [select Id,Opportunity__c from Analysis__c where Id = :parentObject.Id];
            Opportunity opportunity = [select Id, Checklist_Information_Complete__c, Potential__c from Opportunity where Id = :analysis.Opportunity__c];

	        if (parVariant == '1'){
                if (opportunity.Checklist_Information_Complete__c == false){
		            red = Page.ChecklistInformationIncomplete;
                }                    
            } else if (parVariant == '2') {
                if (opportunity.Potential__c == null) {
		            red = Page.CalculationIncomplete;
                }
            }
        }

		if (parentObject.Id.getSObjectType() == Schema.SObjectType.Correspondence__c.getSObjectType()){
			for (EmailUtilities.CAttachmentListItem parentAttachmentListItem : parParentAttachments){
				if (parentAttachmentListItem.selected == true){
					parDocumentAttachments.add(parentAttachmentListItem.record.Id + ';0;internal');
				}
			}
			for (EmailUtilities.CDocumentListItem documentListItem : parDocuments){
				if (documentListItem.selected == true){
					parDocumentAttachments.add(documentListItem.record.Link__c + ';0;external');
				}
			}
			for (EmailUtilities.CCorrespondenceAttachmentListItem correspondenceAttachmentListItem : parCorrespondencies){
				if (correspondenceAttachmentListItem.selected == true){
					parDocumentAttachments.add(correspondenceAttachmentListItem.attachment.Id + ';0;internal');
				}
			}
			for (EmailUtilities.CAttachmentListItem opportunityAttachmentListItem : parOpportunityAttachments){
				if (opportunityAttachmentListItem.selected == true){
					parDocumentAttachments.add(opportunityAttachmentListItem.record.Id + ';0;internal');
				}
			}
			for (EmailUtilities.CAuthorizationAttachmentListItem authorizationAttachmentListItem : parAuthorizations){
				if (authorizationAttachmentListItem.selected == true){
					parDocumentAttachments.add(authorizationAttachmentListItem.attachment.Id + ';0;internal');
				}
			}
		}

		if (parentObject.Id.getSObjectType() == Schema.SObjectType.Cost_Note__c.getSObjectType()){
			Cost_Note__c costNote = [select Id from Cost_Note__c where Id = :parentObject.Id];
			costNote.Date__c = System.today();
			update costNote;
		}

        if (red == null){
            DocumentCreationAction.autoCreateDocument(parentObject.Id,parPreserveMergefields,parOutput,parVariant,parDocumentAttachments);
            red = Page.SuccessPage;
        }
        red.setRedirect(true);
        return red;*/
    }
}