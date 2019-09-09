@RestResource(urlMapping='/docgen/simage')
global without sharing class DGen_SignatureImageService {
    @HttpGet
    global static void signatureImage() {
        Logger.debug('> DGen_SignatureImageService :: signatureImage');
        
        if (RestContext.request.params.get('cs') != DGen_APISettings.SF_WEBHOOK_API_TOKEN) {
            Logger.debug('DGen_SignatureImageService :: signatureImage :: invalid or no api token: ' + RestContext.request.params.get('cs'));
            RESTHelper.SetStatus(403);
            return;
        }
        
        String fileIDStr = RestContext.request.params.get('fileid');
        Logger.debug('DGen_SignatureImageService :: signatureImage :: got fileID: ' + fileIDStr);
        
        ID fileID = ID.valueOf(fileIDStr);
        if (fileID == null) {
            error('DGen_SignatureImageService :: signatureImage :: empty or invalid fileID');
            return;
        }
        
        processImageRequest(fileID);
    }

    // Find an image by contentdocument id
    private static void processImageRequest(ID fileID) {
        // Note: Triggered from DocumentCreationAction, routed through the docgen server.
        // claim.Legal__r.Signature__c -> User.Signature__c
        // opportunity.Legal__r.Signature__c
        // invoice.Accounting__r.Signature__c

        ID signatureFileID = fileID;
        ContentVersion[] cvs = [
            SELECT  Title,
            		FileExtension,
            		FileType,
            		VersionData
            FROM ContentVersion
            WHERE ID IN (
                SELECT LatestPublishedVersionId
                FROM ContentDocument
                WHERE ID = :signatureFileID
            )
        ];
        if (cvs.size() == 0) {
            error('DGen_SignatureImageService :: processImageRequest :: no file found with id: ' + fileID);
            return;
        }
        
        ContentVersion cv = cvs[0];
		Result res = new Result();
        res.filename = cv.title;
        res.contentType = cv.fileType;
        res.data = cv.versionData;
        
        RESTHelper.RenderJSON(res);
        RESTHelper.SetStatus(200);
    }
    
    private static void error(String m) {
        Logger.debug(m);
        RESTHelper.RenderError(m);
        RESTHelper.SetStatus(400);
    }
    
    private class Result {
        String filename;
		String contentType;
        Blob data;
    }
}