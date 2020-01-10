@isTest
public class MandateMailControllerTest {
    
    @isTest
    private static void testInitDisabled(){
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.RecordTypeId = [select Id from RecordType where Name = 'Finanzierung' and SobjectType = 'Opportunity'][0].Id;
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        //opp.Legal__c = legal.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id,'Customers Opposition');
        claim.Clerk__c = backoffice.Id;
 		insert claim;
		String returnValue = MandateMailController.init(claim.Id);
        System.assertEquals('disabled', returnValue);
    }
    
    @isTest
    private static void testInitEnabled01(){
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        //opp.Legal__c = legal.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id,'Legal Opposition');
        claim.Clerk__c = backoffice.Id;
 		insert claim;
		String returnValue = MandateMailController.init(claim.Id);
        System.assertEquals(null, returnValue);
    }
    /*
    @isTest
    private static void testInitEnabled02(){
        Account accountInsurance = TestData.createInsurance('12345678');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.RecordTypeId = [select Id from RecordType where Name = 'Finanzierung' and SobjectType = 'Opportunity'][0].Id;
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        //opp.Legal__c = legal.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id,'Legal Opposition');
        claim.Clerk__c = backoffice.Id;
 		insert claim;
		String returnValue = MandateMailController.init(claim.Id);
        System.assertEquals(null, returnValue);
    }
    */
    @isTest
    private static void testInitEnabled03(){
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.RecordTypeId = [select Id from RecordType where Name = 'Lebensversicherung' and SobjectType = 'Opportunity'][0].Id;
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        opp.Callcenter__c =backoffice.Id;
        //opp.Legal__c = legal.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id,'Legal Opposition');
        claim.Clerk__c = backoffice.Id;
 		insert claim;
		String returnValue = MandateMailController.init(claim.Id);
        System.assertEquals(null, returnValue);
    }
 
    @isTest
    private static void testTriggerEvent(){  
        Test.startTest();
        Account accountInsurance = TestData.createInsurance('123456789');
		insert accountInsurance;
        Account account = TestData.createAccount();
		insert account;
        User backoffice = Testdata.createUser();
        insert backoffice;
        Opportunity opp = TestData.createOpportunity(account.Id, 'check');
        opp.Insurance__c = accountInsurance.Id;
        opp.Insurance_Type__c = 'Rentenversicherung';
        opp.Insurance_Rate__c = 'Dummy-Tarifbezeichnung';
        opp.Backoffice__c= backoffice.Id;
        insert opp;
        Claim__c claim = TestData.createClaim(opp.Id,'Legal Opposition');
        claim.Clerk__c = backoffice.Id;
 		insert claim;
        
        String uuid = MandateMailController.retrieveMailUuid();
        MandateMailController.sendMail(opp.Id, 'testmail@test.de', uuid);
        Test.getEventBus().deliver();
    	List<EventBusSubscriber> subscribers = [SELECT Name, Position, Retries, LastError 
			FROM EventBusSubscriber WHERE Topic='SendMail__e' AND Type='ApexTrigger'];
       
        System.assertNotEquals(null, subscribers);
        Test.stopTest();
    }
    
}