@isTest
public class DocumentEmailHandlerTest {
    @isTest 
    public static void TestAttachments() {
        TriggerConfiguration.allInactive = true;
        
        Account a = new Account(
            Name='VH24'
        );
        
        insert a;
        
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            Number__c = 'BN123',
            StageName = 'New',
            CloseDate = Date.today()
        );
        
        insert o;
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.inboundEmail e = new Messaging.inboundEmail();
        
        e.subject = 'Teakdpowakd Bearbeitungsnummer';
        DocumentEmailHandler.handleInboundEmail(e, env);
        
        
        e.subject = 'Teakdpowakd Bearbeitungsnummer: BN123';
        DocumentEmailHandler.handleInboundEmail(e, env);
        
        e.textAttachments = new List<Messaging.InboundEmail.textAttachment>();
        Messaging.InboundEmail.textAttachment tatt = new Messaging.InboundEmail.textAttachment();
        tatt.Filename= 'test.jpg';
        tatt.Body= 'test';   
        tatt.mimeTypeSubType = 'foo';
        e.textAttachments.add(tatt);
        
        e.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>();
        Messaging.InboundEmail.BinaryAttachment batt = new Messaging.InboundEmail.BinaryAttachment();
        batt.Filename= 'test.jpg';
        batt.Body= Blob.valueOf('test');
        batt.mimeTypeSubType = 'foo';
        e.binaryAttachments.add(batt);

