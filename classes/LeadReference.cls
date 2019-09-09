public class LeadReference {
    private static final String vh24Tag = 'VH';
    private static final String vr24Tag = 'VR';
    private static final String dkRecordTypeTag = 'D';
    private static final String fzRecordTypeTag = 'F';
    private static final String lvRecordTypeTag = 'L';
    private static final Integer tagNumberChars = 6;
    Map<String, Integer> countByTag = new Map<String, Integer>{};
    public void setOn(Lead[] ll, Boolean isBeforeUpdate) {
        Logger.debug('>> LeadReference :: setOn :: ll: ' + ll + ' isBeforeUpdate: ' + isBeforeUpdate);

        buildLastCountMap();
        for (Lead l: ll) {
            if (!String.isBlank(l.reference__c)) {
                continue;
            }
            
            String ref = computeReference(l);
            l.reference__c = ref;
        }

        Logger.debug('<< LeadReference :: setOn');
    }
    
    private String computeReference(Lead l) {
        String tag = tag(l);
        if (String.isBlank(tag)) {
            Logger.error('LeadReference :: computeReference :: unable to get tag for lead: ' + l);
            return null;
        }
        
        Integer c = countByTag.get(tag);
        if (c == null) {
            Logger.error('LeadReference :: computeReference :: unable to get count for tag: ' + tag + ' lead: ' + l);
            return null;
        }

        String cStr = String.valueOf(c+1);
        String refStr = cStr.leftPad(tagNumberChars, '0');
        Logger.debug('LeadReference :: computeReference: ' + cStr + ' with padding: ' + refStr);
        
        String currYear = String.valueOf(System.now().date().year()).right(2);
        return tag + currYear + '-' + refStr;
    }

    private String tag(Lead l) {
        // Compute tag for lead, based on Record Type and Account__c (VH24 or VR24)
        String tag;
        // Calling with no "fetch" because we're in a beforeUpdate.
        if (Leads.isVH24(l, false)) {
            tag = vh24Tag;
        } else if (Leads.isVR24(l, false)) {
            tag = vr24Tag;
        } else {
            Logger.error('LeadReference :: tag :: unable to compute tag company for lead: ' + l);
            return 'Unknown';
        }

        if (Leads.isDieselSkandal(l.recordTypeID)) {
            tag += dkRecordTypeTag;
        } else if (Leads.isFinanzierung(l.recordTypeID)) {
            tag += fzRecordTypeTag;
        } else if (Leads.isLebensversicherung(l.recordTypeID)) {
            tag += lvRecordTypeTag;
        } else {
            Logger.error('LeadReference :: tag :: unable to compute tag record type for lead: ' + l);
            return 'Unknown';
        }
        return tag;
    }

    private void buildLastCountMap() {
        // Check current count value for each tag.
        // We either grab all the leads (1 query) and process them (string manipulation);
        // or we perform 6 different queries, one per possible tag, and order by Reference,
        // getting only the last count value.
        // Went with the latter, since we might have a considerable amount of leads.
        putLastCountForTag(vh24Tag + dkRecordTypeTag);
        putLastCountForTag(vr24Tag + dkRecordTypeTag);
        putLastCountForTag(vh24Tag + fzRecordTypeTag);
        putLastCountForTag(vr24Tag + fzRecordTypeTag);
        putLastCountForTag(vh24Tag + lvRecordTypeTag);
        putLastCountForTag(vr24Tag + lvRecordTypeTag);
    }
    
    private void putLastCountForTag(String tag) {
        Lead[] ll = [
            SELECT Reference__c
            FROM Lead
            WHERE Test__c = false
                AND CreatedDate = THIS_YEAR
                AND Reference__c LIKE :tag + '%'
            ORDER BY Reference__c DESC LIMIT 1
        ];
        if (ll == null || ll.isEmpty()) {
            countByTag.put(tag, 0);
            return;
        }
        
        Lead l = ll[0];
        Integer lc = lastCount(l.reference__c);
        countByTag.put(tag, lc);
    }

    private Integer lastCount(String reference) {
        String lastCountStr = reference.substringAfterLast('-');
        if (String.isBlank(lastCountStr)) {
            return 0;
        }
        
        try {
            return Integer.valueOf(lastCountStr);
        } catch (TypeException te) {
            Logger.error('LeadReference :: lastCount :: expecting count to be an integer. Exception: ' + te.getMessage());
            return 0;
        }
    }
}