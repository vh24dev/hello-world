@isTest
public class FinAPISettingsTests {
    @isTest
    private static void testValuesExist() {
        System.assert(!String.isBlank(new FinAPISettings().baseURL));
    }
}