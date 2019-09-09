public class EmailUtilitiesCorrespondence {
    public class Result {
        public Correspondence__c correspondence;
        public id templateId;
    }

    private static id eid(string s) {
        return Id.valueOf(EmailTemplates.idFromString(s));
    }

    public static Result getTemplate(Id correspondenceID) {
        id templateId;
        Correspondence__c correspondence = [
            SELECT Id,
            Type__c,
            Claim__r.Opportunity__r.Legal_Account__c,
            Claim__r.Opportunity__r.Financing_Type__c,
            Claim__r.Opportunity__r.RecordTypeId,
            Claim__r.Opportunity__r.Vehicle_Brand__c
            FROM Correspondence__c
            WHERE Id = :correspondenceID
        ];
        system.debug('debug recordtype ' + correspondence.Claim__r.Opportunity__r.RecordTypeId + ' ' + Opportunities.dkRtID);
        if (correspondence.Claim__r.Opportunity__r.RecordTypeId == Opportunities.dkRtID) {
            // Diesel
            if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.jcLegalID) {
                // Jäger
                if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    templateId = eid('DieselJaegerLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    templateId = eid('DieselJaegerLegalCorrespondenceAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('DieselJaegerLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    if (correspondence.Claim__r.Opportunity__r.Financing_Type__c == 'Finanzierung'){
                        templateId = eid('FzJaegerLegalCorrespondenceKlageschrift');
                    } else {
                        templateId = eid('DieselJaegerLegalCorrespondenceKlageschrift');
                    }
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('DieselJaegerLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('DieselJaegerLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Replik') {
                    templateId = eid('DieselJaegerLegalCorrespondenceReplik');
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    templateId = eid('DieselJaegerLegalCorrespondenceVollmacht141ZPO');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('DieselJaegerLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('DieselJaegerLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('DieselJaegerLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('DieselJaegerLegalCorrespondenceFristverlaengerung');
                }
            } else if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.Legal21ID ) {
                // 21Legal
                if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Replik') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceReplik');
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceVollmacht141ZPO');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('Diesel21LegalLegalCorrespondenceGeneral');
                }
            } else if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.CLLBLegalID ) {
                // Kainz
                if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    templateId = eid('DieselKainzLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    templateId = eid('DieselKainzLegalCorrespondenceAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('DieselKainzLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    if (correspondence.Claim__r.Opportunity__r.Financing_Type__c == 'Finanzierung'){
                        templateId = eid('FzKainzLegalCorrespondenceKlageschrift');
                    } else {
                        templateId = eid('DieselKainzLegalCorrespondenceKlageschrift');
                    }
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('DieselKainzLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('DieselKainzLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Replik') {
                    templateId = eid('DieselKainzLegalCorrespondenceReplik');
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    templateId = eid('DieselKainzLegalCorrespondenceVollmacht141ZPO');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('DieselKainzLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('DieselKainzLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('DieselKainzLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('DieselKainzLegalCorrespondenceFristverlaengerung');
                }
            } else if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.LeComLegalID) {
                // LeCom
                if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    templateId = eid('DieselLeComLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    templateId = eid('DieselLeComLegalCorrespondenceAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('DieselLeComLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    if (correspondence.Claim__r.Opportunity__r.Financing_Type__c == 'Finanzierung'){
                        templateId = eid('FzLeComLegalCorrespondenceKlageschrift');
                    } else {
                        templateId = eid('DieselLeComLegalCorrespondenceKlageschrift');
                    }
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('DieselLeComLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('DieselLeComLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Replik') {
                    templateId = eid('DieselLeComLegalCorrespondenceReplik');
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    templateId = eid('DieselLeComLegalCorrespondenceVollmacht141ZPO');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('DieselLeComLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('DieselLeComLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('DieselLeComLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('DieselLeComLegalCorrespondenceFristverlaengerung');
                }
            } else {
                // Lachmair
                if (correspondence.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    templateId = eid('DieselLachmairLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Anspruchsschreiben') {
                    templateId = eid('DieselLachmairLegalCorrespondenceAnspruchsschreiben');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('DieselLachmairLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('DieselLachmairLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('DieselLachmairLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Replik') {
                    templateId = eid('DieselLachmairLegalCorrespondenceReplik');
                } else if (correspondence.Type__c == 'Vollmacht §141 ZPO') {
                    templateId = eid('DieselLachmairLegalCorrespondenceVollmacht141ZPO');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('DieselLachmairLegalCorrespondenceGeneral');
                }
            }
        } else if (correspondence.Claim__r.Opportunity__r.RecordTypeId == Opportunities.fzRtID) {
            // FZ
            if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.jcLegalID) {
                // Jäger
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('FzJaegerLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('FzJaegerLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('FzJaegerLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('FzJaegerLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('FzJaegerLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('FzJaegerLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('FzJaegerLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('FzJaegerLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('FZJaegerLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('FZJaegerLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('FZJaegerLegalCorrespondenceFristverlaengerung');
                }
            } else if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.CLLBLegalID) {
                // Kainz
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('FzKainzLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('FzKainzLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('FzKainzLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('FzKainzLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('FzKainzLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('FzKainzLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Gerichtskostenrechnung') {
                    templateId = eid('FzKainzLegalCorrespondenceGerichtskostenrechnung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('FzKainzLegalCorrespondenceGeneral');
                }
            } else if (Accounts.isLegalLeCom(correspondence.Claim__r.Opportunity__r.Legal_Account__c)) {
				// LeCom
                // https://salesfive.atlassian.net/browse/VH24-151                
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('FzLeComLegalCorrespondenceWiderspruchDurchKunden ');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('FzLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('FzLeComLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('FzLeComLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('FzLeComLegalCorrespondenceKlageschrift ');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('FzLeComLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('FzLeComLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('FzLeComLegalCorrespondenceDeckungsanfrageFürVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('LvLeComLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('LvLeComLegalCorrespondenceFristverlaengerung');
                }
            }
        } else {
            // LV
            if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.Legal21ID ) {
                // 21Legal
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('Lv21LegalLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('Lv21LegalLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('Lv21LegalLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('Lv21LegalLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('Lv21LegalLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('Lv21LegalLegalCorrespondenceGeneral');
                }
            } else if (correspondence.Claim__r.Opportunity__r.Legal_Account__c == Accounts.CLLBLegalID) {
                // Kainz
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('LvKainzLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('LvKainzLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('LvKainzLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('LvKainzLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('LvKainzLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('LvKainzLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('LvKainzLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('LvKainzLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('LvKainzLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('LvKainzLegalCorrespondenceFristverlaengerung');
                }
            } else if (Accounts.isJCLegalLv(correspondence.Claim__r.Opportunity__r.Legal_Account__c)) {
                // Jäger
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('LvJaegerLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('LvJaegerLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('LvJaegerLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('LvJaegerLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('LvJaegerLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('LvJaegerLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('LvJaegerLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('LvJaegerLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('LvJaegerLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('LvJaegerLegalCorrespondenceFristverlaengerung');
                }
            } else {
                // LeCom
                // https://salesfive.atlassian.net/browse/VH24-151                
                if (correspondence.Type__c == 'Widerspruch durch Kunden') {
                    templateId = eid('LvLeComLegalCorrespondenceWiderspruchDurchKunden');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Widerspruch') {
                    templateId = eid('LvLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch');
                } else if (correspondence.Type__c == 'Widerspruch durch Anwalt') {
                    templateId = eid('LvLeComLegalCorrespondenceWiderspruchDurchAnwalt');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = eid('LvLeComLegalCorrespondenceDeckungsanfrageFuerKlage');
                } else if (correspondence.Type__c == 'Klageschrift') {
                    templateId = eid('LvLeComLegalCorrespondenceKlageschrift');
                } else if (correspondence.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = eid('LvLeComLegalCorrespondenceDeckungsanfrageFuerBerufung');
                } else if (correspondence.Type__c == 'Sonstiges') {
                    templateId = eid('LvLeComLegalCorrespondenceGeneral');
                } else if (correspondence.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = eid('LvLeComLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Verteidigungsanzeige') {
                    templateId = eid('LvLeComLegalCorrespondenceVerteidigungsanzeige');
                } else if (correspondence.Type__c == 'Fristverlängerung') {
                    templateId = eid('LvLeComLegalCorrespondenceFristverlaengerung');
                }
            }
        }
		Result r = new Result();
        r.templateId = templateId;
        r.correspondence = correspondence;
        return r;
    }
}