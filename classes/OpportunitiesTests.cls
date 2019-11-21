@isTest
public class OpportunitiesTests {
    @isTest
    private static void testRecordTypes() {
        System.assert(!Opportunities.isDieselSkandal(null));
        System.assert(!Opportunities.isFinanzierung(null));
        System.assert(!Opportunities.isLebensversicherung(null));
            
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        
        // DK
        RecordType rt = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Dieselskandal' AND SObjectType = 'Opportunity'
        ];
        o.recordTypeId = rt.ID;
        insert o;
        
        o = [SELECT RecordTypeID FROM Opportunity];
        System.assert(Opportunities.isDieselSkandal(o.recordTypeID));
        System.assert(!Opportunities.isFinanzierung(o.recordTypeID));
        System.assert(!Opportunities.isLebensversicherung(o.recordTypeID));
        
        // FZ
        rt = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Finanzierung' AND SObjectType = 'Opportunity'
        ];
        o.recordTypeId = rt.ID;
        update o;
        
        o = [SELECT RecordTypeID FROM Opportunity];
        System.assert(!Opportunities.isDieselSkandal(o.recordTypeID));
        System.assert(Opportunities.isFinanzierung(o.recordTypeID));
        System.assert(!Opportunities.isLebensversicherung(o.recordTypeID));
        
        // LV
        rt = [
            SELECT ID
            FROM RecordType
            WHERE DeveloperName = 'Lebensversicherung' AND SObjectType = 'Opportunity'
        ];
        o.recordTypeId = rt.ID;
        update o;
        
        o = [SELECT RecordTypeID FROM Opportunity];
        System.assert(!Opportunities.isDieselSkandal(o.recordTypeID));
        System.assert(!Opportunities.isFinanzierung(o.recordTypeID));
        System.assert(Opportunities.isLebensversicherung(o.recordTypeID));
    }

    @isTest
    private static void testCreateAccountOnInsert() {
        Opportunity o1 = TestData.createOpportunity(null, 'On Hold');
        o1.name = 'o1';
        Opportunity o2 = TestData.createOpportunity(null, 'On Hold');
        o2.name = 'o2';
        insert new Opportunity[]{o1, o2};

		Opportunity[] oo = [SELECT Name, Account.ID, Account.Name FROM Opportunity];
        for (Opportunity o: oo) {
            System.assertEquals(o.name, o.account.name);
            System.assertNotEquals(null, o.account.ID);
        }

        // Opps with the same name are not treated correctly currently, they all use the last account created  
        Opportunity o3 = TestData.createOpportunity(null, 'On Hold');
        o3.name = 'o3';
        Opportunity stillO3 = TestData.createOpportunity(null, 'On Hold');
        stillO3.name = 'o3';
        insert new Opportunity[] { o3, stillO3 };

		oo = [SELECT Name, Account.ID, Account.Name FROM Opportunity WHERE Name = 'o3'];
        String aName = oo[0].account.name;
        for (Opportunity o: oo) {
            System.assertEquals(aName, o.account.name);
            System.assertNotEquals(null, o.account.ID);
        }
    }

    @isTest
    private static void testSetDateStampOnInsertAndUpdate() {
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    
        }
        Opportunity o1 = TestData.createOpportunity(null, 'On Hold');
        o1.name = 'o1';
        o1.Callcenter__c = u.Id;
        Opportunity o2 = TestData.createOpportunity(null, 'Lost');
        o2.name = 'o2';
        o2.reason_for_loss__c = 'Potential zu gering';
        insert new Opportunity[]{o1, o2};

        Opportunity[] oo = [SELECT Name, Set_To_On_Hold_Date__c, Set_To_Lost_Date__c FROM Opportunity];
        for (Opportunity o: oo) {
            if (o.name == 'o1') {
                System.assertEquals(Date.today(), o.set_To_On_Hold_Date__c);
                continue;
            }
            
            if (o.name == 'o2') {
                System.assertEquals(Date.today(), o.set_To_Lost_Date__c);
                continue;
            }
        }
        
        // Update
        o1.stageName = 'Claim';
        o1.backoffice__c = u.ID;
        o2.stageName = 'Check';
        o2.backoffice__c = u.ID;
        
        Test.startTest();
        update new Opportunity[]{o1, o2};
		Test.stopTest();
        
        oo = [SELECT Name, Set_To_Claim_Date__c, Set_To_Check_Date__c FROM Opportunity];
        for (Opportunity o: oo) {
            if (o.name == 'o1') {
                System.assertEquals(Date.today(), o.set_To_Claim_Date__c);
                continue;
            }
            
            if (o.name == 'o2') {
                System.assertEquals(Date.today(), o.set_To_Check_Date__c);
                continue;
            }
        }
        
        o1.stageName = 'New';
        update o1;
        oo = [SELECT Name, set_To_Check_Date__c, Set_To_New_Date__c FROM Opportunity];
        for (Opportunity o: oo) {
            if (o.name == 'o1') {
                System.assertEquals(Date.today(), o.set_To_New_Date__c);
                continue;
            }
            
            if (o.name == 'o2') {
                System.assertEquals(Date.today(), o.set_To_Check_Date__c);
                continue;
            }
        }        
    }
    
    @isTest
    public static void testSetUniqueID() {
        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        insert o;
        
        o = [SELECT Id, Token__c FROM Opportunity WHERE Id = :o.Id];
        
        System.assert(o.Token__c != null);
    }
    
    @isTest
    private static void testSetAssignmentTypeOnInsertAndUpdate() {
        Opportunity o1 = TestData.createOpportunity(null, 'On Hold');
        o1.name = 'o1';
        Account a = TestData.createLegalProtection();
        insert a;
        o1.assignment_Type__c = null;
        o1.Legal_Protection_Insurance__c = a.ID;

        Opportunity o2 = TestData.createOpportunity(null, 'Lost');
        o2.name = 'o2';
        o2.reason_for_loss__c = 'Potential zu gering';
        o2.confirmed_Terms_And_Conditions__c = true;
        o2.assignment_Type__c = null;
        o2.has_Legal_Protection_Insurance__c = false;

        Opportunity o3 = TestData.createOpportunity(null, 'On Hold');
        o3.name = 'o3';
        o3.legal_Protection_Insurance__c = null;
        o3.confirmed_Terms_And_Conditions__c = true;
        o3.assignment_Type__c = null;
        o3.has_Legal_Protection_Insurance__c = true;
        insert new Opportunity[]{o1, o2, o3};

        Opportunity[] oo = [
            SELECT  Name,
                    Has_Legal_Protection_Insurance__c,
                    Assignment_Type__c 
            FROM Opportunity
        ];
        for (Opportunity o: oo) {
            if (o.name == 'o1') {
                System.assert(o.has_Legal_Protection_Insurance__c);
                System.assertEquals('RSV', o.assignment_Type__c);
                continue;
            }
            if (o.name == 'o2') {
                System.assertEquals('Share', o.assignment_Type__c);
                continue;
            }
            if (o.name == 'o3') {
                System.assertEquals('RSV', o.assignment_Type__c);
                continue;
            }
        }
    }
    
    @isTest
    private static void testSetHashOnInsertAndUpdate() {
        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        insert o;
        
        Opportunity[] oo = [SELECT Form_Hash_1__c FROM Opportunity];
        System.assert(!oo.isEmpty());
        System.assert(String.isNotBlank(oo[0].form_Hash_1__c));
        
        // Updated
        oo[0].form_Hash_1__c = null;
        update oo;
        
        oo = [SELECT Form_Hash_1__c FROM Opportunity];
        System.assert(!oo.isEmpty());
        System.assert(String.isNotBlank(oo[0].form_Hash_1__c));
    }
    
    
    @isTest
    private static void testSetLegalUsersOnInsertAndUpdate() {
        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        o.recordTypeID = Opportunities.finanzierungRecordType();
        o.sales_Type__c = 'Online';
        insert o;

        o = [SELECT Legal__c FROM Opportunity];
        // System.assertEquals(Users.kainzLegal(), o.legal__c);
        
        // Update
        // LV
        o.legal__c = null;
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        update o;

        o = [SELECT Legal__c FROM Opportunity];
        //System.assertEquals(Users.JHeinrichLegal(), o.legal__c);
        
        // DG
        o.legal__c = null;
        o.recordTypeId = Opportunities.dieselSkandalRecordType();
        update o;

        o = [SELECT Legal__c FROM Opportunity];
        // System.assertEquals(Users.lachmairLegal(), o.legal__c);

        Account a = TestData.createVH24Account();
        insert a;
        o.account__c = a.ID;
        update o;

        o.legal__c = null;
        update o;
        
        o = [SELECT Legal__c FROM Opportunity];
       // System.assertEquals(Users.kainzLegal(), o.legal__c);
    }
    
    
    @isTest
    private static void testSetLegalAccountOnInsertAndUpdate() {
        Account a = TestData.createAccount();
        insert a;

        User u = TestData.legalUser();
        u.account_Id__c = a.ID;
        System.runAs(TestData.bypassUser()) {
            insert u;
        }

        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        o.legal__c = u.ID;
        o.legal_Account__c = null;
        insert o;
        
        o = [SELECT Legal_Account__c FROM Opportunity];
        //System.assertEquals(a.ID, o.legal_Account__c);
        
        // Update
        o.legal__c = null;
        update o;

        // Legal will be set before LegalAccount is
        u = [SELECT Account_Id__c FROM User WHERE ID = :Users.lachmairLegal()];
        o = [SELECT Legal_Account__c FROM Opportunity];
        //System.assertEquals(u.account_Id__c, o.legal_Account__c);
    }
    
    @isTest
    private static void testSetPartnerOnInsert() {
        Account a = TestData.createAccount();
        a.external_Id__c = '119289';
        insert a;

        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        o.partner_Id__c = a.external_Id__c;
        o.partner__c = null;
        insert o;
        
        o = [SELECT Partner__c FROM Opportunity];
        System.assertEquals(a.ID, o.partner__c);
    }
    
    @isTest
    private static void testSetLegalProcessTypeOnInsertAndUpdate() {
        Account a = TestData.createAccount();
        a.legal_Process_Type__c = 'Internal';
        insert a;

        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        o.legal_Account__c = a.ID;
        insert o;
        
        o = [SELECT Legal_Process_Type__c FROM Opportunity];
        System.assertEquals(a.legal_Process_Type__c, o.legal_Process_Type__c);
        
        // Update
        o.legal_Account__c = null;
        update o;
        
        // Changes nothing
        o = [SELECT Legal_Process_Type__c FROM Opportunity];
        System.assertEquals(a.legal_Process_Type__c, o.legal_Process_Type__c);
    }
    
    @isTest
    private static void testSetDecimalFieldsOnInsertAndUpdate() {
        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        // todo: too much setup, a lot of formula fields
        // o.amount_In_Dispute__c = 1200;
        // o.compensation_For_Use__c = 1200;
        o.purchase_Price__c = 1200;
        insert o;
        
        o = [
            SELECT Amount_In_Dispute_Clean__c,
            Compensation_For_Use_Clean__c,
            Purchase_Price_Clean__c
            FROM Opportunity
        ];
        System.assert(!String.isBlank(o.amount_In_Dispute_Clean__c));
        System.assert(!String.isBlank(o.compensation_For_Use_Clean__c));
        System.assertEquals('1.200,00 €', o.purchase_Price_Clean__c);
        
        // Update
        o.purchase_Price__c = 1300;
        update o;
        
        o = [
            SELECT  Amount_In_Dispute_Clean__c,
                    Compensation_For_Use_Clean__c,
                    Purchase_Price_Clean__c
            FROM Opportunity
        ];
        System.assertEquals('1.300,00 €', o.purchase_Price_Clean__c);
    }

    
    @isTest
    private static void testCreateObjectsCorrespondenceKeep() {
	    TriggerConfiguration.allInactive = true;

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    
        }
        
        Opportunity o = TestData.createOpportunity(null, 'Check');
        o.backoffice__c = u.ID;
        o.confirmed_Terms_And_Conditions__c = true;
        o.legal__c = u.ID;
        o.assignment_Type__c = 'RSV';
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Lawsuit_Date__c = System.today()
        );
        insert c;

        Correspondence__c[] crr = [
            SELECT ID FROM Correspondence__c
            WHERE Description__c = 'Wechsel Anspruchstyp zu "Behalten"'
        ];
        System.assertEquals(0, crr.size());
        
        // Update
        o.stageName = 'Claim';
        o.Process_Type__c = 'DG_Keep';
        update o;
		TriggerConfiguration.allInactive = false;
        crr = [
            SELECT ID FROM Correspondence__c
            WHERE Description__c = 'Wechsel Anspruchstyp zu "Behalten"'
        ];
        System.assertEquals(0, crr.size());
    }

    @isTest
    private static void testCreateObjectsCorrespondenceReturn() {
	    TriggerConfiguration.allInactive = true;

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    
        }
        
        Opportunity o = TestData.createOpportunity(null, 'Check');
        o.backoffice__c = u.ID;
        o.confirmed_Terms_And_Conditions__c = true;
        o.legal__c = u.ID;
        o.assignment_Type__c = 'RSV';
        o.Process_Type__c = 'DG_Keep';
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Lawsuit_Date__c = System.today()
        );
        insert c;

        Correspondence__c[] crr = [
            SELECT ID FROM Correspondence__c
            WHERE Description__c = 'Wechsel Anspruchstyp von "Behalten"'
        ];
        System.assertEquals(0, crr.size());
        
        // Update
        o.stageName = 'Claim';
        o.Process_Type__c = 'DG_Return';
        update o;
        TriggerConfiguration.allInactive = false;

        crr = [
            SELECT ID FROM Correspondence__c
            WHERE Description__c = 'Wechsel Anspruchstyp von "Behalten"'
        ];
        System.assertEquals(0, crr.size());
    }
	
    @isTest
    private static void testCreateObjectsClaimFZ() {
	    TriggerConfiguration.allInactive = true;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    

            Opportunity o = TestData.createOpportunity(null, 'Check');
            o.backoffice__c = u.ID;
            o.confirmed_Terms_And_Conditions__c = true;
            o.legal__c = u.ID;
            o.assignment_Type__c = 'RSV';
            o.recordTypeId = Opportunities.finanzierungRecordType();
            insert o;
            TriggerConfiguration.allInactive = false;

            Claim__c[] cc = [SELECT ID FROM Claim__c];
            System.assertEquals(0, cc.size());

            // Update
            o.stageName = 'Claim';
            update o;

            cc = [SELECT ID FROM Claim__c];
            System.assertEquals(1, cc.size());
        }
    }
	
    @isTest
    private static void testCreateObjectsInvoice() {
	    TriggerConfiguration.allInactive = true;

        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    
        }
        
        Opportunity o = TestData.createOpportunity(null, 'Check');
        o.backoffice__c = u.ID;
        o.confirmed_Terms_And_Conditions__c = true;
        o.legal__c = u.ID;
        o.assignment_Type__c = 'RSV';
        insert o;
        Claim__c c = new Claim__c(
            Opportunity__c = o.Id,
            Lawsuit_Date__c = System.today()
        );
        insert c;
        TriggerConfiguration.allInactive = false;
        
        // Update
        o.stageName = 'Claim';
        update o;
        
        o.recordTypeId = Opportunities.lebensversicherungRecordType();
        update o;
        
        o.partial_Refund__c = 1000;
        update o;
        Invoice__c[] ii = [SELECT ID FROM Invoice__c];
        System.assertEquals(1, ii.size());
    }
    
    @isTest
    private static void testCalculateRevenueOnInsertAndUpdate() {
        // todo: more thorough
        TriggerConfiguration.allInactive = true;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;

            Opportunity o = TestData.createOpportunity(null, 'On Hold');
            o.potential__c = 1000;
            insert o;

            Product2 p = TestData.createProduct();
            insert p;
            PriceBookEntry pbe = TestData.createPricebookEntry(p.ID);
            insert pbe;

            OpportunityLineItem oli = TestData.createOpportunityLineItem(o.ID, pbe.ID, 1500);
            insert oli;

            // Update
            o.potential__c = 5000;
            update o;

            OpportunityLineItem[] olis = [SELECT TotalPrice FROM OpportunityLineItem];
            // System.assertNotEquals(0, olis[0].totalPrice); // todo: check calculation logic
        }
    }
    
    @isTest
    private static void testProcessLostOnInsertAndUpdate() {
        TriggerConfiguration.allInactive = true;
        User u = TestData.legalUser();
        Claim__c c = ClaimsTests.buildClaim(u, null, 0, null, null);

        Test.startTest();
        insert c;
        Test.stopTest();

		Opportunity o = [SELECT RecordTypeID FROM Opportunity];
        o.stageName = 'Lost';
        o.reason_For_Loss__c = 'Kunde will nicht';
        update o;
    }
    
    @isTest
    private static void testSetContactLastOpportunity() {
        Account a = TestData.createAccount();
        insert a;
        Contact c = TestData.createContact(a.ID);
        insert c;
        
        Opportunity o = TestData.createOpportunity(null, 'On Hold');
        o.contact__c = c.ID;
        insert o;
        
        c = [SELECT Last_Opportunity__c FROM Contact];
        System.assertEquals(o.ID, c.last_Opportunity__c);
        
        o.contact__c = null;
        update o;
        
        // Update
        c = TestData.createContact(a.ID);
        c.firstName = '2';
        insert c;

		Logger.debug('updating');        
        o.contact__c = c.ID;
        update o;
        
        c = [SELECT Last_Opportunity__c FROM Contact WHERE FirstName = '2'];
        System.assertEquals(o.ID, c.last_Opportunity__c);
    }
    
    private static Opportunity createOpp(ID ownerID) {
        Account a = TestData.createAccount();
        insert a;
        Opportunity o = TestData.createOpportunity(a.ID, 'New');
        o.ownerID = ownerID;
        insert o;
        
        return o;
    }
    
	@isTest
    private static void testEmptyDefaultOwner() {
        User u = TestData.createUser();
        u.username = 'reassignIf@bla.com';
        insert u;
        
        // Do not reassign if no DEFAULT_OWNER
        GeneralSettings.DEFAULT_OWNER = null;
        GeneralSettings.REASSIGN_IF_OWNERS = u.ID;
        
        User ou = TestData.createUser();
        ou.username = 'firstOwner@bla.com';
        insert ou;

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(ou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(ou.ID, o.OwnerID);
    }
    
    @isTest
    private static void testUnknownDefaultOwner() {
        User u = TestData.createUser();
        u.username = 'reassignIf@bla.com';
        insert u;
        
        // Do not reassign if no DEFAULT_OWNER
        GeneralSettings.DEFAULT_OWNER = '19281298912';
        GeneralSettings.REASSIGN_IF_OWNERS = u.ID;
        
        User ou = TestData.createUser();
        ou.username = 'firstOwner@bla.com';
        insert ou;

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(ou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(ou.ID, o.OwnerID);
    }
    
    @isTest
    private static void testEmptyReassignIfOwner() {
        User u = TestData.createUser();
        u.username = 'defaultOwner@bla.com';
        insert u;
        
        // Do not reassign if no REASSIGN_IF_OWNERS
        GeneralSettings.DEFAULT_OWNER = u.ID;
        GeneralSettings.REASSIGN_IF_OWNERS = null;
        
        User ou = TestData.createUser();
        ou.username = 'firstOwner@bla.com';
        insert ou;

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(ou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(ou.ID, o.OwnerID);
    }
    
    @isTest
    private static void testInactiveReassignIfOwner() {
        User u = TestData.createUser();
        u.username = 'defaultOwner@bla.com';
        User inactiveu = TestData.createUser();
        u.username = 'inactive@bla.com';
        u.isActive = false;
        insert new User[]{u, inactiveu};
        
        // Do not reassign if REASSIGN_IF_OWNERS is not an active user
        GeneralSettings.DEFAULT_OWNER = u.ID;
        GeneralSettings.REASSIGN_IF_OWNERS = inactiveu.ID;
        
        User ou = TestData.createUser();
        ou.username = 'firstOwner@bla.com';
        insert ou;

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(ou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(ou.ID, o.OwnerID);
    }

    @isTest
    private static void testNoReassignmentWhenNoMatchingOwner() {
        User dou = TestData.createUser();
        dou.username = 'defaultOwner@bla.com';

        User fou = TestData.createUser();
        fou.username = 'firstOwner@bla.com';
        
        User lou = TestData.createUser();
        lou.username = 'oppOwner@bla.com';

        insert new User[]{dou, fou, lou};

        // Do _not_ reassign opp if the current opp owner if not the one set in REASSIGN_IF_OWNERS.
        GeneralSettings.DEFAULT_OWNER = dou.username;
        GeneralSettings.REASSIGN_IF_OWNERS = fou.username + ';alkslaks@lakslk.com';

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(lou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(lou.ID, o.OwnerID);
    }

    @isTest
    private static void testReassignment() {
        User du = TestData.createUser();
        du.username = 'defaultOwner@bla.com';

        User ou = TestData.createUser();
        ou.username = 'firstOwner@bla.com';

        insert new User[]{du, ou};

        // Reassign opp to DEFAULT_OWNER if REASSIGN_IF_OWNERS is the current owner of the opp
        // and DEFAULT_OWNER is a valid user.
        GeneralSettings.DEFAULT_OWNER = du.username;
        GeneralSettings.REASSIGN_IF_OWNERS = 'alkslaks@lakslk.com;' + ou.username;

        Opportunity o;
        Test.startTest();
        System.runAs(TestData.bypassUser()) {
        	o = createOpp(ou.ID);   
        }
        Test.stopTest();
        
        o = [SELECT ID, OwnerID, Owner.username FROM Opportunity WHERE ID = :o.ID];
        System.assertEquals(du.ID, o.OwnerID);
    }
}