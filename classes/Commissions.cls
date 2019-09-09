public class Commissions {
	public static void setCommissionRate(Commission__c[] cmm) {
		Commission_Rate__c[] cmrr = [SELECT ID, Account__c, Legal_Account__c, Rate__c, Product__c FROM Commission_Rate__c];
		for (Commission__c cm: cmm) {
			for (Commission_Rate__c cmr : cmrr) {
				if (cmr.account__c == cm.account__c
                    && cmr.legal_Account__c == cm.legal_Account__c
                    && cm.product__c.contains(cmr.product__c)) {
					if (cmr.product__c == 'Dieselskandal') {
						cm.commission_Rate_Dg__c = cmr.rate__c;
					} else if (cmr.Product__c == 'Lebensversicherung') {
						cm.commission_Rate_Lv__c = cmr.rate__c;
					}
				} else {
					cm.addError('Es wurde kein Provisionssatz für diese Provisionskombination gefunden. Bitte erstellen.');
				}
			}
		}
	}

    // Legacy code, todo: refactor
    public static void assignCostNotePayments(List<Commission__c> commissions) {
		List<Cost_Note_Payment__c> costNotePayments = [select Id, Cost_Note__c, Date__c, Cost_Note__r.Claim__r.Opportunity__r.Legal_Account__c, Cost_Note__r.Claim__r.Opportunity__r.Account_Id__c, Cost_Note__r.Claim__r.Opportunity__r.Product__c,Amount__c from Cost_Note_Payment__c where Cost_Note__c != null and Date__c != null and Test__c = false and Commission__c = null];
		// assign cost note payments
		List<Cost_Note_Payment__c> updateCostNotePayments = new List<Cost_Note_Payment__c>();
		List<Commission__c> updateCommissions = new List<Commission__c>();

		for (Commission__c commission : commissions) {
			Decimal amountDg = 0;
			Decimal amountLv = 0;
            for (Cost_Note_Payment__c costNotePayment : costNotePayments) {
                if ((commission.Legal_Account__c == costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Legal_Account__c) && (String.valueOf(commission.Account__c).substring(0,15) == costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Account_Id__c) && (commission.Product__c.contains(costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c))) {
                    if ((commission.Start_Date__c != null) && (commission.End_Date__c != null) && (commission.Start_Date__c <= costNotePayment.Date__c) && (commission.End_Date__c >= costNotePayment.Date__c)) {
                        costNotePayment.Commission__c = commission.Id;
                        updateCostNotePayments.add(costNotePayment);
                        
                        //Add amount for different products
                        if (costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c == 'Dieselskandal') {
                            amountDg += costNotePayment.Amount__c;
                        } else if (costNotePayment.Cost_Note__r.Claim__r.Opportunity__r.Product__c == 'Lebensversicherung') {
                            amountLv += costNotePayment.Amount__c;
                        }
                    }
                }
            }
			if (amountDg > 0) {
				System.debug(commission.Id);
				System.debug(commission.Product__c);
				System.debug(commission.Commission_Rate_Dg__c);
				updateCommissionAmount(commission.Id, 'Dieselskandal', amountDg * (commission.Commission_Rate_Dg__c/100));
			}
			if (amountLv > 0) {
				updateCommissionAmount(commission.Id, 'Lebensversicherung', amountLv * (commission.Commission_Rate_Lv__c/100));
			}
		}

	// update cost note payments
		if (updateCostNotePayments.isEmpty() == false) {
			update updateCostNotePayments;
		}
	}
    
    // Legacy
    @Future
	public static void updateCommissionAmount(Id commissionId, String product, Decimal amount) {
        if (product != 'Dieselskandal' && product != 'Lebensversicherung') { return; }

		Commission__c commission = [select Id, Product__c, Account__c from Commission__c where Id = :commissionId];
		if (product == 'Dieselskandal') {
			commission.Amount_Dg__c = amount;
		} else if (product == 'Lebensversicherung') {
			commission.Amount_Lv__c = amount;
		}

		update commission;
	}
    
    @future (callout=true)
    public static void autoCreateDocuments(Set<Id> commissions) {
		List<Cost_Note_Payment__c> costNotePayments = [select Id, Commission__c from Cost_Note_Payment__c where Commission__c IN :commissions];

		Set<Id> commissionIds = new Set<Id>();
		for (Cost_Note_Payment__c costNotePayment : costNotePayments) {
			commissionIds.add(costNotePayment.Commission__c);
		}

		for (Id commission : commissions) {
			if (commissionIds.contains(commission)) {
				DocumentCreationAction.autoCreateDocument(commission, false, 'pdf', null, null);
				DocumentCreationAction.autoCreateDocument(commission, false, 'sameAsInput', null, null);
			}
		}
	}
}