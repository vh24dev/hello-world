public inherited sharing class DGen_APISettings {
    public class DGen_APISettingsException extends Exception {}

    public static String API_BASE_URL;
    public static String API_USERNAME;
	public static String API_PWD;
    public static String SF_WEBHOOK_API_TOKEN;
    static {
        if (Test.isRunningTest()) {
           return;
        }

        Document_Generation_API_Settings__mdt[] s = [
            SELECT API_Base_URL__c, API_Username__c, API_PWD__c, SF_Webhook_Token__c
            FROM Document_Generation_API_Settings__mdt  
            WHERE Is_Active__c = true
        ];
        if (s.size() == 0) {
           throw new DGen_APISettings.DGen_APISettingsException('No integration settings found. Please create them in Setup -> Custom Metadata Types -> Document Generation API Settings -> Manage Records');
        }
        if (s.size() > 1) {
           throw new DGen_APISettings.DGen_APISettingsException('More than one active integration settings found. Please set only one record as active in Setup -> Custom Metadata Types -> Document Generation API Settings -> Manage Records');
        }

        API_BASE_URL = s[0].API_Base_URL__c;
        API_USERNAME = s[0].API_USERNAME__c;
        API_PWD = s[0].API_PWD__c;
        SF_WEBHOOK_API_TOKEN = s[0].SF_Webhook_Token__c;
    }
}