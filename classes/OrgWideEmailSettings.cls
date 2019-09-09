public inherited sharing class OrgWideEmailSettings {
    public class OrgWideEmailSettingsException extends Exception {}

    public static String DG_VOLLMACHT_SENDER;
    public static String LV_VOLLMACHT_SENDER;

    static {
        OrgWide_Email_Settings__mdt[] s = [
            SELECT 	Diesel_Vollmacht_OrgWide_Sender_Email__c,
            		LV_Vollmacht_OrgWide_Sender_Email__c 
            FROM OrgWide_Email_Settings__mdt
            WHERE Is_Active__c = true
        ];

        if (Test.isRunningTest()) {
            s = new OrgWide_Email_Settings__mdt[]{fakeSettings()};
        }

        if (s.size() == 0) {
			Logger.debug('OrgWideEmailSettings :: no records in Setup -> Custom Metadata Types -> OrgWide Email Settings');
           	return;
        }

        if (s.size() > 1) {
           throw new OrgWideEmailSettings.OrgWideEmailSettingsException('More than one active general settings found. Please set only one record as active in Setup -> Custom Metadata Types -> OrgWide Email Settings -> Manage Records');
        }

        DG_VOLLMACHT_SENDER = s[0].diesel_Vollmacht_OrgWide_Sender_Email__c;
        LV_VOLLMACHT_SENDER = s[0].LV_Vollmacht_OrgWide_Sender_Email__c;
    }

    private static OrgWide_Email_Settings__mdt fakeSettings() {
        return new OrgWide_Email_Settings__mdt();
    }
}