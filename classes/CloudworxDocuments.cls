public class CloudworxDocuments {
    private static string labelToDeveloper(string label) {
        string raw = '';
        string res = '';
        raw = label;
        res = raw.replaceAll('ä','ae');
        res = res.replaceAll('ö', 'oe');
        res = res.replaceAll('ü', 'ue');
        res = res.replaceAll('ß', 'ss');
        res = res.replaceAll('[^a-zA-Z0-9]', '');
        system.debug('raw=' + raw + ' res=' + res);
        return res;
    }

    public static void setDeveloperName(cloudworx_document_template__c[] cc) {
        for (cloudworx_document_template__c c : cc) {
            c.DeveloperName__c = labelToDeveloper(c.Label__c);
        }
    }
}