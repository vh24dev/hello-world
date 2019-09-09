public class DocumentCreationActionCostNote {
    public static string getTemplate(Cost_Note__c costnote, Opportunity opp) {
        // Set template
        String templateId;
        // a171t000000QK8QAAW cloudworx template 0000000285, with attachments kostennote_kunde <version>.docx
        // templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVaussergerichtlich); // todo: remove this test template

        if (Opportunities.isDieselSkandal(opp.RecordTypeId)) { // 0120Y000000W0CY
            /*********************************
             *********************************
			 *         DIESELSKANDAL         *
			 *********************************
			 *********************************/
            if (costNote.Recipient__c == 'Customer') {
                if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteKunde); // kostennote_kunde (1.7).docx (@Downloads)
                } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteKunde);
                } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteKunde);
                }
            } else { // Legal Protection Insurance
                if (costNote.Type__c == 'I. Instanz') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVgerichtlich);
                    }
                } else if (costNote.Type__c == 'Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVBerufung);
                    }
                } else {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComKostennoteRSVaussergerichtlich);
                    }
                }
            }
        } else if (Opportunities.isFinanzierung(opp.RecordTypeId)) { // 0120Y000000KnMH
            /*********************************
             *********************************
			 *         FINANZIERUNG          *
			 *********************************
			 *********************************/
            if (costNote.Recipient__c == 'Customer') {
                if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteKunde);
                } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteKunde);
                } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteKunde);
                }
            } else { // Legal Protection Insurance
                if (costNote.Type__c == 'I. Instanz') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVgerichtlich);
                    }
                } else if (costNote.Type__c == 'Berufung') {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVBerufung);
                    }
                } else {
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComKostennoteRSVaussergerichtlich);
                    }
                }
            }
        } else {
            /*********************************
             *********************************
			 *     LEBENSVERSICHERUNG        *
			 *********************************
			 *********************************/
            if (costNote.Recipient__c == 'Customer') {
                if (Accounts.isJCLegalLv(opp.Legal_Account__c)) { // 0010Y000010BXGZ
                    // Jäger
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteKunde);
                } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteKunde);
                } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                    // LeCom
                    templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteKunde);
                }
            } else { // Legal Protection Insurance
                if (costNote.Type__c == 'I. Instanz') {
                    if (Accounts.isJCLegalLv(opp.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVgerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVgerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVgerichtlich);
                    }
                } else if (costNote.Type__c == 'Berufung') {
                    if (Accounts.isJCLegalLv(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVBerufung);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVBerufung);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVBerufung);
                    }
                } else {
                    if (Accounts.isJCLegalLv(opp.Legal_Account__c)) { // 0010Y000010BXGZ
                        // Jäger
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzKostennoteRSVaussergerichtlich);
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateId = CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComKostennoteRSVaussergerichtlich);
                    }
                }
            }
        }
        return templateId;
    }
}