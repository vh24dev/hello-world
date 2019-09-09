public class DGen_DocumentTemplates {
    public class Doc {
        public ID attachmentID;
        public String fileType;
    }

    public static string latest(list<string> versions) {
        Pattern p = Pattern.compile('((?:(\\d+)\\.)?(?:(\\d+)\\.)?(?:(\\d+)))(?:(\\s|\\))*\\.(xlsx|docx))');
		Matcher pm;
       	
        string latestVersion = '';
        string latestVersionKey = '';
        
        for (string name : versions) {
            System.debug('version: ' + name);

            pm = p.matcher(name);
            if (!pm.find()) {
                System.debug('version not matched');
                continue;
            }
 
            // Find the highest doc version
            String v = pm.group(1); // Can be empty when no version            
            if (v > latestVersion) {
                latestVersion = v;
                latestVersionKey = name;
            }   
        }
        
        if (latestVersionKey == '' && versions.size() > 0) {
            System.debug('returning version[0]:' + versions[0]);
            return versions[0];
        }
        
        System.debug('returning latestVersionKey:' + latestVersionKey);
        return latestVersionKey;
    }

    // Given a cloudworx template id, returns the template document with highest version.
    public static Doc latestDoc(ID template) {
        Attachment[] docs = [SELECT ID, Name FROM Attachment WHERE ParentID = :template];
        if (docs.size() == 0) {
            System.debug('DGen_DocumentTemplates :: latestDoc :: unable to find attachment with parentid ' + template);
            return null;
        }
        
        System.debug('found ' + docs.size() + ' docs');
        
        List<string> versions = new List<string>();
        map<string,string> versionMap = new Map<string, string>();
        integer i = 0;
        for(Attachment a : docs) { 
            string n = String.valueOf(i) + ' ' + a.name;
            versions.add(n);
            versionMap.put(n, a.Id);
        }
        
        string latestVersion = latest(versions);
        string ext = latestVersion.substringAfterLast('.');
        string latestVersionId = versionMap.get(latestVersion);

        Doc dt = new Doc();
        dt.attachmentID = latestVersionId;
        dt.fileType = ext;
        return dt;
    }
}