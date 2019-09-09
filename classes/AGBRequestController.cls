// Lead "AGB anfordern" Button
// AGBRequestController is the controller of AGBRequest lightning component.
public class AGBRequestController {
    private static String subjCustReached = 'AGB/Kunde erreicht #';
    private static String subjCustNotReached = 'AGB/Kunde nicht erreicht #';

    public class InvalidInputException extends Exception {}
    public class AGBRequestResult {
        @AuraEnabled
        public String openURL;
        @AuraEnabled
        public String errorMsg;
    }

    @AuraEnabled
    public static AGBRequestResult init(String leadID) {
        Logger.debug('>> AGBRequestController :: init :: leadID: ' + leadID);

        Lead lead = [
            SELECT  ID, Start_Auto_Follow_up__c
            FROM Lead
            WHERE ID = :leadID
        ];

        AGBRequestResult r = new AGBRequestResult();
        if (lead.start_Auto_Follow_up__c) {
            // Exit with warning if the auto follow-up journey already started,
            // nothing to be done.
            Logger.error('AGBRequestController :: init :: exit :: auto follow-up marketing cloud journey already started for lead: ' + lead);        
            r.errorMsg = 'Follow-up wurde bereits gestartet.';
        }
        
        Logger.debug('<< AGBRequestController :: init');
        return r;
    }

    // agbRequest TBD
    // Returns an instance of AGBRequestResult where openURL contains the url to be redirected to, if any.
    @AuraEnabled
    public static AGBRequestResult agbRequest(String leadID, Boolean customerReached, String notes) {
        Logger.debug('>> AGBRequestController :: agbRequest :: leadID: ' + leadID + ' reached: ' + customerReached + ' notes: ' + notes);

        if (String.isBlank(leadID)) {
            throw new InvalidInputException('LeadID field is mandatory.');
        }

        if (customerReached == null ) {
            throw new InvalidInputException('customerReached field is mandatory.');
        }
        
        // Set fields like FollowUp and FollowUpCount.        
        Lead lead = updatedLead(leadID, customerReached, notes);

        if (lead.callcenter__r.ID == null) {
            AGBRequestResult r = new AGBRequestResult();
            r.errorMsg = 'Bitte einen Callcenter Mitarbeiter eintragen.';
            return r;
        }
        
        // Start a marketing cloud journey
        // if customer was not reached and followUp count is now 3.
        if (lead.start_Auto_Follow_up__c) {
            // todo: start a marketing cloud journey
            Logger.debug('AGBRequestController :: agbRequest :: TODO: start the marketing cloud journey for lead: ' + lead);
        }

        updateTasks(lead, !lead.start_Auto_Follow_up__c);
        
        AGBRequestResult r = new AGBRequestResult();
        if (!lead.start_Auto_Follow_up__c) {
            r.openURL = url(lead); // url for sending email   
        }

        Logger.debug('<< AGBRequestController :: agbRequest :: lead: ' + lead + ' res: ' + r);
        return r;
    }

    private static String url(Lead l) {
        String tpl = tpl(l);
        return page.sendMail.getUrl() +
            '?id=' + l.Id +
            '&tpl=' + tpl +
            '&recipient=' + l.Id +
            '&noprtatt=true' + // what is this parentAttachment? Some logic in EmailUtilities..
            '&hdl="Link zu Formularstufe 2 versenden."' +
            '&islead=true' +
            '&closeTab=true' +
            '&showAuthorizationsList=true';        
    }

    private static String tpl(Lead l) {
        String tpl = '';
        if (Leads.isDieselSkandal(l.recordTypeId)) {
            // Diesel
            tpl = Leads.isVH24(l)
                ? EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVh24)
                : EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVr24);
        } else if (Leads.isLebensversicherung(l.recordTypeId)) {
            // LV
            tpl = Leads.isVH24(l)
                ? EmailTemplates.idOf(EmailTemplates.General.LvGeneralWebformStep2MessageVh24)
                : EmailTemplates.idOf(EmailTemplates.General.LvGeneralWebformStep2MessageVr24);
        } else {
            // FZ
            tpl = Leads.isVH24(l)
                ? EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVh24)
                : EmailTemplates.idOf(EmailTemplates.Name.FzCallcenterFormstep2LinkVr24);
        }

        System.debug('tpl: ' + tpl + ' l: ' + l);
        return tpl;
    }
    
    private static Lead updatedLead(String leadID, Boolean customerReached, String notes) {
        Lead lead = [
            SELECT  ID,
                RecordTypeID,
                Follow_up_Count__c, Follow_up_Period__c,
                Customer_reached__c,
                Customer_interaction_notes__c,
                Callcenter__r.ID, Callcenter__r.IsActive,
                Company, Email,
                Start_Auto_Follow_up__c
            FROM Lead
            WHERE ID = :leadID
        ];
        lead.Last_follow_up_task__c = System.today();
        lead.customer_Reached__c = customerReached;
        lead.customer_interaction_notes__c = notes;
        // Assuming that FollowUp count shall be set to 1 on the first time the button is clicked.
        lead.follow_up_Count__c = lead.follow_up_Count__c == null ? 1 : (lead.follow_up_Count__c + 1);
        lead.follow_up_Period__c = 4; // used to be dependent on follow_up_Count__c

        // Start the auto journey if customer not reached and
        // we have two previous "customer not reached" tasks.
        String subj = '%' + subjCustNotReached + '%';
        Integer nrOfNotReachedTasks = [
            SELECT Count()
            FROM Task
            WHERE WhoID = :lead.ID AND Subject like :subj
        ];
        if (!customerReached && nrOfNotReachedTasks == 2) {
            lead.start_Auto_Follow_up__c = true;
        }

        update lead;

        return lead;
    }
    
    private static void updateTasks(Lead l, Boolean createNew) {
        // Close the most recent task related to the Lead, if any.
        Task[] prevTs = [
            SELECT ID, Subject, WhoID
            FROM Task
            WHERE WhoID = :l.ID AND Status != 'Completed'
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        for (Task pt: prevTs) {
            pt.status = 'Completed';
            Logger.debug('AGBRequestController :: AGBRequestResult :: completing task: ' + pt);
        }
        update prevTs;
        
        if (!createNew) {
            return;
        }

        // Create task "AGB/Kunde erreicht #X" or "AGB/Kunde nicht erreicht #X",
        // depending if customer has been reached or not.
        // X is a different counter for each of the task types.
        String subject = l.customer_Reached__c ? subjCustReached : subjCustNotReached;
        String subjectQuery = '%' + subject + '%';
        Task[] lastTaskForType = [
            SELECT ID, Subject
            FROM Task
            WHERE WhoID = :l.ID AND Subject like :subjectQuery
        ];

        Task t = Tasks.build(
            subject + (lastTaskForType.size() + 1),
            l.customer_interaction_notes__c,
            l,
            l.callcenter__r,
            l.follow_up_Period__c > 0 ? Date.today() + Integer.valueOf(l.follow_Up_Period__c) : Date.today(),
            true,
            l.follow_up_Count__c > 0
        );
        Logger.debug('AGBRequestController :: AGBRequestResult :: creating task: ' + t);
        insert t;
    }
}