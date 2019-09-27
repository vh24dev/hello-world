public inherited sharing class GeneralSettings {
    public class GeneralSettingsException extends Exception {}

    public static Boolean DISABLE_AUTO_EMAIL_SENDING;
    public static Boolean DISABLE_ALL_TRIGGERS;
    public static Decimal OPPSONCLAIM_LIMIT;
    private static Decimal OPPSONCLAIM_LIMIT_DEFAULT = 8000;
    public static String DEFAULT_OWNER;
    public static String REASSIGN_IF_OWNERS;

    static {
        General_Settings__mdt[] s = [
            SELECT 	Disable_all_triggers__c,
            		Disable_Auto_Email_Sending__c,
            		OppsOnClaimCache_Query_LIMIT__c,
            		Default_Owner_username__c,
            		Reassign_if_owned_by__c
            FROM General_Settings__mdt
            WHERE Is_Active__c = true
        ];

        if (Test.isRunningTest()) {
            s = new General_Settings__mdt[]{
               	TestData.SettingsEMailAndTriggerTrue()
            };
        }
            
        if (s.size() == 0) {
           throw new GeneralSettings.GeneralSettingsException('No general settings found. Please create them in Setup -> Custom Metadata Types -> General Settings -> Manage Records');
        }
        if (s.size() > 1) {
           throw new GeneralSettings.GeneralSettingsException('More than one active general settings found. Please set only one record as active in Setup -> Custom Metadata Types -> General Settings -> Manage Records');
        }

        DISABLE_AUTO_EMAIL_SENDING = s[0].disable_Auto_Email_Sending__c;
        DISABLE_ALL_TRIGGERS = s[0].disable_all_triggers__c;
        OPPSONCLAIM_LIMIT = s[0].oppsOnClaimCache_Query_LIMIT__c;
        DEFAULT_OWNER = s[0].default_Owner_username__c;
        REASSIGN_IF_OWNERS = s[0].reassign_if_owned_by__c;

    }

   	/*
    private static General_Settings__mdt fakeSettings() {
        return new General_Settings__mdt(
            Disable_Auto_Email_Sending__c = true,
            Disable_all_triggers__c = true,
            OppsOnClaimCache_Query_LIMIT__c = 1000,
            Default_Owner_username__c = 'test@test@com',
            Reassign_if_owned_by__c = 'test'
        );
    }
	*/
    
    public static void setGeneralSettings(General_Settings__mdt gs) {
    	DISABLE_AUTO_EMAIL_SENDING = gs.disable_Auto_Email_Sending__c;
        DISABLE_ALL_TRIGGERS = gs.disable_all_triggers__c;
        OPPSONCLAIM_LIMIT = gs.oppsOnClaimCache_Query_LIMIT__c;
        DEFAULT_OWNER = gs.default_Owner_username__c;
        REASSIGN_IF_OWNERS = gs.reassign_if_owned_by__c;
    }
    
}