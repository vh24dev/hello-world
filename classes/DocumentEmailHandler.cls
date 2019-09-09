public class DocumentEmailHandler implements Messaging.InboundEmailHandler {
    public static Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope envelop) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        Logger.debug('Handling email with subject: ' + email.subject);
        
        Opportunity o = fetchOpportunity(email);
        
        if(o == null) {
            Logger.debug('Could not find opportunity');
            return null;
        }
        
        handleAttachments(email, o.accountId, o.Id);
        if (!String.isBlank(email.htmlBody)) {
            Logger.debug('Attaching email body to opp: ' + o.ID);
            addAsAttachment('email_' + email.fromName + '.html', Blob.valueOf(email.htmlBody), 'text/html', o.ID);
        }
        
        ID uID = o.backoffice__c != null ? o.backoffice__c : o.ownerID;
        User owner = [SELECT ID, IsActive FROM User WHERE ID = :uID];
        createTask(email.subject, o, owner);
        
        return null;
    }
    
    private static void createTask(String subj, Opportunity o, User owner) {
        if (!owner.IsActive) {
            Logger.debug('Failed to create email task, owner is inactive user');
            return;
        }

        Task t = Tasks.build(subj, '', o, owner, Date.today(), false, false, o.ID);
        insert t;
        Logger.debug('Created email task: ' + t);
    }

    private static void handleAttachments(Messaging.inboundEmail e, id accountId, string oppId) {
        System.debug('handling attachments');
        List<Attachment> atts = new List<Attachment>();
        string n = extractNumber(e.subject);
        
        if (String.isBlank(n)) {
            return;
        }
        
        List<GoogleDriveTypeFile> files = new List<GoogleDriveTypeFile>();
        GoogleDriveUtils u = GoogleDriveUtils.forAccount(accountId);
        
        if (u == null) {
            System.debug('could not find a suitable google drive account for account');
            return;
        }

        if (e.binaryAttachments != null) {
            for (Messaging.InboundEmail.BinaryAttachment b : e.binaryAttachments) {
                files.add(uploadFile(u, n, b.fileName, b.mimeTypeSubType, b.body));
            }
        }
        if (e.textAttachments != null) {
            for (Messaging.InboundEmail.textAttachment b : e.textAttachments) {
                files.add(uploadFile(u, n, b.fileName, b.mimeTypeSubType, Blob.valueOf(b.body)));
            }
        }
        
        System.debug('got: ' + files.size() + ' attachments');
        
        storeGoogleFiles(oppId, files);
    }
    
    private static GoogleDriveTypeFile uploadFile(GoogleDriveUtils u, string n, string fn, string mime, blob body) {
        GoogleDriveFile gdf = u.uploadFile(n + '/' + fn, mime, body);
        
        return new GoogleDriveTypeFile(gdf, 'Other');
    }
    
    private static void storeGoogleFiles(string oppId, List<GoogleDriveTypeFile> files) {
        List<Document__c> docs = new List<Document__c>();
        for (GoogleDriveTypeFile f : files) {
            if (f == null) {
                continue;
            }
            
            Document__c doc = new Document__c(
                Opportunity__c = oppId,
                Link__c = f.file.url,
                Google_Drive_Id__c = f.file.id,
                Name = f.file.filename,
                Type__c = f.typ
            );
            
            System.debug(doc);
            
            docs.add(doc);
        }
        insert docs;
    }

    
    // Bearbeitungsnummer or Aktenzeichenuse
    private static string extractNumber(string s) {
        System.debug('>> DocumentEmailHandler :: extractNumber :: s: ' + s);

        Pattern r = Pattern.compile('(BN\\s*[0-9]+)');
        Matcher m = r.matcher(s);
        if (m.find()) {
            String res = m.group(1).replace(' ', '');
            System.debug('DocumentEmailHandler :: extractNumber :: got: ' + res);
            return res;
        }

        System.debug('Bearbeitungsnummer not found. Look for Aktenzeichen');
        r = Pattern.compile('([0-9]+)');
        m = r.matcher(s);
        if (m.find()) {
            return m.group(1).replace(' ', '');
        }
        
        System.debug('Neither Bearbeitungsnummer not Aktenzeichen found for string: ' + s);
        return null;
    }
    
    private static Opportunity fetchOpportunity(Messaging.inboundEmail e) {
        string n = extractNumber(e.subject);
        
        if (String.isBlank(n)) {
            return null;
        }
        
        System.debug('looking up opp with Bearbeitungsnummer or Aktenzeichen: ' + n);
        
        List<Opportunity> opps = [
            SELECT  ID,
                    AccountId,
                    Owner.ID,
                    Owner.IsActive,
                    Backoffice__c,
                    Backoffice__r.IsActive 
            FROM Opportunity
            WHERE Number__c = :n OR Reference__c = :n
        ];
        
        System.debug(opps);
        
        if (opps.size() == 0) {
            return null;
        }
        
        return opps[0];
    }
    
    private static void addAsAttachment(string filename, blob content, string mime, id parentId) {
        ContentVersion cv = new ContentVersion(
            Title = filename,
            VersionData = content,
            PathOnClient = filename
        );
        insert cv;
        
        cv = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ];
        
        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = parentId,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V',
            Visibility = 'AllUsers'
        );
        insert cdl;
    }
}