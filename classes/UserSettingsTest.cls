@isTest
public class UserSettingsTest {
    
    @isTest
    private static void DisableTriggerIsSetToFalse() {
        // insert TestUSer via TestDataObject
        User user = TestData.createUser();
        insert user;
        System.runAs(user) {
        	System.assertEquals(false, UserSettings.DISABLE_ALL_TRIGGERS);
        }
    }
    
    @isTest
    private static void DisableTriggerIsSetToTrue() {
        // insert TestUSer via TestDataObject
        User user = TestData.createUserWithTriggerDisabled();
        insert user;
        System.runAs(user) {
        	System.assertEquals(true, UserSettings.DISABLE_ALL_TRIGGERS);
        }
    }
}