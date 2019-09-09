public class ClaimStage {
    private static Claim__c updateStage(Claim__c c, Map<ID, Claim__c> oldCc, Map<ID, Opportunity> oppByID, Map<Id, List<Correspondence__c>> claimCorrs, boolean isInsert) {
        // Berufungsprozess:
        // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-59
        if (c.Result__c == 'Partially won' && Picklist.contains(c.Cover_Note_Scope__c, 'Without Appeal')) {
            if (c.Stage__c != 'Finished') { // don't overwrite finished to create the ClaimInvoice
                c.Stage__c = 'Processing';
            	return c;
            }
        }
        // https://trello.com/c/SxkSU9wp/537-update-fall-status#comment-5cf62b49b3c239875635a292
        if (
            (
                c.Result__c == 'Accepted'
                ||
                c.Result__c == 'Partially won' // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-59
            )
            && Picklist.contains(c.Cover_Note_Scope__c, 'Appeal')
        ) {
            c.Stage__c = 'Verteidigungsanzeige';
            return c; // force this.
        }
        if (c.Cover_Note__c == 'Refused' && oldCc.get(c.Id).Cover_Note__c != 'Refused') {
            for (Correspondence__c corr : claimCorrs.get(c.Id)) {
                if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige' || corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (c.Cover_Note_Scope__c == 'Appeal'
                        && c.Stage__c == 'Appeal') { // Sonja Logdeser May 10 at 10:55 PM https://trello.com/c/FaWKYoxZ/295-update-fall-status#comment-5cd5e55d7020af760d20ae6b
                            c.Stage__c = 'Finished'; // Abgeschlossen
                            break;
                        }
                }
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben' || corr.Type__c == 'Deckungsanfrage für Klage') {
                    c.Stage__c = 'On Hold'; // Warten auf Grundsatzurteil
                    break;
                }
            }
        }

        Opportunity o = oppByID.get(c.opportunity__c);
        if (o == null) {
            return c;
        }

        if (c.clerk__c == null) {
            Logger.debug('Claims :: setStage :: no clerk, exiting');
            return c;
        }

        if (Claims.isFinanzierung(c.RecordTypeId)) {
            if (c.Result__c == 'Arrangement' && c.Arrangement__c == 'Declined') {
                c.Stage__c = 'Legal Opposition';
                return c;
            }
        }

        if (c.stage__c != 'Draft') {
            Logger.debug('Claims :: setStage :: current stage is not Draft, exiting');
            return c;
        }

        if (Claims.isDieselSkandal(c.recordTypeId)) {
            c.stage__c = 'Claim Letter';
            return c;
        }

        if (Claims.isFinanzierung(c.recordTypeId) || Claims.isLebensversicherung(c.recordTypeId)) {
            c.stage__c = (o.priority_Level__c == 'I' || o.priority_Level__c == 'II')
                ? 'Legal Opposition'
                : 'Customers Opposition';
            return c;
        }
        return c;
    }

    public static void setStage(Claim__c[] cc, Map<ID, Claim__c> oldCc, Map<ID, Opportunity> oppByID, boolean isInsert) {
        Map<Id, List<Correspondence__c>> claimCorrs = new Map<Id, List<Correspondence__c>>();
        for (Claim__c c : [
            SELECT ID,
            (SELECT ID, Type__c FROM Correspondencies__r)
            FROM Claim__c
            WHERE ID IN :cc
        ]) {
            claimCorrs.put(c.Id, c.Correspondencies__r);
        }

        for (Claim__c c: cc) {
            if (isInsert) break;
            string oldStage = c.Stage__c;

            c = updateStage(c, oldCc, oppByID, claimCorrs, isInsert);

            if (oldStage != c.Stage__c) {
                Logger.debug('ClaimStage :: changed stage from=' + oldStage + ' to=' + c.Stage__c);
            }
        }
    }
}