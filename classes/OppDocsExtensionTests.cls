@isTest
public class OppDocsExtensionTests {
    /*
    private static void testErrorCases(Boolean docsComplete) {
        // Arrange
        PageReference p = docsComplete ? Page.OppDocsComplete : Page.OppDocsIncomplete;
        Test.setCurrentPage(p);
        
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        insert new Account[]{vh24, vr24, a};

        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        // o.Account__c = vh24.Id;
        insert o;

		// o = [SELECT Id, account_Id__c FROM Opportunity WHERE Id = :o.Id];
        // System.assertNotEquals(null, o.account_Id__c);

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);
        
        // Act
        PageReference pr = docsComplete ? oe.complete() : oe.incomplete();

        // Assert that no field is set when not LV record type
        o = [
            SELECT  StageName,
            		Dokumente_vollst_ndig__c,
                    Dokumente_unvollst_ndig__c,
            		Has_Legal_Protection_Insurance__c,
            		Assignment_Type__c,
            		Engine_Type__c
            		
            FROM Opportunity
        ];
        System.assertEquals('On Hold', o.stageName);
        System.assertEquals(false, o.dokumente_vollst_ndig__c);
        System.assertEquals(false, o.dokumente_unvollst_ndig__c);
        System.assert(pr.getUrl().containsIgnoreCase(Page.Error.getUrl()));

        rt = [SELECT ID FROM RecordType WHERE Name='DieselSkandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.assignment_Type__c = null;
        o.legal__c = null;
        update o;
        oe = new OppDocsExtension(sc);
        pr = docsComplete ? oe.complete() : oe.incomplete();

    	// Assert that it fails when no assignment_Type__c or legal__c
        String noParamsErrUrl1 = pr.getUrl();
        System.debug('noParamsErrUrl1 ' + noParamsErrUrl1);
        System.assert(noParamsErrUrl1.containsIgnoreCase(Page.Error.getUrl()));
        //--
        o.assignment_Type__c = 'Share';
        o.has_Legal_Protection_Insurance__c = false;

        UserRole ur = [SELECT ID FROM UserRole WHERE Name = 'Management'];
        User u = [SELECT ID FROM User WHERE UserRole.Name = 'Management' LIMIT 1];
        u.userRoleId = ur.ID;
        o.legal__c = u.ID;

        o.engine_Type__c = 'EA189';
        update o;

        oe = new OppDocsExtension(sc);
        pr = docsComplete ? oe.complete() : oe.incomplete();
        
        // Assert that it fails with a different error msg if there's assignment_Type__c and legal__c,
        // but engine_Type__c is 'EA189', Opp record type is 'Dieselskandal', and assignment_Type__c is not 'RSV'.
        String noParamsErrUrl2 = pr.getUrl();
        System.debug('noParamsErrUrl2 ' + noParamsErrUrl2);
        System.assert(noParamsErrUrl2.containsIgnoreCase(Page.Error.getUrl()));
        System.assertNotEquals(noParamsErrUrl1, noParamsErrUrl2);
        
        //--
        o.Backoffice__c = u.Id;
        o.assignment_Type__c = 'RSV';
        o.has_Legal_Protection_Insurance__c = false;
        o.StageName = 'Lost';
        o.Reason_For_Loss__c = 'Aussortiert';
        update o;
        
        oe = new OppDocsExtension(sc);
        pr = docsComplete ? oe.complete() : oe.incomplete();
        
        // Assert that it fails with a different error msg if there's if has_Legal_Protection_Insurance__c is false.
        String noParamsErrUrl3 = pr.getUrl();
        System.assert(noParamsErrUrl3.containsIgnoreCase(Page.Error.getUrl()));
        System.assertNotEquals(noParamsErrUrl1, noParamsErrUrl3);
        System.assertNotEquals(noParamsErrUrl2, noParamsErrUrl3);
        
        //--
        o.has_Legal_Protection_Insurance__c = true;
        update o;
        
        oe = new OppDocsExtension(sc);
        pr = docsComplete ? oe.complete() : oe.incomplete();

        // Assert that it fails with a different error msg if Backoffice__c is not filled.
        String noParamsErrUrl4 = pr.getUrl();
        System.assert(noParamsErrUrl4.containsIgnoreCase(Page.Error.getUrl()));
        System.assertNotEquals(noParamsErrUrl1, noParamsErrUrl4);
        System.assertNotEquals(noParamsErrUrl2, noParamsErrUrl4);
        System.assertNotEquals(noParamsErrUrl3, noParamsErrUrl4);

        //--
        o.backoffice__c = u.ID;
        update o;
        
        oe = new OppDocsExtension(sc);
        pr = docsComplete ? oe.complete() : oe.incomplete();

        // Assert that it fails with a different error msg if the opp is not linked to a vh24 or vr24 account
        System.assert(pr.getUrl().containsIgnoreCase(Page.Error.getUrl()));
        System.assertNotEquals(noParamsErrUrl1, pr.getUrl());
        System.assertNotEquals(noParamsErrUrl2, pr.getUrl());
        System.assertNotEquals(noParamsErrUrl3, pr.getUrl());
        System.assertNotEquals(noParamsErrUrl4, pr.getUrl());
    }

    @isTest
    private static void testErrorCasesForComplete() {
        TriggerConfiguration.allInactive = true;
        testErrorCases(true);
    }

    @isTest
    private static void testErrorCasesForIncomplete() {
        TriggerConfiguration.allInactive = true;
        testErrorCases(false);
    }
	*/

