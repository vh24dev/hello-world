public class ClaimMail {
    // Legacy code, adjusted to remove the hardcoded ids.
    // todo: refactor the if/else mess
    public static void send(Claim__c[] cc, Map<ID, Claim__c> oldClaims) {
        
        cc = [
            SELECT Id,
            Legal__c,
            Stage__c,
            Cover_Note__c,
            Cover_Note_Scope__c,
            Sent_Mail_Flag_1__c,
            Result__c,
            Submission_Date_Before_Claim_Statement__c,
            Submitter_Before_Claim_Statement__c,
            Submission_Date_Before_Lawsuit_Date__c,
            Submitter_Before_Lawsuit_Date__c,
            Response_Claim_Letter__c,
            Next_Court_Date__c,
            Canceled_Next_Court_Date__c,
            Account__c,
            Reason_For_Cover_Note_Refusal__c,
            Response_Insurance_Legal_Opposition__c,
            Response_Insurance_Claim_Letter__c,
            Response_Insurance_Lawsuit__c,
            RecordTypeId,
            Opportunity__c,
            Opportunity__r.Contact__c,
            Opportunity__r.Vehicle_Brand__c,
            Opportunity__r.Legal_Account__c,
            Opportunity__r.Bank__c,
            Opportunity__r.Legal_Protection_Insurance__c
            FROM Claim__c
            WHERE Id IN :cc
        ];
        
        for (Claim__c claim : cc) {
            Logger.debug('>> ClaimMail :: send :: loop claim=' + claim.id + ' recordtype=' + claim.RecordTypeId);

            if (Claims.isDieselSkandal(claim.RecordTypeId)) {
                // DG
                Logger.debug('ClaimMail :: Dieselskandal');
                // Benachrichtigung über Dokumentation Deckungszusage außergerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Claim_Letter__c != null) && (claim.Response_Insurance_Claim_Letter__c != oldClaims.get(claim.Id).Response_Insurance_Claim_Letter__c)) {
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued') {
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Extrajudicial'))) {
                            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimCoverNoteIssuedClaimLetter));
                            } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                                // 21Legal
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimCoverNoteIssuedClaimLetter));
                            } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimCoverNoteIssuedClaimLetter));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimCoverNoteIssuedClaimLetter));
                            } else {
                                // Lachmair
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimCoverNoteIssuedClaimLetter));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimCoverNoteRefusedClaimLetter));
                        } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                            // 21Legal
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimCoverNoteRefusedClaimLetter));
                        } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimCoverNoteRefusedClaimLetter));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimCoverNoteRefusedClaimLetter));
                        } else {
                            // Lachmair
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimCoverNoteRefusedClaimLetter));
                        }
                    }
                    if (templateId != null) {
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
                
                // Benachrichtigung über Dokumentation Deckungszusage gerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Lawsuit__c != null) && (claim.Response_Insurance_Lawsuit__c != oldClaims.get(claim.Id).Response_Insurance_Lawsuit__c)) {
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued') {
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Judicial'))) {
                            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimCoverNoteIssuedLawsuit));
                            } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                                // 21Legal
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimCoverNoteIssuedLawsuit));
                            } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimCoverNoteIssuedLawsuit));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimCoverNoteIssuedLawsuit));
                            } else {
                                // Lachmair
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimCoverNoteIssuedLawsuit));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimCoverNoteRefusedLawsuit));
                        } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                            // 21Legal
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimCoverNoteRefusedLawsuit));
                        } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimCoverNoteRefusedLawsuit));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimCoverNoteRefusedLawsuit));
                        } else {
                            // Lachmair
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimCoverNoteRefusedLawsuit));
                        }
                    }
                    if (templateId != null) {
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
                
                // Benachrichtigung über Warten auf Grundsatzurteil
                if ((claim.Stage__c == 'On Hold') && (claim.Stage__c != oldClaims.get(claim.Id).Stage__c)) {
                    Id templateId;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalOnHold));
                    } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                        // 21Legal
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalOnHold));
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalOnHold));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalOnHold));
                    } else {
                        // Lachmair
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalOnHold));
                    }
                    EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                    String result = emailUtilities.send();
                    System.debug('Sent automatic mail with result: ' + result);
                }
                
                // Benachrichtigung über Absage des Gerichtstermins
                if ((claim.Stage__c == 'Lawsuit') && (claim.Canceled_Next_Court_Date__c == true) && (claim.Canceled_Next_Court_Date__c != oldClaims.get(claim.Id).Canceled_Next_Court_Date__c) && (claim.Sent_Mail_Flag_1__c == false)) {
                    Id templateId;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimCanceledNexCourtDate));
                    } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                        // 21Legal
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimCanceledNexCourtDate));
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimCanceledNexCourtDate));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimCanceledNexCourtDate));
                    } else {
                        // Lachmair
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimCanceledNexCourtDate));
                    }
                    EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                    String result = emailUtilities.send();
                    System.debug('Sent automatic mail with result: ' + result);
                }
                
                // Email zur Information über automatische Annahme der Eigentümerschaft vor Klage
                if ((claim.Stage__c == 'Lawsuit') && (claim.Submission_Date_Before_Claim_Statement__c != null) && (claim.Submission_Date_Before_Claim_Statement__c != oldClaims.get(claim.Id).Submission_Date_Before_Claim_Statement__c) && (claim.Submitter_Before_Claim_Statement__c == 'System')) {
                    Id templateId;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimNoResponseClaimStatement));
                    } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                        // 21Legal
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimNoResponseClaimStatement));
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimNoResponseClaimStatement));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimNoResponseClaimStatement));
                    } else {
                        // Lachmair
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimNoResponseClaimStatement));
                    }
                    EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                    String result = emailUtilities.send();
                    System.debug('Sent automatic mail with result: ' + result);
                }
                
                // Email zur Information über automatische Annahme der Eigentümerschaft vor Gerichtstermin
                if ((claim.Stage__c == 'Lawsuit') && (claim.Submission_Date_Before_Lawsuit_Date__c != null) && (claim.Submission_Date_Before_Lawsuit_Date__c != oldClaims.get(claim.Id).Submission_Date_Before_Lawsuit_Date__c) && (claim.Submitter_Before_Lawsuit_Date__c == 'System')) {
                    Id templateId;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselJaegerLegalClaimNoResponseLawsuitDate));
                    } else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                        // 21Legal
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Diesel21LegalLegalClaimNoResponseLawsuitDate));
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselKainzLegalClaimNoResponseLawsuitDate));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLeComLegalClaimNoResponseLawsuitDate));
                    } else {
                        // Lachmair
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.DieselLachmairLegalClaimNoResponseLawsuitDate));
                    }
                    EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                    String result = emailUtilities.send();
                    System.debug('Sent automatic mail with result: ' + result);
                }
            } else if (claims.isFinanzierung(claim.RecordTypeId)) { // 0121v00000032Pe
                // FZ
                Logger.debug('ClaimMail :: Finanzierung');
                if (
                    (claim.Result__c == 'Accepted' && claim.Stage__c == 'Finished') ||
                    (claim.Result__c == 'Declined' && claim.Stage__c == 'Legal Opposition') ||
                    (claim.Result__c == 'No Response')
                ) {
                    System.debug('ClaimMail :: Finanzierung :: ResultMatch');
                    Id templateId;
                    if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.name.FzJaegerLegalCorrespondenceDeckungsanfrageFuerWiderspruch));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.name.FzLeComLegalCorrespondenceDeckungsanfrageFuerWiderspruch));
                    } else {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.name.FzKainzLegalCorrespondenceDeckungsanfrageFuerWiderspruch));
                    }
                    if (templateId != null) {
                        //if (claim.Result__c == 'No Response') {
                            if (claim.Opportunity__r.Legal_Protection_Insurance__c == null) {
                                Logger.error('ClaimMail :: error: Failed to send automatic mail Legal_Protection_Insurance__c is null (claim=' + claim.id + ')');
                            } else {
                                EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Legal_Protection_Insurance__c, templateId, claim.Legal__c);
                                String result = emailUtilities.send();
                                System.debug('Sent automatic mail to Legal_Protection_Insurance__c with templateid: ' + templateId + ' result: ' + result);
                            }
                        //} else {
                            if (claim.Opportunity__r.Bank__c == null) {
                                Logger.error('ClaimMail :: error: Failed to send automatic mail Bank__c is null (claim=' + claim.id + ')');
                            } else {
                                EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Bank__c, templateId, claim.Legal__c);
                                String result = emailUtilities.send();
                                System.debug('Sent automatic mail to Bank__c with templateid: ' + templateId + ' result: ' + result);
                            }
                        // }
                    }
                }
                // Benachrichtigung über Dokumentation Deckungszusage außergerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Legal_Opposition__c != null) && (claim.Response_Insurance_Legal_Opposition__c != oldClaims.get(claim.Id).Response_Insurance_Legal_Opposition__c)){
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued') {
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Extrajudicial'))){
                            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) { // 0010Y000011MYHW
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzJaegerLegalClaimCoverNoteIssuedClaimLetter));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzLeComLegalClaimCoverNoteIssuedClaimLetter));
                            } else {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzKainzLegalClaimCoverNoteIssuedClaimLetter));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzJaegerLegalClaimCoverNoteRefusedClaimLetter));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzLeComLegalClaimCoverNoteRefusedClaimLetter));
                        } else {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzKainzLegalClaimCoverNoteRefusedClaimLetter));
                        }
                    }
                    if (templateId != null) {
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
                
                // Benachrichtigung über Dokumentation Deckungszusage gerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Lawsuit__c != null) && (claim.Response_Insurance_Lawsuit__c != oldClaims.get(claim.Id).Response_Insurance_Lawsuit__c)) {
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued') {
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Judicial'))) {
                            if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzJaegerLegalClaimCoverNoteIssuedLawsuit));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzLeComLegalClaimCoverNoteIssuedLawsuit));
                            } else {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzKainzLegalClaimCoverNoteIssuedLawsuit));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzJaegerLegalClaimCoverNoteRefusedLawsuit));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzLeComLegalClaimCoverNoteRefusedLawsuit));
                        } else {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.FzKainzLegalClaimCoverNoteRefusedLawsuit));
                        }
                    }
                    if (templateId != null){
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
            } else {
                // LV
                Logger.debug('ClaimMail :: Lebensversicherung');

                // Benachrichtigung über Dokumentation Deckungszusage außergerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Legal_Opposition__c != null) && (claim.Response_Insurance_Legal_Opposition__c != oldClaims.get(claim.Id).Response_Insurance_Legal_Opposition__c)){
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued') {
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Extrajudicial'))) {
                            if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) {
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvJaegerLegalClaimCoverNoteIssuedClaimLetter));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvLeComLegalClaimCoverNoteIssuedClaimLetter));
                            } else {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvKainzLegalClaimCoverNoteIssuedClaimLetter));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvJaegerLegalClaimCoverNoteRefusedClaimLetter));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvLeComLegalClaimCoverNoteIssuedClaimLetter));
                        } else {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvKainzLegalClaimCoverNoteRefusedClaimLetter));
                        }
                    }
                    if (templateId != null){
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
                
                // Benachrichtigung über Dokumentation Deckungszusage gerichtlich
                if ((claim.Cover_Note__c != null) && (claim.Response_Insurance_Lawsuit__c != null) && (claim.Response_Insurance_Lawsuit__c != oldClaims.get(claim.Id).Response_Insurance_Lawsuit__c)){
                    Id templateId;
                    if (claim.Cover_Note__c == 'Issued'){
                        if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c.contains('Judicial'))) {
                            if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) {
                                // Jäger
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvJaegerLegalClaimCoverNoteIssuedLawsuit));
                            } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                                // LeCom
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvLeComLegalClaimCoverNoteIssuedLawsuit));
                            } else {
                                // Kainz
                                templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvKainzLegalClaimCoverNoteIssuedLawsuit));
                            }
                        }
                    } else {
                        if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)) {
                            // Jäger
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvJaegerLegalClaimCoverNoteRefusedLawsuit));
                        } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                            // LeCom
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvLeComLegalClaimCoverNoteRefusedLawsuit));
                        } else {
                            // Kainz
                            templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvKainzLegalClaimCoverNoteRefusedLawsuit));
                        }
                    }
                    if (templateId != null){
                        EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                        String result = emailUtilities.send();
                        System.debug('Sent automatic mail with result: ' + result);
                    }
                }
                
                if ((claim.Stage__c == 'On Hold') && (claim.Stage__c != oldClaims.get(claim.Id).Stage__c)) {
                    Id templateId;
                    if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
                        // 21Legal
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.Lv21LegalLegalOnHold));
                    } else if (Accounts.isCLLBLegal(claim.Opportunity__r.Legal_Account__c)) {
                        // Kainz
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvKainzLegalOnHold));
                    } else if (Accounts.isLegalLeCom(claim.Opportunity__r.Legal_Account__c)) {
                        // LeCom
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvLeComLegalOnHold));
                    } else {
                        // Jäger
                        templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.Claims.LvJaegerLegalOnHold));
                    }
                    EmailUtilities emailUtilities = new EmailUtilities(claim.Id, claim.Opportunity__r.Contact__c, templateId, claim.Legal__c);
                    String result = emailUtilities.send();
                    System.debug('Sent automatic mail with result: ' + result);
                }
            }
            Logger.debug('<< ClaimMail :: send');
        }
    }
}