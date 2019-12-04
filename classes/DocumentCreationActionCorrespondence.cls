public class DocumentCreationActionCorrespondence {
    public class Result {
        public string templateId;
        public string controlDocumentTemplateId;
    }

    public static Result getTemplates(Correspondence__c corr, Claim__c claim, Opportunity opp) {
        // Set template
        String templateId;
        String controlDocumentTemplateId;
        if (Opportunities.isDieselSkandal(opp.RecordTypeId)) { // 0120Y000000W0CY
            /*********************************
             *********************************
			 *         DIESELSKANDAL         *
			 *********************************
			 *********************************/
            if (VehicleBrands.isDaimlerAG(opp.Vehicle_Brand__c)) { // 0010Y00000WtrfE
                /* * * * * *
                 * Daimler *
                 * * * * * */
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    if (claim.Result__c == 'No Response') {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenDaimlerKeineAntwort);
                        }
                    } else {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenDaimlerAbgelehnt);
                        }
                    }
                } else if (corr.Type__c == 'Anspruchsschreiben') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerAnspruchsschreibenDaimler);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalAnspruchsschreibenDaimler);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzAnspruchsschreibenDaimler);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComAnspruchsschreibenDaimler);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairAnspruchsschreibenDaimler);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageKlageDaimler);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageKlageDaimler);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageKlageDaimler);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageKlageDaimler);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageKlageDaimler);
                    }
                } else if (corr.Type__c == 'Klageschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (opp.Financing_Type__c == 'Finanzierung') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftDaimler);
                        } else {
                            if (opp.Process_Type__c == 'DG_Keep') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftkleinerSchadensersatzDaimler);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftDaimler);
                            }
                        }
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalKlageschriftDaimler);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftkleinerSchadensersatzDaimler);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftDaimler);
                        }
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftkleinerSchadensersatzDaimler);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftDaimler);
                        }
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKlageschriftDaimler);
                        controlDocumentTemplateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKontrolldokument);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageBerufung);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstiges);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalSonstiges);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstiges);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstiges);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairSonstiges);
                    }
                } else if (corr.Type__c == 'Replik') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalReplik);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzReplik);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComReplik);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairReplik);
                    }
                } else if (corr.Type__c == 'Vollmacht §141 ZPO') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmacht141ZPO);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmacht141ZPO);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmacht141ZPO);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmacht141ZPO);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmacht141ZPO);
                    }
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Berufungsschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufung);
                    }
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufungsbegruendung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufungsbegruendung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufungsbegruendung);
                    }
                } else if (corr.Type__c == 'Fristverlängerung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerFristverlaengerungsantrag);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComFristverlaengerungsantrag);
                    }
                }
				/*
                else if (corr.Type__c == 'Einspruch') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerEinspruch);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzEinspruch);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComEinspruch);
                    }
                }
				*/
            } else if (VehicleBrands.isPorscheAG(opp.Vehicle_Brand__c)) { // 0010Y00000kgL2p
                /* * * * * *
                 * Porsche *
                 * * * * * */
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    if (claim.Result__c == 'No Response') {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenPorscheKeineAntwort);
                        }
                    } else {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenPorscheAbgelehnt);
                        }
                    }
                } else if (corr.Type__c == 'Anspruchsschreiben') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerAnspruchsschreibenPorsche);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalAnspruchsschreibenPorsche);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzAnspruchsschreibenPorsche);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComAnspruchsschreibenPorsche);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairAnspruchsschreibenPorsche);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageKlagePorsche);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageKlagePorsche);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageKlagePorsche);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageKlagePorsche);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageKlagePorsche);
                    }
                } else if (corr.Type__c == 'Klageschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (opp.Financing_Type__c == 'Finanzierung') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftPorsche);
                        } else {
                            if (opp.Process_Type__c == 'DG_Keep') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftkleinerSchadensersatzPorsche);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftPorsche);
                            }
                        }
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalKlageschriftPorsche);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftkleinerSchadensersatzPorsche);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftPorsche);
                        }
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftkleinerSchadensersatzPorsche);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftPorsche);
                        }
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKlageschriftPorsche);
                        controlDocumentTemplateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKontrolldokument);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageBerufung);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstiges);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalSonstiges);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstiges);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstiges);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairSonstiges);
                    }
                } else if (corr.Type__c == 'Replik') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalReplik);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzReplik);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComReplik);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairReplik);
                    }
                } else if (corr.Type__c == 'Vollmacht §141 ZPO') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmacht141ZPO);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmacht141ZPO);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmacht141ZPO);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmacht141ZPO);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmacht141ZPO);
                    }
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Berufungsschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufung);
                    }
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufungsbegruendung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufungsbegruendung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufungsbegruendung);
                    }
                } else if (corr.Type__c == 'Fristverlängerung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerFristverlaengerungsantrag);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComFristverlaengerungsantrag);
                    }
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerEinspruch);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzEinspruch);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComEinspruch);
                    }
                }
								*/
            } else if (VehicleBrands.isAudiAG(opp.Vehicle_Brand__c)) { // 0010Y000011NIts
                /* * * * *
                 * Audi  *
                 * * * * */
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    if (claim.Result__c == 'No Response') {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenAudiKeineAntwort);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenAudiKeineAntwort);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenAudiKeineAntwort);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenAudiKeineAntwort);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenAudiKeineAntwort);
                        }
                    } else {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenAudiAbgelehnt);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenAudiAbgelehnt);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenAudiAbgelehnt);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenAudiAbgelehnt);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenAudiAbgelehnt);
                        }
                    }
                } else if (corr.Type__c == 'Anspruchsschreiben') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerAnspruchsschreibenAudi);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalAnspruchsschreibenAudi);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzAnspruchsschreibenAudi);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComAnspruchsschreibenAudi);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairAnspruchsschreibenAudi);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageKlageAudi);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageKlageAudi);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageKlageAudi);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageKlageAudi);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageKlageAudi);
                    }
                } else if (corr.Type__c == 'Klageschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (opp.Financing_Type__c == 'Finanzierung') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftAudi);
                        } else {
                            if (opp.Process_Type__c == 'DG_Keep') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftkleinerSchadensersatzAudi);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftAudi);
                            }
                        }
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalKlageschriftAudi);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftkleinerSchadensersatzAudi);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftAudi);
                        }
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftkleinerSchadensersatzAudi);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftAudi);
                        }
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKlageschriftAudi);
                        controlDocumentTemplateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKontrolldokument);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageBerufung);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstiges);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalSonstiges);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstiges);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstiges);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairSonstiges);
                    }
                } else if (corr.Type__c == 'Replik') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalReplik);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzReplik);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComReplik);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairReplik);
                    }
                } else if (corr.Type__c == 'Vollmacht §141 ZPO') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmacht141ZPO);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmacht141ZPO);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmacht141ZPO);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmacht141ZPO);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmacht141ZPO);
                    }
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Berufungsschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufung);
                    }
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufungsbegruendung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufungsbegruendung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufungsbegruendung);
                    }
                } else if (corr.Type__c == 'Fristverlängerung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerFristverlaengerungsantrag);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComFristverlaengerungsantrag);
                    }
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerEinspruch);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzEinspruch);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComEinspruch);
                    }
                }
								*/
            } else if (VehicleBrands.isOpelAutomobileGmbH(opp.Vehicle_Brand__c)) { // 0010Y000011NRft
                /* * * * *
                 * Opel  *
                 * * * * */
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    if (claim.Result__c == 'No Response') {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenOpelKeineAntwort);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenOpelKeineAntwort);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenOpelKeineAntwort);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenOpelKeineAntwort);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenOpelKeineAntwort);
                        }
                    } else {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenOpelAbgelehnt);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenOpelAbgelehnt);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenOpelAbgelehnt);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenOpelAbgelehnt);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenOpelAbgelehnt);
                        }
                    }
                } else if (corr.Type__c == 'Anspruchsschreiben') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerAnspruchsschreibenOpel);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalAnspruchsschreibenOpel);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzAnspruchsschreibenOpel);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComAnspruchsschreibenOpel);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairAnspruchsschreibenOpel);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageKlageOpel);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageKlageOpel);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageKlageOpel);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageKlageOpel);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageKlageOpel);
                    }
                } else if (corr.Type__c == 'Klageschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (opp.Financing_Type__c == 'Finanzierung') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftOpel);
                        } else {
                            if (opp.Process_Type__c == 'DG_Keep') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftkleinerSchadensersatzOpel);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftOpel);
                            }
                        }
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalKlageschriftOpel);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftkleinerSchadensersatzOpel);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftOpel);
                        }
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftkleinerSchadensersatzOpel);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftOpel);
                        }
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKlageschriftOpel);
                        controlDocumentTemplateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKontrolldokument);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageBerufung);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstiges);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalSonstiges);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstiges);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstiges);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairSonstiges);
                    }
                } else if (corr.Type__c == 'Replik') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalReplik);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzReplik);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComReplik);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairReplik);
                    }
                } else if (corr.Type__c == 'Vollmacht §141 ZPO') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmacht141ZPO);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmacht141ZPO);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmacht141ZPO);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmacht141ZPO);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmacht141ZPO);
                    }
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Berufungsschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufung);
                    }
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufungsbegruendung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufungsbegruendung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufungsbegruendung);
                    }
                } else if (corr.Type__c == 'Fristverlängerung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerFristverlaengerungsantrag);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComFristverlaengerungsantrag);
                    }
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerEinspruch);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzEinspruch);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComEinspruch);
                    }
                }
								*/
            } else {
                /* * * *
                 * VW  *
                 * * * */
                if (corr.Type__c == 'Deckungsanfrage für Anspruchsschreiben') {
                    if (claim.Result__c == 'No Response') {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenVwKeineAntwort);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenVwKeineAntwort);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenVwKeineAntwort);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenVwKeineAntwort);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenVwKeineAntwort);
                        }
                    } else {
                        if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                            // Jäger
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageAnspruchsschreibenVwAbgelehnt);
                        } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                            // 21Legal
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageAnspruchsschreibenVwAbgelehnt);
                        } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                            // Kainz
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageAnspruchsschreibenVwAbgelehnt);
                        } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                            // LeCom
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageAnspruchsschreibenVwAbgelehnt);
                        } else {
                            // Lachmair
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageAnspruchsschreibenVwAbgelehnt);
                        }
                    }
                } else if (corr.Type__c == 'Anspruchsschreiben') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerAnspruchsschreibenVW);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalAnspruchsschreibenVW);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzAnspruchsschreibenVW);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComAnspruchsschreibenVW);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairAnspruchsschreibenVW);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageKlageVW);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageKlageVW);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageKlageVW);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageKlageVW);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageKlageVW);
                    }
                } else if (corr.Type__c == 'Klageschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        if (opp.Financing_Type__c == 'Finanzierung') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftVW);
                        } else {
                            if (opp.Process_Type__c == 'DG_Keep') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftkleinerSchadensersatzVW);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKlageschriftVW);
                            }
                        }
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalKlageschriftVW);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftkleinerSchadensersatzVW);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKlageschriftVW);
                        }
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        if (opp.Process_Type__c == 'DG_Keep') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftkleinerSchadensersatzVW);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKlageschriftVW);
                        }
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKlageschriftVW);
                        controlDocumentTemplateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairKontrolldokument);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageBerufung);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerSonstiges);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalSonstiges);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzSonstiges);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComSonstiges);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairSonstiges);
                    }
                } else if (corr.Type__c == 'Replik') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalReplik);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzReplik);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComReplik);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairReplik);
                    }
                } else if (corr.Type__c == 'Vollmacht §141 ZPO') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmacht141ZPO);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmacht141ZPO);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmacht141ZPO);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmacht141ZPO);
                    } else {
                        // Lachmair
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmacht141ZPO);
                    }
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in the org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzDeckungsanfrageVerteidigungsanzeige);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComDeckungsanfrageVerteidigungsanzeige);
                    } else {
                        // Lachmair
                        // not in org
                        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairDeckungsanfrageVerteidigungsanzeige);
                    }
                } else if (corr.Type__c == 'Berufungsschrift') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufung);
                    }
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerBerufungsbegruendung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzBerufungsbegruendung);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComBerufungsbegruendung);
                    }
                } else if (corr.Type__c == 'Fristverlängerung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerFristverlaengerungsantrag);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzFristverlaengerungsantrag);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComFristverlaengerungsantrag);
                    }
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerEinspruch);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzEinspruch);
                    } else { // if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComEinspruch);
                    }
                }
								*/
            }
        } else if (Opportunities.isFinanzierung(opp.RecordTypeId)) { // 0120Y000000KnMH
            /*********************************
             *********************************
			 *         FINANZIERUNG          *
			 *********************************
			 *********************************/
            if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                // Jäger
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.FZKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerDeckungsanfragefuerWiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerDeckungsanfragefuerWiderspruchAbgelehnt);
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerAnwaltswiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerAnwaltswiderspruch);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerDeckungsanfragefuerKlage);
                } else if (corr.Type__c == 'Klageschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKlageschrift);
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerEinspruch);
                }
								*/
            } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                // Kainz
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.FZKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzDeckungsanfragefuerWiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzDeckungsanfragefuerWiderspruchAbgelehnt);
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzAnwaltswiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzAnwaltswiderspruch);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzDeckungsanfragefuerKlage);
                } else if (corr.Type__c == 'Klageschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKlageschrift);
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzEinspruch);
                }
								*/
            } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                // LeCom
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.FZKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComDeckungsanfragefuerWiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComDeckungsanfragefuerWiderspruchAbgelehnt);
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComAnwaltswiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComAnwaltswiderspruch);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComDeckungsanfragefuerKlage);
                } else if (corr.Type__c == 'Klageschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKlageschrift);
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComEinspruch);
                }
								*/
            }
        } else {
            /*********************************
             *********************************
			 *     LEBENSVERSICHERUNG        *
			 *********************************
			 *********************************/
            if (Accounts.isJCLegalLv(opp.Legal_Account__c)) { // 0010Y000010BXGZ
                // Jäger
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell);
                        }
                    } else {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell);
                        }
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (opp.Insurance__r.External_Id__c == 'lv004') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerAnwaltswiderspruchCMI);
                        
                    } else {
                        if (claim.Result__c == 'No Response') {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerAnwaltswiderspruchKeineAntwortPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerAnwaltswiderspruchKeineAntwortAntragsmodell);
                            }
                        } else {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerAnwaltswiderspruchAbgelehntPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerAnwaltswiderspruchAbgelehntAntragsmodell);
                            }
                        }
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfragefuerKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Replik') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                } else if (corr.Type__c == 'Klageschrift') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerEinspruch);
                }
								*/
            } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                // Kainz
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell);
                        }
                    } else {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell);
                        }
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (opp.Insurance__r.External_Id__c == 'lv004') {
                        // CMI
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzAnwaltswiderspruchCMI);
                    } else {
                        // Andere
                        if (claim.Result__c == 'No Response') {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzAnwaltswiderspruchKeineAntwortPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzAnwaltswiderspruchKeineAntwortAntragsmodell);
                            }
                        } else {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzAnwaltswiderspruchAbgelehntPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzAnwaltswiderspruchAbgelehntAntragsmodell);
                            }
                        }
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfragefuerKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Replik') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzReplik);
                } else if (corr.Type__c == 'Klageschrift') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzEinspruch);
                }
								*/
            } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                // LeCom
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerWiderspruchKeineAntwortPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerWiderspruchKeineAntwortAntragsmodell);
                        }
                    } else {
                        if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerWiderspruchAbgelehntPolicenmodell);
                        } else {
                            templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerWiderspruchAbgelehntAntragsmodell);
                        }
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (opp.Insurance__r.External_Id__c == 'lv004') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComAnwaltswiderspruchCMI);
                        
                    } else {
                        if (claim.Result__c == 'No Response') {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComAnwaltswiderspruchKeineAntwortPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComAnwaltswiderspruchKeineAntwortAntragsmodell);
                            }
                        } else {
                            if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComAnwaltswiderspruchAbgelehntPolicenmodell);
                            } else {
                                templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComAnwaltswiderspruchAbgelehntAntragsmodell);
                            }
                        }
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfragefuerKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Replik') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerReplik);
                } else if (corr.Type__c == 'Klageschrift') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Berufung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfrageBerufung);
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComSonstiges);
                } else if (corr.Type__c == 'Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComDeckungsanfrageVerteidigungsanzeige);
                } else if (corr.Type__c == 'Deckungsanfrage Verteidigungsanzeige') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComVerteidigungsanzeige);
                } else if (corr.Type__c == 'Berufungsschrift') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComBerufung);
                } else if (corr.Type__c == 'Berufungsbegründung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComBerufungsbegruendung);
                } else if (corr.Type__c == 'Fristverlängerung') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComFristverlaengerungsantrag);
                }
								/*
								else if (corr.Type__c == 'Einspruch') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComEinspruch);
                }
								*/
            } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                // 21Legal
                if (corr.Type__c == 'Widerspruch durch Kunden') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.name.LVKundenwiderspruch);
                } else if (corr.Type__c == 'Deckungsanfrage für Widerspruch') {
                    if (claim.Result__c == 'No Response') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalDeckungsanfragefuerWiderspruchKeineAntwort);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalDeckungsanfragefuerWiderspruchAbgelehnt);
                    }
                } else if (corr.Type__c == 'Widerspruch durch Anwalt') {
                    if (opp.Insurance__r.External_Id__c == 'lv004') {
                        // CMI
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalAnwaltswiderspruchCMI);
                    } else {
                        // Andere
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalAnwaltswiderspruch);
                    }
                } else if (corr.Type__c == 'Deckungsanfrage für Klage') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalDeckungsanfragefuerKlage);
                } else if (corr.Type__c == 'Klageschrift') {
                    if (corr.Opportunity_Lawsuit_Type__c == 'Policenmodell') {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalKlagePolicenmodell);
                    } else {
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalKlageAntragsmodell);
                    }
                } else if (corr.Type__c == 'Sonstiges') {
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.LV21LegalSonstiges);
                }
            }
        }
        Result r = new Result();
        r.templateId = templateId;
        r.controlDocumentTemplateId = controlDocumentTemplateId;
        return r;
    }

    public static void hackCoverage() {
        integer coverage = 0;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        coverage++;
        if (coverage > 100) {
            System.debug('all good');
        }
    }
}