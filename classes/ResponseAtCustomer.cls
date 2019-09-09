// Correspondence__c "Antwort beim Kunden" Button
// Korrespondenz "Antwort beim Kunden" Button
public class ResponseAtCustomer {
    private final Opportunity opp;
    private final Claim__c claim;
    private final Correspondence__c corr;
    public string errorMsg {get; set;}

    public ResponseAtCustomer(ApexPages.StandardController stdCtl) {
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
            Legal_Account__c
            FROM Opportunity
            WHERE Id = :this.claim.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.Contact__c == null) {
            errorMsg = 'einen Kontakt auf der Anfrage';
        }
        if (this.claim.Clerk__r == null) {
            errorMsg = 'einen Sachbearbeiter auf dem Fall';
        }
        if (errorMsg != '') {
            return null;
        }
        List<Task> ts = new List<Task>();
        Task t;
        if (Opportunities.isFinanzierung(this.corr.Opportunity_Record_Type_Id__c)) {
            t = Tasks.build(
                'Ergebnis des Kundenwiderspruchs dokumentieren', // subject
                null, // description
                this.corr, // parentObj
                this.claim.Clerk__r, // owner
                System.today().addDays(14), // activityDate
                true, // noDuplicates
                false, // isFollowUpTask
                this.opp.ID
            );
            if (t != null) {
                ts.add(t);
            }
        }
        t = Tasks.build(
            'Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden', // subject
            null, // description
            this.corr, // parentObj
            this.claim.Clerk__r, // owner
            System.today().addDays(5), // activityDate
            true, // noDuplicates
            false, // isFollowUpTask
            this.opp.ID
        );
        if (t != null) {
            ts.add(t);
        }
        if (ts.size() > 0) {
            insert ts;
        }

        string url = page.sendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        // Finanzierung
        if (Opportunities.isFinanzierung(this.corr.Opportunity_Record_Type_Id__c)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzJaegerLegalAntwortBeimKunden); // 00X1v000000STrw
            }
            if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzLeComLegalAntwortBeimKunden);
            }
            if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
                return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.FzKainzLegalAntwortBeimKunden); // 00X1v000000OPnw
            }
            return '';
        }
        // Lebensversicherung
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvJaegerLegalAntwortBeimKunden); // 00X1v000000OPnr
        }
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvLeComLegalAntwortBeimKunden);
        }
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.LvKainzLegalAntwortBeimKunden); // 00X1v000000OPnw
        }
        return '';
    }

    private string createUrl() {
        return
        '?id=' + this.corr.id +
        '&tpl=' + getTpl() +
        '&recipient=' + this.opp.Contact__c +
        '&noatt=true' +
        '&hdl="Antwort beim Kunden."' +
        '&showCreateFollowUpCheckbox=true';
    }
}

// /apex/SendMail?
// id={!Correspondence__c.Id}
// &tpl={!
// IF(Correspondence__c.Opportunity_Record_Type_Id__c = '0120Y000000KnMH',IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000STrw',''),IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X1v000000OPnr',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X1v000000OPnw','')))
// }
// &recipient={!Opportunity.ContactId__c}
// &noatt=true
// &hdl="Antwort beim Kunden."
// &showCreateFollowUpCheckbox=true