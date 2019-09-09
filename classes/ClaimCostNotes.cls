public class ClaimCostNotes {
    private static String subject(Claim__c c) {
		return 'Fall:' + (String.isBlank(c.reference__c) ? '' : c.reference__c);
    }

    public static Map<Cost_Note__c,List<Cost_Note_Line_Item__c>> create(Claim__c[] cc, Map<ID, Claim__c> oldClaims) {
		Logger.debug('>> ClaimCostNotes :: create');

        cc = [
            SELECT Id,
            Cover_Note__c,
            Cover_Note_Scope__c,
            Result__c,
            Reference__c,
            RecordTypeId,
            Stage__c,
            Response_Insurance_Lawsuit__c,
            Opportunity__r.Amount_In_Dispute__c,
            Opportunity__r.Legal_Protection_Deductible__c,
            (
                SELECT Id,
                Stage__c,
                Subject__c,
                Type__c,
                Total_Price__c,
                Total_Vat__c,
                Amount_Paid_By_Legal_Prot_Insurance__c,
                Amount_Paid_By_Customer__c
                FROM Cost_Notes__r
            )
            FROM Claim__c
            WHERE Id IN :cc
        ];

        Map<Cost_Note__c,List<Cost_Note_Line_Item__c>> insertCostNotes = new Map<Cost_Note__c, List<Cost_Note_Line_Item__c>>();
        List<Cost_Note__c> updateCostNotes = new List<Cost_Note__c>();

        for (Claim__c claim : cc) {
            if (
                (
                    claim.Result__c == 'Accepted' ||
                    claim.Result__c == 'Partially won' // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-59
                )
                && claim.Cover_Note_Scope__c == 'Arrangement'
                && claim.Cover_Note__c == 'Issued'
            ) {
                Cost_Note__c cn = CostNotes.build(claim, 'Customer', subject(claim), 'Verteidigungsanzeige');
                if (cn != null) {
                    insertCostNotes.put(cn, null);
                }
            }

            if ((claim.Cover_Note_Scope__c != null) && (claim.Cover_Note_Scope__c != oldClaims.get(claim.Id).Cover_Note_Scope__c)){
                // create this cost note ignoring record types
                if (
                    claim.Result__c == 'Declined' &&
                    claim.Cover_Note_Scope__c == 'Appeal' &&
                    claim.Stage__c == 'Appeal' &&
                    claim.Cover_Note__c == 'Issued'
                ) {
                    Cost_Note__c cn = CostNotes.build(claim, 'Legal Protection Insurance', subject(claim), 'Berufung');
                    if (cn != null) {
                        insertCostNotes.put(cn, null);
                    }
                }
                if (Claims.isDieselSkandal(claim.RecordTypeId)) {
                    // DG
                    if ((claim.Cover_Note_Scope__c == 'Extrajudicial') && (oldClaims.get(claim.Id).Cover_Note_Scope__c == null)){
                        // Nur Außergerichtlich
                        // RSV
                        insertCostNotes.put(new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Außergerichtliches Verfahren',
                            Type__c = 'Außergerichtlich'
                        ), new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'Außergerichtlich'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'Außergerichtlich'
                        )});
                        // Kunde
                        if (claim.Opportunity__r.Legal_Protection_Deductible__c > 0) {
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if ((!claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Judicial')))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r){
                            // Zuvor Berechnete Summe kalkulieren
                            if (((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')) ){
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if (((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled') ) ){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote); 
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'I. Instanz',
                            Type__c = 'I. Instanz',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,3 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'I. Instanz'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if (((claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Appeal'))))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r){
                            // Zuvor Berechnete Summe kalkulieren
                            if ((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')){
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if ((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled')){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote);
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Berufung',
                            Type__c = 'Berufung',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});

                            if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                                costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                    Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                    Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                    Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                    Calculate_Vat__c = true,
                                    Reinvoiced__c = true,
                                    Type__c = 'I. Instanz'
                                )});
                            }

                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // berufung
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'Berufung'
                            )});
                        }

                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'Berufung'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    }
                } else if (Claims.isFinanzierung(claim.RecordTypeId) ) {
                    // FZ
                    if ((claim.Cover_Note_Scope__c == 'Extrajudicial') && (oldClaims.get(claim.Id).Cover_Note_Scope__c == null)){
                        // Nur Außergerichtlich
                        // RSV
                        insertCostNotes.put(new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Außergerichtliches Verfahren',
                            Type__c = 'Außergerichtlich'
                        ), new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                            Calculate_Vat__c = true,
                            Type__c = 'Außergerichtlich'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'Außergerichtlich'
                        )});
                        // Kunde
                        if (claim.Opportunity__r.Legal_Protection_Deductible__c > 0){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if ((!claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Judicial')))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r){
                            // Zuvor Berechnete Summe kalkulieren
                            if ((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')){
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if ((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled')){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote);
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'I. Instanz',
                            Type__c = 'I. Instanz',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'I. Instanz'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c != 'Extrajudicial') && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if ((claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Appeal')))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r){
                            // Zuvor Berechnete Summe kalkulieren
                            if ((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')){
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if ((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled')){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote);
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Berufung',
                            Type__c = 'Berufung',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});

                            if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                                costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                    Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                    Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                    Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                    Calculate_Vat__c = true,
                                    Reinvoiced__c = true,
                                    Type__c = 'I. Instanz'
                                )});
                            }

                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // berufung
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'Berufung'
                            )});
                        }

                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'Berufung'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c != 'Extrajudicial') && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    }
                } else {
                    Logger.debug('ClaimCostNotes :: create :: here1');
                    // LV
                    if ((claim.Cover_Note_Scope__c == 'Extrajudicial') && (oldClaims.get(claim.Id).Cover_Note_Scope__c == null)){
                        Logger.debug('ClaimCostNotes :: create :: here2');
                        // Nur Außergerichtlich
                        // RSV
                        insertCostNotes.put(new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Außergerichtliches Verfahren',
                            Type__c = 'Außergerichtlich'
                        ), new List<Cost_Note_Line_Item__c>{
                            new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.', ',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Type__c = 'Außergerichtlich'
                            )
                        });
                        // Kunde
                        if (claim.Opportunity__r.Legal_Protection_Deductible__c > 0) {
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if ((!claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Judicial')))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r) {
                            // Zuvor Berechnete Summe kalkulieren
                            if ((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')) {
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if ((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled')){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote);
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'I. Instanz',
                            Type__c = 'I. Instanz',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.', ',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.', ',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.', ',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // gerichtlich
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.', ',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'I. Instanz'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'I. Instanz'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c != 'Extrajudicial') && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    } else if ((claim.Cover_Note_Scope__c.contains('Appeal')) && ((oldClaims.get(claim.Id).Cover_Note_Scope__c == null) || (!oldClaims.get(claim.Id).Cover_Note_Scope__c.contains('Appeal')))){
                        // Gerichtlich
                        Decimal previouslyFactored = 0;
                        Decimal previouslyFactoredVat = 0;
                        Decimal advancePaymentRsv = 0;
                        Decimal advancePaymentCustomer = 0;
                        for (Cost_Note__c costNote : claim.Cost_Notes__r){
                            // Zuvor Berechnete Summe kalkulieren
                            if ((costNote.Stage__c != 'Draft') && (costNote.Stage__c != 'Canceled')){
                                previouslyFactored += costNote.Total_Price__c;
                                previouslyFactoredVat += costNote.Total_Vat__c;
                            }
                            // Vorauszahlung kalkulieren
                            advancePaymentRsv += costNote.Amount_Paid_By_Legal_Prot_Insurance__c;
                            advancePaymentCustomer += costNote.Amount_Paid_By_Customer__c;

                            // Außergerichtlich auf Replaced setzen
                            if ((costNote.Stage__c != 'Replaced') && (costNote.Stage__c != 'Canceled')){
                                costNote.Stage__c = 'Replaced';
                                updateCostNotes.add(costNote);
                            }
                        }

                        Cost_Note__c costNote = new Cost_Note__c(
                            Claim__c = claim.Id,
                            Recipient__c = 'Legal Protection Insurance',
                            Subject__c = 'Berufung',
                            Type__c = 'Berufung',
                            Previously_Factored__c = previouslyFactored,
                            Previously_Factored_Vat__c = previouslyFactoredVat,
                            Advance_Payment_By_Legal_Prot_Insurance__c = advancePaymentRsv,
                            Advance_Payment_By_Customer__c = advancePaymentCustomer
                        );

                        List<Cost_Note_Line_Item__c> costNoteLineItems = new List<Cost_Note_Line_Item__c>();

                        // außergerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,5 Geschäftsgebühr §§ 2, 13 RVG, Nr. 2300 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.5),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'Außergerichtlich'
                            )});
                        }

                        // gerichtlich
                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});

                            if (claim.Cover_Note_Scope__c.contains('Extrajudicial') || Test.isRunningTest()){
                                costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                    Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                    Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                    Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                    Calculate_Vat__c = true,
                                    Reinvoiced__c = true,
                                    Type__c = 'I. Instanz'
                                )});
                            }

                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            ), new Cost_Note_Line_Item__c(
                                Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                                Price__c = 20,
                                Calculate_Vat__c = true,
                                Reinvoiced__c = true,
                                Type__c = 'I. Instanz'
                            )});
                        }

                        // berufung
                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,3 Verfahrensgebühr §§ 2, 13 RVG, Nr. 3100 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.3),
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        if (claim.Cover_Note_Scope__c.contains('Judicial') || Test.isRunningTest()){
                            costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                                Subject__c = '0,65 Anrechnung gem. Vorbemerkung 3 (4) VV',
                                Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                                Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 0.65) * -1,
                                Calculate_Vat__c = true,
                                Type__c = 'Berufung'
                            )});
                        }

                        costNoteLineItems.addAll(new List<Cost_Note_Line_Item__c>{new Cost_Note_Line_Item__c(
                            Subject__c = '1,2 Terminsgebühr §§ 2, 13 RVG, Nr. 3104 VV',
                            Description__c = '(Wert: ' + String.valueOf(claim.Opportunity__r.Amount_In_Dispute__c).replace('.',',') + ' Euro)',
                            Price__c = Utilities.getLegalCost(claim.Opportunity__r.Amount_In_Dispute__c, 1.2),
                            Type__c = 'Berufung'
                        ), new Cost_Note_Line_Item__c(
                            Subject__c = 'Post- und Telekommunikationspauschale Nr. 7002 VV',
                            Price__c = 20,
                            Calculate_Vat__c = true,
                            Type__c = 'Berufung'
                        )});

                        insertCostNotes.put(costNote,costNoteLineItems);

                        // Kunde
                        if ((oldClaims.get(claim.Id).Cover_Note_Scope__c != 'Extrajudicial') && (claim.Opportunity__r.Legal_Protection_Deductible__c > 0)){
                            Cost_Note__c cn = CostNotes.build(claim, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
                            if (cn != null) {
                                insertCostNotes.put(cn, null);
                            }
                        }
                    }
                 }
            }
        }

        if (insertCostNotes.isEmpty() == false && !Test.isRunningTest()){
            CostNoteQueueable queueable = new CostNoteQueueable();
            queueable.insertCostNotes = insertCostNotes;
            System.enqueueJob(queueable);
        }

        if (updateCostNotes.size() > 0){
            update updateCostNotes;
        }
        return insertCostNotes;
    }
}