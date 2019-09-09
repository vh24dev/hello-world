// Having an unfortunate name due to the API name of the object it refers to - Date__c.
// You can think of it as an Appointment (Termin).
public class Dates {
	public static void setHash(Date__c[] dd) {
		for (Date__c d: dd) {
			if (d.form_Hash_1__c == null) {
				d.form_Hash_1__c = GUID.Gen();
			}
		}
	}
    
    // Legacy code, todo: refactor
    public static void autoSendMails(List<Date__c> dd, Map<Id,Date__c> oldDd) {
		Set<Id> claimIds = new Set<Id>();
		for (Date__c d : dd){
			claimIds.add(d.Claim__c);
		}

		Map<Id,Claim__c> claims = new Map<Id,Claim__c>([select Id, Opportunity_Record_Type_Id__c from Claim__c where Id IN :claimIds]);
		for (Date__c d: dd){
			if (d.representative__c != null && d.representative__c != oldDd.get(d.ID).representative__c) {
				Claim__c claim = claims.get(d.Claim__c);
				Id templateId;
				if (Opportunities.isDieselSkandal(claim.Opportunity_Record_Type_Id__c)) {
					// DG
					if (Accounts.JCLegalID == d.Legal__c) {
						// Jäger
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselJaegerLegalDateRequest));
                    } else if (Accounts.LeComLegalID == d.Legal__c) {
						// LeCom
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselLeComLegalDateRequest));
					} else {
						// Kainz
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.DieselKainzLegalDateRequest));
					}
				} else if (Opportunities.isFinanzierung(claim.Opportunity_Record_Type_Id__c)) {
					// FZ
					if (Accounts.JCLegalID == d.Legal__c) {
						// Jäger
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.FzJaegerLegalDateRequest));
                    } else if (Accounts.LeComLegalID == d.Legal__c) {
						// LeCom
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.FzLeComLegalDateRequest));
					} else {
						// Kainz
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.FzKainzLegalDateRequest));
					}
				} else {
					// LV
					if (Accounts.JCLegalLvID == d.Legal__c) {
						// Jäger
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.LvJaegerLegalDateRequest));
                    } else if (Accounts.LeComLegalID == d.Legal__c) {
						// LeCom
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.LvLeComLegalDateRequest));
					} else {
						// Kainz
						templateId = Id.valueOf(EmailTemplates.idOf(EmailTemplates.LegalDate.LvKainzLegalDateRequest));
					}
				}

				if (templateId != null) {
					EmailUtilities emailUtilities = new EmailUtilities(d.Id, d.Representative__c, templateId, d.Legal__c);
					String result = emailUtilities.send();
					System.debug('Sent automatic mail with result: ' + result);
				}
			}
		}
	}
    
    // Leagcy code, todo: refactor
    public static void createObjects(List<Date__c> dates, Map<Id,Date__c> oldDates){
		List<Date_Notification__c> insertDateNotifications = new List<Date_Notification__c>();
		List<Date_Record__c> insertDateRecords = new List<Date_Record__c>();
		List<Date_Authorization__c> insertDateAuthorizations = new List<Date_Authorization__c>();

		for (Date__c thisDate : dates){
			if ((thisDate.Claim_Stage__c == 'Appeal') && (thisDate.Type__c == 'Gerichtstermin')){
				if ((thisDate.Representative__c != null) && (thisDate.Representative__c != oldDates.get(thisDate.Id).Representative__c)){
					insertDateAuthorizations.add(new Date_Authorization__c(
						Date__c = thisDate.Id
					));
				}
				if ((thisDate.Representative_Confirmation_Date__c != null) && (thisDate.Representative_Confirmation_Date__c != oldDates.get(thisDate.Id).Representative_Confirmation_Date__c)){
					insertDateNotifications.add(new Date_Notification__c(
						Date__c = thisDate.Id
					));
					insertDateRecords.add(new Date_Record__c(
						Date__c = thisDate.Id
					));
				}
			}
		}

		if (!insertDateNotifications.isEmpty()) {
			insert insertDateNotifications;
		}

		if (!insertDateRecords.isEmpty()) {
			insert insertDateRecords;
		}

		if (!insertDateAuthorizations.isEmpty()) {
			insert insertDateAuthorizations;
		}
	}
}