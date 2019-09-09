public class CreditNotes {
    // Legacy code, todo: refactor
	public static void setNumber(List<Credit_Note__c> creditNotes, Map<Id,Credit_Note__c> oldCreditNotes, Boolean isInsert) {
		Set<Id> claimIds = new Set<Id>();
		for (Credit_Note__c creditNote : creditNotes){
			claimIds.add(creditNote.Claim__c);
		}

		Map<Id,Claim__c> claims = new Map<Id,Claim__c>([select Id, Opportunity__r.Legal_Account__c, Opportunity__r.RecordTypeId, Opportunity__r.Account_Id__c from Claim__c where Id IN :claimIds]);

		Set<String> postfixes = new Set<String>();
		for (Claim__c claim : claims.values()){
			if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) {
				// DG
				if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
					// Jäger
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
						// VH24
						postfixes.add('CNJVH');
					} else {
						// VR24
						postfixes.add('CNJDG');
					}
				} else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
					// 21Legal
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
						// VH24
						postfixes.add('CN21VH');
					} else {
						// VR24
						postfixes.add('CN21DG');
					}
				} else {
					// Lachmair
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
						// VH24
						postfixes.add('CNVH');
					} else {
						// VR24
						postfixes.add('CNDG');
					}
				}
			} else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)){
				// FZ
				if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
					// Jäger
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
						// VH24
						postfixes.add('CNJVHFZ');
					} else {
						// VR24
						postfixes.add('CNJVRFZ');
					}
				} else {
					// Kainz
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
						// VH24
						postfixes.add('CNCVHFZ');
					} else {
						// VR24
						postfixes.add('CNCVRFZ');
					}
				}
			} else {
				// LV
				if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)){
					// Jäger
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
						// VH24
						postfixes.add('CNJVHLV');
					} else {
						// VR24
						postfixes.add('CNJVRLV');
					}
				} else {
					// 21Legal
					if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
						// VH24
						postfixes.add('CN21VHLV');
					} else {
						// VR24
						postfixes.add('CN21VRLV');
					}
				}
			}
		}

		Map<String,Credit_Note__c> lastCreditNotes = new Map<String,Credit_Note__c>();
		for (String postfix : postfixes){
			if (lastCreditNotes.get(postfix) == null){
				List<Credit_Note__c> queriedCreditNotes = Database.query('SELECT Id,Number__c FROM Credit_Note__c where Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE \'%/' + postfix + '\' ORDER BY Number__c DESC NULLS LAST LIMIT 1');
				if (queriedCreditNotes.size() > 0){
					lastCreditNotes.put(postfix,queriedCreditNotes[0]);
				}
			}
		}

		Map<String,Integer> lastCreditNoteCount = new Map<String,Integer>();
		Map<String,Integer> thisCreditNoteCount = new Map<String,Integer>();
		for (String postfix : postfixes){
			Integer count = 0;
			if (lastCreditNotes.get(postfix) != null){
				count = Integer.valueOf(lastCreditNotes.get(postfix).Number__c.substring(4,10));
			}
			lastCreditNoteCount.put(postfix,count);
			thisCreditNoteCount.put(postfix,1);
		}

		for (Credit_Note__c creditNote : creditNotes){
			if ((creditNote.Number__c == null) && (creditNote.Date__c != null) && ((isInsert == true) || (creditNote.Date__c != oldCreditNotes.get(creditNote.Id).Date__c))){
				Claim__c claim = claims.get(creditNote.Claim__c);

				String postfix;
				if (Opportunities.isDieselSkandal(claim.Opportunity__r.RecordTypeId)) {
					// DG
					if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
						// Jäger
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
							// VH24
							postfix = 'CNJVH';
						} else {
							// VR24
							postfix = 'CNJDG';
						}
					} else if (Accounts.isLegal21(claim.Opportunity__r.Legal_Account__c)) {
						// 21Legal
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
							// VH24
							postfix = 'CN21VH';
						} else {
							// VR24
							postfix = 'CN21DG';
						}
					} else {
						// Lachmair
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
							// VH24
							postfix = 'CNVH';
						} else {
							// VR24
							postfix = 'CNDG';
						}
					}
				} else if (Opportunities.isFinanzierung(claim.Opportunity__r.RecordTypeId)){
					// FZ
					if (Accounts.isJCLegal(claim.Opportunity__r.Legal_Account__c)) {
						// Jäger
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
							// VH24
							postfix = 'CNJVHFZ';
						} else {
							// VR24
							postfix = 'CNJVRFZ';
						}
					} else {
						// Kainz
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)) {
							// VH24
							postfix = 'CNCVHFZ';
						} else {
							// VR24
							postfix = 'CNCVRFZ';
						}
					}
				} else {
					// LV
					if (Accounts.isJCLegalLv(claim.Opportunity__r.Legal_Account__c)){
						// Jäger
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
							// VH24
							postfix = 'CNJVHLV';
						} else {
							// VR24
							postfix = 'CNJVRLV';
						}
					} else {
						// 21Legal
						if (Accounts.isVH24(claim.Opportunity__r.Account_Id__c)){
							// VH24
							postfix = 'CN21VHLV';
						} else {
							// VR24
							postfix = 'CN21VRLV';
						}
					}
				}

				Integer count = lastCreditNoteCount.get(postfix) + thisCreditNoteCount.get(postfix);
				String year = System.now().date().year().format().replace('.','');

				if (creditNote.Test__c == true){
					creditNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/Test';
				} else {
					creditNote.Number__c = year + count.format().replace('.','').leftPad(6,'0') + '/' + postfix;
					thisCreditNoteCount.put(postfix,thisCreditNoteCount.get(postfix) + 1);
				}
			}
		}
	}
    
	public static void uploadToDropbox(List<Credit_Note__c> creditNotes, Map<Id,Credit_Note__c> oldCreditNotes) {
        List<Id>relatedCreditNoteIds = new List<Id>();

        for (Credit_Note__c creditNote : creditNotes){
            if ((creditNote.Stage__c != oldCreditNotes.get(creditNote.Id).Stage__c) && (creditNote.Stage__c == 'Sent') && (creditNote.Uploaded_To_Dropbox__c == false)){
                relatedCreditNoteIds.add(creditNote.Id);
            }
        }

        if (relatedCreditNoteIds.isEmpty() == false){

            Map<Id, String> paths = new Map<Id, String>{
                    Accounts.CLLBLegalID => '/CLLB/Kostennoten/',
                    Accounts.JCLegalLvID => '/Jäger/Kostennoten/',
                    Accounts.JCLegalID => '/J und C/Kostennoten/',
                    Accounts.LegalLachmairID => '/Lachmair/Kostennoten/',
                    Accounts.LegalVortmannID => '/Vortmann/Kostennoten/',
                    Accounts.Legal21ID => '/21Legal/Kostennoten/'
            };

            List<Credit_Note__c> relatedCreditNotes = [select Id,Stage__c,Claim__r.Opportunity__r.Legal_Account__c,Claim__r.Test__c from Credit_Note__c where Id IN :relatedCreditNoteIds];
            List<Attachment> attachments = [select Id,ParentId from Attachment where ParentId IN :creditNotes];

            for (Credit_Note__c creditNote : relatedCreditNotes){
                for (Attachment attachment : attachments){
                    if (attachment.ParentId == creditNote.Id){
                        String path;
                        if (paths.containsKey((creditNote.Claim__r.Opportunity__r.Legal_Account__c)) && (creditNote.Claim__r.Test__c == false)) {
                            path = paths.get(creditNote.Claim__r.Opportunity__r.Legal_Account__c);
                        } else {
                            path = '/Technik/Testdaten/Credit Notes/';
                        }
                        IntegrateDropbox.uploadFileToDropboxAsync(path, attachment.Id,creditNote.Claim__r.Opportunity__r.Legal_Account__c);
                    }
                }
            }
        }
	}
}