public class DocumentCreationActionAuthorization {
    public class Result {
        public List<String> templateIds;
        public List<String> filePostfixes;
    }
    
    public static Result getTemplates(Opportunity opp) {
        List<String> templateIds = new List<String>();
        List<String> filePostfixes = new List<String>();
        if (Opportunities.isDieselSkandal(opp.RecordTypeId)) { // 0120Y000000W0CY
            /* * * * * * * * *
             * Dieselskandal *
             * * * * * * * * */
            if ((opp.Financing_Type__c != 'Finanzierung') && (opp.Financing_Type__c != 'Leasing')) {
                // Vollmachten gegen Fahrzeughersteller
                if (VehicleBrands.isDaimlerAG(opp.Vehicle_Brand__c)) { // 0010Y00000WtrfE
                    // Daimler
                    filePostfixes.add('Daimler');
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtDaimler));
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtDaimler));
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtDaimler));
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtDaimler));
                    } else {
                        // Lachmair
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtDaimler));
                    }
                } else if (VehicleBrands.isPorscheAG(opp.Vehicle_Brand__c)) { // 0010Y00000kgL2p
                    // Porsche
                    filePostfixes.add('Porsche');
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtPorsche));
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtPorsche));
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtPorsche));
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtPorsche));
                    } else {
                        // Lachmair
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtPorsche));
                    }
                } else if (VehicleBrands.isAudiAG(opp.Vehicle_Brand__c) || VehicleBrands.isVolkswagenAG(opp.Vehicle_Brand__c)) { // 0010Y000011NIts (Audi)
                    // Audi
                    filePostfixes.add('Audi');
                    filePostfixes.add('VW');
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtAudi));
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtVW));
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtAudi));
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtVW));
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtAudi));
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtVW));
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtAudi));
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtVW));
                    } else {
                        // Lachmair
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtAudi));
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtVW));
                    }
                } else if (VehicleBrands.isBMWAG(opp.Vehicle_Brand__c)) {
                    // BMW - https://salesfive.atlassian.net/browse/VH24-111
                    filePostfixes.add('BMW');
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtAllgemein));
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        System.debug('VehicleBrands :: no template for BMW - 21Legal');
                        //? templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtAudi));
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtAllgemein));
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtAllgemein));
                    } else {
                        // Lachmair
                        System.debug('VehicleBrands :: no template for BMW - Lachmair');
                        //? templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtAudi));
                    }
                } else { // if (VehicleBrands.isOpelAutomobileGmbH(opp.Vehicle_Brand__c)) { // 0010Y000011NRft
                    // Opel
                    filePostfixes.add('Opel');
                    if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                        // Jäger
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtOpel));
                    } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                        // 21Legal
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtOpel));
                    } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                        // Kainz
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtOpel));
                    } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                        // LeCom
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtOpel));
                    } else {
                        // Lachmair
                        templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtOpel));
                    }
                }
            } else {
                // Vollmachten blanko gegen Kreditinstitut für Finanzierung im Dieselprozess
                filePostfixes.add('Kreditinstitut');
                if (Accounts.isJCLegal(opp.Legal_Account__c)) { // 0010Y000011MYHW
                    // Jäger
                    templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.DGJaegerVollmachtohneGegner));
                } else if (Accounts.isLegal21(opp.Legal_Account__c)) { // 0010Y000013yLnP
                    // 21Legal
                    templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.DG21LegalVollmachtohneGegner));
                } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) { // 0010Y000010COcm
                    // Kainz
                    templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.DGKainzVollmachtohneGegner));
                } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                    // LeCom
                    templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.DGLeComVollmachtOhneGegner));
                } else {
                    // Lachmair
                    templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.DGLachmairVollmachtohneGegner));
                }
            }
        } else if (Opportunities.isFinanzierung(opp.RecordTypeId)) { // 0120Y000000KnMH
            /* * * * * * * * *
             * Finanzierung  *
             * * * * * * * * */
            filePostfixes.add('Finanzierung');
            if (Accounts.isJCLegal(opp.Legal_Account__c)) {
                // Jäger
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.FZJaegerVollmacht));
            } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) {
                // Kainz
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzVollmacht));
            } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                // LeCom
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.FZLeComVollmacht));
            }
        } else {
            /* * * * * * * * * * * *
             * Lebensversicherung  *
             * * * * * * * * * * * */
            filePostfixes.add('Lebensversicherung');
            //templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.name.LVVollmacht));
            
            // https://salesfive.atlassian.net/browse/VH24-105
            if (Accounts.isJCLegalLv(opp.Legal_Account__c)) {
                // Jäger
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.LVJaegerVollmacht));
            } else if (Accounts.isCLLBLegal(opp.Legal_Account__c)) {
                // Kainz
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.LVKainzVollmacht));
            } else if (Accounts.isLegalLeCom(opp.Legal_Account__c)) {
                // LeCom
                templateIds.add(CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.LVLeComVollmacht));
            }
        }
        Result r = new Result();
        r.templateIds = templateIds;
        r.filePostfixes = filePostfixes;
        return r;
    }
}