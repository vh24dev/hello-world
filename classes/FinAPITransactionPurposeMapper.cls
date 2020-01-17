public class FinAPITransactionPurposeMapper implements FinAPITransactionMapper {
    private Log log;
    public FinAPITransactionPurposeMapper(Log log) {
        this.log = log;
    }

    // wip: refactor legacy code
    public void doMap(Integer lastN, Date lastNBefore) {
        Logger.debug('>> FinAPITransactionPurposeMapper :: doMap :: lastN: ' + lastN + ' lastNBefore: ' + lastNBefore);

        if (lastNBefore == null) {
            lastNBefore = Date.today();
        }
        
        if (lastN == null) {
            lastN = 0;
        }

        // Note: legacy code processing only the last 250
        Transaction__c[] transactions = [
            SELECT  ID,
		            Stage__c,
            		Purpose__c,
            		Method__c,
            		Amount__c,
            		Date__c,
            		External_Id__c,
            		Mapping_Error__c,
            		Matching_records__c
            FROM Transaction__c
            WHERE Stage__c = 'Open' AND Date__c <= :lastNBefore
            ORDER BY Date__c DESC NULLS LAST
            LIMIT :lastN
        ];
        System.debug('FinAPITransactionMapper :: process :: number of transactions: ' + transactions.size() + ' limited to: ' + lastN + ' before: ' + lastNBefore);
        
        if (transactions.size() == 0) {
            return;
        }

        // Try to match a Transaction__c to open Opps, Claims, Invoices, CostNotes, CreditNotes, or Receipts, by Transaction Purpose.
        
        // All invoices which haven't been canceled or paid.
        Invoice__c[] invoices = [
            SELECT  ID,
            		Number__c,
            		Stage__c,
            		Amount__c,
            		Amount_Open__c,
            		Opportunity__r.Number__c,
            		(SELECT ID,
                     		Amount__c
                     FROM Invoice_Payments__r)
            FROM Invoice__c
            WHERE Stage__c != 'Canceled' AND Stage__c != 'Paid'
        ];
        System.debug('FinAPITransactionMapper :: process :: number of invoices: ' + invoices.size());
        
        Map<String, Invoice__c> invoicesByInvoiceNumber = new Map<String, Invoice__c>();
        Map<String, Invoice__c[]> invoicesByOpportunityNumber = new Map<String, Invoice__c[]>();
        for (Invoice__c inv: invoices) {
            if (String.isBlank(inv.Number__c)) {
                System.debug('FinAPITransactionMapper :: process :: invoice has blank number: ' + inv.ID);
                continue;
            }
            invoicesByInvoiceNumber.put(cleanedNumber(inv.Number__c), inv);

            if (String.isBlank(inv.Opportunity__r.Number__c)) {
                System.debug('FinAPITransactionMapper :: process :: invoice opp has blank number: ' + inv.ID);
                continue;
            }
            
            Invoice__c[] invs = invoicesByOpportunityNumber.get(inv.Opportunity__r.Number__c);
            if (invs == null) {
                invs = new Invoice__c[]{};
            }
            invs.add(inv);
			invoicesByOpportunityNumber.put(cleanedNumber(inv.Opportunity__r.Number__c), invs);
        }
        
        // All CostNotes which haven't been canceled, paid, or replaced.
        Cost_Note__c[] costNotes = [
            SELECT  ID,
            		Number__c,
            		Stage__c,
            		Amount__c,
            		Amount_For_Customer__c,
            		Amount_For_Legal_Prot_Insurance__c,
            		Amount_Open__c,
            		Amount_Open_By_Customer__c,
            		Amount_Open_By_Legal_Prot_Insurance__c,
            		Claim__r.Reference__c,
            		(SELECT ID, Amount__c FROM Cost_Note_Payments__r)
            FROM Cost_Note__c
            WHERE Stage__c != 'Canceled' AND Stage__c != 'Paid' AND Stage__c != 'Replaced' // AND Number__c != null
        ];
        System.debug('FinAPITransactionMapper :: process :: number of costnotes: ' + costNotes.size());

        Map<String, Cost_Note__c> costNotesByCostNoteNumber = new Map<String, Cost_Note__c>();
        Map<String, Cost_Note__c[]> costNotesByReference = new Map<String, Cost_Note__c[]>();
        for (Cost_Note__c cn: costNotes) {
            if (String.isBlank(cn.Number__c)) {
                System.debug('FinAPITransactionMapper :: process :: costNote has blank number: ' + cn.ID);
                continue;
            }
            costNotesByCostNoteNumber.put(cleanedNumber(cn.Number__c), cn);

            if (String.isBlank(cn.Claim__r.Reference__c)) {
                System.debug('FinAPITransactionMapper :: process :: costNote claim has blank number: ' + cn.ID);
                continue;
            }

            Cost_Note__c[] cns = costNotesByReference.get(cleanedNumber(cn.Claim__r.Reference__c));
            if (cns == null) {
                cns = new Cost_Note__c[]{};
				Logger.debug('cns0');
            }
            cns.add(cn);
            Logger.debug('cns: ' + cns);
			costNotesByReference.put(cleanedNumber(cn.Claim__r.Reference__c), cns);
            Logger.debug('costNotesByReference loop: ' + costNotesByReference);
        }
        Logger.debug('costNotesByReference: ' + costNotesByReference);
        
        // All CreditNotes which haven't been canceled or paid.
        Credit_Note__c[] creditNotes = [
            SELECT  ID,
            		Number__c,
            		Stage__c,
            		Amount__c,
            		Amount_For_Customer__c,
            		Amount_For_Legal_Prot_Insurance__c,
            		Amount_Open__c,
            		Amount_Open_To_Customer__c,
            		Amount_Open_To_Legal_Prot_Insurance__c,
            		Claim__r.Reference__c,
            		(SELECT ID, Amount__c FROM Credit_Note_Payments__r)
            FROM Credit_Note__c
            WHERE Stage__c != 'Canceled' AND Stage__c != 'Paid' // AND Number__c != null
        ];
        System.debug('FinAPITransactionMapper :: process :: number of creditnotes: ' + creditNotes.size());
        
        Map<String, Credit_Note__c> creditNotesByCreditNoteNumber = new Map<String, Credit_Note__c>();
        for (Credit_Note__c cn: creditNotes) {
            if (String.isBlank(cn.Number__c)) {
                System.debug('FinAPITransactionMapper :: process :: creditNote has blank number: ' + cn.ID);
                continue;
            }
            creditNotesByCreditNoteNumber.put(cleanedNumber(cn.Number__c), cn);
        }
        
        // All Receipts which haven't been canceled or paid.
        Receipt__c[] receipts = [
            SELECT  ID,
            		Number__c,
            		Stage__c,
            		Amount__c,
            		Amount_Open__c,
            		(SELECT ID, Amount__c FROM Receipt_Payments__r)
            FROM Receipt__c
            WHERE Stage__c != 'Canceled' AND Stage__c != 'Paid' // AND Number__c != null
        ];
        System.debug('FinAPITransactionMapper :: process :: number of receipts: ' + receipts.size());
        
        Map<String, Receipt__c> receiptsByReceiptNumber = new Map<String, Receipt__c>();
        for (Receipt__c r: receipts) {
            if (String.isBlank(r.Number__c)) {
                System.debug('FinAPITransactionMapper :: process :: receipt has blank number: ' + r.ID);
                continue;
            }
            receiptsByReceiptNumber.put(cleanedNumber(r.Number__c), r);
        }
        
        // Start mapping
        List<Invoice_Payment__c> newInvoicePayments = new List<Invoice_Payment__c>();
        List<Cost_Note_Payment__c> newCostNotePayments = new List<Cost_Note_Payment__c>();
        List<Credit_Note_Payment__c> newCreditNotePayments = new List<Credit_Note_Payment__c>();
        List<Receipt_Payment__c> newReceiptPayments = new List<Receipt_Payment__c>();
        Map<Id, Invoice_Payment__c> updateInvoicePayments = new Map<Id, Invoice_Payment__c>();
        Map<Id, Cost_Note_Payment__c> updateCostNotePayments = new Map<Id, Cost_Note_Payment__c>();
        Map<Id, Credit_Note_Payment__c> updateCreditNotePayments = new Map<Id, Credit_Note_Payment__c>();
        Map<Id, Receipt_Payment__c> updateReceiptPayments = new Map<Id, Receipt_Payment__c>();
        Map<Id, Transaction__c> newTransactions = new Map<Id, Transaction__c>();
        for (Transaction__c trans: transactions) {
            String transactionPurpose = trans.Purpose__c == null ? '' : cleanedNumber(trans.Purpose__c);
            System.debug('#####');
            System.debug('FinAPITransactionMapper :: process :: transaction: ' + trans + ' cleaned purpose: ' + transactionPurpose + ' old mapping error (will be recalculated): ' + trans.mapping_Error__c  + ' old matches (will be recalculated): ' + trans.matching_records__c);

            trans.mapping_Error__c = null;
            trans.matching_records__c = null;
            trans.last_mapping_process_at__c = DateTime.now();
            newTransactions.put(trans.ID, trans);

            // Search for invoice number
            System.debug('FinAPITransactionMapper :: process :: invoicesByInvoiceNumber: ' + invoicesByInvoiceNumber.size());
            Set<Invoice__c> invoiceHits = new Set<Invoice__c>();
            for (String invoiceNumber : invoicesByInvoiceNumber.keySet()) {
                if (transactionPurpose.contains(invoiceNumber)) {
                    invoiceHits.add(invoicesByInvoiceNumber.get(invoiceNumber));
                }
            }
            // Search for opportunity number
            for (String oppNumber : invoicesByOpportunityNumber.keySet()) {
                if (transactionPurpose.contains(oppNumber)) {
                    Invoice__c[] invs = invoicesByOpportunityNumber.get(oppNumber);
                    if (invs.size() > 1) {
                        System.debug('FinAPITransactionMapper :: process :: found more than one invoice for matching Opp Number: ' + oppNumber);
                    }
                    for (Invoice__c inv: invs) {
                    	invoiceHits.add(inv);   
                    }
                }
            }
            System.debug('FinAPITransactionMapper :: process :: invoiceHits: ' + invoiceHits);
            
            // Search for cost note number
            Set<Cost_Note__c> costNoteHits = new Set<Cost_Note__c>();
            for (String costNoteNumber : costNotesByCostNoteNumber.keySet()) {
                if (transactionPurpose.contains(costNoteNumber)) {
                    costNoteHits.add(costNotesByCostNoteNumber.get(costNoteNumber));
                }
            }
            
            // Search for claim reference
            Logger.debug('costNotesByReference: ' + costNotesByReference);
            for (String claimReference : costNotesByReference.keySet()) {
                if (transactionPurpose.contains(claimReference)) {
                    Cost_Note__c[] cns = costNotesByReference.get(claimReference);
                    if (cns.size() > 1) {
                        System.debug('FinAPITransactionMapper :: process :: found more than one costnote for matching Claim Reference: ' + claimReference);
                    }
                    for (Cost_Note__c cn: cns) {
                    	costNoteHits.add(cn);
                    }
                }
            }
			System.debug('FinAPITransactionMapper :: process :: costNoteHits: ' + costNoteHits);
            
            // Search for credit note number
            Set<Credit_Note__c> creditNoteHits = new Set<Credit_Note__c>();
            for (String creditNoteNumber : creditNotesByCreditNoteNumber.keySet()) {
                if (transactionPurpose.contains(creditNoteNumber)) {
                    creditNoteHits.add(creditNotesByCreditNoteNumber.get(creditNoteNumber));
                }
            }
            System.debug('FinAPITransactionMapper :: process :: creditNoteHits: ' + creditNoteHits);

            // Search for receipt number
            Set<Receipt__c> receiptHits = new Set<Receipt__c>();
            for (String receiptNumber : receiptsByReceiptNumber.keySet()) {
                if (transactionPurpose.contains(receiptNumber)) {
                    receiptHits.add(receiptsByReceiptNumber.get(receiptNumber));
                }
            }
            System.debug('FinAPITransactionMapper :: process :: receiptHits: ' + receiptHits);
            
            Integer hitsCount = invoiceHits.size() + costNoteHits.size() + creditNoteHits.size() + receiptHits.size();
            System.debug('FinAPITransactionMapper :: process :: found invoiceHits.size(): ' + invoiceHits.size() + ' costNoteHits.size(): ' + costNoteHits.size() + ' creditNoteHits.size(): ' + creditNoteHits.size() + ' receiptHits.size(): ' + receiptHits.size() + ' hitsCount: ' + hitsCount + ' for transaction: ' + trans.ID);

            // Evaluate search result
            // 
            // Search for a matching amount on one of the matching records. If only one record found then we're good.
            if (hitsCount == 0) {
                trans.mapping_Error__c = 'No mapping result.';
                newTransactions.put(trans.ID, trans);
                System.debug('FinAPITransactionMapper :: process :: found no matches for transaction, consider as processed t: ' + trans);
                continue;
            }

            // Evaluate invoice hits
            // 
            Invoice__c[] invoiceHitsList = new Invoice__c[]{};
            invoiceHitsList.addAll(invoiceHits);
            Boolean processedInvoice = false;
            for (Invoice__c inv: invoiceHitsList) {
                System.debug('FinAPITransactionMapper :: process :: invoice: ' + inv.ID);

                // What if more than one matches the amount? (edge case)
                processedInvoice = processInvoiceHit(trans, inv, newInvoicePayments, updateInvoicePayments, newTransactions);
                if (processedInvoice) {
                    // No need to look for other invoices for this transaction.
                    System.debug('FinAPITransactionMapper :: process :: found matching invoice: ' + inv);
                    break;
                }
            }
            
            // We've gone through all invoices and we either processed the transaciotn for an Invoice
            // or no Invoice matched amount.
            // If the transaction matches other object types we let it run,
            // if not, we set an error and assume it as processed.
            if (processedInvoice || hitsCount == invoiceHitsList.size()) {
				setMappingMatches(trans, invoiceHitsList);
            }

            if (processedInvoice) {
                System.debug('FinAPITransactionMapper :: process :: found matching invoice, consider transaction as processed t: ' + trans);
                newTransactions.put(trans.ID, trans);
                continue;
            }

            if (hitsCount == invoiceHitsList.size()) {
                // Hits are all invoices
                if (hitsCount == 1) {
                    setAmountNotMatchingError(trans, invoiceHitsList[0].ID, invoiceHitsList[0].amount_Open__c, trans.amount__c);
                } else {
                    setMultipleMappingMatchesError(trans, invoiceHitsList);
                }
                System.debug('FinAPITransactionMapper :: process :: (on invoices) no matches from other object types, consider transaction as processed t: ' + trans);
                newTransactions.put(trans.ID, trans);
                continue;
            }
    
            System.debug('FinAPITransactionMapper :: process :: invoices through :: there are matches from other object types, let it run');                
            // --
            
            // Evaluate costNote hits
            // 
            Cost_Note__c[] costNoteHitsList = new Cost_Note__c[]{};
            costNoteHitsList.addAll(costNoteHits);
            Boolean processedCostNote = false;
            for (Cost_Note__c cn: costNoteHitsList) {
                System.debug('FinAPITransactionMapper :: process :: costNote: ' + cn.ID);

                // What if more than one matches the amount? (edge case)
                processedCostNote = processCostNoteHit(trans, cn, newCostNotePayments, updateCostNotePayments, newTransactions);
                if (processedCostNote) {
                    // No need to look for other costnotes for this transaction.
                    System.debug('FinAPITransactionMapper :: process :: found matching costNote: ' + cn);
                    break;
                }
            }

            if (processedCostNote || hitsCount == costNoteHitsList.size()) {
				setMappingMatches(trans, costNoteHitsList);
            }

            if (processedCostNote) {
                System.debug('FinAPITransactionMapper :: process :: found matching costNote, consider transaction as processed t: ' + trans);
                newTransactions.put(trans.ID, trans);
                continue;
            }

            if (hitsCount == costNoteHitsList.size()) {
                // Hits are all costNotes
                if (hitsCount == 1) {
                    setAmountNotMatchingError(trans, costNoteHitsList[0].ID, costNoteHitsList[0].amount_Open__c, trans.amount__c);
                } else {
                    setMultipleMappingMatchesError(trans, costNoteHitsList);
                }
                System.debug('FinAPITransactionMapper :: process :: (on costnote) no matches from other object types, consider transaction as processed t: ' + trans);
                newTransactions.put(trans.ID, trans);
                continue;
            }
    
            System.debug('FinAPITransactionMapper :: process :: costNotes through :: there are matches from other object types, let it run');                
            // --
            
            // Evaluate credit Note hits
            Credit_Note__c[] creditNoteHitsList = new Credit_Note__c[]{};
            creditNoteHitsList.addAll(creditNoteHits);
            if (creditNoteHits.Size() == 1) {
                Credit_Note__c creditNote = creditNoteHitsList[0];
                System.debug('FinAPITransactionMapper :: process :: creditNote: ' + creditNote.ID);

                Decimal convertedTransAmount = trans.Amount__c * -1;
                if (!amountsMatch(creditNote.Amount_Open_To_Customer__c, convertedTransAmount) && !amountsMatch(creditNote.Amount_Open_To_Legal_Prot_Insurance__c, convertedTransAmount)) {
                    System.debug('FinAPITransactionMapper :: process :: credNoteHits :: Amount open equals transaction amount');
                    
                    Boolean found = false;
                    for (Credit_Note_Payment__c creditNotePayment : creditNote.Credit_Note_Payments__r) {
                        if (amountsMatch(creditNotePayment.Amount__c, convertedTransAmount) && (amountsMatch(creditNote.Amount_For_Customer__c, convertedTransAmount) || amountsMatch(creditNote.Amount_For_Legal_Prot_Insurance__c, convertedTransAmount))) {
                            trans.Mapping_Error__c = 'Transaction already processed. Added mapping.';
                            trans.Stage__c = 'Processed';
                            newTransactions.put(trans.Id, trans);
                            creditNotePayment.Transaction__c = trans.Id;
                            updateCreditNotePayments.put(creditNotePayment.Id, creditNotePayment);
                            found = true;
                        }
                    }
                    if (!found) {
                        setAmountNotMatchingError(trans, creditNote.ID, convertedTransAmount, creditNote.Amount_Open_To_Customer__c);
                        newTransactions.put(trans.Id, trans);
                    }
                } else {
                    // Create and map new payment
                    String recipientType;
                    if (amountsMatch(creditNote.Amount_Open_To_Customer__c, convertedTransAmount)) {
                        recipientType = 'Kunde';
                    } else if (amountsMatch(creditNote.Amount_Open_To_Legal_Prot_Insurance__c, convertedTransAmount)) {
                        recipientType = 'RSV';
                    }
                    Credit_Note_Payment__c creditNotePayment = new Credit_Note_Payment__c(
                        Credit_Note__c = creditNote.Id,
                        Amount__c = convertedTransAmount,
                        Date__c = trans.Date__c,
                        Method__c = trans.Method__c,
                        Transaction__c = trans.Id,
                        Recipient_Type__c = recipientType
                    );
                    // Filter duplicate transactions
                    Boolean found = false;
                    for (Credit_Note_Payment__c existingNewCreditNotePayments : newCreditNotePayments) {
                        if (existingNewCreditNotePayments.Credit_Note__c == creditNotePayment.Credit_Note__c && amountsMatch(existingNewCreditNotePayments.Amount__c, creditNotePayment.Amount__c) && existingNewCreditNotePayments.Date__c == creditNotePayment.Date__c) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        newCreditNotePayments.add(creditNotePayment);
                        trans.Stage__c = 'Processed';
                        trans.Mapping_Error__c = '';
                    } else {
                        trans.Mapping_Error__c = 'Duplicate transaction.';
                    }
                    newTransactions.put(trans.Id, trans);
                }
            }
            
            // Evaluate receipt hits
            Receipt__c[] receiptHitsList = new Receipt__c[]{};
            receiptHitsList.addAll(receiptHits);
            if (receiptHits.Size() == 1) {
                    Receipt__c receipt = receiptHitsList[0];
                	System.debug('FinAPITransactionMapper :: process :: receipt: ' + receipt.ID);
                
                    if (!amountsMatch(receipt.Amount_Open__c, trans.Amount__c)) {
						System.debug('FinAPITransactionMapper :: process :: receiptHits :: Amount open is different than transaction amount');

                        Boolean found = false;
                        for (Receipt_Payment__c receiptPayment : receipt.Receipt_Payments__r) {
                            if (amountsMatch(receiptPayment.Amount__c, trans.Amount__c) && amountsMatch(receipt.Amount__c, trans.Amount__c)) {
                                trans.Mapping_Error__c = 'Transaction already processed. Added mapping.';
                                trans.Stage__c = 'Processed';
                                newTransactions.put(trans.Id, trans);
                                receiptPayment.Transaction__c = trans.Id;
                                updateReceiptPayments.put(receiptPayment.Id, receiptPayment);
                                found = true;
                            }
                        }
                        if (!found) {
                            setAmountNotMatchingError(trans, receipt.ID, trans.Amount__c, receipt.Amount_Open__c);
                            newTransactions.put(trans.Id, trans);
                        }
                    } else {
                        // Create and map new payment
                        Receipt_Payment__c receiptPayment = new Receipt_Payment__c(
                            Receipt__c = receipt.Id,
                            Amount__c = trans.Amount__c,
                            Date__c = trans.Date__c,
                            Method__c = trans.Method__c,
                            Transaction__c = trans.Id
                        );
                        // Filter duplicate transactions
                        Boolean found = false;
                        for (Receipt_Payment__c existingNewReceiptPayments : newReceiptPayments) {
                            if (existingNewReceiptPayments.Receipt__c == receiptPayment.Receipt__c && amountsMatch(existingNewReceiptPayments.Amount__c, receiptPayment.Amount__c) && existingNewReceiptPayments.Date__c == receiptPayment.Date__c) {
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            newReceiptPayments.add(receiptPayment);
                            trans.Stage__c = 'Processed';
                            trans.Mapping_Error__c = '';
                        } else {
                            trans.Mapping_Error__c = 'Duplicate transaction.';
                        }
                        newTransactions.put(trans.Id, trans);
                    }
                }
            
            // Set all mapping matches.
            SObject[] allMatches = new SObject[]{};
			allMatches.addAll(invoiceHitsList);
            allMatches.addAll(costNoteHitsList);
            allMatches.addAll(creditNoteHitsList);
            allMatches.addAll(receiptHitsList);
            setMappingMatches(trans, allMatches);
            newTransactions.put(trans.ID, trans);

            if (trans.Stage__c != 'Open' || !String.isBlank(trans.mapping_Error__c)) {
                Logger.debug('FinAPITransactionMapper :: process :: processed t: ' + trans);
                continue;
            }

            if (hitsCount > 1) {
                setMultipleMappingMatchesError(trans, allMatches);
            } else {
                setAmountNotMatchingError(trans, null, trans.amount__c, null);
            }
            
            Logger.debug('FinAPITransactionMapper :: process :: did set mapping error :: processed t: ' + trans);
        }
        
        logStats(transactions, lastN, lastNBefore);

        if (newInvoicePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: inserting ' + newInvoicePayments.Size() + ' invoicePayments');
            insert newInvoicePayments;
        }
        
        if (newCostNotePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: inserting ' + newCostNotePayments.Size() + ' newCostNotePayments');
            insert newCostNotePayments;
        }
        
        if (newCreditNotePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: inserting ' + newCreditNotePayments.Size() + ' newCreditNotePayments');
            insert newCreditNotePayments;
        }
        
        if (newReceiptPayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: inserting ' + newReceiptPayments.Size() + ' newReceiptPayments');
            insert newReceiptPayments;
        }
        
        if (newTransactions.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: updating ' + newTransactions.Size() + ' newTransactions');
            update newTransactions.values();
        }
        
        if (updateInvoicePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: updating ' + updateInvoicePayments.Size() + ' updateInvoicePayments');
            update updateInvoicePayments.values();
        }
        
        if (updateCostNotePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: updating ' + updateCostNotePayments.Size() + ' updateCostNotePayments');
            update updateCostNotePayments.values();
        }
        
        if (updateCreditNotePayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: updating ' + updateCreditNotePayments.Size() + ' updateCreditNotePayments');
            update updateCreditNotePayments.values();
        }
        
        if (updateReceiptPayments.Size() > 0) {
            System.debug('FinAPITransactionMapper :: process :: updating ' + updateReceiptPayments.Size() + ' updateReceiptPayments');
            update updateReceiptPayments.values();
        }
    }
    
    private Boolean processInvoiceHit(Transaction__c t, Invoice__c inv, Invoice_Payment__c[] newInvoicePayments, Map<Id, Invoice_Payment__c> updateInvoicePayments, Map<Id, Transaction__c> newTransactions) {
        System.debug('FinAPITransactionMapper :: processInvoiceHit :: t: ' + t + ' inv: ' + inv);

        if (amountsMatch(inv.amount_Open__c, t.amount__c)) {
            System.debug('FinAPITransactionMapper :: processInvoiceHit :: Amount open equals transaction amount');

			// Check if there's already a new InvoicePayment for this Invoice/Transaction.
            Boolean foundDuplicate = false;
            for (Invoice_Payment__c existingNewInvoicePayment : newInvoicePayments) {
                if (inv.ID == existingNewInvoicePayment.Invoice__c && amountsMatch(t.Amount__c, existingNewInvoicePayment.Amount__c) && t.Date__c == existingNewInvoicePayment.Date__c) {
                    System.debug('FinAPITransactionMapper :: processInvoiceHit :: existingNewInvoicePayment: ' + existingNewInvoicePayment);
                    t.Mapping_Error__c = 'Duplicate transaction.';
                    foundDuplicate = true;
                    break;
                }
            }

            if (!foundDuplicate) {
                System.debug('FinAPITransactionMapper :: processInvoiceHit :: no duplicate. Create new invoicePayment');

                Invoice_Payment__c invoicePayment = new Invoice_Payment__c(
                    Invoice__c = inv.Id,
                    Amount__c = t.Amount__c,
                    Date__c = t.Date__c,
                    Method__c = t.Method__c,
                    Transaction__c = t.Id
                );
                newInvoicePayments.add(invoicePayment);
                t.Stage__c = 'Processed';
                t.Mapping_Error__c = '';
                
            }

            newTransactions.put(t.Id, t);
            return true;
        }
        
        System.debug('FinAPITransactionMapper :: processInvoiceHit :: Amount open is different than transaction amount for invoice');

        // Look for any existing InvoicePayment matching the amount of the transaction.        
        for (Invoice_Payment__c ip: inv.Invoice_Payments__r) {
            System.debug('FinAPITransactionMapper :: processInvoiceHit :: checking existing invoicepayment: ' + ip.ID);
            if (!amountsMatch(ip.Amount__c, t.Amount__c) || !amountsMatch(inv.Amount__c, t.Amount__c)) {
				System.debug('FinAPITransactionMapper :: processInvoiceHit :: Didnt find any existing invoice payment');
                continue;
            }

            System.debug('FinAPITransactionMapper :: processInvoiceHit :: Transaction already paid :: found invoicepayment: ' + ip.ID);
            
            t.Mapping_Error__c = 'Transaction already processed. Added mapping.';
            t.Stage__c = 'Processed';
            newTransactions.put(t.Id, t);
            ip.Transaction__c = t.Id;
            updateInvoicePayments.put(ip.Id, ip);
            
            System.debug('FinAPITransactionMapper :: processInvoiceHit :: transaction marked as processed');
            return true;
        }
        
        System.debug('FinAPITransactionMapper :: processInvoiceHit :: did not process transaction');
        return false;
    }
    
    private Boolean processCostNoteHit(Transaction__c t, Cost_Note__c cn, Cost_Note_Payment__c[] newCostNotePayments, Map<Id, Cost_Note_Payment__c> updateCostNotePayments, Map<Id, Transaction__c> newTransactions) {
        System.debug('FinAPITransactionMapper :: processCostNoteHit :: t: ' + t + ' cn: ' + cn);

        if (amountsMatch(cn.Amount_Open_By_Customer__c, t.Amount__c) || amountsMatch(cn.Amount_Open_By_Legal_Prot_Insurance__c, t.Amount__c)) {
            System.debug('FinAPITransactionMapper :: processCostNoteHit :: Amount open equals transaction amount');

			// Check if there's already a new CostNotePayment for this Invoice/Transaction.
            Boolean foundDuplicate = false;
            for (Cost_Note_Payment__c existingCostNotePayment: newCostNotePayments) {
                System.debug('FinAPITransactionMapper :: processCostNoteHit :: checking newCostNotePayment: ' + existingCostNotePayment);
                if (cn.ID == existingCostNotePayment.Cost_Note__c && amountsMatch(t.Amount__c, existingCostNotePayment.Amount__c) && t.Date__c == existingCostNotePayment.Date__c) {
                    System.debug('FinAPITransactionMapper :: processCostNoteHit :: duplicate transaction :: matching newCostNotePayment: ' + existingCostNotePayment);
                    t.Mapping_Error__c = 'Duplicate transaction.';
                    foundDuplicate = true;
                    break;
                }
            }

            if (!foundDuplicate) {
                System.debug('FinAPITransactionMapper :: processCostNoteHit :: no duplicate. Create new costNotePayment and mark transaction as processed');

                String senderType;
                if (amountsMatch(cn.Amount_Open_By_Customer__c, t.Amount__c)) {
                    senderType = 'Kunde';
                } else if (amountsMatch(cn.Amount_Open_By_Legal_Prot_Insurance__c, t.Amount__c)) {
                    senderType = 'RSV';
                }
                Cost_Note_Payment__c costNotePayment = new Cost_Note_Payment__c(
                    Cost_Note__c = cn.Id,
                    Amount__c = t.Amount__c,
                    Date__c = t.Date__c,
                    Method__c = t.Method__c,
                    Transaction__c = t.Id,
                    Sender_Type__c = senderType
                );
                newCostNotePayments.add(costNotePayment);
                t.Stage__c = 'Processed';
                t.Mapping_Error__c = '';
            }

            newTransactions.put(t.Id, t);
            return true;
        }
        
        System.debug('FinAPITransactionMapper :: processCostNoteHit :: Amount open is different than transaction amount for costNote');

        // Look for any existing CostNotePayment matching the amount of the transaction.        
        for (Cost_Note_Payment__c ip: cn.cost_Note_Payments__r) {
            System.debug('FinAPITransactionMapper :: processCostNoteHit :: checking existing costnotepayment: ' + ip.ID);
            if ((!amountsMatch(cn.Amount__c, t.Amount__c) || !amountsMatch(cn.Amount_For_Customer__c, t.Amount__c)) && !amountsMatch(cn.Amount_For_Legal_Prot_Insurance__c, t.Amount__c)) {
				System.debug('FinAPITransactionMapper :: processCostNoteHit :: Didnt find any existing costnotepayment');
                continue;
            }

            System.debug('FinAPITransactionMapper :: processCostNoteHit :: Transaction already paid :: found costnotepayment: ' + ip.ID);
            
            t.Mapping_Error__c = 'Transaction already processed. Added mapping.';
            t.Stage__c = 'Processed';
            newTransactions.put(t.Id, t);
            ip.Transaction__c = t.Id;
            updateCostNotePayments.put(ip.Id, ip);
            
            System.debug('FinAPITransactionMapper :: processCostNoteHit :: transaction marked as processed');
            return true;
        }
        
        System.debug('FinAPITransactionMapper :: processCostNoteHit :: did not process transaction');
        return false;
    }

    private void setMultipleMappingMatchesError(Transaction__c t, SObject[] matches) {
        t.mapping_Error__c = 'More than one mapping result. None matching amount.';
        setMappingMatches(t, matches);

        System.debug('FinAPITransactionMapper :: setMultipleMappingMatchesError :: t.ID: ' + t.ID + ' matches: ' + t.matching_records__c);
    }

    private void setMappingMatches(Transaction__c t, SObject[] matches) {
        Logger.debug('>> FinAPITransactionPurposeMapper :: setMappingMatches :: t: ' + t + ' matches: ' + matches);

        Set<String> existing = String.isBlank(t.matching_records__c) ? new Set<String>{} : new Set<String>(t.matching_records__c.split(';'));
        for (SObject o: matches) {
            ID i = (ID)o.get('ID');
            if (!existing.contains(String.valueOf(i))) {
            	existing.add(i);
            }
		}
        t.matching_records__c = String.join(new List<String>(existing), ';');

        Logger.debug('<< FinAPITransactionPurposeMapper :: setMappingMatches :: t.matching_records__c: ' + t.matching_records__c);
    }

    private static final Decimal errorMargin = 1; // eur
    private Boolean amountsMatch(Decimal a1, Decimal a2) {
        Decimal diff = Math.abs(a1 - a2);
        Boolean matches = diff < errorMargin;
        System.debug('FinAPITransactionMapper :: amountsMatch :: a1: ' + a1 + ' a2: ' + a2 + ' errorMargin: ' + errorMargin + ' diff: ' + diff + ' matches: ' + matches);

        return matches;
    }
    
    // From legacy code, unsure why we clean it this way.
    private String cleanedNumber(String n) {
        return String.isBlank(n) ? '' : n.toLowerCase().replace('//n', '').replace(' ', '').replace('/','').replace('-','');
    }

    private void setAmountNotMatchingError(Transaction__c t, ID recordID, Decimal expected, Decimal actual) {
        System.debug('>> setAmountNotMatchingError');
        if (recordID != null) {
			t.matching_records__c = recordID;            
        }

        t.mapping_Error__c = 'Amount not matching. Expecting ' + expected + ' (transaction). Got ' + (actual == null ? '?' : String.valueOf(actual)) + ' (matching record). Error margin: ' + errorMargin;
    }
    
    private void logStats(Transaction__c[] tt, Integer lastN, Date lastNBefore) {
        Integer totalConsidered = tt.size();
        Integer processedWithError = 0;
        Integer processedWithNoError = 0;
        Integer notProcessed = 0;
        for (Transaction__c t: tt) {
            if (!String.isBlank(t.mapping_Error__c)) {
                ++processedWithError;
            } else if (t.stage__c != 'Open') {
                ++processedWithNoError;
            } else {
                ++notProcessed;
            }
        }

        this.log.debug('FinAPITransactionMapper :: process :: results: total: ' + totalConsidered + ' processedWithError: ' + processedWithError + ' processedWithNoError: ' + processedWithNoError + ' notProcessed: ' + notProcessed + ' lastN: ' + lastN + ' lastNBefore: ' + lastNBefore + ' oldest: ' + tt[tt.size()-1].date__c + ' newest: ' + tt[0].date__c);
        Logger.debug('FinAPITransactionMapper :: process :: results: total: ' + totalConsidered + ' processedWithError: ' + processedWithError + ' processedWithNoError: ' + processedWithNoError + ' notProcessed: ' + notProcessed + ' lastN: ' + lastN + ' lastNBefore: ' + lastNBefore + ' oldest: ' + tt[tt.size()-1].date__c + ' newest: ' + tt[0].date__c);
    }
}