// Legacy. Refactoring in progress.
// Relies on process builder to call an invocable class that drives the conversion.
@isTest
public class LeadConversionTests {
    @isTest
    static void testSuccess() {
        TriggerConfiguration.allInactive = true;
        User user = TestData.createUser();
        insert user;
        Account account = TestData.createAccount();
        account.External_Id__c = 'TestID';
        account.Name = 'Testcompany';
        account.Type = 'Lebensversicherung';
        insert account;
        Account account2 = TestData.createAccount();
        account2.External_Id__c = 'TestID2';
        account2.Name = 'Testcompany2';
        account2.Type = 'Rechtsschutzversicherung';
        insert account2;
        Account account3 = TestData.createAccount();
        account3.External_Id__c = 'TestID3';
        account3.Name = 'Testcompany3';
        account3.Type = 'Fahrzeughersteller';
        insert account3;
        Account account4 = TestData.createAccount();
        account4.External_Id__c = 'TestID4';
        account4.Name = 'Testcompany4';
        account4.Type = 'Partner';
        insert account4;
        Account account5 = TestData.createVH24Account();
        insert account5;
        Account account6 = TestData.createAccount();
        account6.External_Id__c = 'TestID6';
        account6.Name = 'Testcompany6';
        account6.Type = 'Kreditinstitut';
        Product2 product = TestData.createProduct();
        product.ProductCode = 'sp001';
        insert product;
        PricebookEntry pricebookEntry = TestData.createPricebookEntry(product.Id);
        insert pricebookEntry;
        Lead lead = TestData.createLead(account5.ID, 'DieselSkandal', 'Test LastName');
        lead.Status = 'New';
        lead.Product_Code__c = product.ProductCode;
        lead.Company = account.Name;
        lead.Availability__c = lead.getSObjectType().getDescribe().fields.getMap().get('Availability__c').getDescribe().getPickListValues()[0].getValue();
        lead.Browser__c = 'Browser';
        lead.Campaign__c = 'Campaign';
        lead.Form_Id__c = 'FormId';
        lead.Insurance__c = account.External_Id__c;
        lead.Legal_Protection_Insurance__c = account2.External_Id__c;
        lead.Vehicle_Brand__c = account3.External_Id__c;
        lead.Partner__c = account4.External_Id__c;
        lead.Bank__c = account6.External_Id__c;
        lead.IP__c = 'IP';
        lead.Location__Latitude__s = 1.123456789012;
        lead.Location__Longitude__s = 2.123456789012;
        lead.Partner_Id__c = 'PartnerId';
        lead.Referrer__c = 'Referrer';
        lead.Second_Email__c = 'second@email.com';
        lead.Second_Phone__c = '12345';
        lead.Unique_Id__c = 'UniqueId';
        lead.Callcenter__c = user.Id;
        lead.Confirmed_terms_and_conditions__c = true;
        lead.Phone = '1234422';        

        System.runAs(TestData.bypassUser()) {
            insert lead;
        }
        
        Test.startTest();
        
        lead = [SELECT ID FROM Lead];
        LeadConversion.convert(new Id[]{lead.Id});

        Test.stopTest();

        // Assert that an Opportunity has been created and has the fields filled out
        // according to the lead and account values.
        lead = [
            SELECT  ID,
                    Name,
                    Company,
                    Account__c,
                    ConvertedOpportunityId,
                    ConvertedContactId,
                    ConvertedAccountId,
                    Availability__c,
                    Browser__c,
                    Campaign__c,
                    Form_Id__c,
                    Insurance__c,
                    IP__c,
                    Location__Latitude__s,
                    Location__Longitude__s,
                    Partner_Id__c,
                    Referrer__c,
                    Return__c,
                    Termination__c,
                    Unique_Id__c,
                    Second_Email__c,
                    Second_Phone__c,
                    Status
            FROM Lead
            //WHERE ID = :lead.ID
        ];
        System.assertEquals('Converted', lead.status);

        Opportunity[] opps = [
            SELECT  ID,
                    Bank__c,
                    Partner__c,
                    RecordTypeId,
                    Follow_up_Period__c,
                    Callcenter__c,
                    Account__c,
                    AccountId,
                    Account.Name,
                    Availability__c,
                    Browser__c,
                    Campaign__c,
                    Form_Id__c,
                    Insurance__c,
                    Legal_Protection_Insurance__c,
                    Vehicle_Brand__c,
                    IP__c,
                    Location__Latitude__s,
                    Location__Longitude__s,
                    Partner_Id__c,
                    Referrer__c,
                    Return__c,
                    Termination__c,
                    Unique_Id__c,
                    (SELECT ID FROM OpportunityLineItems)
            FROM Opportunity
            WHERE ID = :lead.ConvertedOpportunityId
        ];
        System.assertEquals(1, opps.size());
        
        Contact[] contacts = [
            SELECT  ID,
                    Second_Email__c,
                    Second_Phone__c
            FROM Contact
            WHERE ID = :lead.ConvertedContactId
        ];
        System.assertEquals(1, contacts.size());
        
        Contact contact = contacts[0];
        System.assert(contact.Second_Email__c == lead.Second_Email__c);
        System.assert(contact.Second_Phone__c == lead.Second_Phone__c);
        
        Opportunity opportunity = opps[0];
        System.assert(Opportunities.isDieselSkandal(opportunity.RecordTypeId));
        System.assert(opportunity.Follow_up_Period__c == 2);
        System.assert(opportunity.Account.ID == account.Id);
        System.assert(opportunity.Account.Name == lead.Company);
        System.assert(opportunity.Account__c == lead.Account__c);
        System.assert(opportunity.Availability__c == lead.Availability__c);
        System.assert(opportunity.Browser__c == lead.Browser__c);
        System.assert(opportunity.Campaign__c == lead.Campaign__c);
        System.assert(opportunity.Form_Id__c == lead.Form_Id__c);
        System.assert(opportunity.Insurance__c == account.Id);
        System.assert(opportunity.Legal_Protection_Insurance__c == account2.Id);
        System.assert(opportunity.Vehicle_Brand__c == account3.Id);
        System.assert(opportunity.Partner__c == account4.Id);
        System.assert(opportunity.Bank__c == account6.Id);
        System.assert(opportunity.IP__c == lead.IP__c);
        System.assert(opportunity.Location__Latitude__s == lead.Location__Latitude__s);
        System.assert(opportunity.Location__Longitude__s == lead.Location__Longitude__s);
        System.assert(opportunity.Partner_Id__c == lead.Partner_Id__c);
        System.assert(opportunity.Referrer__c == lead.Referrer__c);
        System.assert(opportunity.Return__c == lead.Return__c);
        System.assert(opportunity.Termination__c == lead.Termination__c);
        System.assert(opportunity.Unique_Id__c == lead.Unique_Id__c);
        System.assert(opportunity.OpportunityLineItems.size() == 1);
        System.assert(opportunity.Callcenter__c == user.Id);
    }

