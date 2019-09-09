@isTest
public class AGBRequestControllerTests {
    @isTest
    private static void testInvalidInput() {
        try {
            AGBRequestController.agbRequest(null, null, null);
            System.assert(false);
        } catch (AGBRequestController.InvalidInputException e) {
            System.assert(true);
        }
    }

    @isTest
    private static void testCustomerReached() {
        TriggerConfiguration.allInactive = true;
        // Arrange
        User u = user();
        u.bypass_process_builder__c = true;
        insert u;

        System.runAs(u) {
            testCustomerReachedAsUser(u);
        }
    }

    private static void testCustomerReachedAsUser(User u) {
        Account vh24 = TestData.createVH24Account();
        insert vh24;

        Lead l = TestData.createLead(vh24.ID, 'Dieselskandal', 'Test');
        l.callcenter__c = u.ID;
        insert l;

        // Act
        AGBRequestController.AGBRequestResult res = AGBRequestController.agbRequest(l.ID, true, 'Notes here');    
        System.debug('res: ' + res);

        // Assert
        Lead updatedL = [
            SELECT ID,
                   Follow_up_Count__c, Follow_up_Period__c,
                   Customer_reached__c,
                   Customer_interaction_notes__c,
                   Email
            FROM Lead
        ];
        System.assertEquals(1, updatedL.follow_up_Count__c);
        System.assertEquals(4, updatedL.follow_up_Period__c);
        System.assertEquals(true, updatedL.customer_Reached__c);
        System.assertEquals('Notes here', updatedL.customer_interaction_notes__c);

        Task[] ts = [
            SELECT ID,
                   Subject,
                   Description,
                   Follow_Up_Task__c,
                   ActivityDate,
                   Status
            FROM Task
            WHERE WhoID = :updatedL.ID
        ];
        System.assertEquals(1, ts.size());
        Task t = ts[0];
        System.assertEquals('AGB/Kunde erreicht #1', t.subject);
        System.assertEquals('Notes here', t.description);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertEquals(Date.today() + Integer.valueOf(updatedL.follow_Up_Period__c), t.activityDate);
        System.assertNotEquals('Completed', t.status);

        System.assertNotEquals(null, res);
        String expectedURL = page.sendMail.getUrl() +
            '?id=' + updatedL.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVh24) +
            '&recipient=' + updatedL.Id +
            '&noprtatt=true' + // what is this parentAttachment? Some logic in EmailUtilities
            '&hdl="Link zu Formularstufe 2 versenden."' +
            '&islead=true' +
            '&closeTab=true' +
            '&showAuthorizationsList=true';

        System.assertEquals(expectedURL, res.openURL);

        // Test values when reaching the customer a second time.
        // The previous task should be completed.
        res = AGBRequestController.agbRequest(updatedL.ID, true, 'Notes here');

        updatedL = [
            SELECT ID,
                   Follow_up_Count__c, Follow_up_Period__c,
                   Customer_reached__c,
                   Customer_interaction_notes__c,
                   Email
            FROM Lead
        ];
        System.assertEquals(2, updatedL.follow_up_Count__c);
        System.assertEquals(4, updatedL.follow_up_Period__c);
        System.assertEquals(true, updatedL.customer_Reached__c);
        System.assertEquals('Notes here', updatedL.customer_interaction_notes__c);

        ts = [
            SELECT ID,
                   Subject,
                   Description,
                   Follow_Up_Task__c,
                   ActivityDate,
                   Status
            FROM Task
            WHERE WhoID = :updatedL.ID
            ORDER BY CreatedDate ASC
        ];
        System.assertEquals(2, ts.size());
        t = openTask(ts);
        System.assertNotEquals(ts[0].status, ts[1].status);
        System.assertEquals('AGB/Kunde erreicht #2', t.subject);
        System.assertEquals('Notes here', t.description);
        System.assertEquals(Date.today() + Integer.valueOf(updatedL.follow_Up_Period__c), t.activityDate);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertNotEquals('Completed', t.status);

        System.assert(res.openURL.endsWithIgnoreCase(expectedURL));

        // Test values when reaching the customer a third time,
        // FollowUp Period should be 5 (when FollowUp count is higher than 2).
        res = AGBRequestController.agbRequest(updatedL.ID, true, 'Notes notes');

        updatedL = [
            SELECT ID,
                   Follow_up_Count__c, Follow_up_Period__c,
                   Customer_reached__c,
                   Customer_interaction_notes__c,
                   Email,
                   Start_Auto_Follow_up__c
            FROM Lead
        ];
        System.assertEquals(3, updatedL.follow_up_Count__c);
        System.assertEquals(4, updatedL.follow_up_Period__c);
        System.assertEquals(true, updatedL.customer_Reached__c);
        System.assertEquals('Notes notes', updatedL.customer_interaction_notes__c);
        System.assertEquals(false, updatedL.start_Auto_Follow_up__c);

