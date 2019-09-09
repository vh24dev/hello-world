public class ClassActions {
    public static void checkClaims(List<Class_Action__c> classActions) {
        if (classActions.size() != 1) {
            return;
        }
        Class_Action__c ca = classActions[0];

        List<Class_Action_Reference__c> rfrs = [SELECT Id, Claim__c FROM Class_Action_Reference__c WHERE Class_Action__c = :ca.Id];
        List<Id> claimIds = new List<Id>();
        for (Class_Action_Reference__c r : rfrs) {
            claimIds.add(r.Claim__c);
        }
        List<Claim__c> claims = [SELECT Id, Clerk__c, Legal__c FROM Claim__c WHERE Id IN :claimIds];

        for (Claim__c c : claims) {
            if (c.Clerk__c == null || c.Legal__c == null) {
                ca.Stage__c.addError('Bitte hinterlegen Sie auf allen Fällen einen Anwalt und einen Sachbearbeiter, bevor Sie die Stage auf "Abgeschlossen" setzen!');
                return;
            }
        }
    }

    // Legacy code, todo: refactor
	public static void setClaimStage(List<Class_Action__c> classActions, Map<Id,Class_Action__c> oldClassActions) {
		classActions = [select Id, Stage__c, (select Id, Claim__c from Class_Action_Referencies__r) from Class_Action__c where Id IN :classActions];

		Set<Id> claimIds = new Set<Id>();
		for (Class_Action__c classAction : classActions){
			for (Class_Action_Reference__c classActionReference : classAction.Class_Action_Referencies__r){
				claimIds.add(classActionReference.Claim__c);
			}
		}

		Map<Id,Claim__c> claims = new Map<Id,Claim__c>([select Id, Stage__c from Claim__c where Id IN :claimIds]);

		List<Claim__c> updateClaims = new List<Claim__c>();

		for (Class_Action__c classAction : classActions){
			if ((classAction.Stage__c != oldClassActions.get(classAction.Id).Stage__c) && (classAction.Stage__c == 'Lawsuit')){
				for (Class_Action_Reference__c classActionReference : classAction.Class_Action_Referencies__r){
					Claim__c claim = claims.get(classActionReference.Claim__c);
					if (claim.Stage__c != 'Class Action'){
						claim.Stage__c = 'Class Action';
						updateClaims.add(claim);
					}
				}
			} else if ((classAction.Stage__c != oldClassActions.get(classAction.Id).Stage__c) && (classAction.Stage__c == 'Finished')){
				for (Class_Action_Reference__c classActionReference : classAction.Class_Action_Referencies__r){
					Claim__c claim = claims.get(classActionReference.Claim__c);
					if (claim.Stage__c != 'Processing'){
						claim.Stage__c = 'Processing';
						updateClaims.add(claim);
					}
				}
			}
		}
		if (updateClaims.size() > 0){
			update updateClaims;
		}
	}
}