    @isTest
    static void testSuccessCloseTasks() {
        TriggerConfiguration.allInactive = true;
        User user = TestData.createUser();
        insert user;
        Account account = TestData.createAccount();
        account.External_Id__c = 'TestID';
        account.Name = 'Testcompany';
        account.Type = 'Lebensversicherung';
        insert account;
        Account account2 = TestData.createAccount();
        account2.External_Id__c = 'TestID2';
        account2.Name = 'Testcompany2';
        account2.Type = 'Rechtsschutzversicherung';
        insert account2;
        Account account3 = TestData.createAccount();
        account3.External_Id__c = 'TestID3';
        account3.Name = 'Testcompany3';
        account3.Type = 'Fahrzeughersteller';
        insert account3;
        Account account4 = TestData.createAccount();
        account4.External_Id__c = 'TestID4';
        account4.Name = 'Testcompany4';
        account4.Type = 'Partner';
        insert account4;
        Account account5 = TestData.createVH24Account();
        insert account5;
        Account account6 = TestData.createAccount();
        account6.External_Id__c = 'TestID6';
        account6.Name = 'Testcompany6';
        account6.Type = 'Kreditinstitut';
        Product2 product = TestData.createProduct();
        product.ProductCode = 'sp001';
        insert product;
        PricebookEntry pricebookEntry = TestData.createPricebookEntry(product.Id);
        insert pricebookEntry;
        Lead lead = TestData.createLead(account5.ID, 'DieselSkandal', 'Test LastName');
        lead.Status = 'New';
        lead.Product_Code__c = product.ProductCode;
        lead.Company = account.Name;
        lead.Availability__c = lead.getSObjectType().getDescribe().fields.getMap().get('Availability__c').getDescribe().getPickListValues()[0].getValue();
        lead.Browser__c = 'Browser';
        lead.Campaign__c = 'Campaign';
        lead.Form_Id__c = 'FormId';
        lead.Insurance__c = account.External_Id__c;
        lead.Legal_Protection_Insurance__c = account2.External_Id__c;
        lead.Vehicle_Brand__c = account3.External_Id__c;
        lead.Partner__c = account4.External_Id__c;
        lead.Bank__c = account6.External_Id__c;
        lead.IP__c = 'IP';
        lead.Location__Latitude__s = 1.123456789012;
        lead.Location__Longitude__s = 2.123456789012;
        lead.Partner_Id__c = 'PartnerId';
        lead.Referrer__c = 'Referrer';
        lead.Second_Email__c = 'second@email.com';
        lead.Second_Phone__c = '12345';
        lead.Unique_Id__c = 'UniqueId';
        lead.Callcenter__c = user.Id;
        lead.Confirmed_terms_and_conditions__c = true;
        lead.Phone = '1234422';        

        System.runAs(TestData.bypassUser()) {
            insert lead;
        }
        Task t;
        List<Task> ts = new List<Task>();
        t = Tasks.build('foo', 'bar', lead, user, System.today().addDays(2), true, false);
        if (t != null) {
            ts.add(t);
        }
        t = Tasks.build('foo2', 'bar2', lead, user, System.today().addDays(2), true, false);
        if (t != null) {
            ts.add(t);
        }
        insert ts;
        ts = [SELECT ID FROM Task WHERE WhoID = :lead.id];
        System.assertEquals(2, ts.size());

        Test.startTest();

        lead = [SELECT ID FROM Lead];
        LeadConversion.convert(new Id[]{lead.Id});

        Test.stopTest();

        ts = [SELECT ID FROM Task WHERE WhoID = :lead.id];
        System.assertEquals(0, ts.size());
        ts = [SELECT ID FROM Task WHERE Subject = 'foo' AND Status <> 'Completed'];
        System.assertEquals(0, ts.size());
		ts = [SELECT ID FROM Task WHERE Subject = 'foo' AND Status = 'Completed'];
        System.assertEquals(1, ts.size());
        ts = [SELECT ID FROM Task WHERE Subject = 'foo2' AND Status <> 'Completed'];
        System.assertEquals(0, ts.size());
		ts = [SELECT ID FROM Task WHERE Subject = 'foo2' AND Status = 'Completed'];
        System.assertEquals(1, ts.size());
    }

