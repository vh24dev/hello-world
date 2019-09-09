public class CloudworxTemplates {
    public static map<string, id> templateToIds;
    
    static {
        cloudworx_document_template__c[] ets = [
            SELECT ID, DeveloperName__c
            FROM cloudworx_document_template__c
        ];
        templateToIds = new map<string, id>();
        for(cloudworx_document_template__c et : ets) {
			templateToIds.put(et.DeveloperName__c.toLowerCase(), et.Id);
        }
    }

	public enum Name {
		FZKundenwiderspruch,
		LVGutschrift,
		LVKostennote,
		LVKundenwiderspruch,
		LVPotentialrechner,
		LVVH24Mahnung,
		LVVH24Rechnung,
		LVVH24VertragDirekt,
		LVVH24VertragRSV,
		LVVH24VertragShare,
		LVVollmacht,
		LVVR24Mahnung,
		LVVR24Rechnung,
		VH24Provision,
		VH24ProvisionExcel,
		VR24Provision,
		VR24ProvisionExcel,
        VH24EidesstattlicheVersicherung
	}

	public enum DG21Legal {
		DG21LegalAnspruchsschreibenAudi,
		DG21LegalAnspruchsschreibenDaimler,
		DG21LegalAnspruchsschreibenOpel,
		DG21LegalAnspruchsschreibenPorsche,
		DG21LegalAnspruchsschreibenVW,
		DG21LegalBegruessungsschreibenAudi,
		DG21LegalBegruessungsschreibenDaimler,
		DG21LegalBegruessungsschreibenOpel,
		DG21LegalBegruessungsschreibenPorsche,
		DG21LegalBegruessungsschreibenVW,
		DG21LegalDeckungsanfrageAnspruchsschreibenAudiAbgelehnt,
		DG21LegalDeckungsanfrageAnspruchsschreibenAudiKeineAntwort,
		DG21LegalDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt,
		DG21LegalDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort,
		DG21LegalDeckungsanfrageAnspruchsschreibenOpelAbgelehnt,
		DG21LegalDeckungsanfrageAnspruchsschreibenOpelKeineAntwort,
		DG21LegalDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt,
		DG21LegalDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort,
		DG21LegalDeckungsanfrageAnspruchsschreibenVwAbgelehnt,
		DG21LegalDeckungsanfrageAnspruchsschreibenVwKeineAntwort,
		DG21LegalDeckungsanfrageKlageAudi,
		DG21LegalDeckungsanfrageKlageDaimler,
		DG21LegalDeckungsanfrageKlageOpel,
		DG21LegalDeckungsanfrageKlagePorsche,
		DG21LegalDeckungsanfrageKlageVW,
		DG21LegalKlageschriftAudi,
		DG21LegalKlageschriftDaimler,
		DG21LegalKlageschriftOpel,
		DG21LegalKlageschriftPorsche,
		DG21LegalKlageschriftVW,
		DG21LegalKontrolldokument,
		DG21LegalReplik,
		DG21LegalSonstiges,
		DG21LegalVollmacht141ZPO,
		DG21LegalVollmachtAudi,
		DG21LegalVollmachtDaimler,
		DG21LegalVollmachtohneGegner,
		DG21LegalVollmachtOpel,
		DG21LegalVollmachtPorsche,
		DG21LegalVollmachtVW
	}

	public enum DGJaeger {
		DGJaegerAnspruchsschreibenAudi,
		DGJaegerAnspruchsschreibenDaimler,
		DGJaegerAnspruchsschreibenOpel,
		DGJaegerAnspruchsschreibenPorsche,
		DGJaegerAnspruchsschreibenVW,
		DGJaegerBegruessungsschreibenAudi,
		DGJaegerBegruessungsschreibenDaimler,
		DGJaegerBegruessungsschreibenOpel,
		DGJaegerBegruessungsschreibenPorsche,
		DGJaegerBegruessungsschreibenVW,
		DGJaegerBerufung,
		DGJaegerBerufungsbegruendung,
		DGJaegerDeckungsanfrageAnspruchsschreibenAudiAbgelehnt,
		DGJaegerDeckungsanfrageAnspruchsschreibenAudiKeineAntwort,
		DGJaegerDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt,
		DGJaegerDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort,
		DGJaegerDeckungsanfrageAnspruchsschreibenOpelAbgelehnt,
		DGJaegerDeckungsanfrageAnspruchsschreibenOpelKeineAntwort,
		DGJaegerDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt,
		DGJaegerDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort,
		DGJaegerDeckungsanfrageAnspruchsschreibenVwAbgelehnt,
		DGJaegerDeckungsanfrageAnspruchsschreibenVwKeineAntwort,
		DGJaegerDeckungsanfrageBerufung,
		DGJaegerDeckungsanfrageKlageAudi,
		DGJaegerDeckungsanfrageKlageDaimler,
		DGJaegerDeckungsanfrageKlageOpel,
		DGJaegerDeckungsanfrageKlagePorsche,
		DGJaegerDeckungsanfrageKlageVW,
		DGJaegerDeckungsanfrageVerteidigungsanzeige,
		DGJaegerEinspruch,
		DGJaegerFristverlaengerungsantrag,
		DGJaegerGutschriftRSVaussergerichtlich,
		DGJaegerGutschriftRSVgerichtlich,
		DGJaegerKlageschriftAudi,
		DGJaegerKlageschriftDaimler,
		DGJaegerKlageschriftkleinerSchadensersatzAudi,
		DGJaegerKlageschriftkleinerSchadensersatzDaimler,
		DGJaegerKlageschriftkleinerSchadensersatzOpel,
		DGJaegerKlageschriftkleinerSchadensersatzPorsche,
		DGJaegerKlageschriftkleinerSchadensersatzVW,
		DGJaegerKlageschriftOpel,
		DGJaegerKlageschriftPorsche,
		DGJaegerKlageschriftVW,
		DGJaegerKostennoteKunde,
		DGJaegerKostennoteRSVaussergerichtlich,
		DGJaegerKostennoteRSVBerufung,
		DGJaegerKostennoteRSVgerichtlich,
		DGJaegerMahnung,
		DGJaegerMusterfeststellungsklage,
		DGJaegerReplik,
		DGJaegerSonstiges,
		DGJaegerSonstigesAnfrage,
		DGJaegerStornierungaussergerichtlich,
		DGJaegerStornierunggerichtlich,
		DGJaegerTerminbenachrichtigung,
		DGJaegerTerminprotokoll,
		DGJaegerTerminvollmacht,
		DGJaegerVerteidigungsanzeige,
		DGJaegerVollmacht141ZPO,
		DGJaegerVollmachtAudi,
		DGJaegerVollmachtDaimler,
		DGJaegerVollmachtohneGegner,
		DGJaegerVollmachtOpel,
		DGJaegerVollmachtPorsche,
		DGJaegerVollmachtVW,
        DGJaegerVollmachtAllgemein
	}

	public enum DGKainz {
		DGKainzAnspruchsschreibenAudi,
		DGKainzAnspruchsschreibenDaimler,
		DGKainzAnspruchsschreibenOpel,
		DGKainzAnspruchsschreibenPorsche,
		DGKainzAnspruchsschreibenVW,
		DGKainzBegruessungsschreibenAudi,
		DGKainzBegruessungsschreibenDaimler,
		DGKainzBegruessungsschreibenOpel,
		DGKainzBegruessungsschreibenPorsche,
		DGKainzBegruessungsschreibenVW,
		DGKainzBerufung,
		DGKainzBerufungsbegruendung,
		DGKainzDeckungsanfrageAnspruchsschreibenAudiAbgelehnt,
		DGKainzDeckungsanfrageAnspruchsschreibenAudiKeineAntwort,
		DGKainzDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt,
		DGKainzDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort,
		DGKainzDeckungsanfrageAnspruchsschreibenOpelAbgelehnt,
		DGKainzDeckungsanfrageAnspruchsschreibenOpelKeineAntwort,
		DGKainzDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt,
		DGKainzDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort,
		DGKainzDeckungsanfrageAnspruchsschreibenVwAbgelehnt,
		DGKainzDeckungsanfrageAnspruchsschreibenVwKeineAntwort,
		DGKainzDeckungsanfrageBerufung,
		DGKainzDeckungsanfrageKlageAudi,
		DGKainzDeckungsanfrageKlageDaimler,
		DGKainzDeckungsanfrageKlageOpel,
		DGKainzDeckungsanfrageKlagePorsche,
		DGKainzDeckungsanfrageKlageVW,
		DGKainzDeckungsanfrageVerteidigungsanzeige,
		DGKainzEinspruch,
		DGKainzFristverlaengerungsantrag,
		DGKainzGutschriftRSVaussergerichtlich,
		DGKainzGutschriftRSVgerichtlich,
		DGKainzKlageschriftAudi,
		DGKainzKlageschriftDaimler,
		DGKainzKlageschriftkleinerSchadensersatzAudi,
		DGKainzKlageschriftkleinerSchadensersatzDaimler,
		DGKainzKlageschriftkleinerSchadensersatzOpel,
		DGKainzKlageschriftkleinerSchadensersatzPorsche,
		DGKainzKlageschriftkleinerSchadensersatzVW,
		DGKainzKlageschriftOpel,
		DGKainzKlageschriftPorsche,
		DGKainzKlageschriftVW,
		DGKainzKostennoteKunde,
		DGKainzKostennoteRSVaussergerichtlich,
		DGKainzKostennoteRSVBerufung,
		DGKainzKostennoteRSVgerichtlich,
		DGKainzMahnung,
		DGKainzReplik,
		DGKainzSonstiges,
		DGKainzSonstigesAnfrage,
		DGKainzStornierungaussergerichtlich,
		DGKainzStornierunggerichtlich,
		DGKainzTerminbenachrichtigung,
		DGKainzTerminprotokoll,
		DGKainzTerminvollmacht,
		DGKainzVerteidigungsanzeige,
		DGKainzVollmacht141ZPO,
		DGKainzVollmachtAudi,
		DGKainzVollmachtDaimler,
		DGKainzVollmachtohneGegner,
		DGKainzVollmachtOpel,
		DGKainzVollmachtPorsche,
		DGKainzVollmachtVW,
        DGKainzVollmachtAllgemein
	}

	public enum DGLachmair {
		DGLachmairAnspruchsschreibenAudi,
		DGLachmairAnspruchsschreibenDaimler,
		DGLachmairAnspruchsschreibenOpel,
		DGLachmairAnspruchsschreibenPorsche,
		DGLachmairAnspruchsschreibenVW,
		DGLachmairBegruessungsschreibenAudi,
		DGLachmairBegruessungsschreibenDaimler,
		DGLachmairBegruessungsschreibenOpel,
		DGLachmairBegruessungsschreibenPorsche,
		DGLachmairBegruessungsschreibenVW,
		DGLachmairDeckungsanfrageAnspruchsschreibenAudiAbgelehnt,
		DGLachmairDeckungsanfrageAnspruchsschreibenAudiKeineAntwort,
		DGLachmairDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt,
		DGLachmairDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort,
		DGLachmairDeckungsanfrageAnspruchsschreibenOpelAbgelehnt,
		DGLachmairDeckungsanfrageAnspruchsschreibenOpelKeineAntwort,
		DGLachmairDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt,
		DGLachmairDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort,
		DGLachmairDeckungsanfrageAnspruchsschreibenVwAbgelehnt,
		DGLachmairDeckungsanfrageAnspruchsschreibenVwKeineAntwort,
		DGLachmairDeckungsanfrageKlageAudi,
		DGLachmairDeckungsanfrageKlageDaimler,
		DGLachmairDeckungsanfrageKlageOpel,
		DGLachmairDeckungsanfrageKlagePorsche,
		DGLachmairDeckungsanfrageKlageVW,
		DGLachmairKlageschriftAudi,
		DGLachmairKlageschriftDaimler,
		DGLachmairKlageschriftOpel,
		DGLachmairKlageschriftPorsche,
		DGLachmairKlageschriftVW,
		DGLachmairKontrolldokument,
		DGLachmairReplik,
		DGLachmairSonstiges,
		DGLachmairVollmacht141ZPO,
		DGLachmairVollmachtAudi,
		DGLachmairVollmachtDaimler,
		DGLachmairVollmachtohneGegner,
		DGLachmairVollmachtOpel,
		DGLachmairVollmachtPorsche,
		DGLachmairVollmachtVW
	}

	public enum DGLeCom {
		DGLeComAnspruchsschreibenAudi,
		DGLeComAnspruchsschreibenDaimler,
		DGLeComAnspruchsschreibenOpel,
		DGLeComAnspruchsschreibenPorsche,
		DGLeComAnspruchsschreibenVW,
		DGLeComBegruessungsschreibenAudi,
		DGLeComBegruessungsschreibenDaimler,
		DGLeComBegruessungsschreibenOpel,
		DGLeComBegruessungsschreibenPorsche,
		DGLeComBegruessungsschreibenVW,
		DGLeComBerufung,
		DGLeComBerufungsbegruendung,
		DGLeComDeckungsanfrageAnspruchsschreibenAudiAbgelehnt,
		DGLeComDeckungsanfrageAnspruchsschreibenAudiKeineAntwort,
		DGLeComDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt,
		DGLeComDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort,
		DGLeComDeckungsanfrageAnspruchsschreibenOpelAbgelehnt,
		DGLeComDeckungsanfrageAnspruchsschreibenOpelKeineAntwort,
		DGLeComDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt,
		DGLeComDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort,
		DGLeComDeckungsanfrageAnspruchsschreibenVWAbgelehnt,
		DGLeComDeckungsanfrageAnspruchsschreibenVWKeineAntwort,
		DGLeComDeckungsanfrageBerufung,
		DGLeComDeckungsanfrageKlageAudi,
		DGLeComDeckungsanfrageKlageDaimler,
		DGLeComDeckungsanfrageKlageOpel,
		DGLeComDeckungsanfrageKlagePorsche,
		DGLeComDeckungsanfrageKlageVW,
		DGLeComDeckungsanfrageVerteidigungsanzeige,
		DGLeComEinspruch,
		DGLeComFristverlaengerungsantrag,
		DGLeComGutschriftRSVaussergerichtlich,
		DGLeComGutschriftRSVgerichtlich,
		DGLeComKlageschriftAudi,
		DGLeComKlageschriftDaimler,
		DGLeComKlageschriftkleinerSchadensersatzAudi,
		DGLeComKlageschriftkleinerSchadensersatzDaimler,
		DGLeComKlageschriftkleinerSchadensersatzOpel,
		DGLeComKlageschriftkleinerSchadensersatzPorsche,
		DGLeComKlageschriftkleinerSchadensersatzVW,
		DGLeComKlageschriftOpel,
		DGLeComKlageschriftPorsche,
		DGLeComKlageschriftVW,
		DGLeComKostennoteKunde,
		DGLeComKostennoteRSVaussergerichtlich,
		DGLeComKostennoteRSVBerufung,
		DGLeComKostennoteRSVgerichtlich,
		DGLeComMahnung,
		DGLeComMusterfeststellungsklage,
		DGLeComReplik,
		DGLeComSonstiges,
		DGLeComSonstigesAnfrage,
		DGLeComStornierungaussergerichtlich,
		DGLeComStornierunggerichtlich,
		DGLeComTerminbenachrichtigung,
		DGLeComTerminprotokoll,
		DGLeComTerminvollmacht,
		DGLeComVerteidigungsanzeige,
		DGLeComVollmacht141ZPO,
		DGLeComVollmachtAudi,
		DGLeComVollmachtDaimler,
		DGLeComVollmachtohneGegner,
		DGLeComVollmachtOpel,
		DGLeComVollmachtPorsche,
		DGLeComVollmachtVW,
        DGLeComVollmachtAllgemein
	}

	public enum FZJaeger {
        FZJaegerVollmacht,
        FZJaegerEinspruch,
        FZJaegerFristverlaengerungsantrag,
        FZJaegerBerufung,
            FZJaegerBerufungsbegruendung,
        FZJaegerDeckungsanfrageVerteidigungsanzeige,
            FZJaegerVerteidigungsanzeige,
		FZJaegerAnwaltswiderspruch,
		FZJaegerAnwaltswiderspruchKeineAntwort,
		FZJaegerDeckungsanfrageBerufung,
		FZJaegerDeckungsanfragefuerKlage,
		FZJaegerDeckungsanfragefuerWiderspruchAbgelehnt,
		FZJaegerDeckungsanfragefuerWiderspruchKeineAntwort,
		FZJaegerGutschriftRSVaussergerichtlich,
		FZJaegerGutschriftRSVgerichtlich,
		FZJaegerKlageschrift,
		FZJaegerKostennoteKunde,
		FZJaegerKostennoteRSVaussergerichtlich,
		FZJaegerKostennoteRSVBerufung,
		FZJaegerKostennoteRSVgerichtlich,
		FZJaegerMahnung,
		FZJaegerSonstiges,
		FZJaegerSonstigesAnfrage,
		FZJaegerStornierungaussergerichtlich,
		FZJaegerStornierunggerichtlich,
		FZJaegerTerminbenachrichtigung,
		FZJaegerTerminprotokoll,
		FZJaegerTerminvollmacht
	}

	public enum FZKainz {
        FZKainzVollmacht,
        FZKainzEinspruch,
        FZKainzFristverlaengerungsantrag,
        FZKainzBerufung,
        FZKainzBerufungsbegruendung,
        FZKainzDeckungsanfrageVerteidigungsanzeige,
            FZKainzVerteidigungsanzeige,
		FZKainzAnwaltswiderspruch,
		FZKainzAnwaltswiderspruchKeineAntwort,
		FZKainzDeckungsanfrageBerufung,
		FZKainzDeckungsanfragefuerKlage,
		FZKainzDeckungsanfragefuerWiderspruchAbgelehnt,
		FZKainzDeckungsanfragefuerWiderspruchKeineAntwort,
		FZKainzGutschriftRSVaussergerichtlich,
		FZKainzGutschriftRSVgerichtlich,
		FZKainzKlageschrift,
		FZKainzKostennoteKunde,
		FZKainzKostennoteRSVaussergerichtlich,
		FZKainzKostennoteRSVBerufung,
		FZKainzKostennoteRSVgerichtlich,
		FZKainzMahnung,
		FZKainzSonstiges,
		FZKainzSonstigesAnfrage,
		FZKainzStornierungaussergerichtlich,
		FZKainzStornierunggerichtlich,
		FZKainzTerminbenachrichtigung,
		FZKainzTerminprotokoll,
		FZKainzTerminvollmacht
	}

	public enum FZLeCom {
        FZLeComVollmacht,
        FZLeComEinspruch,
        FZLeComFristverlaengerungsantrag,
        FZLeComBerufung,
        FZLeComBerufungsbegruendung,
        FZLeComDeckungsanfrageVerteidigungsanzeige,
            FZLeComVerteidigungsanzeige,
		FZLeComAnwaltswiderspruch,
		FZLeComAnwaltswiderspruchKeineAntwort,
		FZLeComDeckungsanfrageBerufung,
		FZLeComDeckungsanfragefuerKlage,
		FZLeComDeckungsanfragefuerWiderspruchAbgelehnt,
		FZLeComDeckungsanfragefuerWiderspruchKeineAntwort,
		FZLeComGutschriftRSVaussergerichtlich,
		FZLeComGutschriftRSVgerichtlich,
		FZLeComKlageschrift,
		FZLeComKostennoteKunde,
		FZLeComKostennoteRSVaussergerichtlich,
		FZLeComKostennoteRSVBerufung,
		FZLeComKostennoteRSVgerichtlich,
		FZLeComMahnung,
		FZLeComSonstiges,
		FZLeComSonstigesAnfrage,
		FZLeComStornierungaussergerichtlich,
		FZLeComStornierunggerichtlich,
		FZLeComTerminbenachrichtigung,
		FZLeComTerminprotokoll,
		FZLeComTerminvollmacht
	}

	public enum LV21Legal {
		LV21LegalAnwaltswiderspruch,
		LV21LegalAnwaltswiderspruchCMI,
		LV21LegalDeckungsanfragefuerKlage,
		LV21LegalDeckungsanfragefuerWiderspruchAbgelehnt,
		LV21LegalDeckungsanfragefuerWiderspruchKeineAntwort,
		LV21LegalKlageAntragsmodell,
		LV21LegalKlagePolicenmodell,
		LV21LegalSonstiges
	}

	public enum LVJaeger {
        LVJaegerEinspruch,
        LVJaegerFristverlaengerungsantrag,
        LVJaegerBerufung,
        LVJaegerBerufungsbegruendung,
        LVJaegerDeckungsanfrageVerteidigungsanzeige,
            LVJaegerVerteidigungsanzeige,
		LVJaegerAnwaltswiderspruchAbgelehntAntragsmodell,
		LVJaegerAnwaltswiderspruchAbgelehntPolicenmodell,
		LVJaegerAnwaltswiderspruchCMI,
		LVJaegerAnwaltswiderspruchKeineAntwortAntragsmodell,
		LVJaegerAnwaltswiderspruchKeineAntwortPolicenmodell,
		LVJaegerBegruessungsschreiben,
		LVJaegerDeckungsanfrageBerufung,
		LVJaegerDeckungsanfragefuerKlageAntragsmodell,
		LVJaegerDeckungsanfragefuerKlagePolicenmodell,
		LVJaegerDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell,
		LVJaegerDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell,
		LVJaegerDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell,
		LVJaegerDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell,
		LVJaegerGutschriftRSVaussergerichtlich,
		LVJaegerGutschriftRSVgerichtlich,
		LVJaegerKlageAntragsmodell,
		LVJaegerKlagePolicenmodell,
		LVJaegerKostennoteKunde,
		LVJaegerKostennoteRSVaussergerichtlich,
		LVJaegerKostennoteRSVBerufung,
		LVJaegerKostennoteRSVgerichtlich,
		LVJaegerMahnung,
		LVJaegerReplik,
		LVJaegerSonstiges,
		LVJaegerSonstigesAnfrage,
		LVJaegerStornierungaussergerichtlich,
		LVJaegerStornierunggerichtlich,
		LVJaegerTerminbenachrichtigung,
		LVJaegerTerminprotokoll,
		LVJaegerTerminvollmacht,
		LVJaegerVollmacht
	}

	public enum LVKainz {
        LVKainzEinspruch,
        LVKainzFristverlaengerungsantrag,
        LVKainzBerufung,
        LVKainzBerufungsbegruendung,
        LVKainzDeckungsanfrageVerteidigungsanzeige,
        LVKainzVerteidigungsanzeige,
		LVKainzAnwaltswiderspruchAbgelehntAntragsmodell,
		LVKainzAnwaltswiderspruchAbgelehntPolicenmodell,
		LVKainzAnwaltswiderspruchCMI,
		LVKainzAnwaltswiderspruchKeineAntwortAntragsmodell,
		LVKainzAnwaltswiderspruchKeineAntwortPolicenmodell,
		LVKainzBegruessungsschreiben,
		LVKainzDeckungsanfrageBerufung,
		LVKainzDeckungsanfragefuerKlageAntragsmodell,
		LVKainzDeckungsanfragefuerKlagePolicenmodell,
		LVKainzDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell,
		LVKainzDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell,
		LVKainzDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell,
		LVKainzDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell,
		LVKainzGutschriftRSVaussergerichtlich,
		LVKainzGutschriftRSVgerichtlich,
		LVKainzKlageAntragsmodell,
		LVKainzKlagePolicenmodell,
		LVKainzKostennoteKunde,
		LVKainzKostennoteRSVaussergerichtlich,
		LVKainzKostennoteRSVBerufung,
		LVKainzKostennoteRSVgerichtlich,
		LVKainzMahnung,
		LVKainzReplik,
		LVKainzSonstiges,
		LVKainzSonstigesAnfrage,
		LVKainzStornierungaussergerichtlich,
		LVKainzStornierunggerichtlich,
		LVKainzTerminbenachrichtigung,
		LVKainzTerminprotokoll,
		LVKainzTerminvollmacht,
		LVKainzVollmacht
	}

	public enum LVLeCom {
        LVLeComEinspruch,
        LVLeComFristverlaengerungsantrag,
        LVLeComBerufung,
        LVLeComBerufungsbegruendung,
        LVLeComDeckungsanfrageVerteidigungsanzeige,
		LVLeComVerteidigungsanzeige,
		LVLeComAnwaltswiderspruchAbgelehntAntragsmodell,
		LVLeComAnwaltswiderspruchAbgelehntPolicenmodell,
		LVLeComAnwaltswiderspruchCMI,
		LVLeComAnwaltswiderspruchKeineAntwortAntragsmodell,
		LVLeComAnwaltswiderspruchKeineAntwortPolicenmodell,
		LVLeComBegruessungsschreiben,
		LVLeComDeckungsanfrageBerufung,
		LVLeComDeckungsanfragefuerKlageAntragsmodell,
		LVLeComDeckungsanfragefuerKlagePolicenmodell,
		LVLeComDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell,
		LVLeComDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell,
		LVLeComDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell,
		LVLeComDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell,
		LVLeComGutschriftRSVaussergerichtlich,
		LVLeComGutschriftRSVgerichtlich,
		LVLeComKlageAntragsmodell,
		LVLeComKlagePolicenmodell,
		LVLeComKostennoteKunde,
		LVLeComKostennoteRSVaussergerichtlich,
		LVLeComKostennoteRSVBerufung,
		LVLeComKostennoteRSVgerichtlich,
		LVLeComMahnung,
		LVLeComReplik,
		LVLeComSonstiges,
		LVLeComSonstigesAnfrage,
		LVLeComStornierungaussergerichtlich,
		LVLeComStornierunggerichtlich,
		LVLeComTerminbenachrichtigung,
		LVLeComTerminprotokoll,
		LVLeComTerminvollmacht,
        LVLeComVollmacht
	}


    public static ID idFromString(string str) {
        id et = templateToIds.get(str.toLowerCase());
        if (et == null) {
            return null;
        }        
        return et;
    }

    public static ID idOf(DG21Legal ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LV21Legal ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DGJaeger ett) {
        return idOf(ett.name());
    }

    public static ID idOf(FZJaeger ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LVJaeger ett) {
        return idOf(ett.name());
    }

    public static ID idOf(FZKainz ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DGKainz ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LVKainz ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DGLachmair ett) {
        return idOf(ett.name());
    }

    public static ID idOf(DGLeCom ett) {
        return idOf(ett.name());
    }

    public static ID idOf(LVLeCom ett) {
        return idOf(ett.name());
    }

    public static ID idOf(FZLeCom ett) {
        return idOf(ett.name());
    }

    public static ID idOf(Name ett) {
        return idOf(ett.name());
    }

    private static ID idOf(String ett) {
        return idFromString(ett);
    }
}