public class FinishedLegalCheck {
    private final Opportunity opp;
    public Opportunity parOpportunity {get; set;}

    public FinishedLegalCheck(ApexPages.StandardController stdCtl) {
        parOpportunity = new Opportunity();
        this.opp = [
            SELECT ID, RecordTypeID, Sales_Type__c, Account_Id__c, Contact__c, Backoffice__c, Backoffice__r.isActive, (SELECT ID, Status, Subject, IsClosed FROM Tasks)
            FROM Opportunity
            WHERE ID = :stdCtl.getId()
        ];
    }

    public PageReference renderPage() {
        PageReference pageRef;
		
        if (!Opportunities.isLebensversicherung(this.opp.RecordTypeId)) {
        	// Send mail if not LV
            Id templateId;
            Id userId;
            if (Accounts.isVH24(this.opp.Account_Id__c)) { // 0010Y00000eCUS9
                // VH24
                templateId = EmailTemplates.idOf(EmailTemplates.name.LvBackofficeFinishedLegalCheckVh24); // 00X0Y000000m4um
                if (this.opp.Sales_Type__c == 'Online') {
                    // Online
                    userId = this.opp.Backoffice__c;
                } else {
                    //Partner
                    userId = Users.vh24Lv(); // 0050Y000003848T
                }
            } else {
                // VR24
                templateId = EmailTemplates.idOf(EmailTemplates.name.LvBackofficeFinishedLegalCheckVr24); // 00X0Y000000dmum
                userId = this.opp.Backoffice__c;
            }
    
            EmailUtilities emailUtilities = new EmailUtilities(this.opp.Id, this.opp.Contact__c, templateId, userId);
            emailUtilities.noAttachment = true;
            String result = emailUtilities.send();
            System.debug('Sent automatic mail with result: ' + result);   
        } else {
            Logger.debug('FinishedLegalCheck :: renderPage :: is LV. No email sent');
        }

        // Close task
        update Tasks.markAsClosed('Juristische Prüfung', this.opp);

        // Update opportunity
        this.opp.Lawsuit_Type__c = parOpportunity.Lawsuit_Type__c;
        update this.opp;

        // Create task
        User user = [SELECT Id, isActive FROM User WHERE Id = :Users.potentialCheck() ]; // Martin Braun
        // Task task = Tasks.build('Potential prüfen', null, this.opp, user, System.today(), true, false);
        Task task = Tasks.build('Potential prüfen', null, this.opp, user, System.today(), true, false, this.opp.ID);

        if (task != null) {
            insert task;
        }

        return new PageReference('/' + this.opp.ID);
    }
}