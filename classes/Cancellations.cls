public class Cancellations {
    public static void setNumber(List<Cancellation__c> cancellations, Map<Id,Cancellation__c> oldCancellations, Boolean isInsert) {
        Set<Id> costNoteIds = new Set<Id>();
        for (Cancellation__c cancellation : cancellations){
            costNoteIds.add(cancellation.Cost_Note__c);
        }

        Map<Id,Cost_Note__c> costNotes = new Map<Id,Cost_Note__c>([
            SELECT Id, Test__c, Claim__r.Opportunity__r.Legal_Account__c, Claim__r.Opportunity__r.RecordTypeId, Claim__r.Opportunity__r.Account_Id__c
            FROM Cost_Note__c
            WHERE Id IN :costNoteIds
        ]);
        if (costNotes.size() == 0) {
            return;
        }

        Set<String> postfixes = new Set<String>();
        for (Cost_Note__c costNote : costNotes.values()){
            if (Opportunities.isDieselSkandal(costNote.Claim__r.Opportunity__r.RecordTypeId)){
                // DG
                if (Accounts.isJCLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                    // Jäger
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('JVH');
                    } else {
                        // VR24
                        postfixes.add('JDG');
                    }
                } else if (Accounts.isCLLBLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                    // Kainz
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('CVH');
                    } else {
                        // VR24
                        postfixes.add('CVR');
                    }
                } else if (Accounts.isLegal21(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                    // 21Legal
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('21VH');
                    } else {
                        // VR24
                        postfixes.add('21DG');
                    }
                } else {
                    // Lachmair
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('VH');
                    } else {
                        // VR24
                        postfixes.add('DG');
                    }
                }
            } else if (Opportunities.isFinanzierung(costNote.Claim__r.Opportunity__r.RecordTypeId)){
                // FZ
                if (Accounts.isJCLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                    // Jäger
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('JVHFZ');
                    } else {
                        // VR24
                        postfixes.add('JVRFZ');
                    }
                } else {
                    // Kainz
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        Logger.debug('bla4');
                        // VH24
                        postfixes.add('CVHFZ');
                    } else {
                        // VR24
                        postfixes.add('CVRFZ');
                    }
                }
            } else {
                // LV
                if (Accounts.isJCLegalLv(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                    // Jäger
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('JVHLV');
                    } else {
                        // VR24
                        postfixes.add('JVRLV');
                    }
                } else {
                    // 21Legal
                    if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                        // VH24
                        postfixes.add('21VHLV');
                    } else {
                        // VR24
                        postfixes.add('21VRLV');
                    }
                }
            }
        }

        Map<String,Cancellation__c> lastCancellations = new Map<String,Cancellation__c>();
        for (String postfix : postfixes){
            if (lastCancellations.get(postfix) == null){
                List<Cancellation__c> queriedCancellations = Database.query('SELECT Id,Number__c FROM Cancellation__c where Cost_Note__r.Test__c = false AND CreatedDate = THIS_YEAR AND Number__c LIKE \'%/' + postfix + '\' ORDER BY Number__c DESC NULLS LAST LIMIT 1');
                if (queriedCancellations.size() > 0){
                    lastCancellations.put(postfix,queriedCancellations[0]);
                }
            }
        }

        Map<String,Integer> lastCancellationCount = new Map<String,Integer>();
        Map<String,Integer> thisCancellationCount = new Map<String,Integer>();
        for (String postfix : postfixes){
            Integer count = 0;
            if (lastCancellations.get(postfix) != null){
                count = Integer.valueOf(lastCancellations.get(postfix).Number__c.substring(5,11));
            }
            lastCancellationCount.put(postfix,count);
            thisCancellationCount.put(postfix,1);
        }

        for (Cancellation__c cancellation : cancellations){
            if ((cancellation.Number__c == null) && (cancellation.Date__c != null) && ((isInsert == true) || (cancellation.Date__c != oldCancellations.get(cancellation.Id).Date__c))){
                Cost_Note__c costNote = costNotes.get(cancellation.Cost_Note__c);

                String postfix;
                if (Opportunities.isDieselSkandal(costNote.Claim__r.Opportunity__r.RecordTypeId)){
                    // DG
                    if (Accounts.isJCLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                        // Jäger
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'JVH';
                        } else {
                            // VR24
                            postfix = 'JDG';
                        }
                    } else if (Accounts.isCLLBLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                        // Kainz
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'CVH';
                        } else {
                            // VR24
                            postfix = 'CVR';
                        }
                    } else if (Accounts.isLegal21(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                        // 21Legal
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = '21VH';
                        } else {
                            // VR24
                            postfix = '21DG';
                        }
                    } else {
                        // Lachmair
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'VH';
                        } else {
                            // VR24
                            postfix = 'DG';
                        }
                    }
                } else if (Opportunities.isFinanzierung(costNote.Claim__r.Opportunity__r.RecordTypeId)){
                    // FZ
                    if (Accounts.isJCLegal(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                        // Jäger
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'JVHFZ';
                        } else {
                            // VR24
                            postfix = 'JVRFZ';
                        }
                    } else {
                        // Kainz
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'CVHFZ';
                        } else {
                            // VR24
                            postfix = 'CVRFZ';
                        }
                    }
                } else {
                    // LV
                    if (Accounts.isJCLegalLv(costNote.Claim__r.Opportunity__r.Legal_Account__c)){
                        // Jäger
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = 'JVHLV';
                        } else {
                            // VR24
                            postfix = 'JVRLV';
                        }
                    } else {
                        // 21Legal
                        if (Accounts.isVH24(costNote.Claim__r.Opportunity__r.Account_Id__c)){
                            // VH24
                            postfix = '21VHLV';
                        } else {
                            // VR24
                            postfix = '21VRLV';
                        }
                    }
                }

                Integer count = lastCancellationCount.get(postfix) + thisCancellationCount.get(postfix);
                String year = String.valueOf(System.now().date().year());

                if (costNote.Test__c == true){
                    cancellation.Number__c = year + '1' + count.format().replace('.','').leftPad(6,'0') + '/Test';
                } else {
                    cancellation.Number__c = year + '1' + count.format().replace('.','').leftPad(6,'0') + '/' + postfix;
                    thisCancellationCount.put(postfix,thisCancellationCount.get(postfix) + 1);
                }
            }
        }
    }
}