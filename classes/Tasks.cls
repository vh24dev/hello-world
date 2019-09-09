public class Tasks {
    public class InvalidInputException extends Exception {}
    private static Map<string, id> rtIds;
    
    static {
        rtIds = new Map<string, id>();
    	List<RecordType> rts = [
            SELECT Id, Name
            FROM RecordType
            WHERE SObjectType = 'Task'
        ];
        
        for(RecordType rt : rts) {
            rtIds.put(rt.Name, rt.Id);
        }
    }
    
    public static Id emailId() {
        return rtIds.get('Email');
    }
    
    // Builds a task considering the given parameters.
    // Returns null if noDuplicate is true and there's already a task
    // with the same subject related to parentObj.
    // Owner must be an active user.
    public static Task build(String subject,
                             String description,
                             sObject parentObj,
                             User owner,
                             Date activityDate,
                             Boolean noDuplicates,
                             Boolean isFollowUpTask) {
    	return build(subject,
                     description,
                     parentObj,
                     owner,
                     activityDate,
                     noDuplicates,
                     isFollowUpTask,
                     null);
	}
    
    public static Task build(String subject,
                             String description,
                             sObject parentObj,
                             User owner,
                             Date activityDate,
                             Boolean noDuplicates,
                             Boolean isFollowUpTask,
                             ID relatedOpp){
		Logger.debug('>> Tasks :: build :: subject: ' + subject);

		// todo: do not force consumers to query IsActive.
		// Querying it here might result in hitting 101 limit, though.
        if (owner == null || !owner.isActive) {
            throw new InvalidInputException('Task Owner is mandatory and must be an active user: ' + owner);
        }
        
        if (parentObj == null) {
            throw new InvalidInputException('Parent Object is mandatory');
        }
        
        if (String.isBlank(subject)) {
            throw new InvalidInputException('Subject is mandatory');
        }
        
        if (noDuplicates) {
            Integer duplicates = [
                SELECT Count()
                FROM Task
                WHERE Subject = :subject AND (WhatId = :parentObj.ID OR WhoId = :parentObj.ID)
            ];
            if (duplicates > 0) {
                System.debug('Tasks :: there\'s already a Task with subject: ' + subject + ' related to: ' + parentObj.ID);
                return null;
            }
        }
        
        Task t = new Task(
            OwnerId = owner.ID,
            Subject = subject,
            ActivityDate = activityDate,
            Status = 'Open',
            Priority = 'Normal',
            Type = 'Task',
            Description = description,
            Follow_Up_Task__c = isFollowUpTask
        );
		// Use WhoID or WhatID to link the task to the parent object
		// depending on the type of that object.
        if (parentObj.getSObjectType() == Schema.SObjectType.Lead.getSObjectType()
             || parentObj.getSObjectType() == Schema.SObjectType.Contact.getSObjectType()) {
            t.whoID =  parentObj.ID;
        } else {
        	t.whatID =  parentObj.ID;
        }
        
		if (relatedOpp != null) {
			t.related_Opportunity__c = relatedOpp;
		}

        return t;
    }
    
    public static Task[] markAsClosed(String subj, sObject parentObj){
        Task[] toClose = new Task[]{};
        for (Task t: parentObj.getSObjects('Tasks')) {
            System.debug('closing: ' + t);
            if (t.subject.contains(subj) && t.status != 'Completed') {
                System.debug('closing2: ' + t);
                t.status = 'Completed';
                toClose.add(t);
            }
        }
        return toClose;
    }
}