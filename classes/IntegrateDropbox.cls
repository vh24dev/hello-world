public class IntegrateDropbox {

	public static Boolean noCallout = false;

	@future (callout=true)
	public static void uploadFileToDropboxAsync(String path,Id attachmentId, Id accountId) {

		if (Test.isRunningTest() == false) {

			List<List<String>> dropboxVariables = new List<List<String>>{new List<String>{path, attachmentId, accountId}};

			IntegrateDropboxQueueable queueable = new IntegrateDropboxQueueable();
			queueable.dropboxVariables.addAll(dropboxVariables);
			System.enqueueJob(queueable);
		} else {
			uploadFileToDropbox(path, attachmentId, accountId);
		}
	}

	public static void uploadFileToDropbox(String path,Id attachmentId, Id accountId) {
		Map<Id, Boolean> accountsActive = new Map<Id, Boolean>{
				Accounts.VR24ID => true,
				Accounts.VH24ID => true,
				Accounts.CLLBLegalID => false,
				Accounts.JCLegalLvID => false,
				Accounts.JCLegalID => true,
				Accounts.LegalLachmairID => false,
				Accounts.LegalVortmannID => false,
				Accounts.Legal21ID => false
		};

        if (((accountsActive.containsKey(accountId) == true) && (accountsActive.get(accountId) == true)) || (accountsActive.containsKey(accountId) == false)) {
            String access_token;
            String authorizationHeader;
            String error;
            String error_subject;
            Boolean success = true;

            Map<Id, String> authorizations = new Map<Id, String>{
                    Accounts.VR24ID => 'Bearer VnHWZKkdpkAAAAAAAAAAFu6Nh0ekaXoEMdJMvzYFwZZ44vEYYomYPVUnBUAgvneq', // Dropbox gehört VH24
                    Accounts.VH24ID => 'Bearer VnHWZKkdpkAAAAAAAAAAFu6Nh0ekaXoEMdJMvzYFwZZ44vEYYomYPVUnBUAgvneq',
                    Accounts.CLLBLegalID => 'Bearer ',
                    Accounts.JCLegalLvID => 'Bearer ',
                    Accounts.JCLegalID => 'Bearer VnHWZKkdpkAAAAAAAAAAFu6Nh0ekaXoEMdJMvzYFwZZ44vEYYomYPVUnBUAgvneq', // Dropbox gehört VH24
                    Accounts.LegalLachmairID => 'Bearer ',
                    Accounts.LegalVortmannID => 'Bearer ',
                    Accounts.Legal21ID => 'Bearer '
            };

            List<Attachment> attachments = [select Id,ParentId,Name,Body from Attachment where Id = :attachmentId];
            Id parentId = attachments[0].ParentId;

            if (attachments.isEmpty() == false) {

                // replace illegal characters
                path = path.replaceAll('[<>:"|?*]', '');

                Http http = new Http();
                HttpRequest request = new HttpRequest();

                // Call url
                String url = 'https://content.dropboxapi.com/2/files/upload';

                System.debug('URL: ' + url);

                request.setEndpoint(url);
                request.setMethod('POST');

                if (authorizations.containsKey(accountId) == true) {
                    authorizationHeader = authorizations.get(accountId);
                } else {
                    authorizationHeader = 'Bearer D39IPXtCndAAAAAAAAAAkvmPSqSil6c6-2iaRjQNhmod9mzas_OWSnMaV6WvsAqf';
                }

                request.setHeader('Authorization', authorizationHeader);
                request.setHeader('Dropbox-API-Arg', '{\"path\": \"' + path + 'TEST - ' + attachments[0].Name + '\",\"mode\": \"add\",\"autorename\": true,\"mute\": false}');
                request.setHeader('Content-Type', 'application/octet-stream');

                request.setBodyAsBlob(attachments[0].Body);

                System.debug('Dropbox request: ' + request);
                System.debug('Request header: ' + request.getHeader('Dropbox-API-Arg'));

                HttpResponse response = new HttpResponse();

                if (noCallout == false) { // Queuables can't use callout mocks, so we mock response ourselves
                    response = http.send(request);
                } else {
                    response.setBody('{"name": "cost_note_cn20160810020.pdf", "path_lower": "/test/cost_note_cn20160810020.pdf", "path_display": "/Test/cost_note_cn20160810020.pdf", "id": "id:b1-3Lzp3mDQAAAAAAABR2A", "client_modified": "2016-08-10T14:40:27Z", "server_modified": "2016-08-10T14:40:27Z", "rev": "1c0470bd6ed24", "size": 84310}');
                    response.setStatusCode(200);
                }
                // debugging call, which you can check in debug logs
                System.debug('Dropbox response :' + response.getBody());

                // get body
                String jsonResponses = response.getBody();
                // deserialize
                CDropboxUploadResponse UploadResponse = (CDropboxUploadResponse) JSON.deserialize(jsonResponses, CDropboxUploadResponse.class);

                //save response
                if (!response.getStatusCode().format().startsWith('2')) {
                    error = 'Error while trying to connect to ' + request.getEndpoint() + ' : ' + response.getStatusCode() + ' ' + response.getStatus();
                    error_subject = 'Dropbox connection error';
                    success = false;
                } else {
                    if (UploadResponse.error == null) {

                        // get data for task
                        Schema.SObjectType sobjectType = attachments[0].ParentId.getSObjectType();
                        System.debug(sobjectType);
                        String sObjectName = sobjectType.getDescribe().getName();
                        System.debug(sObjectName);
                        SObject parentObject = Database.query('Select Id, Uploaded_To_Dropbox__c, (select Id,Status,Subject from Tasks) from ' + sobjectName + ' where Id = :parentId');
                        User taskOwner = [select Id,isActive from User where Id = :System.UserInfo.getUserId()];

                        // set checbox in parent
                        if(sObjectName == 'Cost_Note__c') {
                            Cost_Note__c costNote = (Cost_Note__c)parentObject;
                            costNote.Uploaded_To_Dropbox__c = true;
                            update costNote;
                        } else if(sObjectName == 'Invoice__c') {
                            Invoice__c invoice = (Invoice__c)parentObject;
                            invoice.Uploaded_To_Dropbox__c = true;
                            update invoice;
                        } else if(sObjectName == 'Credit_Note__c') {
                            Credit_Note__c creditNote = (Credit_Note__c)parentObject;
                            creditNote.Uploaded_To_Dropbox__c = true;
                            update creditNote;
                        }

                        // Log Upload
                        Task task = Tasks.build('Uploaded to ' + UploadResponse.path_display, '', parentObject, taskOwner, System.today(), true, false);

                        if (task != null) {
                            task.Status = 'Completed';
                            insert task;
                        }
                    } else {
                        error = 'Error while trying to upload file to dropbox: ' + UploadResponse.error + ' - ' + UploadResponse.error_summary;
                        error_subject = 'Dropbox file upload error';
                        success = false;
                    }
                }

                // Send notification to admins
                if (success == false) {
                    Logger.error('Failed to upload to Drobox: ' + request.getBody());
                }
            }
        } else {
            System.debug('Upload to Dropbox has been deactivated for this specific account in class IntegrateDropbox');
        }
	}

	//secondary classes
	private class CDropboxUploadResponse {
		private String name;
		private String path_lower;
		private String path_display;
		private String id;
		private String client_modified;
		private String server_modified;
		private String rev;
		private String size;
		private String error;
		private String error_summary;
	}
}