@isTest
public class OrgWideEmailSettingsTests {
	@isTest
    private static void testA() {
        System.assert(String.isBlank(OrgWideEmailSettings.DG_VOLLMACHT_SENDER));
    }
}