        Test.setMock(HttpCalloutMock.class, new MissingDocumentsMock());
        Test.startTest();
        e.subject = 'Teakdpowcakd Bearbeitungsnummer: BN123';
        DocumentEmailHandler.handleInboundEmail(e, env);
        Test.stopTest();
    }
    
    @isTest public static void TestBodyAttachment() {
        TriggerConfiguration.allInactive = true;
        
        Account a = new Account(
            Name='VH24'
        );
        insert a;
        
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            Number__c = 'BN1234',
            Reference__c = '4321',
            StageName = 'New',
            CloseDate = Date.today()
        );
        insert o;
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.inboundEmail e = new Messaging.inboundEmail();
        
        // BNXX
        e.subject = 'Teakdpowakd Bearbeitungsnummer: BN1234';
        e.htmlBody = '<html>bla</html>';
        e.fromName = 'Alice';
        DocumentEmailHandler.handleInboundEmail(e, env);
        
        // Assert that a file is attached to the Opp with html body of the email
        ContentVersion[] cvs = contentFor(o.ID);
        System.assertEquals(1, cvs.size());
        
        ContentVersion cv = cvs[0];
        System.assert(cv.title.contains('Alice'));
        System.assert(cv.contentSize > 0);
        
        // BN    XX
        e.subject = 'Teakdpowakd BN 1234 asas';
        DocumentEmailHandler.handleInboundEmail(e, env);

        cvs = contentFor(o.ID);
        System.assertEquals(2, cvs.size());
        
        // Aktenzeichen
        e.subject = 'Teakdpowakd 4321 asas';
        DocumentEmailHandler.handleInboundEmail(e, env);

        cvs = contentFor(o.ID);
        System.assertEquals(3, cvs.size());
        
        // No match
        e.subject = 'Teakdpowakd asas';
        DocumentEmailHandler.handleInboundEmail(e, env);

        cvs = contentFor(o.ID);
        System.assertEquals(3, cvs.size());
    }
    
    @isTest public static void TestTaskCreation() {
        TriggerConfiguration.allInactive = true;
        
        Account a = new Account(
            Name='VH24'
        );
        insert a;
        
        User u = TestData.bypassUser();
        insert u;

        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            Number__c = 'BN1234',
            Reference__c = '4321',
            StageName = 'New',
            CloseDate = Date.today(),
            Backoffice__c = u.ID
        );
        insert o;
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.inboundEmail e = new Messaging.inboundEmail();
        
        // BNXX
        e.subject = 'Subj: BN1234';
        e.htmlBody = '<html>bla</html>';
        e.fromName = 'Alice';
        DocumentEmailHandler.handleInboundEmail(e, env);
        
        Task[] tt = [
            SELECT Subject, WhatID, OwnerID FROM Task WHERE WhatID = :o.ID AND OwnerID = :u.ID
        ];
        System.assertEquals(1, tt.size());
        System.assertEquals(e.subject, tt[0].subject);
    }

    private static ContentVersion[] contentFor(ID id) {
        ContentDocumentLink[] cdls = [
            SELECT ContentDocumentID
            FROM ContentDocumentLink
            WHERE LinkedEntityID = :id
        ];
        
        ID[] cdids = new ID[]{};
		for (ContentDocumentLink cdl: cdls) {
			cdids.add(cdl.contentDocumentID);
		}
        return [
            SELECT Title, ContentSize
            FROM ContentVersion
            WHERE ContentDocumentID = :cdids
        ];
    }
    
    // NHC - New Tests
    @isTest 
    public static void TestIsClaimMonitored() {
    	String subject = 'BN123456 - monitored - Widerspruch';
        boolean isMonitored = DocumentEmailhandler.claimIsMonitored(subject);
        System.assertEquals(true, isMonitored);
        subject = 'BN123456-monitored-Widerspruch';
        isMonitored = DocumentEmailhandler.claimIsMonitored(subject);
        System.assertEquals(true, isMonitored);
        subject = 'BN123456-motored-Widerspruch';
        isMonitored = DocumentEmailhandler.claimIsMonitored(subject);
        System.assertEquals(false, isMonitored);
	}
    
    @isTest 
    private static void testRetrieveClaim() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
   	    Claim__c c = mockData(u);
        String subject = 'BN123456-monitored-Widerspruch';
        Claim__c claimRetrieved = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals(c.Id, claimRetrieved.Id);
        TriggerConfiguration.allInactive = false;
    }
    
    @isTest     
    private static void testUpdateClaimStatus01() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-Anwaltswiderspruch versendet';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('Anwaltswiderspruch versendet',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }
    
    @isTest     
    private static void testUpdateClaimStatus02() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-Absage AW WSP';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('Absage AW WSP',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }

    @isTest     
    private static void testUpdateClaimStatus03() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-Deckungszusage AG';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('Deckungszusage AG',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }    
    
    @isTest     
    private static void testUpdateClaimStatus04() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-Kostennote AG bezahlt  ';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('Kostennote AG bezahlt',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }    
    
    @isTest     
    private static void testUpdateClaimStatus05() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-1.Mahnung KN 1.Instanz versendet	  ';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('1.Mahnung KN 1.Instanz versendet',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }  
    
    @isTest     
    private static void testUpdateClaimStatusWrong06() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        mockData(u);
        
        System.Test.startTest();
        String subject = 'BN123456-monitored-1.Mahnung KN 1.Instanz versndet	  ';
        Claim__c claim = DocumentEMailHandler.retrieveClaim(subject);
        System.runAs(u) {
        	DocumentEMailHandler.updateClaimStatus(claim,subject);
        }
        claim = DocumentEMailHandler.retrieveClaim(subject);
        System.assertEquals('status not clear',claim.Statuskontrolle_Anwalt__c);
        System.Test.stopTest();
        
        TriggerConfiguration.allInactive = false;
    }    
    
    @isTest         
    private static void testCreateReviewProblemsTask() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        Claim__c c = mockData(u);
        System.Test.startTest();
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.inboundEmail e = new Messaging.inboundEmail();
        
        // BNXX
        e.subject = 'BN123456-monitored-1.Mahnung KN 1.Instanz versendt';
        e.htmlBody = '<html>bla</html>';
        e.fromName = 'Alice';
        System.runAs(u) {
        	DocumentEmailHandler.handleInboundEmail(e, env);
        }        
        Task[] tt = [
            SELECT Type, Subject, WhatID, OwnerID FROM Task WHERE WhatID = :c.ID
        ];
        String tasksubject = 'Fehler bei Kontrollmail für Fall mit BN: '+ 'BN123456';

        System.assertEquals(1, tt.size());
        System.assertEquals(tasksubject, tt[0].subject);
        System.assertEquals('KontrolleAnwaltFehler', tt[0].type);
        System.Test.stopTest();
    }
    
    @isTest         
    private static void testCreateReviewSuccessTask() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.bypassUser();
        insert u;
        Claim__c c = mockData(u);
        System.Test.startTest();
        
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.inboundEmail e = new Messaging.inboundEmail();
        
        // BNXX
        e.subject = 'BN123456-monitored-1.Mahnung KN 1.Instanz versendet';
        e.htmlBody = '<html>bla</html>';
        e.fromName = 'Alice';
        System.runAs(u) {
        	DocumentEmailHandler.handleInboundEmail(e, env);
        }
        Task[] tt = [
            SELECT Type, Subject, WhatID, OwnerID FROM Task WHERE WhatID = :c.ID
        ];
        String tasksubject = 'Neue Kontrollmail für Fall mit BN: '+ 'BN123456';

        System.assertEquals(1, tt.size());
        System.assertEquals(tasksubject, tt[0].subject);
        System.assertEquals('KontrolleAnwaltErfolg', tt[0].type);
        System.Test.stopTest();
    }
    
    
    // testUtils
    private static Claim__c mockData(User u) {
        Account a = new Account(
            Name='VH24'
        );
        insert a;
        
        Opportunity o = new Opportunity(
            Name = 'foo',
            AccountId = a.Id,
            Number__c = 'BN123456',
            Reference__c = '4321',
            StageName = 'New',
            CloseDate = Date.today(),
            Backoffice__c = u.ID
        );
    
    	Claim__c c;
        System.runAs(u) {
        	insert o;
    		User l = TestData.legalUser();
        	insert l;
            c = new Claim__c(
            	Opportunity__c = o.Id,
            	Clerk__c = l.Id
        	);
        	insert c;
        }
        return c;
    }
    
    
}