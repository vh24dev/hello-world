public class CorrespondencesTasks {
    private static List<Task> addTask(List<Task> append, String subject,sObject parentObj,User owner,Date activityDate, ID relatedOpp){
        if (owner == null || owner.isActive == false) {
            return append;
        }
        append.add(Tasks.build(subject, null, parentObj, owner, activityDate, true, false, relatedOpp));
        return append;
    }

    public static void create(List<Correspondence__c> correspondencies){
        correspondencies = [
            SELECT Id,
            Type__c,
            Stage__c,
            Claim__c,
            Berufungsschrift_erstellt__c,
            Berufungsbegruendung_created__c,
            Follow_up_Period__c,
            Wiedervorlage_erstellen__c,
            (SELECT Id, Status, Subject FROM Tasks)
            FROM Correspondence__c
            WHERE Id IN :correspondencies
        ];

        Set<Id> claimIds = new Set<Id>();
        for (Correspondence__c correspondence : correspondencies){
            claimIds.add(correspondence.Claim__c);
        }

        Map<Id,Claim__c> claims = new Map<Id,Claim__c>([
            SELECT Id,
            Stage__c,
            Result__c,
            Cover_Note_Scope__c,
            Opportunity__r.Legal_Account__c,
            Opportunity__r.Insurance__r.External_Id__c,
            Follow_up_Period__c,
            Legal__c,
            Legal__r.isActive,
            Clerk__c,
            Clerk__r.isActive,
            Clerk_Appeal__c,
            Clerk_Appeal__r.isActive,
            Opportunity__r.RecordTypeId,
            Opportunity__r.Sales_Type__c,
            Opportunity__r.Callcenter__c,
            Opportunity__r.Callcenter__r.isActive,
            Opportunity__r.Backoffice__c,
            Opportunity__r.Backoffice__r.isActive,
            Opportunity__c,
            (SELECT Id,Status,Subject FROM Tasks)
            FROM Claim__c
            WHERE Id IN :claimIds
        ]);

        List<Task> nullTasks = new List<Task>();
        List<Task> newTasks = new List<Task>();

        for (Correspondence__c correspondence : correspondencies){
            // =============
            // Legacy Code
            // =============
            Claim__c claim = claims.get(correspondence.Claim__c);
            if (correspondence.Stage__c == 'Draft'){
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    nullTasks = addTask(nullTasks, 'Widerspruchsvorlage an Kunden versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    nullTasks = addTask(nullTasks, 'Deckungsanfrage für Widerspruch versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    if (claim.Opportunity__r.Insurance__r.External_Id__c == 'lv004') {
                        // CMI
                        nullTasks = addTask(nullTasks, 'Widerspruchsart prüfen', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
                    } else {
                        // Andere
                        nullTasks = addTask(nullTasks, 'Widerspruchsschreiben versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                    }
                } else if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    nullTasks = addTask(nullTasks, 'Deckungsanfrage für Anspruchsschreiben versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    nullTasks = addTask(nullTasks, 'Anspruchsschreiben versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    nullTasks = addTask(nullTasks, 'Deckungsanfrage für Klage versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Klageschrift') {
                    if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)){ // 0120Y000000W0CY
                        // Diesel
                        if (claim.Stage__c == 'Lawsuit'){ // damit der Task nicht erstellt wird, wenn die Klageschrift bereits vorher erzeugt wird
                            nullTasks = addTask(nullTasks, 'Rückfrage zur Eigentümerschaft versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                        }
                    } else {
                        // LV & FZ
                        nullTasks = addTask(nullTasks, 'Klagedokumente prüfen', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                    }
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    nullTasks = addTask(nullTasks, 'Deckungsanfrage für Berufung versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    User user;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        user = [SELECT Id, isActive FROM User WHERE Id = :Users.JCLegal()]; // 0050Y0000047hLE
                    } else {
                        user = claim.Clerk__r;
                    }
                    nullTasks = addTask(nullTasks, 'Gerichtskostenrechnung hochladen und versenden', correspondence, user, System.today()+30, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    nullTasks = addTask(nullTasks, 'Vollmacht versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if ((correspondence.Type__c == 'Replik') && (claim.Stage__c == 'Appeal')) {
                    nullTasks = addTask(nullTasks, 'Replik erstellen', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Eingehend') {
                    nullTasks = addTask(nullTasks, 'Auf Vollständigkeit/Frist prüfen, Dokument hochladen und als empfangen markieren', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                }
            } else if (correspondence.Stage__c == 'Sent') {
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    nullTasks = addTask(nullTasks, 'Ergebnis des Kundenwiderspruchs dokumentieren', claim, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    nullTasks = addTask(nullTasks, 'Ergebnis des Anwaltswiderspruchs dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)claim.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    nullTasks = addTask(nullTasks, 'Ergebnis des Anspruchsschreibens dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)correspondence.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Klageschrift') {
                    if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) { // 0120Y000000W0CY
                        // Diesel no Task
                    } else {
                        // LV
                        nullTasks = addTask(nullTasks, 'Gerichtstermin für Klage hinterlegen', claim, claim.Legal__r, System.today() + 60, claim.opportunity__c);
                    }
                } else if ((correspondence.Type__c == 'Replik') && (claim.Stage__c == 'Appeal')) {
                    nullTasks = addTask(nullTasks, 'Gerichtstermin für Berufung hinterlegen', claim, claim.Clerk__r, System.today(), claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    nullTasks = addTask(nullTasks, 'Deckungszusage für Widerspruch dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)claim.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    nullTasks = addTask(nullTasks, 'Deckungszusage für Anspruchsschreiben dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)correspondence.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    nullTasks = addTask(nullTasks, 'Deckungszusage für Klage dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)correspondence.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    nullTasks = addTask(nullTasks, 'Deckungszusage für Berufung dokumentieren', claim, claim.Clerk__r, System.today() + (Integer)correspondence.Follow_up_Period__c, claim.opportunity__c);
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') { // new s5
                    nullTasks = addTask(nullTasks, 'Deckungszusage für Verteidigungsanzeige dokumentieren', claim, claim.Clerk_Appeal__r, System.today(), claim.opportunity__c);
                }
            }

            // ========================
            // new code
            // process builder to apex
            // ========================

            if (correspondence.Berufungsschrift_erstellt__c) {
                nullTasks = addTask(nullTasks, 'Berufungsschrift herunterladen und versenden (BeA)', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
            }

            if (correspondence.Type__c == 'Fristverlängerung') {
                nullTasks = addTask(nullTasks, 'Antrag auf Fristverlängerung senden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
            } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                nullTasks = addTask(nullTasks, 'Deckungsanfrage für Verteidigungsanzeige versenden', correspondence, claim.Clerk_Appeal__r, System.today(), claim.opportunity__c);
            } else if (correspondence.Type__c == 'Berufungsschrift') {
                nullTasks = addTask(nullTasks, 'Berufungsschrift erstellen (mit Textbausteinen)', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
            } else if (correspondence.Type__c == 'Berufungsbegründung') {
                if (correspondence.Berufungsbegruendung_created__c) {
                    nullTasks = addTask(nullTasks, 'Berufungsbegründung herunterladen und versenden (BeA)', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
                }
                nullTasks = addTask(nullTasks, 'Berufungsbegründung erstellen', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
            } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                nullTasks = addTask(nullTasks, 'Verteidigungsanzeige versenden', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
            }

            if (correspondence.Stage__c == 'Sent') {
                if (correspondence.Wiedervorlage_erstellen__c) {
                    if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Widerspruch durch Kunden', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Anspruchsschreiben', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Klageschrift') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Klageschrift', correspondence, claim.Legal__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                        User nina = [SELECT ID, isActive FROM User WHERE id = :Users.NinaHoyer()];
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Gerichtskostenrechnung', correspondence, nina, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Replik') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Replik', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Vollmacht §141 ZPO', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                	} else if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Deckungsanfrage für Anspruchsschreiben', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Deckungsanfrage für Klage', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Sonstiges') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Sonstiges', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (
                        correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige'
                        && (claim.Result__c == 'Accepted' || claim.Result__c == 'Partially won')
                        && claim.Cover_Note_Scope__c.contains('Appeal')
                    ) {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Deckungsanfrage für Verteidigungsanzeige', correspondence, claim.Clerk__r, System.today() + 7, claim.opportunity__c);
					} else if (correspondence.Type__c == 'Fristverlängerung') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Fristverlängerung', correspondence, claim.Clerk__r, System.today(), claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Deckungsanfrage für Berufung', correspondence, claim.Clerk_Appeal__r, System.today() + 7, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Berufungsschrift') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Berufungsschrift', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Berufungsbegründung') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Berufungsbegründung', correspondence, claim.Legal__r, System.today(), claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Verteidigungsanzeige', correspondence, claim.Clerk_Appeal__r, System.today(), claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Widerspruchsschreiben', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                        nullTasks = addTask(nullTasks, 'Wiedervorlage bzgl. Widerspruch', correspondence, claim.Clerk__r, System.today() + 14, claim.opportunity__c);
                    }
                }
            }
        }

        for (Task task : nullTasks) {
            if (task == null) {
                continue;
            }
            newTasks.add(task);
        }

        if (newTasks.size() > 0) {
            insert newTasks;
        }
    }

    public static void close(List<Correspondence__c> correspondencies) {
		correspondencies = [SELECT Id, Stage__c, (select Id,Status,Subject FROM Tasks) FROM Correspondence__c WHERE Id IN :correspondencies];

        List<Task> updateTasks = new List<Task>();

        for (Correspondence__c correspondence : correspondencies) {
            if ((correspondence.Stage__c == 'Canceled')) {
                updateTasks.addAll(Tasks.markAsClosed('',correspondence));
            } else if (correspondence.Stage__c == 'Received') {
                updateTasks.addAll(Tasks.markAsClosed('Auf Vollständigkeit/Frist prüfen, Dokument hochladen und als empfangen markieren',correspondence));
            } else if (correspondence.Stage__c == 'Sent') {
                updateTasks.addAll(Tasks.markAsClosed('Unterschriebenen Widerspruch hochladen und an Kreditinstitut versenden',correspondence));
            }
        }

        if (updateTasks.size() > 0) {
            update updateTasks;
        }
    }
}