@isTest
public class DocumentEmailHandlerTest {
    @isTest public static void TestAttachments() {
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
}