        ts = [
            SELECT ID,
                   Subject,
                   Description,
                   Follow_Up_Task__c,
                   ActivityDate,
                   Status
            FROM Task
            WHERE WhoID = :updatedL.ID
            ORDER BY CreatedDate ASC
        ];
        System.assertEquals(3, ts.size());
        t = openTask(ts);
        System.assertEquals('AGB/Kunde erreicht #3', t.subject);
        System.assertEquals('Notes notes', t.description);
        System.assertEquals(Date.today() + Integer.valueOf(updatedL.follow_Up_Period__c), t.activityDate);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertNotEquals('Completed', t.status);

        System.assert(res.openURL.endsWithIgnoreCase(expectedURL));
    }

    @isTest
    private static void testCustomerNotReachedStartsMarketingJourney() {
        TriggerConfiguration.allInactive = true;
        User u = user();
        u.bypass_process_builder__c = true;
        insert u;

        System.runAs(u) {
            testCustomerNotReachedStartsMarketingJourneyAs(u);
        }        
    }

    private static void testCustomerNotReachedStartsMarketingJourneyAs(User u) {
        // Arrange
        Account vh24 = TestData.createVH24Account();
        insert vh24;

        Lead l = TestData.createLead(vh24.ID, 'Dieselskandal', 'Test');
        l.callcenter__c = u.ID;
        insert l;

        // Act
        // Test that not reaching three times sets start_Auto_Follow_up__c to true,
        // even if we have a "customer reached" in between.
        AGBRequestController.agbRequest(l.ID, false, 'Notes here');
        AGBRequestController.agbRequest(l.ID, false, 'Notes there');
        AGBRequestController.agbRequest(l.ID, true, 'Notes there');
        AGBRequestController.AGBRequestResult res = AGBRequestController.agbRequest(l.ID, false, 'Notes here');

        // Assert
        Lead updatedL = [
            SELECT ID,
                   Follow_up_Count__c, Follow_up_Period__c,
                   Customer_reached__c,
                   Customer_interaction_notes__c,
                   Email,
                   Start_Auto_Follow_up__c 
            FROM Lead
        ];
        System.assertEquals(4, updatedL.follow_up_Count__c);
        System.assertEquals(4, updatedL.follow_up_Period__c);
        System.assertEquals(false, updatedL.customer_Reached__c);
        System.assertEquals('Notes here', updatedL.customer_interaction_notes__c);
        System.assertEquals(true, updatedL.start_Auto_Follow_up__c);

        Task[] ts = [
            SELECT ID,
                   Subject,
                   Description,
                   Follow_Up_Task__c,
                   ActivityDate,
                   Status
            FROM Task
            WHERE WhoID = :updatedL.ID
        ];
        System.assertEquals(3, ts.size());

        // Expecting no Open tasks, since we reached three "customer not reached" interactions,
        // previous task should be closed and the auto journey should kick in, no new task created.
        Task t = openTask(ts);
        System.assertEquals(null, t);

        // No redirection expected, since no email will be sent when the auto journey is supposed to start.
        System.assertNotEquals(null, res);
        System.assert(String.isBlank(res.openURL));
    }

    @isTest
    private static void testInitReturnsErrorWhenFollowUpJourneyAlreadyStarted() {
        // Arrange
        User u = user();
        insert u;

        Test.startTest();

        Account vh24 = TestData.createVH24Account();
        insert vh24;

        Lead l = TestData.createLead(vh24.ID, 'Dieselskandal', 'Test');
        l.callcenter__c = u.ID;
        insert l;

        // Act
        // Test that not reaching three times sets start_Auto_Follow_up__c to true,
        // even if we have a "customer reached" in between.
        AGBRequestController.agbRequest(l.ID, false, 'Notes here');
        AGBRequestController.agbRequest(l.ID, false, 'Notes there');
        AGBRequestController.agbRequest(l.ID, true, 'Notes there');
        AGBRequestController.AGBRequestResult initRes = AGBRequestController.init(l.ID);
        AGBRequestController.AGBRequestResult res = AGBRequestController.agbRequest(l.ID, false, 'Notes here');
        Test.stopTest();

        // Assert
        Lead updatedL = [SELECT ID, Start_Auto_Follow_up__c FROM Lead];
        System.assertEquals(true, updatedL.start_Auto_Follow_up__c);

        System.assertNotEquals(null, initRes);
        System.assert(String.isBlank(initRes.openURL));
        System.assert(String.isBlank(initRes.errorMsg));

        // No redirection expected, since no email will be sent when the auto journey is supposed to start.
        System.assertNotEquals(null, res);
        System.assert(String.isBlank(res.openURL));
        System.assert(String.isBlank(initRes.errorMsg));

        // Expecting any following interaction to be shown an error message,
        // mentioning that the auto follow-up journey already started.
        initRes = AGBRequestController.init(l.ID);
        System.assertNotEquals(null, initRes);
        System.assert(String.isBlank(initRes.openURL));
        System.assert(!String.isBlank(initRes.errorMsg));
    }

    @isTest
    private static void testMixedCustomerReachedNotReached() {
        TriggerConfiguration.allInactive = true;
        User u = user();
        u.bypass_process_builder__c = true;
        insert u;

        System.runAs(u) {
            testMixedCustomerReachedNotReachedAsUser(u);
        }
    }

    private static void testMixedCustomerReachedNotReachedAsUser(User u) {
        // Arrange
        Account vh24 = TestData.createVH24Account();
        insert vh24;

        Lead l = TestData.createLead(vh24.ID, 'Dieselskandal', 'Test');
        l.callcenter__c = u.ID;
        insert l;

        // Act
        // Test that interleaving reaching and not reaching the customer will create tasks with independent numeration.
        AGBRequestController.agbRequest(l.ID, false, 'Notes here');
        AGBRequestController.agbRequest(l.ID, true, 'Notes there');
        AGBRequestController.AGBRequestResult res = AGBRequestController.agbRequest(l.ID, false, 'Notes here');

        // Assert
        Lead updatedL = [
            SELECT ID,
                   Follow_up_Count__c, Follow_up_Period__c,
                   Customer_reached__c,
                   Customer_interaction_notes__c,
                   Email,
                   Start_Auto_Follow_up__c 
            FROM Lead
        ];
        // Lead contains values from the last interaction
        System.assertEquals(3, updatedL.follow_up_Count__c);
        System.assertEquals(4, updatedL.follow_up_Period__c);
        System.assertEquals(false, updatedL.customer_Reached__c);
        System.assertEquals('Notes here', updatedL.customer_interaction_notes__c);
        System.assertEquals(false, updatedL.start_Auto_Follow_up__c);

        Task[] ts = [
            SELECT ID,
                   Subject,
                   Description,
                   Follow_Up_Task__c,
                   ActivityDate,
                   Status
            FROM Task
            WHERE WhoID = :updatedL.ID
        ];
        System.assertEquals(3, ts.size());
        Task t = openTask(ts);
        System.assertEquals('AGB/Kunde nicht erreicht #2', t.subject);

        // Last task created
        System.assertEquals('Notes here', t.description);
        System.assertEquals(Date.today() + Integer.valueOf(updatedL.follow_Up_Period__c), t.activityDate);
        System.assertEquals(true, t.follow_Up_Task__c);
        System.assertEquals('Open', t.status);

        System.assertNotEquals(null, res);

        String expectedURL = page.sendMail.getUrl() +
            '?id=' + updatedL.Id +
            '&tpl=' + EmailTemplates.idOf(EmailTemplates.Name.DieselskandalCallcenterFormstep2LinkVh24) +
            '&recipient=' + updatedL.Id +
            '&noprtatt=true' + // what is this parentAttachment? Some logic in EmailUtilities
            '&hdl="Link zu Formularstufe 2 versenden."' +
            '&islead=true' +
            '&closeTab=true' +
            '&showAuthorizationsList=true';

        System.assertEquals(expectedURL, res.openURL);
    }

    private static Task openTask(Task[] ts) {
        // Not pretty but serves the purpose.
        Boolean foundOpenAlready = false;
        Task t;
        for (Task tt: ts) {
            System.assert(tt.status == 'Completed' || tt.status == 'Open');
            if (tt.status == 'Open') {
                if (foundOpenAlready) { System.assert(false, 'Expecting only one Open Task');}
                t = tt;
                foundOpenAlready = true;
            }
        }
        return t;
    }

    private static User user() {
        Profile testProfile = [
            SELECT ID 
            FROM Profile
            WHERE Name = 'System Administrator' 
            LIMIT 1
        ];
        return new User(
            LastName = 'Test u1', 
            Username = 'testu1@test.com', 
            Email = 'testu1@test.com', 
            Alias = 'u1', 
            TimeZoneSidKey = 'GMT', 
            LocaleSidKey = 'en_GB', 
            EmailEncodingKey = 'ISO-8859-1', 
            ProfileId = testProfile.Id, 
            LanguageLocaleKey = 'en_US',
            IsActive = true
        );
    }
}