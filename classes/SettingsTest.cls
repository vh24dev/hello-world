@isTest
public class SettingsTest {
	
    // trigger
    @isTest
    private static void AllTriggerFlagsSetToTrue() {
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerTrue();       
        GeneralSettings.setGeneralSettings(gs);
        User user = TestData.createUserWithTriggerDisabled();
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_ALL_TRIGGERS);
        }
    }
    
    @isTest
    private static void TriggerGeneralSetToFalseUserSetToTrue() {
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerFalse();       
        GeneralSettings.setGeneralSettings(gs);
        User user = TestData.createUserWithTriggerDisabled();
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_ALL_TRIGGERS);
        }
    }
	
    @isTest
    private static void TriggerGeneralSetToTrueUserSetToFalse() {
        User user = TestData.createUser();
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerTrue();       
        GeneralSettings.setGeneralSettings(gs);
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_ALL_TRIGGERS);
        }
    }
    
    @isTest
    private static void TriggerGeneralSetToFalseUserSetToFalse() {
        User user = TestData.createUser();
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerFalse();       
        GeneralSettings.setGeneralSettings(gs);
        insert user;
        System.runAs(user) {
        	System.assertEquals(false, Settings.DISABLE_ALL_TRIGGERS);
        }
    }
    
    // e-mail
    @isTest
    private static void AllEMailFlagsSetToTrue() {
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerTrue();       
        GeneralSettings.setGeneralSettings(gs);
        User user = TestData.createUserWithTriggerDisabled();
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_AUTO_EMAIL_SENDING);
        }
    }
    
    @isTest
    private static void EMailGeneralSetToFalseUserSetToTrue() {
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerFalse();       
        GeneralSettings.setGeneralSettings(gs);
        User user = TestData.createUserWithTriggerDisabled();
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_AUTO_EMAIL_SENDING);
        }
    }
	
    @isTest
    private static void EMailGeneralSetToTrueUserSetToFalse() {
        User user = TestData.createUser();
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerTrue();       
        GeneralSettings.setGeneralSettings(gs);
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, Settings.DISABLE_AUTO_EMAIL_SENDING);
        }
    }
    
    @isTest
    private static void EMailGeneralSetToFalseUserSetToFalse() {
        User user = TestData.createUser();
        General_Settings__mdt gs = TestData.SettingsEMailAndTriggerFalse();       
        GeneralSettings.setGeneralSettings(gs);
        insert user;
        System.runAs(user) {
        	System.assertEquals(false, Settings.DISABLE_AUTO_EMAIL_SENDING);
        }
    }   
}