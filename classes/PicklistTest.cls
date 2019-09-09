@isTest
public class PicklistTest {
    // unit
    @isTest
    public static void testTrue() {
        System.assertEquals(
            true,
            Picklist.contains('foo;bar', 'foo')
        );
        System.assertEquals(
            true,
            Picklist.contains('foo', 'foo')
        );
    }

    @isTest
    public static void testFalse() {
        System.assertEquals(
            false,
            Picklist.contains('foo;bar', 'baz')
        );
        System.assertEquals(
            false,
            Picklist.contains('foo', 'bar')
        );
        System.assertEquals(
            false,
            Picklist.contains('foo', 'fooo')
        );
    }

    @isTest
    public static void testNullFalse() {
        System.assertEquals(
            false,
            Picklist.contains(null, 'baz')
        );
        string nullStr;
        System.assertEquals(
            false,
            Picklist.contains(nullStr, 'bar')
        );
    }
}