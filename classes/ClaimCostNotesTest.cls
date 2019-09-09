@isTest
public class ClaimCostNotesTest {
     private static String dkRtName = 'Dieselskandal';
    private static String fzRtName = 'Finanzierung';
    private static String lvRtName = 'Lebensversicherung';
    private static ID dkRtID;
    private static ID fzRtID;
    private static ID lvRtID;
    static {
        RecordType[] rts = [
            SELECT ID, DeveloperName
            FROM RecordType
            WHERE (DeveloperName = :dkRtName
                OR DeveloperName = :fzRtName
                OR DeveloperName = :lvRtName)
                AND SObjectType = 'Claim__c'
        ];
        for (RecordType rt : rts) {
            if (rt.developerName == dkRtName) {
                dkRtID = rt.ID;
                continue;
            }
            if (rt.developerName == fzRtName) {
                fzRtID = rt.ID;
                continue;
            }
            if (rt.developerName == lvRtName) {
                lvRtID = rt.ID;
                continue;
            }
        }
    }
	@isTest
    private static void testClaimCostNotes() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Extrajudicial';
        claim.Cover_Note__c = 'Issued';
        claim.RecordTypeId = dkRtID;
        claim.Clerk__c = legalUser.Id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
    @isTest
    private static void testClaimCostNotes2() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Judicial';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = dkRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
    @isTest
    private static void testClaimCostNotes3() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Judicial';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = fzRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = 'Appeal';
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
    @isTest
    private static void testClaimCostNotes4() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Appeal';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = fzRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    @isTest
    private static void testClaimCostNotes5() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Appeal';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = dkRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
    @isTest
    private static void testClaimCostNotes6() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Extrajudicial';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = fzRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
    @isTest
    private static void testClaimCostNotes7() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Extrajudicial';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = lvRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null;
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();


    }
    
     @isTest
    private static void testClaimCostNotes8() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Judicial';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = lvRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null; 
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();
    }
    
    @isTest
    private static void testClaimCostNotes9() {

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Accepted';
        claim.Cover_Note_Scope__c = 'Appeal';
        claim.Cover_Note__c = 'Issued'; 
        claim.RecordTypeId = lvRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null; 
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();
    }

    @isTest
    private static void testClaimCostNotes10() { // 'Legal Protection Insurance' 'Berufung'

        Map<Id,Claim__c> mm = new Map<id,Claim__c>();
        List<Claim__c> cc = new List<Claim__c>();

        Claim__c oldClaim ;
        // Testsetup
        TriggerConfiguration.allInactive = true; 

		// Create admin user to update roles on other users
		User adminUser = TestData.createUser();
		adminUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		insert adminUser;

		// Create test users and set their roles with admin user
		User legalUser = TestData.createUser();
		legalUser.ProfileId = [SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
		legalUser.Username = 'legalUser@cloudworx.agency';
		insert legalUser;

		System.runAs(adminUser) {
            legalUser.UserRoleId = [select id from userrole where name = 'Legal'][0].Id;
			update legalUser;
		}

		Account account = TestData.createAccount();
		insert account;
		Contact contact = TestData.createContact(account.Id);
		insert contact;
		Opportunity opportunity = TestData.createOpportunity(account.Id,'New');
		opportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Dieselskandal').getRecordTypeId();
		opportunity.Contact__c = contact.Id;
		insert opportunity;
		Claim__c claim = TestData.createClaim(opportunity.Id,'Lawsuit');
        claim.extrajudicial_Cost_Note_Number__c = null;
        claim.Result__c = 'Declined';
        claim.Cover_Note_Scope__c = 'Appeal';
        claim.Cover_Note__c = 'Issued'; 
        claim.Stage__c = 'Appeal';
        claim.RecordTypeId = lvRtID;
        claim.Clerk__c = legalUser.id;
		insert claim;
        oldClaim = claim;
        oldClaim.Cover_Note_Scope__c = null; 
        
        //oldClaim.Cover_Note_Scope__c = 'Judicial ';
		Cost_Note__c costNote = TestData.createCostNote(claim.Id,'Draft');
		Cost_Note_Line_Item__c costNoteLineItem = TestData.createCostNoteLineItem(null,10000);
		cc.add(claim);
        mm.put(claim.Id, oldClaim);
        TriggerConfiguration.allInactive = false;
        
        Test.startTest();
        ClaimCostNotes.create(cc,mm); 
        Test.stopTest();
    }
}