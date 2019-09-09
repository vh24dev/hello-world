// Anfrage "Dokumente unvollständig" Button
// Anfrage "Dokumente vollständig" Button

// Opportunity "Dokumente unvollständig" Button
// Opportunity "Dokumente vollständig" Button
/*
OppDocsExtension is a visualforce controller extension to provide the business logic
for when an Opportunity has completed all the necessary documents or not.
An automated email is sent on either case, and a few variables are set on the Opportunity.
*/
public class OppDocsExtension {
    private final Opportunity opp;
    public OppDocsExtension(ApexPages.StandardController stdCtl) {
        this.opp = fetchOpp(stdCtl.getId());
    }

    public PageReference complete() {
        Logger.debug('>> OppDocsExtension :: complete :: opp: ' + this.opp);
        Logger.debug('<< OppDocsExtension :: complete');

        if (this.opp.Documents__r.size() < 1) {
            return Errors.page('Zu dieser Anfrage wurden noch keine Dokumente hochgeladen!');
        }

        return process(true, this.opp.account_Id__c, this.opp.recordTypeId);
    }

    public PageReference incomplete() {
        Logger.debug('>> OppDocsExtension :: incomplete :: opp: ' + this.opp);
        Logger.debug('<< OppDocsExtension :: incomplete');
        return process(false, this.opp.account_Id__c, this.opp.recordTypeId);
    }

    private PageReference process(Boolean docsComplete, ID acc, ID oppRecordType) {
        if (this.opp.stageName == 'Claim') {
            // Already in Claim stage, nothing to be done.
            return Errors.page('Die Anfrage befindet sich bereits im Fall Status. Es muss keine Aktion ausgeführt werden.');
        }

        if (this.opp.stageName != 'Check') { // no lawayer needed in stage check
            if (this.opp.assignment_Type__c == null || opp.legal__c == null) {
                return Errors.page('Daten unvollständig für diese Aktion: Auftragstyp, Anwalt. Bitte ergänzen und erneut versuchen.');
            }
        }

        if (this.opp.Contact__c == null) {
            return Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde" der Anfrage.');
        }

        if (Opportunities.isDieselSkandal(opp.recordTypeId)
            && this.opp.assignment_Type__c != 'RSV'
            && this.opp.engine_Type__c == 'EA189') {
            return Errors.page('Fehler bei Übergabe des Prozesses.',
                               'Anfragen ohne Rechtsschutzversicherung und Motortyp EA189 können nicht an Anwalt oder Finanzierungsprozess übergeben werden.');
        }

        /*
        // should be covered by validation rules now
        if (this.opp.has_Legal_Protection_Insurance__c == null || !this.opp.has_Legal_Protection_Insurance__c) {
            return Errors.page('Es muss eine Rechtsschutzversicherung vorhanden sein.',
                               'Bevor die Stage auf "Claim" gestezt werden kann muss "RSV vorhanden" gecheckt sein.');
        }

        if (this.opp.backoffice__c == null) {
            return Errors.page('Bitte tragen Sie einen Backoffice Mitarbeiter ein.',
                               'Bevor die Stage auf "Claim" gestezt werden kann muss ein Backoffice Mitarbeiter eingetragen werden.');
        }
		*/

        if (Opportunities.isDieselSkandal(oppRecordType) && docsComplete) {
            this.opp.stageName = 'Claim';
        }

        this.opp.dokumente_vollst_ndig__c = docsComplete;
        this.opp.dokumente_unvollst_ndig__c = !docsComplete;
        update this.opp;

        // https://salesfive.atlassian.net/browse/VH24-146
        if (Opportunities.isLebensversicherung(this.opp.recordTypeId)) {
            Logger.debug('OppDocsExtension :: complete :: is LV. No email sent');
            return new PageReference('/' + this.opp.ID);
        }

        String templID = templateID(docsComplete);
        if (String.isBlank(templID)) {
            String errMsg = 'Unable to get email template for related account. No email sent.';
            Logger.error('OppDocsExtension :: complete :: ' + errMsg);
            return Errors.page(null, errMsg);
        }

        Logger.debug('OppDocsExtension :: complete :: sending email with template id: ' + templID);
        string url = page.sendMail.getUrl() + createUrl(templID);
        System.debug('url: ' +  url);
        Logger.debug('<< OppDocsExtension :: toClaim');
        return new PageReference(url);
    }

    private string createUrl(string tpl) {
        return
            '?id=' + opp.Id +
            '&tpl=' + tpl +
            '&recipient=' + opp.Contact__c +
            '&noprtatt=true' +
            '&hdl="Anfrage für fehlende Dokumente versenden."' +
            '&showAuthorizationsList=true';
    }
 
    private string getTplIncomplete() {
        if (Opportunities.isDieselSkandal(this.opp.RecordTypeId)) { // 0120Y000000W0CY
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.DieselskandalBackofficeDocumentsIncompleteJaeger);
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.DieselskandalBackofficeDocumentsIncompleteVh24);
            }
            return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.DieselskandalBackofficeDocumentsIncompleteVr24);
        }
        if (Opportunities.isFinanzierung(this.opp.RecordTypeId)) { // 0120Y000000KnMH
            if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
                return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.FzBackofficeDocumentsIncompleteJaeger);
            }
            if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
                return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.FzBackofficeDocumentsIncompleteVh24);
            }
            return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.FzBackofficeDocumentsIncompleteVr24);
        }
        if (Accounts.isVH24(this.opp.Account__c)) { // 0010Y00000eCUS9
            return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.LvCallcenterDocumentsIncompleteVh24);
        }
        return EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.LvCallcenterDocumentsIncompleteVr24);
    }

    private string getTplComplete() {
        if (Accounts.isVH24(this.opp.Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVh24);
        }
        if (Accounts.isVR24(this.opp.Account__c)) {
            return EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVr24);
        }
        return '';
    }

    private String templateID(Boolean docsComplete) {
        return docsComplete
            ? getTplComplete()
            : getTplIncomplete();
		/*
        if (Accounts.isVH24(accID)) {
            return docsComplete 
                ? EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVh24)
                : EmailTemplates.idOf(EmailTemplates.Name.LvCallcenterDidNotReceiveDocumentsVh24);
        }
        if (Accounts.isVR24(accID)) {
            return docsComplete 
                ? EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVr24)
                : EmailTemplates.idOf(EmailTemplates.Name.LvCallcenterDidNotReceiveDocumentsVr24);
        }
        return null;
		*/
    }

    private PageReference notLebensversicherungError() {
        String errMsg = 'Diese Funktionalität ist nur für die Sparte "Lebensversicherung" verfügbar.';
        Logger.error('OppDocsExtension :: ' + errMsg);
        return Errors.page(null, errMsg);
    }

    private Opportunity fetchOpp(ID oppID) {
        return [
            SELECT ID,
            RecordTypeId,
            Account_Id__c,
            Account__c,
            Legal_Account__c,
            Assignment_Type__c,
            Engine_Type__c,
            StageName,
            Legal__c,
            Has_Legal_Protection_Insurance__c,
            Backoffice__c,
            Contact__c,
            Callcenter__c,
            Dokumente_vollst_ndig__c,
            Dokumente_unvollst_ndig__c,
            Automatisches_Follow_up_2__c,
            (SELECT Id FROM Documents__r)
            FROM Opportunity
            WHERE ID = :oppID
        ];
    } 
}