    @isTest
    private static void testErrorClaimAlready() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};

		Opportunity o = buildOpp(a.ID, vr24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Claim';
        o.assignment_Type__c = 'RSV';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);

        // Act
        PageReference pr = oe.incomplete();

        System.assertEquals(Errors.page('Die Anfrage befindet sich bereits im Fall Status. Es muss keine Aktion ausgeführt werden.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorNoContact() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};

		Opportunity o = buildOpp(a.ID, vr24.ID);
        o.Contact__c = null;
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.assignment_Type__c = 'RSV';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);

        // Act
        PageReference pr = oe.complete();

        System.assertEquals(Errors.page('Bitte hinterlegen Sie einen Kontakt auf dem Feld "Kunde" der Anfrage.').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testErrorNotEnoughDocs() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};

		Opportunity o = buildOpp(a.ID, vr24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.assignment_Type__c = 'RSV';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);

        // Act
        PageReference pr = oe.complete();

        System.assertEquals(Errors.page('Zu dieser Anfrage wurden noch keine Dokumente hochgeladen!').getUrl(), pr.getUrl());
    }

    @isTest
    private static void testDocsCompleteVR() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};

		Opportunity o = buildOpp(a.ID, vr24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.assignment_Type__c = 'RSV';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);

        // Act
        PageReference pr = oe.complete();

        o = [
            SELECT  ID,
            StageName,
            Dokumente_vollst_ndig__c,
            Dokumente_unvollst_ndig__c
            FROM Opportunity
        ];

        // Assert that when Account is VH24 or VR24 we don't return an error,
        // and opp fields are set.
        System.assertEquals('Claim', o.stageName);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVr24)));
        System.assertEquals(true, o.dokumente_vollst_ndig__c);
        System.assertEquals(false, o.dokumente_unvollst_ndig__c);
    }

    @isTest
    private static void testDocsCompleteVH() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);

        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};

		Opportunity o = buildOpp(a.ID, vh24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.assignment_Type__c = 'RSV';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;

        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);

        // Act
        PageReference pr = oe.complete();

        o = [
            SELECT  ID,
            StageName,
            Dokumente_vollst_ndig__c,
            Dokumente_unvollst_ndig__c
            FROM Opportunity
        ];

        // Assert that when Account is VH24 or VR24 we don't return an error,
        // and opp fields are set.
        System.assertEquals('Claim', o.stageName);
        System.assertEquals(true, pr.getUrl().contains(EmailTemplates.idOf(EmailTemplates.DocumentsComplete.LVCallcenterDocumentsCompleteVh24)));
        System.assertEquals(true, o.dokumente_vollst_ndig__c);
        System.assertEquals(false, o.dokumente_unvollst_ndig__c);
    }

    @isTest
    private static void testDocsIncompleteVHcoverFZ() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);
        
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};
        
        Opportunity o = buildOpp(a.ID, vh24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        o.recordtypeid = Opportunities.finanzierungRecordType();
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);
        
        // Act
        PageReference pr = oe.incomplete();
    }

    @isTest
    private static void testDocsIncompleteVH() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);
        
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};
        
        Opportunity o = buildOpp(a.ID, vh24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);
        
        // Act
        PageReference pr = oe.incomplete();

        o = [
            SELECT  ID,
            		StageName,
            		Dokumente_vollst_ndig__c,
                    Dokumente_unvollst_ndig__c
            FROM Opportunity
        ];

        // Assert that when Account is VH24 or VR24 we don't return an error,
        // and opp fields are set.
        System.assertNotEquals('Claim', o.stageName);
        System.assert(pr.getUrl().containsIgnoreCase(o.ID));
        System.assertEquals(false, o.dokumente_vollst_ndig__c);
        System.assertEquals(true, o.dokumente_unvollst_ndig__c);
    }

    @isTest
    private static void testDocsIncompleteVR() {
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);
        
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};
        
        Opportunity o = buildOpp(a.ID, vr24.ID);
        o.Assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.Legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        insert o;
        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);
        
        // Act
        PageReference pr = oe.incomplete();

        o = [
            SELECT  ID,
            		StageName,
            		Dokumente_vollst_ndig__c,
                    Dokumente_unvollst_ndig__c
            FROM Opportunity
        ];

        // Assert that when Account is VH24 or VR24 we don't return an error,
        // and opp fields are set.
        System.assertNotEquals('Claim', o.stageName);
        System.assert(pr.getUrl().containsIgnoreCase(o.ID));
        System.assertEquals(false, o.dokumente_vollst_ndig__c);
        System.assertEquals(true, o.dokumente_unvollst_ndig__c);
    }

   @isTest
    private static void testLebensversicherung() {
        TriggerConfiguration.allInactive = true;
        // Arrange
        PageReference p = Page.OppDocsComplete;
        Test.setCurrentPage(p);
        
        Account vh24 = TestData.createVH24Account();
        Account vr24 = TestData.createVR24Account();
        Account a = TestData.createAccount();
        a.Type = 'Rechtsschutzversicherung';
        insert new Account[]{vh24, vr24, a};
        
        Opportunity o = buildOpp(a.ID, vr24.ID);
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        o.assignment_Type__c = 'Direkt';
        o.stageName = 'Check';
        o.legal_Protection_Insurance__c = a.Id;
        o.has_Legal_Protection_Insurance__c = true;
        
        User u = TestData.createUser();
		insert u;
        o.callcenter__c = u.ID;
	    insert o;

        Document__c doc = new Document__c(
            Opportunity__c = o.Id
        );
        insert doc;
        
        Apexpages.StandardController sc = new Apexpages.standardController(o);
        OppDocsExtension oe = new OppDocsExtension(sc);
        
        // Act
        PageReference pr = oe.incomplete();

        o = [
            SELECT  ID,
            		StageName,
            		Dokumente_vollst_ndig__c,
                    Dokumente_unvollst_ndig__c
            FROM Opportunity
        ];

        // Assert that when Account is VH24 or VR24, and LV, we don't return an error
        // but we also don't take the user to the email sending page.
        // Opp fields shoudl still be set, though.
        System.assertNotEquals('Claim', o.stageName);
        System.assert(pr.getUrl().endsWith('/' + o.ID));
        System.assertEquals(false, o.dokumente_vollst_ndig__c);
        System.assertEquals(true, o.dokumente_unvollst_ndig__c);
    }
    
    private static Opportunity buildOpp(ID accID, ID vhOrVrAcc) {
        TriggerConfiguration.allInactive = true;
        Opportunity o = TestData.createOpportunity(accID, 'On Hold');
        Contact con = new Contact(LastName = 'foo', Email = 'bar@baz.de');
        insert con;
        o.Contact__c = con.id;
        o.account__c = vhOrVrAcc;
        RecordType rt = [SELECT ID FROM RecordType WHERE Name='Dieselskandal' AND sObjectType = 'Opportunity'];
        o.recordTypeId = rt.ID;
        o.has_Legal_Protection_Insurance__c = true;
        o.assignment_Type__c = 'Share';
		// UserRole ur = [SELECT ID FROM UserRole WHERE Name = 'Management'];
        // User u = [SELECT ID FROM User WHERE UserRole.Name = 'Management' LIMIT 1];
        // u.userRoleId = ur.ID;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        o.legal__c = u.ID;
        o.backoffice__c = u.ID;
        return o;
    }
}