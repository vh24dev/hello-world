// Correspondence__c "Als versendet markieren" Button
// Korrespondenz "Als versendet markieren" Button
public class SetCorrespondenceSent {
    private final Correspondence__c corr;
    private final Claim__c claim;
    public boolean parCreateFollowUp {get; set;}
    public boolean errorClaim {get; set;}
    public boolean errorLegal {get; set;}

    public SetCorrespondenceSent(ApexPages.StandardController stdCtl) {
        errorClaim = false;
        errorLegal = false;
        this.corr = [
            SELECT Id, Date__c, Claim__c, Stage__c, Type__c, Follow_up_Period__c, Wiedervorlage_erstellen__c,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Correspondence__c
            WHERE Id = :stdCtl.getId()
        ];
        this.claim = [
            SELECT Id, Stage__c, Follow_up_Period__c, Legal__c, Legal__r.isActive
            FROM Claim__c
            WHERE Id = :this.corr.Claim__c
        ];
        parCreateFollowUp = this.corr.Wiedervorlage_erstellen__c;
    }

    public PageReference renderPage() {
 		PageReference pageRef;

		if (this.corr.Stage__c != 'Sent'){
			this.corr.Stage__c = 'Sent';

			if (this.corr.Type__c == 'Widerspruch durch Kunden') {
				claim.Customer_Opposition_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
				claim.Claim_Letter_Insurance_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Anspruchsschreiben') {
				claim.Claim_Letter_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Deckungsanfrage für Widerspruch') {
				claim.Legal_Opposition_Insurance_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Widerspruch durch Anwalt') {
				claim.Legal_Opposition_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Deckungsanfrage für Klage') {
				claim.Lawsuit_Insurance_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Klageschrift') {
				claim.Lawsuit_Date__c = this.corr.Date__c;
				update claim;
			} else if (this.corr.Type__c == 'Deckungsanfrage für Berufung') {
				claim.Appeal_Insurance_Date__c = this.corr.Date__c;
				update claim;
			} else if ((this.corr.Type__c == 'Replik') && (claim.Stage__c == 'Appeal')) {
				claim.Appeal_Date__c = this.corr.Date__c;
				update claim;
			}
		}

		// Close Task
		update Utilities.closeTasks('Wiedervorlage', this.corr);
		update Utilities.closeTasks('versenden', this.corr);

        this.corr.Wiedervorlage_erstellen__c = parCreateFollowUp;
        update this.corr;
		// Create Follow-up
		// Created by ProcessBuilder
		/*
		if (parCreateFollowUp == true){
			User usr = [select Id, isActive from User where Id = :UserInfo.getUserId()];
			Task task;
            Date activityDate = System.today() + Integer.valueOf(this.corr.Follow_up_Period__c);
			if (this.corr.Type__c == 'Widerspruch durch Kunden') {
				task = Utilities.createTask('Wiedervorlage bzgl. Kundenwiderspruch', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Widerspruch durch Anwalt') {
				task = Utilities.createTask('Wiedervorlage bzgl. Anwaltswiderspruch', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Anspruchsschreiben') {
				task = Utilities.createTask('Wiedervorlage bzgl. Anspruchsschreiben', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Klageschrift') {
				task = Utilities.createTask('Wiedervorlage bzgl. Klageschrift', null, this.corr, claim.Legal__r, activityDate, false, true);
			} else if (this.corr.Type__c == 'Gerichtskostenrechnung') {
				task = Utilities.createTask('Wiedervorlage bzgl. Gerichtskostenrechnung', null, this.corr, claim.Legal__r, activityDate, false, true);
			} else if (this.corr.Type__c == 'Replik') {
				task = Utilities.createTask('Wiedervorlage bzgl. Replik', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Vollmacht §141 ZPO') {
				task = Utilities.createTask('Wiedervorlage bzgl. Vollmacht §141 ZPO', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Deckungsanfrage für Widerspruch') {
				task = Utilities.createTask('Wiedervorlage bzgl. Deckungsanfrage für Widerspruch', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
				task = Utilities.createTask('Wiedervorlage bzgl. Deckungsanfrage für Anspruchsschreiben', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Deckungsanfrage für Klage') {
				task = Utilities.createTask('Wiedervorlage bzgl. Deckungsanfrage für Klage', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Deckungsanfrage für Berufung') {
				task = Utilities.createTask('Wiedervorlage bzgl. Deckungsanfrage für Berufung', null, this.corr, usr, activityDate, false, true);
			} else if (this.corr.Type__c == 'Sonstiges') {
				task = Utilities.createTask('Wiedervorlage', null, this.corr, claim.Legal__r, activityDate, false, true);
			} else {
				task = Utilities.createTask('Wiedervorlage', null, this.corr, usr, activityDate, false, true);
			}
			if (task != null) {
				insert task;
			}
		}
		*/

		pageRef = Page.SuccessPage;
		pageRef.setRedirect(true);
		return pageRef;
    }
}