    @isTest
    static void testFailure(){
        Account account = TestData.createAccount();
        account.Name = 'Testcompany';
        insert account;
        Product2 product = TestData.createProduct();
        product.ProductCode = 't001';
        insert product;
        Lead lead = TestData.createLead();
        lead.Status = 'Converted';
        lead.Product_Code__c = product.ProductCode;
        lead.Company = account.Name;        
        
        Test.startTest();

        insert lead;
        
        //lead = [SELECT ID FROM Lead];
        //LeadConversion.convert(new Lead[]{lead});

        Test.stopTest();

        // Assert that not Opportunities have been created.
        lead = [SELECT ConvertedOpportunityId FROM Lead];
        Opportunity[] opportunity = [SELECT ID FROM Opportunity WHERE ID = :lead.ConvertedOpportunityId];
        System.assert(opportunity.size() == 0);
    }

    @isTest
    static void testSuccessStageLv() {
        TriggerConfiguration.allInactive = true;
        User user = TestData.createUser();
        insert user;
        Account account = TestData.createAccount();
        account.External_Id__c = 'TestID';
        account.Name = 'Testcompany';
        account.Type = 'Lebensversicherung';
        insert account;
        Account account2 = TestData.createAccount();
        account2.External_Id__c = 'TestID2';
        account2.Name = 'Testcompany2';
        account2.Type = 'Rechtsschutzversicherung';
        insert account2;
        Product2 product = TestData.createProduct();
        product.ProductCode = 'sp001';
        insert product;
        Account account5 = TestData.createVH24Account();
        insert account5;
        PricebookEntry pricebookEntry = TestData.createPricebookEntry(product.Id);
        insert pricebookEntry;
        Lead lead = TestData.createLead(account5.ID, 'DieselSkandal', 'Test LastName');
        lead.RecordTypeId = Leads.lvRtID;
        lead.Status = 'New';
        lead.Company = account.Name;
        lead.Insurance__c = account.External_Id__c;
        lead.Legal_Protection_Insurance__c = account2.External_Id__c;
        lead.Callcenter__c = user.Id;
        lead.Confirmed_terms_and_conditions__c = true;
        lead.Phone = '2222';

        System.runAs(TestData.bypassUser()) {
            insert lead;
        }

        Test.startTest();

        lead = [SELECT ID FROM Lead];
        LeadConversion.convert(new Id[]{lead.Id});

        Test.stopTest();

        lead = [SELECT ConvertedOpportunityId FROM Lead];
        Opportunity[] opps = [SELECT ID, StageName FROM Opportunity WHERE ID = :lead.ConvertedOpportunityId];
        System.assertEquals(1, opps.size());
        Opportunity opp = opps[0];
        System.assertNotEquals('On Hold', opp.StageName); // https://salesfive.atlassian.net/jira/software/projects/VH24/boards/25?selectedIssue=VH24-48
    }
}