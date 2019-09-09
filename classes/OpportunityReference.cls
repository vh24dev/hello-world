// todo: there's also a LeadReference class; we could extract common functionality to another class
public class OpportunityReference {
    private static final String vh24Tag = 'VH';
    private static final String vr24Tag = 'VR';
    private static final String dkRecordTypeTag = 'D';
    private static final String fzRecordTypeTag = 'F';
    private static final String lvRecordTypeTag = 'L';
    private static final Integer tagNumberChars = 6;
    Map<String, Integer> countByTag = new Map<String, Integer>{};

    public void setOn(Opportunity[] oo, Boolean isBeforeUpdate, Boolean overrideExisting) {
        Logger.debug('>> OpportunityReference :: setOn :: oo: ' + oo + ' isBeforeUpdate: ' + isBeforeUpdate + ' overrideExisting: ' + overrideExisting);

        buildLastCountMap();
        for (Opportunity o: oo) {
            if (!overrideExisting && !String.isBlank(o.reference__c)) {
                continue;
            }

            String ref = computeReference(o);
            o.reference__c = ref;
            o.tag__c = tag(o);
        }

        Logger.debug('<< OpportunityReference :: setOn');
    }

    private String computeReference(Opportunity o) {
        String tag = tag(o);
        if (String.isBlank(tag)) {
            Logger.error('OpportunityReference :: computeReference :: unable to get tag for opp: ' + o);
            return null;
        }

        Integer c = countByTag.get(tag);
        if (c == null) {
            Logger.error('OpportunityReference :: computeReference :: unable to get count for tag: ' + tag + ' opp: ' + o);
            return null;
        }

        String cStr = String.valueOf(c+1);
        String refStr = cStr.leftPad(tagNumberChars, '0');
        Logger.debug('OpportunityReference :: computeReference: ' + cStr + ' with padding: ' + refStr);

        String currYear = String.valueOf(System.now().date().year()).right(2);
        return tag + currYear + '-' + refStr;
    }

    private String tag(Opportunity o) {
        // Compute tag for opp, based on Record Type and Account__c (VH24 or VR24)
        String tag;
        // Calling with no "fetch" because we're in a beforeUpdate.
        if (Opportunities.isVH24(o, false)) {
            tag = vh24Tag;
        } else if (Opportunities.isVR24(o, false)) {
            tag = vr24Tag;
        } else {
            Logger.error('OpportunityReference :: tag :: unable to compute tag company for opp: ' + o);
            return 'Unknown';
        }

        if (Opportunities.isDieselSkandal(o.recordTypeID)) {
            tag += dkRecordTypeTag;
        } else if (Opportunities.isFinanzierung(o.recordTypeID)) {
            tag += fzRecordTypeTag;
        } else if (Opportunities.isLebensversicherung(o.recordTypeID)) {
            tag += lvRecordTypeTag;
        } else {
            Logger.error('OpportunityReference :: tag :: unable to compute tag record type for opp: ' + o);
            return 'Unknown';
        }
        return tag;
    }

    private void buildLastCountMap() {
        putLastCountForTag(vh24Tag + dkRecordTypeTag);
        putLastCountForTag(vr24Tag + dkRecordTypeTag);
        putLastCountForTag(vh24Tag + fzRecordTypeTag);
        putLastCountForTag(vr24Tag + fzRecordTypeTag);
        putLastCountForTag(vh24Tag + lvRecordTypeTag);
        putLastCountForTag(vr24Tag + lvRecordTypeTag);
    }

    private void putLastCountForTag(String tag) {
        Logger.debug('>> OpportunityReference :: putLastCountForTag: ' + tag);

        Opportunity[] oldoo = [
            SELECT Reference__c
            FROM Opportunity
            WHERE Test__c = false
            AND (created_date_old_org__c = THIS_YEAR OR CreatedDate = THIS_YEAR)
            AND tag__c = :tag
            ORDER BY Reference__c DESC
            LIMIT 1
        ];

        List<string> refs = new List<string>();

        if (oldoo == null || oldoo.isEmpty()) {
            countByTag.put(tag, 0);
            return;
        }

        Opportunity o = oldoo[0];
        Logger.debug('Got opp: ' + o);
        Integer lc = lastCount(o.reference__c);
        countByTag.put(tag, lc);
        Logger.debug('Did put: ' + tag + ' ' + lc);

        /*for(Opportunity o : oldoo) { 
            if (o.Reference__c.startsWith(tag)) {
                refs.add(o.Reference__c);
            }
        }

        refs.sort(); // asc

        if (refs == null || refs.isEmpty()) {
            countByTag.put(tag, 0);
            return;
        }

        Integer oc = lastCount(refs[refs.size()-1]); // grab last
        countByTag.put(tag, oc);
		*/
    }

    private Integer lastCount(String reference) {
        Logger.debug('>> OpportunityReference :: lastCount: ' + reference);

        if (String.isBlank(reference)) {
            Logger.debug('OpportunityReference :: reference is empty');
			return 0;            
        }

        String lastCountStr = reference.substringAfterLast('-');
        if (String.isBlank(lastCountStr)) {
            return 0;
        }

        try {
            return Integer.valueOf(lastCountStr);
        } catch (TypeException te) {
            Logger.error('OpportunityReference :: lastCount :: expecting count to be an integer. Exception: ' + te.getMessage());
            return 0;
        }
    }
}