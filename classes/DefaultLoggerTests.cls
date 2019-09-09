@isTest
public class DefaultLoggerTests {
	@isTest
    private static void testBla() {
        new DefaultLogger().debug('debug');
        new DefaultLogger().error('error');
    }
}