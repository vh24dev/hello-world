@isTest
public class GeneralSettingsTests {
    @isTest
    private static void testValuesExist() {
        System.assertEquals(true, GeneralSettings.DISABLE_AUTO_EMAIL_SENDING);
    }
}