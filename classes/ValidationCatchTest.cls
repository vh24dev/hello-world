@isTest
public class ValidationCatchTest {
    private static User user() {
        Profile testProfile = [
            SELECT ID
            FROM Profile
            WHERE Name = 'System Administrator'
            LIMIT 1
        ];
        User usr = new User(
            LastName = 'Test u1',
            Username = 'testu1@test.com',
            Email = 'testu1@test.com',
            Alias = 'u1',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_GB',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = testProfile.Id,
            LanguageLocaleKey = 'en_US',
            IsActive = true
        );
		usr.bypass_process_builder__c = false;
        insert usr;
        return usr;
    }

	@isTest
    public static void testInsertFailBackoffice() {
        User usr = user();
        System.runAs(usr) {
            Account a = TestData.createAccount();
            insert a;
            Opportunity opp = TestData.createOpportunity(a.Id, 'Claim');
            string err = ValidationCatch.insertObj(opp);
            System.assertEquals('Bitte tragen Sie einen Backoffice Mitarbeiter ein.', err);
        }
    }

	@isTest
    public static void testInsertFailRSV() {
        User usr = user();
        System.runAs(usr) {
            Account a = TestData.createAccount();
            insert a;
            User u = TestData.createUser();
            insert u;
            Opportunity opp = TestData.createOpportunity(a.Id, 'Claim');
            opp.Backoffice__c = u.Id;
            opp.Has_Legal_Protection_Insurance__c = false;
            opp.Assignment_Type__c = 'RSV';
            string err = ValidationCatch.insertObj(opp);
            System.assertEquals('Der Auftragstyp kann nicht RSV sein, wenn keine Rechtsschutzversicherung vorhanden ist.', err);
        }
    }

	@isTest
    public static void testInsertOpp() {
        User usr = user();
        System.runAs(usr) {
            Account a = TestData.createAccount();
            insert a;
            User u = TestData.createUser();
            insert u;
            Opportunity opp = TestData.createOpportunity(a.Id, 'Claim');
            opp.Backoffice__c = u.Id;
            string err = ValidationCatch.insertObj(opp);
            System.assertEquals('', err);
        }
    }

	@isTest
    public static void testUpdateOpp() {
        User usr = user();
        System.runAs(usr) {
            Account a = TestData.createAccount();
            insert a;
            User u = TestData.createUser();
            insert u;
            Opportunity opp = TestData.createOpportunity(a.Id, 'Claim');
            opp.Backoffice__c = u.Id;
            string err = ValidationCatch.insertObj(opp);
            System.assertEquals('', err);
            opp.StageName = 'On Hold';
            err = ValidationCatch.updateObj(opp);
            System.assertEquals('', err);
        }
    }

	@isTest
    public static void testUpdateFail() {
        User usr = user();
        System.runAs(usr) {
            Account a = TestData.createAccount();
            insert a;
            User u = TestData.createUser();
            insert u;
            Opportunity opp = TestData.createOpportunity(a.Id, 'Claim');
            opp.Backoffice__c = u.Id;
            string err = ValidationCatch.insertObj(opp);
            System.assertEquals('', err);
            opp.Has_Legal_Protection_Insurance__c = false;
            opp.Assignment_Type__c = 'RSV';
            err = ValidationCatch.updateObj(opp);
            System.assertEquals('Der Auftragstyp kann nicht RSV sein, wenn keine Rechtsschutzversicherung vorhanden ist.', err);
        }
    }
}