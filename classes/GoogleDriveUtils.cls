public class GoogleDriveUtils {
    private string calloutName;
    private string domain;
    
    public GoogleDriveUtils(string calloutName, string domain) {
        this.calloutName = calloutName;
        this.domain = domain;
    }
    
    public static GoogleDriveUtils forAccount(Id accountId) {
        if (Accounts.isVR24(accountId)) {
            return new GoogleDriveUtils('Google_Drive_VR24', 'verbraucherrechte24.de');
        } else {
            return new GoogleDriveUtils('Google_Drive_VH24', 'verbraucherhilfe24.de');
        }
    }
	
    private class CreateFileRequest {
        public string name;
    }
	
    public GoogleDriveFile uploadFile(string filename, string contentType, blob contents) {
        CreateFileRequest rd = new CreateFileRequest();
        rd.name = filename;

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + this.calloutName + '/upload/drive/v3/files/?uploadType=resumable');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-Upload-Content-Type', contentType);
        req.setBody(JSON.serialize(rd));
        Http http = new Http();
        HTTPResponse response = http.send(req);

        req = new HttpRequest();
        req.setEndpoint(response.getHeader('Location'));
        req.setMethod('PUT');
		req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', contentType);
        req.setHeader('Content-Size', String.valueOf(contents.size()));
        req.setTimeout(100000);
        req.setBodyAsBlob(contents);
        http = new Http();
        response = http.send(req);
        
        Map<String, Object> responseData = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        string fileId = (String)responseData.get('id');
        
        req = new HttpRequest();
        req.setEndpoint('callout:' + this.calloutName + '/drive/v3/files/' + fileId + '/permissions');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody('{"role":"reader","type":"domain","domain":"verbraucherhilfe24.de"}');
        http = new Http();
        response = http.send(req);
        
        GoogleDriveFile file = new GoogleDriveFile();
        file.id = fileId;
        file.url = 'https://drive.google.com/a/' + this.domain + '/file/d/' + fileId + '/view?usp=drivesdk';
        file.filename = filename;
        return file;
    }
    
    public HttpResponse downloadFile(string fileId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + this.calloutName + '/drive/v3/files/' + fileId + '?alt=media');
        req.setMethod('GET');
        HTTP http = new Http();
        return http.send(req);
    }
}