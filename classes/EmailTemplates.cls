public without sharing class EmailTemplates {
    public static map<string, id> templateToIds;
    
    static {
        EmailTemplate[] ets = [
            SELECT ID, DeveloperName, Name
            FROM EmailTemplate
        ];
        
        templateToIds = new map<string, id>();
        
        for(EmailTemplate et : ets) {
            templateToIds.put(et.DeveloperName.toLowerCase(), et.Id);
        }
    }

    public enum LvBackoffice {
        LvBackofficeAuthorizationVr24,
        LvBackofficeAuthorizationVh24
    }

    public enum ClaimComparison {
        FzLeComLegalClaimComparisonunderReviewBank,
		FzLeComLegalClaimComparisonunderReviewRechtsschutzversicherung,
		FzLeComLegalClaimComparisonunderReviewKunde,
		FzJaegerLegalClaimComparisonunderReviewBank,
		FzJaegerLegalClaimComparisonunderReviewRechtsschutzversicherung,
		FzJaegerLegalClaimComparisonunderReviewKunde,
		FzKainzLegalClaimComparisonunderReviewBank,
		FzKainzLegalClaimComparisonunderReviewRechtsschutzversicherung,
		FzKainzLegalClaimComparisonunderReviewKunde
    }

    public enum Cancellation {
        LvLeComLegalCancellation,
        DieselLeComLegalCancellation,
        FzLeComLegalCancellation,
        DieselJaegerLegalCancellation,
        DieselKainzLegalCancellation,
        FzJaegerLegalCancellation,
        FzKainzLegalCancellation,
        LvKainzLegalCancellation,
        LvJaegerLegalCancellation
    }

    public enum RequestOwnership {
        DieselLeComLegalRequestOwnership,
        DieselJaegerLegalRequestOwnership,
        Diesel21LegalLegalRequestOwnership,
        DieselKainzLegalRequestOwnership,
        DieselLachmairLegalRequestOwnership
    }

    public enum GeneralTestCase {
        DieselskandalGeneralTestCaseNewTestCaseAssignmentVr24,
        DieselskandalGeneralTestCaseNewTestCaseNoAssignmentVr24,
        DieselskandalGeneralTestCaseNewTestCaseAssignmentVh24,
        DieselskandalGeneralTestCaseNewTestCaseNoAssignmentVh24,
        DieselskandalGeneralTestCaseFinishedTestCaseVr24,
        DieselskandalGeneralTestCaseFinishedTestCaseVh24
    }

    public enum LegalAuthorization {
        DieselLeComLegalAuthorization,
        LvLeComLegalAuthorization,
		DieselJaegerLegalAuthorization,
		Diesel21LegalLegalAuthorization,
		DieselKainzLegalAuthorization,
		DieselLachmairLegalAuthorization,
		Lv21LegalLegalAuthorization,
		LvKainzLegalAuthorization,
		LvJaegerLegalAuthorization
    }

    public enum LegalDate {
        FzKainzLegalDateRecord,
		DieselJaegerLegalDateRecord,
		DieselKainzLegalDateRecord,
		FzJaegerLegalDateRecord,
		LvKainzLegalDateRecord,
		LvJaegerLegalDateRecord,
        FzKainzLegalDateNotification,
        LvJaegerLegalDateNotification,
        LvKainzLegalDateNotification,
        FzJaegerLegalDateNotification,
        DieselKainzLegalDateNotification,
        DieselJaegerLegalDateNotification,
        FzLeComLegalDateReminderCustomer14,
        LvLeComLegalDateReminderCustomer14,
        LvLeComLegalDateNotification,
        FzLeComLegalDateReminderRepresentative2,
        DieselLeComLegalDateNotification,
        LvLeComLegalDateRequest,
        LvLeComLegalDateRecord,
        LvLeComLegalDateAuthorization,
        DieselLeComLegalDateRequest,
        FzLeComLegalDateAuthorization,
        LvLeComLegalDateReminderRepresentative2,
        DieselLeComLegalDateReminderCustomer2,
        DieselLeComLegalDateRecord,
        LvLeComLegalDateReminderCustomer2,
        DieselLeComLegalDateReminderRepresentative2,
        FzLeComLegalDateReminderRepresentative14,
        LvLeComLegalDateReminderRepresentative14,
        FzLeComLegalDateReminderCustomer2,
        FzLeComLegalDateRequest,
        FzLeComLegalDateRecord,
        FzLeComLegalDateNotification,
        DieselLeComLegalDateReminderRepresentative14,
        DieselLeComLegalDateAuthorization,
        DieselLeComLegalDateReminderCustomer14,
        DieselJaegerLegalDateRequest,
        DieselKainzLegalDateRequest,
        FzJaegerLegalDateRequest,
        FzKainzLegalDateRequest,
        LvJaegerLegalDateRequest,
        LvKainzLegalDateRequest,
        DieselJaegerLegalDateAuthorization,
        DieselKainzLegalDateAuthorization,
        FzJaegerLegalDateAuthorization,
        LvJaegerLegalDateAuthorization,
        LvKainzLegalDateAuthorization
    }

    public enum LegalCorrespondence {
        LvLeComLegalCorrespondenceFristverlaengerung,
        LvLeComLegalCorrespondenceVerteidigungsanzeige,
        LvLeComLegalCorrespondenceDeckungsanfrageFuerVerteidigungsanzeige,
        FzKainzLegalCorrespondenceWiderspruchDurchKunden,
        DieselLeComLegalCorrespondenceGeneral,
        DieselLeComLegalCorrespondenceKlageschrift,
        FzLeComLegalCorrespondenceWiderspruchDurchAnwalt,
        DieselLeComLegalCorrespondenceDeckungsanfrageFuerAnspruchsschreiben,
        LvLeComLegalCorrespondenceKlageschrift,
        DieselLeComLegalCorrespondenceDeckungsanfrageFuerBerufung,
        DieselLeComLegalCorrespondenceAnspruchsschreiben,
        LvLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        FzLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        LvLeComLegalCorrespondenceCustomerInformation,
        DieselLeComLegalCorrespondenceReplik,
        FzLeComLegalCorrespondenceGeneral,
        LvLeComLegalCorrespondenceDeckungsanfrageFuerKlage,
        LvLeComLegalCorrespondenceWiderspruchDurchKunden,
        LvLeComLegalCorrespondenceDeckungsanfrageFuerBerufung,
        LvLeComLegalCorrespondenceGeneral,
        DieselLeComLegalCorrespondenceDeckungsanfrageFuerKlage,
        DieselLeComLegalCorrespondenceVollmacht141ZPO,
        FzLeComLegalCorrespondenceCustomerInformation,
        DieselLeComLegalCorrespondenceCustomerInformation,
        DieselLeComLegalCorrespondenceGerichtskostenrechnung,
        FzLeComLegalCorrespondenceGerichtskostenrechnung,
        DieselLeComLegalCorrespondenceReminder,
        FzLeComLegalCorrespondenceWiderspruchDurchKunden,
        FzLeComLegalCorrespondenceDeckungsanfrageFuerBerufung,
        FzLeComLegalCorrespondenceDeckungsanfrageFuerKlage,
        FzLeComLegalCorrespondenceKlageschrift,
        LvLeComLegalCorrespondenceWiderspruchDurchAnwalt,
        LvLeComLegalCorrespondenceReminder,
        DieselJaegerLegalCorrespondenceCustomerInformation,
        Diesel21LegalLegalCorrespondenceCustomerInformation,
        DieselKainzLegalCorrespondenceCustomerInformation,
        DieselLachmairLegalCorrespondenceCustomerInformation,
        FzJaegerLegalCorrespondenceCustomerInformation,
        FzKainzLegalCorrespondenceCustomerInformation,
        Lv21LegalLegalCorrespondenceCustomerInformation,
        LvKainzLegalCorrespondenceCustomerInformation,
        LvJaegerLegalCorrespondenceCustomerInformation
    }

    public enum General {
        DieselskandalGeneralWebformStep3MessageVh24,
        DieselskandalGeneralOpportunityOnHoldInsertVh24,
        DieselskandalGeneralOpportunityOnHoldInsertVr24,
        DieselskandalGeneralOpportunityOnHoldUpdateVh24,
        DieselskandalGeneralOpportunityOnHoldUpdateVr24,
        DieselskandalGeneralWebformStep2MessageDaimlerVh24,
        DieselskandalGeneralWebformStep2MessagePorscheVh24,
        DieselskandalGeneralWebformStep2MessageAudiVh24,
        DieselskandalGeneralWebformStep2MessageOpelVh24,
        DieselskandalGeneralWebformStep2MessageVwVh24,
        DieselskandalGeneralWebformStep2MessageNoVehicleBrandVh24,
        DieselskandalGeneralWebformStep2MessageDaimlerVr24,
        DieselskandalGeneralWebformStep2MessagePorscheVr24,
        DieselskandalGeneralWebformStep2MessageAudiVr24,
        DieselskandalGeneralWebformStep2MessageOpelVr24,
        DieselskandalGeneralWebformStep2MessageVwVr24,
        DieselskandalGeneralWebformStep2MessageNoVehicleBrandVr24,
        LvGeneralOpportunityOnHoldInsertVh24,
        LvGeneralOpportunityOnHoldInsertVr24,
        LvGeneralOpportunityOnHoldUpdateVh24,
        LvGeneralOpportunityOnHoldUpdateVr24,
        LvGeneralWebformStep2MessageVh24,
        LvGeneralWebformStep2MessageVr24,
        LvGeneralRefusalNichtImZeitraumVh24,
        LvGeneralRefusalNichtImZeitraumVr24,
        LvGeneralRefusalKundeMoechteNichtWegenPreisVh24,
        LvGeneralRefusalKundeMoechteNichtWegenPreisVr24,
        LvGeneralRefusalKundeWillNichtVh24,
        LvGeneralRefusalKundeWillNichtVr24,
        LvGeneralRefusalWiderrufNichtAngreifbarVh24,
        LvGeneralRefusalWiderrufNichtAngreifbarVr24,
        LvGeneralRefusalPotentialZuGeringVh24,
        LvGeneralRefusalPotentialZuGeringVr24,
        LvGeneralRefusalKeinWirtschaftlichesPotentialVh24,
        LvGeneralRefusalKeinWirtschaftlichesPotentialVr24,
        LvGeneralRefusalDokumenteNichtGeschicktVh24,
        LvGeneralRefusalDokumenteNichtGeschicktVr24,
        LvGeneralRefusalKundeNichtErreichbarVh24,
        LvGeneralRefusalKundeNichtErreichbarVr24,
        LvGeneralRefusalSonstigeGruendeVh24,
        LvGeneralRefusalSonstigeGruendeVr24
    }

    public enum LeComLegalRefusal {
        FzLeComLegalRefusalKundeNichtKaeufer,
        DieselLeComLegalRefusalKundeNichtKaeufer,
        FzLeComLegalRefusalUmruestungErfolgt,
        DieselLeComLegalRefusalKapitalZuGering,
        FzLeComLegalRefusalLeasingVertrag,
        FzLeComLegalRefusalNutzungsanteilZuGering,
        FzLeComLegalRefusalKeineWiderrufsbelehrung,
        FzLeComLegalRefusalBmwEzNach2014,
        DieselLeComLegalRefusalAutoVerkauft,
        FzLeComLegalRefusalKundeVerstorben,
        DieselLeComLegalRefusalLeasingVertrag,
        DieselLeComLegalRefusalFahrzeugNichtBetroffen,
        FzLeComLegalRefusalFahrzeugNichtBetroffen,
        DieselLeComLegalRefusalDarlehensvertragAelter2Jahre,
        FzLeComLegalRefusalKundeHatWiderrufen,
        FzLeComLegalRefusalKundeNichtErreichbar,
        FzLeComLegalRefusalAutoVerkauft,
        DieselLeComLegalRefusalUmruestungErfolgt,
        DieselLeComLegalRefusalMfkNichtBestaetigt,
        DieselLeComLegalRefusalKundeHatWiderrufen,
        FzLeComLegalRefusalMfkNichtBestaetigt,
        FzLeComLegalRefusalKapitalZuGering,
        FzLeComLegalRefusalDokumenteNichtGeschickt,
        FzLeComLegalRefusalAtChKleinerMotor,
        FzLeComLegalRefusalDarlehensvertragAelter2Jahre,
        DieselLeComLegalRefusalKeineWiderrufsbelehrung,
        DieselLeComLegalRefusalDokumenteNichtGeschickt,
        DieselLeComLegalRefusalAtChKleinerMotor,
        FzLeComLegalRefusalAbsageWegenKenntnis,
        DieselLeComLegalRefusalNutzungsanteilZuGering,
        DieselLeComLegalRefusalBmwEzNach2014,
        FzLeComLegalRefusalNichtImZeitraum,
        FzLeComLegalRefusalEffektiverJahreszins,
        DieselLeComLegalRefusalNichtImZeitraum,
        DieselLeComLegalRefusalEffektiverJahreszins,
        DieselLeComLegalRefusalAbsageWegenKenntnis,
        DieselLeComLegalRefusalKundeVerstorben
    }

    public enum LegalRefusal {
        DieselJaegerLegalRefusalFahrzeugNichtBetroffen,
        Diesel21LegalLegalRefusalFahrzeugNichtBetroffen,
        DieselKainzLegalRefusalFahrzeugNichtBetroffen,
        DieselLachmairLegalRefusalFahrzeugNichtBetroffen,
        DieselJaegerLegalRefusalKundeVerstorben,
        Diesel21LegalLegalRefusalKundeVerstorben,
        DieselKainzLegalRefusalKundeVerstorben,
        DieselLachmairLegalRefusalKundeVerstorben,
        DieselJaegerLegalRefusalDokumenteNichtGeschickt,
        Diesel21LegalLegalRefusalDokumenteNichtGeschickt,
        DieselKainzLegalRefusalDokumenteNichtGeschickt,
        DieselLachmairLegalRefusalDokumenteNichtGeschickt,
        DieselJaegerLegalRefusalKundeHatWiderrufen,
        Diesel21LegalLegalRefusalKundeHatWiderrufen,
        DieselKainzLegalRefusalKundeHatWiderrufen,
        DieselLachmairLegalRefusalKundeHatWiderrufen,
        DieselJaegerLegalRefusalAutoVerkauft,
        Diesel21LegalLegalRefusalAutoVerkauft,
        DieselKainzLegalRefusalAutoVerkauft,
        DieselLachmairLegalRefusalAutoVerkauft,
        DieselJaegerLegalRefusalKundeNichtKaeufer,
        Diesel21LegalLegalRefusalKundeNichtKaeufer,
        DieselKainzLegalRefusalKundeNichtKaeufer,
        DieselLachmairLegalRefusalKundeNichtKaeufer,
        DieselJaegerLegalRefusalNichtImZeitraum,
        Diesel21LegalLegalRefusalNichtImZeitraum,
        DieselKainzLegalRefusalNichtImZeitraum,
        DieselLachmairLegalRefusalNichtImZeitraum,
        DieselJaegerLegalRefusalLeasingVertrag,
        DieselKainzLegalRefusalLeasingVertrag,
        DieselJaegerLegalRefusalKeineWiderrufsbelehrung,
        DieselKainzLegalRefusalKeineWiderrufsbelehrung,
        DieselJaegerLegalRefusalBmwEzNach2014,
        DieselKainzLegalRefusalBmwEzNach2014,
        DieselJaegerLegalRefusalDarlehensvertragAelter2Jahre,
        DieselKainzLegalRefusalDarlehensvertragAelter2Jahre,
        DieselJaegerLegalRefusalNutzungsanteilZuGering,
        DieselKainzLegalRefusalNutzungsanteilZuGering,
        DieselJaegerLegalRefusalKapitalZuGering,
        DieselKainzLegalRefusalKapitalZuGering,
        DieselJaegerLegalRefusalAtChKleinerMotor,
        DieselKainzLegalRefusalAtChKleinerMotor,
        DieselJaegerLegalRefusalUmruestungErfolgt,
        DieselKainzLegalRefusalUmruestungErfolgt,
        DieselJaegerLegalRefusalMfkNichtBestaetigt,
        DieselKainzLegalRefusalMfkNichtBestaetigt,
        DieselJaegerLegalRefusalEffektiverJahreszins,
        DieselKainzLegalRefusalEffektiverJahreszins,
        DieselJaegerLegalRefusalAbsageWegenKenntnis,
        DIeselKainzLegalRefusalAbsageWegenKenntnis,
        FzJaegerLegalRefusalFahrzeugNichtBetroffen,
        FzKainzLegalRefusalFahrzeugNichtBetroffen,
        FzJaegerLegalRefusalKundeVerstorben,
        FzKainzLegalRefusalKundeVerstorben,
        FzJaegerLegalRefusalDokumenteNichtGeschickt,
        FzKainzLegalRefusalDokumenteNichtGeschickt,
        FzJaegerLegalRefusalKundeHatWiderrufen,
        FzKainzLegalRefusalKundeHatWiderrufen,
        FzJaegerLegalRefusalAutoVerkauft,
        FzKainzLegalRefusalAutoVerkauft,
        FzJaegerLegalRefusalKundeNichtKaeufer,
        FzKainzLegalRefusalKundeNichtKaeufer,
        FzJaegerLegalRefusalNichtImZeitraum,
        FzKainzLegalRefusalNichtImZeitraum,
        FzJaegerLegalRefusalKundeNichtErreichbar,
        FzJaegerLegalRefusalLeasingVertrag,
        FzKainzLegalRefusalLeasingVertrag,
        FzJaegerLegalRefusalKeineWiderrufsbelehrung,
        FzKainzLegalRefusalKeineWiderrufsbelehrung,
        FzJaegerLegalRefusalBmwEzNach2014,
        FzKainzLegalRefusalBmwEzNach2014,
        FzJaegerLegalRefusalDarlehensvertragAelter2Jahre,
        FzKainzLegalRefusalDarlehensvertragAelter2Jahre,
        FzJaegerLegalRefusalNutzungsanteilZuGering,
        FzKainzLegalRefusalNutzungsanteilZuGering,
        FzJaegerLegalRefusalKapitalZuGering,
        FzKainzLegalRefusalKapitalZuGering,
        FzJaegerLegalRefusalAtChKleinerMotor,
        FzKainzLegalRefusalAtChKleinerMotor,
        FzJaegerLegalRefusalUmruestungErfolgt,
        FzKainzLegalRefusalUmruestungErfolgt,
        FzJaegerLegalRefusalMfkNichtBestaetigt,
        FzKainzLegalRefusalMfkNichtBestaetigt,
        FzJaegerLegalRefusalEffektiverJahreszins,
        FzKainzLegalRefusalEffektiverJahreszins,
        FzJaegerLegalRefusalAbsageWegenKenntnis,
        FzKainzLegalRefusalAbsageWegenKenntnis
    }
    
    public enum GeneralRefusal {
        DieselskandalGeneralRefusalFahrzeugNichtBetroffenVh24,
        DieselskandalGeneralRefusalKundeVerstorbenVh24,
        DieselskandalGeneralRefusalDokumenteNichtGeschicktVh24,
        DieselskandalGeneralRefusalKundeHatWiderrufenVh24,
        DieselskandalGeneralRefusalAutoVerkauftVh24,
        DieselskandalGeneralRefusalKundeNichtKaeuferVh24,
        DieselskandalGeneralRefusalNichtImZeitraumVh24,
        DieselskandalGeneralRefusalKundeNichtErreichtVh24,
        DieselskandalGeneralRefusalKundeHatKeineRsvVh24,
        DieselskandalGeneralRefusalLeasingVertragVh24,
        DieselskandalGeneralRefusalKeineWiderrufsbelehrungVh24,
        DieselskandalGeneralRefusalBmwEzNach2014Vh24,
        DieselskandalGeneralRefusalDarlehensvertragAelter2JahreVh24,
        DieselskandalGeneralRefusalNutzungsanteilZuGeringVh24,
        DieselskandalGeneralRefusalKapitalZuGeringVh24,
        DieselskandalGeneralRefusalAtChKleinerMotorVh24,
        DieselskandalGeneralRefusalUmruestungErfolgtVh24,
        DieselskandalGeneralRefusalMfkNichtBestaetigtVh24,
        DieselGeneralRefusalEffektiverJahreszinsVh24,
        DieselGeneralRefusalAbsageWegenKenntnisVh24,
        DieselskandalGeneralRefusalFahrzeugNichtBetroffenVr24,
        DieselskandalGeneralRefusalKundeVerstorbenVr24,
        DieselskandalGeneralRefusalDokumenteNichtGeschicktVr24,
        DieselskandalGeneralRefusalKundeHatWiderrufenVr24,
        DieselskandalGeneralRefusalAutoVerkauftVr24,
        DieselskandalGeneralRefusalKundeNichtKaeuferVr24,
        DieselskandalGeneralRefusalNichtImZeitraumVr24,
        DieselskandalGeneralRefusalKundeNichtErreichtVr24,
        DieselskandalGeneralRefusalKundeHatKeineRsvVr24,
        DieselskandalGeneralRefusalLeasingVertragVr24,
        DieselskandalGeneralRefusalKeineWiderrufsbelehrungVr24,
        DieselskandalGeneralRefusalBmwEzNach2014Vr24,
        DieselskandalGeneralRefusalDarlehensvertragAelter2JahreVr24,
        DieselskandalGeneralRefusalNutzungsanteilZuGeringVr24,
        DieselskandalGeneralRefusalKapitalZuGeringVr24,
        DieselskandalGeneralRefusalAtChKleinerMotorVr24,
        DieselskandalGeneralRefusalUmruestungErfolgtVr24,
        DieselskandalGeneralRefusalMfkNichtBestaetigtVr24,
        DieselGeneralRefusalEffektiverJahreszinsVr24,
        DieselGeneralRefusalAbsageWegenKenntnisVr24,
        FzGeneralRefusalFahrzeugNichtBetroffenVh24,
        FzGeneralRefusalKundeVerstorbenVh24,
        FzGeneralRefusalDokumenteNichtGeschicktVh24,
        FzGeneralRefusalKundeHatWiderrufenVh24,
        FzGeneralRefusalAutoVerkauftVh24,
        FzGeneralRefusalKundeNichtKaeuferVh24,
        FzGeneralRefusalNichtImZeitraumVh24,
        FzGeneralRefusalKundeNichtErreichtVh24,
        FzGeneralRefusalLeasingVertragVh24,
        FzGeneralRefusalKeineWiderrufsbelehrungVh24,
        FzGeneralRefusalBmwEzNach2014Vh24,
        FzGeneralRefusalDarlehensvertragAelter2JahreVh24,
        FzGeneralRefusalNutzungsanteilZuGeringVh24,
        FzGeneralRefusalKapitalZuGeringVh24,
        FzGeneralRefusalAtChKleinerMotorVh24,
        FzGeneralRefusalUmruestungErfolgtVh24,
        FzGeneralRefusalMfkNichtBestaetigtVh24,
        FzGeneralRefusalEffektiverJahreszinsVh24,
        FzGeneralRefusalAbsageWegenKenntnisVh24,
        FzGeneralRefusalFahrzeugNichtBetroffenVr24,
        FzGeneralRefusalKundeVerstorbenVr24,
        FzGeneralRefusalDokumenteNichtGeschicktVr24,
        FzGeneralRefusalKundeHatWiderrufenVr24,
        FzGeneralRefusalAutoVerkauftVr24,
        FzGeneralRefusalKundeNichtKaeuferVr24,
        FzGeneralRefusalNichtImZeitraumVr24,
        FzGeneralRefusalKundeNichtErreichtVr24,
        FzGeneralRefusalLeasingVertragVr24,
        FzGeneralRefusalKeineWiderrufsbelehrungVr24,
        FzGeneralRefusalBmwEzNach2014Vr24,
        FzGeneralRefusalDarlehensvertragAelter2JahreVr24,
        FzGeneralRefusalNutzungsanteilZuGeringVr24,
        FzGeneralRefusalKapitalZuGeringVr24,
        FzGeneralRefusalAtChKleinerMotorVr24,
        FzGeneralRefusalUmruestungErfolgtVr24,
        FzGeneralRefusalMfkNichtBestaetigtVr24,
        FzGeneralRefusalEffektiverJahreszinsVr24,
        FzGeneralRefusalAbsageWegenKenntnisVr24,
        LvGeneralRefusalNichtImZeitraumVh24,
        LvGeneralRefusalNichtImZeitraumVr24,
        LvGeneralRefusalKundeMoechteNichtWegenPreisVh24,
        LvGeneralRefusalKundeMoechteNichtWegenPreisVr24,
        LvGeneralRefusalKundeWillNichtVh24,
        LvGeneralRefusalKundeWillNichtVr24,
        LvGeneralRefusalWiderrufNichtAngreifbarVh24,
        LvGeneralRefusalWiderrufNichtAngreifbarVr24,
        LvGeneralRefusalPotentialZuGeringVh24,
        LvGeneralRefusalPotentialZuGeringVr24,
        LvGeneralRefusalKeinWirtschaftlichesPotentialVh24,
        LvGeneralRefusalKeinWirtschaftlichesPotentialVr24,
        LvGeneralRefusalDokumenteNichtGeschicktVh24,
        LvGeneralRefusalDokumenteNichtGeschicktVr24,
        LvGeneralRefusalKundeNichtErreichbarVh24,
        LvGeneralRefusalKundeNichtErreichbarVr24,
        LvGeneralRefusalSonstigeGruendeVh24,
        LvGeneralRefusalSonstigeGruendeVr24
    }

    public enum Claims {
        DieselLeComLegalClaimGeneralAccount,
        DieselJaegerLeComCoverNoteRefusedPrecontractualClaimLetterInsurance,
        DieselLeComLegalClaimCoverNoteIssuedClaimLetter,
        DieselLeComLegalClaimNoResponseClaimStatement,
        DieselLeComLegalCoverNoteRefusedOtherClaimLetterCustomer,
        DieselLeComLegalClaimResendDocumentsContact,
        DieselLeComLegalCoverNoteRefusedPrecontractualClaimLetterCustomer,
        DieselLeComLegalClaimCoverNoteRefusedClaimLetter,
        LvLeComLegalClaimGeneralContact,
        LvLeComLegalClaimCoverNoteIssuedLawsuit,
        FzLeComLegalClaimCoverNoteIssuedClaimLetter,
        FzLeComLegalClaimGeneralContact,
        DieselLeComLegalCoverNoteRefusedPostcontractualClaimLetterInsurance,
        DieselLeComLegalClaimCourtDateReminder,
        FzLeComLegalClaimCoverNoteRefusedClaimLetter,
        DieselLeComLegalCoverNoteRefusedPostcontractualClaimLetterCustomer,
        DieselLeComLegalCoverNoteRefusedOtherClaimLetterInsurance,
        LvLeComLegalClaimCoverNoteRefusedClaimLetter,
        LvLeComLegalClaimRequestDocumentsAccount,
        DieselLeComLegalClaimGeneralContact,
        DieselLeComLegalClaimRequestDocumentsContact,
        DieselLeComLegalClaimRequestDeductible,
        DieselLeComLegalClaimNoResponseLawsuitDate,
        FzLeComLegalClaimGeneralAccount,
        DieselLeComLegalClaimCoverNoteIssuedLawsuit,
        LvLeComLegalClaimCoverNoteIssuedClaimLetter,
        LvLeComLegalClaimResendDocumentsAccount,
        DieselLeComLegalClaimClarification,
        LvLeComLegalClaimGeneralAccount,
        LvLeComLegalClaimResendDocumentsContact,
        FzLeComLegalClaimCoverNoteRefusedLawsuit,
        LvLeComLegalClaimCoverNoteRefusedLawsuit,
        DieselLeComLegalClaimResendDocumentsAccount,
        DieselLeComLegalClaimRequestDocumentsAccount,
        DieselLeComLegalClaimCoverNoteRefusedLawsuit,
        DieselLeComLegalClaimReview,
        FzLeComLegalClaimCoverNoteIssuedLawsuit,
        LvLeComLegalClaimRequestDocumentsContact,
        DieselLeComLegalClaimCanceledNexCourtDate,
        DieselJaegerLegalClaimCoverNoteIssuedClaimLetter,
        Diesel21LegalLegalClaimCoverNoteIssuedClaimLetter,
        DieselKainzLegalClaimCoverNoteIssuedClaimLetter,
        DieselLachmairLegalClaimCoverNoteIssuedClaimLetter,
        DieselJaegerLegalClaimCoverNoteRefusedClaimLetter,
        Diesel21LegalLegalClaimCoverNoteRefusedClaimLetter,
        DieselKainzLegalClaimCoverNoteRefusedClaimLetter,
        DieselLachmairLegalClaimCoverNoteRefusedClaimLetter,
        DieselJaegerLegalClaimCoverNoteIssuedLawsuit,
        Diesel21LegalLegalClaimCoverNoteIssuedLawsuit,
        DieselKainzLegalClaimCoverNoteIssuedLawsuit,
        DieselLachmairLegalClaimCoverNoteIssuedLawsuit,
        DieselJaegerLegalClaimCoverNoteRefusedLawsuit,
        Diesel21LegalLegalClaimCoverNoteRefusedLawsuit,
        DieselKainzLegalClaimCoverNoteRefusedLawsuit,
        DieselLachmairLegalClaimCoverNoteRefusedLawsuit,
        DieselJaegerLegalOnHold,
        Diesel21LegalLegalOnHold,
        DieselKainzLegalOnHold,
        DieselLachmairLegalOnHold,
        DieselLeComLegalOnHold,
        LvLeComLegalOnHold,
        DieselJaegerLegalClaimCanceledNexCourtDate,
        Diesel21LegalLegalClaimCanceledNexCourtDate,
        DieselKainzLegalClaimCanceledNexCourtDate,
        DieselLachmairLegalClaimCanceledNexCourtDate,
        DieselJaegerLegalClaimNoResponseClaimStatement,
        Diesel21LegalLegalClaimNoResponseClaimStatement,
        DieselKainzLegalClaimNoResponseClaimStatement,
        DieselLachmairLegalClaimNoResponseClaimStatement,
        DieselJaegerLegalClaimNoResponseLawsuitDate,
        Diesel21LegalLegalClaimNoResponseLawsuitDate,
        DieselKainzLegalClaimNoResponseLawsuitDate,
        DieselLachmairLegalClaimNoResponseLawsuitDate,
        FzJaegerLegalClaimCoverNoteIssuedClaimLetter,
        FzKainzLegalClaimCoverNoteIssuedClaimLetter,
        FzJaegerLegalClaimCoverNoteRefusedClaimLetter,
        FzKainzLegalClaimCoverNoteRefusedClaimLetter,
        FzJaegerLegalClaimCoverNoteIssuedLawsuit,
        FzKainzLegalClaimCoverNoteIssuedLawsuit,
        FzJaegerLegalClaimCoverNoteRefusedLawsuit,
        FzKainzLegalClaimCoverNoteRefusedLawsuit,
        LvJaegerLegalClaimCoverNoteIssuedClaimLetter,
        LvKainzLegalClaimCoverNoteIssuedClaimLetter,
        LvJaegerLegalClaimCoverNoteRefusedClaimLetter,
        LvKainzLegalClaimCoverNoteRefusedClaimLetter,
        LvJaegerLegalClaimCoverNoteIssuedLawsuit,
        LvKainzLegalClaimCoverNoteIssuedLawsuit,
        LvJaegerLegalClaimCoverNoteRefusedLawsuit,
        LvKainzLegalClaimCoverNoteRefusedLawsuit,
        Lv21LegalLegalOnHold,
        LvKainzLegalOnHold,
        LvJaegerLegalOnHold,
        LvBackofficeSetClaimOnHoldVh24,
        LvBackofficeSetClaimOnHoldVr24
    }

    public enum CostNote {
        FzKainzLegalCostNoteInsurance,
        FzKainzLegalCostNoteCustomer,
        LvLeComLegalCostNoteReminderContact,
        DieselLeComLegalCostNoteReminderContact,
        DieselLeComLegalCostNoteCustomer,
        LvLeComLegalCostNoteReminderAccount,
        LvLeComLegalCostNoteCustomer,
        DieselLeComLegalCostNoteReminderAccount,
        DieselLeComLegalCostNoteInsurance,
        FzLeComLegalCostNoteCustomer,
        FzLeComLegalCostNoteInsurance,
        FzLeComLegalCostNoteReminderAccount,
        FzLeComLegalCostNoteReminderContact,
        LvLeComLegalCostNoteInsurance,
        LvJaegerLegalCostNoteReminderAccount,
        LvJaegerLegalCostNoteReminderContact,
        LvKainzLegalCostNoteReminderAccount,
        LvKainzLegalCostNoteReminderContact,
        FzJaegerLegalCostNoteReminderAccount,
        FzJaegerLegalCostNoteReminderContact,
        DieselKainzLegalCostNoteReminderAccount,
        DieselKainzLegalCostNoteReminderContact,
        DieselJaegerLegalCostNoteReminderAccount,
        DieselJaegerLegalCostNoteReminderContact,
        LvJaegerLegalCostNoteInsurance,
        LvJaegerLegalCostNoteCustomer,
        LvKainzLegalCostNoteInsurance,
        LvKainzLegalCostNoteCustomer,
        FzJaegerLegalCostNoteInsurance,
        FzJaegerLegalCostNoteCustomer,
        DieselKainzLegalCostNoteInsurance,
        DieselKainzLegalCostNoteCustomer,
        DieselJaegerLegalCostNoteInsurance,
        DieselJaegerLegalCostNoteCustomer
    }

    public enum CreditNote {
        DieselLeComLegalCreditNote,
        LvLeComLegalCreditNote,
        FzLeComLegalCreditNote,
        LvJaegerLegalCreditNote,
        LvKainzLegalCreditNote,
        FzJaegerLegalCreditNote,
        DieselKainzLegalCreditNote,
        DieselJaegerLegalCreditNote
    }

    public enum AntwortBeimKunden {
        LvLeComLegalAntwortBeimKunden,
        FzKainzLegalAntwortBeimKunden,
        FzLeComLegalAntwortBeimKunden,
        LvKainzLegalAntwortBeimKunden,
        LvJaegerLegalAntwortBeimKunden,
        FzJaegerLegalAntwortBeimKunden
    }

    public enum ReceiveAuthorization {
        LvCallcenterDidNotReceiveAuthorizationVh24,
		LvCallcenterDidNotReceiveAuthorizationVr24
    }

    public enum DocumentsIncomplete {
        DieselskandalBackofficeDocumentsIncompleteVr24,
        DieselskandalBackofficeDocumentsIncompleteVh24,
        DieselskandalBackofficeDocumentsIncompleteJaeger,
        FzBackofficeDocumentsIncompleteJaeger,
        FzBackofficeDocumentsIncompleteVr24,
        FzBackofficeDocumentsIncompleteVh24,
        LvCallcenterDocumentsIncompleteVr24,
        LvCallcenterDocumentsIncompleteVh24
    }

    public enum DocumentsComplete {
        LvCallcenterDocumentsCompleteVh24,
        LvCallcenterDocumentsCompleteVr24
    }
    
    // Note that the enum value name is being used in the SOQL query to find the template.
    public enum Name {
		DieselJaegerBackofficeSendWelcomeLetter,
		Diesel21LegalBackofficeSendWelcomeLetter,
		DieselKainzBackofficeSendWelcomeLetter,
		DieselLachmairBackofficeSendWelcomeLetter,
        LvGeneralLinkZumDokumentenupload,
        FzKainzLegalAnfrageKorrespondenz,
        LvLeComLegalAnfrageKorrespondenz,
        FzLeComLegalAnfrageKorrespondenz,
        DieselLeComLegalAnfrageKorrespondenz,
        DieselJaegerLegalAnfrageKorrespondenz,
        DieselKainzLegalAnfrageKorrespondenz,
        FzJaegerLegalAnfrageKorrespondenz,
        LvJaegerLegalAnfrageKorrespondenz,
        LvKainzLegalAnfrageKorrespondenz,
        FzKainzLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        FzJaegerLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        FzLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        Lv21LegalLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        LvJaegerLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        LvKainzLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        LvLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch,
        ErrorNotification,
        LvBackofficeSendCustomersOppositionToCustomerVr24,
        LvBackofficeSendCustomersOppositionToCustomerVh24,
        FzBackofficeSendCustomersOppositionToCustomerVr24,
        FzBackofficeSendCustomersOppositionToCustomerVh24,
        LvCallcenterDidNotReceiveContractVr24,
        LvCallcenterDidNotReceiveContractVh24,
        LvCallcenterResendContractVh24,
        LvCallcenterResendContractVr24,
        LvCallcenterDidNotReceiveDocumentsVh24,
        LvCallcenterDidNotReceiveDocumentsVr24,
        DieselskandalCallcenterFormstep2LinkVh24,
        DieselskandalCallcenterFormstep2LinkVr24,
        FzCallcenterFormstep2LinkVh24,
        FzCallcenterFormstep2LinkVr24,
        DieselskandalBackofficeResendAuthorizationJaeger,
        DieselskandalBackofficeResendAuthorizationVh24,
        DieselskandalBackofficeResendAuthorizationVr24,
        FzBackofficeResendAuthorizationJaeger,
        FzBackofficeResendAuthorizationVh24,
        FzBackofficeResendAuthorizationVr24,
        LvGeneralBlankTemplateVr24,
        LvGeneralBlankTemplateVh24,
        FzGeneralBlankTemplateVr24,
        FzGeneralBlankTemplateVh24,
        DieselskandalGeneralBlankTemplateVr24,
        DieselskandalGeneralBlankTemplateVh24,
        DieselskandalBackofficeExampleCalculationVh24,
        DieselskandalBackofficeExampleCalculationVr24,
        FzBackofficeExampleCalculationVh24,
        FzBackofficeExampleCalculationVr24,
        LvBackofficeExampleCalculationVh24,
        LvBackofficeExampleCalculationVr24,
        DieselskandalBackofficeSwornStatementJaeger,
        DieselskandalBackofficeSwornStatementVh24,
        DieselskandalBackofficeSwornStatementVr24,
        FzBackofficeSwornStatementJaeger,
        FzBackofficeSwornStatementVh24,
        FzBackofficeSwornStatementVr24,
        DieselskandalBackofficeExampleCalcLeadVh24,
        FzBackofficeExampleCalcLeadVr24,
        FzBackofficeExampleCalcLeadVh24,
        LvBackofficeExampleCalcLeadVh24,
        LvBackofficeExampleCalcLeadVr24,
        DieselskandalBackofficeExampleCalcLeadVr24,
        LvBackofficeFinishedLegalCheckVr24,
        LvBackofficeFinishedLegalCheckVh24,
        DieselskandalCallcenterRsvEmailVh24,
        DieselskandalCallcenterRsvEmailVr24,
        DieselskandalBackofficeDocumentUploadLinkJaeger,
        DieselskandalBackofficeDocumentUploadLinkVh24,
        DieselskandalBackofficeDocumentUploadLinkVr24,
        FzBackofficeDocumentUploadLinkJaeger,
        FzBackofficeDocumentUploadLinkVh24,
        FzBackofficeDocumentUploadLinkVr24,
        SendQuestionToVH24,
        DieselJaegerLegalClaimReview,
        Diesel21LegalLegalClaimReview,
        DieselKainzLegalClaimReview,
        DieselLachmairLegalClaimReview,
        DieselJaegerLegalClaimClarification,
        Diesel21LegalLegalClaimClarification,
        DieselKainzLegalClaimClarification,
        DieselLachmairLegalClaimClarification,
        DieselJaegerLegalClaimRequestDeductible,
        Diesel21LegalLegalClaimRequestDeductible,
        DieselKainzLegalClaimRequestDeductible,
        DieselLachmairLegalClaimRequestDeductible,
        LvCallcenterImportDateCommitmentConfirmationVh24,
        LvCallcenterWebformDateCommitmentConfirmationVh24,
        LvCallcenterImportDateCommitmentConfirmationVr24,
        LvCallcenterWebformDateCommitmentConfirmationVr24,
        LvBackofficeSendPotentialVh24,
        LvBackofficeSendPotentialVr24
    }
    
    public static ID idFromString(string str) {
        id et = templateToIds.get(str.toLowerCase());
      
        if (et == null) {
            return null;
        }
        
        return et;
    }

    public static ID idOf(LvBackoffice ett) {
        return idOf(ett.name());
    }

    public static ID idOf(ClaimComparison ett) {
        return idOf(ett.name());
    }

    public static ID idOf(Cancellation ett) {
        return idOf(ett.name());
    }

    public static ID idOf(RequestOwnership ett) {
        return idOf(ett.name());
    }

    public static ID idOf(GeneralTestCase ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LegalDate ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LegalCorrespondence ett) {
        return idOf(ett.name());
    }

    public static ID idOf(General ett) {
        return idOf(ett.name());
    }
    
    public static ID idOf(LegalRefusal ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LeComLegalRefusal ett) {
        return idOf(ett.name());
    }

    public static ID idOf(GeneralRefusal ett) {
        return idOf(ett.name());
    }

    public static ID idOf(CostNote ett) {
        return idOf(ett.name());
    }

    public static ID idOf(CreditNote ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LegalAuthorization ett) {
        return idOf(ett.name());
    }

    public static ID idOf(AntwortBeimKunden ett) {
        return idOf(ett.name());
    }

    public static ID idOf(ReceiveAuthorization ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DocumentsComplete ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DocumentsIncomplete ett) {
        return idOf(ett.name());
    }

    public static ID idOf(Name ett) {
        return idOf(ett.name());
    }
    
    public static ID idOf(Claims ett) {
        return idOf(ett.name());
    }
    
    private static ID idOf(String ett) {
        return idFromString(ett);
    }
}