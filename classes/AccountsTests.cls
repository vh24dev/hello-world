@isTest
public class AccountsTests {
	@isTest
    private static void testVH24Accounts() {
        // Both created at the beginning since Accounts fetches both in static constructor,
        // an attempt to decrease the number of SOQL queries per transaction.
        Account vh24 = new Account(name='VH24');
        Account vr24 = new Account(name='VR24');
        insert new Account[]{vh24, vr24};


        // test
        System.assert(Accounts.isVH24(vh24.ID));
        System.assert(!Accounts.isVR24(vh24.ID));

        System.assert(!Accounts.isVH24(vr24.ID));
        System.assert(Accounts.isVR24(vr24.ID));

        System.assert(!Accounts.isVH24(null));
        System.assert(!Accounts.isVR24(null));
    }
}