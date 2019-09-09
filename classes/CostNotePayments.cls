public class CostNotePayments {
	public static void preventDelete(Cost_Note_Payment__c[] cnpp) {
		for (Cost_Note_Payment__c cnp: cnpp) {
			if (cnp.commission__c != null) {
				cnp.addError('Dieser Zahlungseingang der Kostennote darf nicht gelöscht werden, da er bereits einer Abrechnung hinzugefügt wurde.');
			}
		}
	}

	public static void preventUpdate(Cost_Note_Payment__c[] cnpp, Map<ID, Cost_Note_Payment__c> oldCnpp) {
		for (Cost_Note_Payment__c cnp: cnpp) {
			if (cnp.commission__c != null && oldCnpp.get(cnp.ID).commission__c != null) { // ?
				cnp.addError('Dieser Zahlungseingang der Kostennote darf nicht verändert oder gelöscht werden, da er bereits einer Abrechnung hinzugefügt wurde.');
			}
		}
	}
}