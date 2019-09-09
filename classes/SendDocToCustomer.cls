// Correspondence__c "Vorlage an Kunden versenden" Button
// Korrespondenz "Vorlage an Kunden versenden" Button
public class SendDocToCustomer {
    private final Opportunity opp;
    private final Claim__c claim;
    private final Correspondence__c corr;
    public string errorMsg {get; set;}

    public SendDocToCustomer(ApexPages.StandardController stdCtl) {
        errorMsg = '';
        this.corr = [
            SELECT Id, Claim__c, Opportunity_Record_Type_Id__c
            FROM Correspondence__c
            WHERE Id = :stdCtl.getId()
        ];
        if (this.corr.Claim__c == null) {
            errorMsg = 'einen Fall auf der Korrespondenz';
            return;
        }
        this.claim = [
            SELECT Id,
            Opportunity__c,
            Opportunity_Legal_Account_Id__c,
            Clerk__c,
            Clerk__r.isActive
            FROM Claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        if (this.claim.Opportunity__c == null) {
            errorMsg = 'eine Anfrage auf dem Fall';
            return;
        }
        this.opp = [
            SELECT Id,
            Contact__c,
            Legal_Account__c,
            Account__c,
            RecordTypeId
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorMsg = 'einen Kontakt auf der Anfrage';
        }
        if (this.claim.Clerk__c == null) {
            errorMsg = 'einen Sachbearbeiter auf dem Fall';
        }
        if (errorMsg != '') {
            return null;
        }
        Task t = Tasks.build(
            'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden', // subject
            null, // description
            this.corr, // parentObj
            this.claim.Clerk__r, // owner
            System.today().addDays(14), // activityDate
            true, // noDuplicates
            false, // isFollowUpTask
            this.opp.ID
        );
        if (t != null) {
            insert t;
        }

        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSendCustomersOppositionToCustomerVh24);
            }
            return EmailTemplates.idOf(EmailTemplates.name.FzBackofficeSendCustomersOppositionToCustomerVr24);
        }
        if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSendCustomersOppositionToCustomerVh24);
        }
        return EmailTemplates.idOf(EmailTemplates.name.LvBackofficeSendCustomersOppositionToCustomerVr24);
    }

    private string getBcc() {
        if (!Accounts.isVH24(this.opp.Account__c)) {
            return '';
        }
        if (!Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            return '';
        }
        return 'RA-abgas@verbraucherhilfe24.de';
    }

    private string createUrl() {
        return
		'?id=' + this.corr.id +
		'&recipient=' + this.opp.Contact__c +
		'&hdl=Widerspruchsvorlage an Kunden versenden' +
		'&showDocumentsList=true' +
		'&showCorrespondenciesList=true' +
		'&showOpportunityAttachmentsList=true' +
		'&showAuthorizationsList=true' +
		'&showCreateFollowUpCheckbox=true' +
		'&bcc=' + getBcc() +
		'&tpl=' + getTpl() +
		'&attreq=true';
    }
}

// /apex/SendMail
// ?id={!Correspondence__c.Id}
// &recipient={!
// IF(Opportunity.Contact__c != null,Opportunity.ContactId__c,null)
// }
// &hdl=Widerspruchsvorlage an Kunden versenden
// &showDocumentsList=true
// &showCorrespondenciesList=true
// &showOpportunityAttachmentsList=true
// &showAuthorizationsList=true
// &&showCreateFollowUpCheckbox=true
// &bcc={!
// IF(AND(Correspondence__c.Opportunity_Account_Id__c = '0010Y00000eCUS9',Correspondence__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH'),'RA-abgas@verbraucherhilfe24.de','')
// }
// &tpl={!
// IF(Correspondence__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X1v000000SMsJ','00X1v000000SMsO'),IF(Opportunity.Account_Id__c = '0010Y00000eCUS9','00X0Y000000mDt7','00X0Y000000mDtH'))
// }
// &attreq=true