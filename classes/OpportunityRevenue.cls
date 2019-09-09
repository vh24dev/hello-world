public class OpportunityRevenue {
    // Legacy code, extracted from Utilities
	public static Decimal calculate(Id accountId, Decimal value, Id recordTypeId, String assignmentType){
		Decimal amount;
		if (Opportunities.isDieselSkandal(recordTypeId)) {
			// DG
			if (assignmentType == 'Share'){
				amount = value * 0.25;
				System.debug(amount*1.19);
				if ((amount * 1.19) > 2900){
					amount = (2900 / 1.19).setScale(2,System.RoundingMode.HALF_UP);
				}
			} else {
				amount = 0;
			}
		} else {
			// LV // edit: and FZ, right?
			if (Accounts.isVH24(accountId)){
				// VH24
				if (assignmentType == 'Share'){
					if (value <= 50000){
						amount = value * 0.4 * 1.19;
					} else if (value <= 75000){
						amount = value * 0.37 * 1.19;
					} else if (value <= 100000){
						amount = value * 0.34 * 1.19;
					} else {
						amount = value * 0.3 * 1.19;
					}
				} else if (assignmentType == 'RSV'){
					amount = (value * 0.2 * 1.19) + 89.0;
				} else {
					amount = 0;
				}
			} else {
				// VR24
				if (assignmentType == 'Share'){
					if (value <= 50000){
						amount = value * 0.5;
					} else if (value <= 75000){
						amount = value * 0.45;
					} else if (value <= 100000){
						amount = value * 0.4;
					} else {
						amount = value * 0.35;
					}
				} else if (assignmentType == 'RSV'){
					amount = value * 0.2;
				} else {
					amount = 0;
				}
			}
		}
		return amount;
	}
}