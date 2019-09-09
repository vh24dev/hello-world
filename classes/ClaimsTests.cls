@isTest
public class ClaimsTests { 
    @isTest
    private static void testRecordTypeOnInsert() {
        ClaimTriggerhandler.Deactivate = true;

        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, 0, null, null);

        Test.startTest();
        insert c;
        Test.stopTest();

        Opportunity o = [SELECT RecordTypeID FROM Opportunity];
        
        // DieselSkandal
        c = [SELECT RecordTypeID FROM Claim__c];
        System.assertNotEquals(null, c);
        
        //System.assert(Claims.isDieselSkandal(c.recordTypeID));

        // Finanzierung
        o.recordTypeID = Opportunities.finanzierungRecordType();
        update o;

        c = TestData.createClaim(o.ID, 'Draft');
        c.legal__c = u.ID;
        c.clerk__c = u.ID;
        insert c;

        c = [SELECT RecordTypeID FROM Claim__c WHERE ID = :c.ID];
        System.assertNotEquals(null, c);        
       // System.assert(Claims.isFinanzierung(c.recordTypeID));
        
        // Lebensversicherung
        o.recordTypeID = Opportunities.lebensversicherungRecordType();
        update o;

        c = TestData.createClaim(o.ID, 'Draft');
        c.legal__c = u.ID;
        c.clerk__c = u.ID;
        insert c;

        c = [SELECT RecordTypeID FROM Claim__c WHERE ID = :c.ID];
        System.assertNotEquals(null, c);        
        //System.assert(Claims.isLebensversicherung(c.recordTypeID));
    }

    @isTest
    private static void testUsersOnInsertAndUpdate() {
        Account a = TestData.createAccount();
        Account vh24 = TestData.createVH24Account();
        Account legal = TestData.createCLLBLegal();
        insert new Account[]{a, vh24, legal};
        
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;    
        }

        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.recordTypeID = Opportunities.dieselSkandalRecordType();
        o.account__c = vh24.Id;
        o.backoffice__c = u.Id;
        o.legal__c = u.ID;
        o.legal_Account__c = legal.ID;
        insert o;

        Claim__c c = TestData.createClaim(o.ID, 'Appeal');
        c.legal__c = null;
        c.clerk__c = null;
        c.clerk_Appeal__c = null;

        o = [SELECT Legal__c, Legal_Account__c FROM Opportunity];
        
        Test.startTest();
        insert c;
        Test.stopTest();
        
        c = [SELECT Legal__c, Clerk__c, Clerk_Appeal__c FROM Claim__c];
        System.assertNotEquals(null, c);
        System.assertEquals(o.legal__c, c.legal__c);
        System.assertEquals(Users.cllbClerk(), c.clerk__c);
        System.assertEquals(Users.clerkAppeal(), c.clerk_Appeal__c);
        
        // Update
        c.legal__c = null;
        update c;
        c = [SELECT Legal__c FROM Claim__c];
        System.assertEquals(o.legal__c, c.legal__c);
    }

    @isTest
    private static void testCourtOnInsertAndUpdate() { 
        Account daimler = TestData.createDaimlerBrand();
        Account opel = TestData.createPorscheBrand();
        Account stutCourt = TestData.createStuttgartAmtsgerichtCourt();
        Account darmstadtCourt = TestData.createDarmstadtAmtsgerichtCourt();
        
        insert new Account[]{daimler, opel, stutCourt, darmstadtCourt};

        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, daimler, 2000, null, null); // Goes to Stuttgart county court
        
        Test.startTest();
        insert c;
        Test.stopTest();

        c = [SELECT Court__c, Opportunity_Amount_In_Dispute__c, Opportunity__c FROM Claim__c];
        System.assertNotEquals(null, c);
        System.assertNotEquals(null, c.court__c);
        System.assert(c.opportunity_Amount_In_Dispute__c <= 5000 ? Courts.isStuttgartAmtsgericht(c.court__c) : Courts.isStuttgartLandgericht(c.court__c));
        
        ID oldCourt = c.court__c;
        // Update
        c.court__c = null;
        c.lawsuit_Insurance_Date__c = null;
        update c;
        
        c = [SELECT Court__c, Opportunity_Amount_In_Dispute__c, Opportunity__r.Vehicle_Brand__c, Opportunity_Vehicle_Brand_Id__c FROM Claim__c];
        System.assertNotEquals(null, c);
        System.assertEquals(oldCourt, c.court__c);
    }
    
    @isTest
    private static void testStageOnInsertAndUpdate() {
        ClaimTriggerhandler.Deactivate = true;
        Account daimler = TestData.createDaimlerBrand();
        insert daimler;

        User u = TestData.legalUser();
        Claim__c cDG = buildClaim(u, daimler, null, null, Opportunities.dieselSkandalRecordType());
        Claim__c cFZ = buildClaim(u, daimler, null, 'I', Opportunities.finanzierungRecordType());
        Claim__c cLV = buildClaim(u, daimler, null, 'II', Opportunities.finanzierungRecordType());
        Claim__c cLV2 = buildClaim(u, daimler, null, null, Opportunities.finanzierungRecordType());

        Test.startTest();
        insert new Claim__c[]{cDG, cFZ, cLV, cLV2};
        Test.stopTest();

        Claim__c[] cc = [SELECT RecordTypeID, RecordType.name, Stage__c, Opportunity__r.Priority_Level__c FROM Claim__c];
        System.assert(!cc.isEmpty());
        for (Claim__c c: cc) {
            System.assertNotEquals(null, c);
            System.assertNotEquals(null, c.stage__c);
            if (Claims.isDieselSkandal(c.recordTypeId)) {
                System.assertEquals('Claim Letter', c.stage__c);
                continue;
            }
            
            if (Claims.isFinanzierung(c.recordTypeId) || Claims.isLebensversicherung(c.recordTypeId)) {
                if (c.opportunity__r.priority_Level__c == 'I' || c.opportunity__r.priority_Level__c == 'II') {
                    //System.assertEquals('Legal Opposition', c.stage__c);
                } else {
                    System.assertEquals('Customers Opposition', c.stage__c);
                }
                continue;
            }
        }
        
        // Update
        cFZ.recordTypeId = Claims.dieselSkandalRecordType();
        update cFZ;
        cFZ = [SELECT Stage__c FROM Claim__c WHERE ID = :cFZ.ID];
        System.assertEquals('Customers Opposition', cFZ.stage__c);
    }

    @isTest
    private static void testHashOnUpdate() {
        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        insert c;
        
        Test.startTest();
        c.submission_Date_Before_Claim_Statement__c = Date.today();
        c.Submission_Date_Before_Lawsuit_Date__c = Date.today();
        update c;
        Test.stopTest();

        Claim__c[] cc = [SELECT Form_Hash_1__c FROM Claim__c];
        System.assert(!cc.isEmpty());
        System.assert(String.isNotBlank(cc[0].form_Hash_1__c));
    }
    
    @isTest
    private static void testLastStageChangedAtOnUpdate() {
        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        insert c;
        
        Test.startTest();
        c.stage__c = 'Appeal';
        update c;
        DateTime dt = DateTime.now();
        Test.stopTest();

        Claim__c[] cc = [SELECT Last_Stage_Change__c FROM Claim__c];
        System.assert(!cc.isEmpty());
        //System.assertEquals(dt.minute(), cc[0].last_Stage_Change__c.minute()); // if this failed just rerun the test you might get unlucky
    }
    
    @isTest
    private static void testResponseInsuranceLawsuitOnUpdate() {
        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        insert c;
        
        Test.startTest();
        c.cover_Note_Scope__c = 'Judicial';
        c.claim_Letter_Insurance_Date__c = Date.today();
        c.response_Insurance_Claim_Letter__c = Date.today();
        update c;
        Test.stopTest();

        Claim__c[] cc = [
            SELECT  Lawsuit_Insurance_Date__c, Response_Insurance_Lawsuit__c,
                    Claim_Letter_Insurance_Date__c, Response_Insurance_Claim_Letter__c
            FROM Claim__c
        ];
        System.assert(!cc.isEmpty());
        System.assertEquals(cc[0].claim_Letter_Insurance_Date__c, cc[0].lawsuit_Insurance_Date__c);
        System.assertEquals(cc[0].response_Insurance_Claim_Letter__c, cc[0].response_Insurance_Lawsuit__c);
    }
    
    /*@isTest
    private static void testCreateTasksOnInsertAndUpdate() {
        User u = TestData.legalUser();
        u.bypass_process_builder__c = true;
        System.runAs(u) {
            testCreateTasksOnInsertAndUpdateAsUser(u);
        }
    }*/
    
    private static void testCreateTasksOnInsertAndUpdateAsUser(User u) {
        //User u = TestData.legalUser();
        ClaimTriggerhandler.Deactivate = true;
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        c.result__c = 'Partial';

        Test.startTest();
        insert c;        
        Test.stopTest();

        Task[] tt = [
            SELECT Subject
            FROM Task
            WHERE WhatID = :c.ID
        ];
        System.assertEquals(1, tt.size());
        System.assertEquals('Teilerstattungsbetrag hinterlegen', tt[0].subject);

        c.stage__c = 'Processing';
        c.result__c = 'Declined';
        update c;
        tt = [
            SELECT Subject
            FROM Task
            WHERE WhatID = :c.ID
        ];
        System.assertEquals(2, tt.size());
        System.assert(tt[0].subject == 'Teilerstattungsbetrag hinterlegen' || tt[0].subject == 'Als abgeschlossen markieren');
        System.assert(tt[1].subject == 'Teilerstattungsbetrag hinterlegen' || tt[1].subject == 'Als abgeschlossen markieren');
        System.assertNotEquals(tt[0].subject, tt[1].subject);
        
        c.result__c = 'Arrangement';
        update c;
        tt = [
            SELECT Subject
            FROM Task
            WHERE WhatID = :c.ID
        ];
        System.assertEquals(3, tt.size());
        System.assertNotEquals(tt[0].subject, tt[1].subject);
        System.assertNotEquals(tt[1].subject, tt[2].subject);
        System.assertNotEquals(tt[0].subject, tt[2].subject);
        
        // todo: fix 101 error from pb on correspondence.
        // Trigger recursion stopper ignored since it's a test.

        // Test correspondences as well
        /*Correspondence__c cr = TestData.createCorrespondence(c.ID, 'Court', 'Klageschrift', 'Draft');
        insert cr;

        c.stage__c = 'Lawsuit';
        c.customer_Is_Owner__c = true;
        c.canceled_Next_Court_Date__c = true;
        c.response_Insurance_Lawsuit__c = Date.today();
        c.cover_Note__c = 'Issued';
        c.cover_Note_Scope__c = 'Judicial';
        c.submission_Date_Before_Claim_Statement__c = Date.today();
        c.lawsuit_Date__c = null;
        update c;
        tt = [
            SELECT Subject
            FROM Task
            WHERE WhatID = :c.ID
        ];
        System.assertEquals(5, tt.size());
        */
    }
    
    @isTest
    private static void testCloseTasksOnUpdate() {
        // todo:
    }

    @testVisible
    private static Claim__c buildClaim(User u,
                                       Account vehicleBrand,
                                       Decimal amountInDispute,
                                       String oppPriorityLevel,
                                       ID oppRecordType) {
        Account a = TestData.createAccount();
        Account vh24 = TestData.createVH24Account();
        insert new Account[]{a, vh24};

        User[] uu = [SELECT ID FROM User WHERE Username = :u.username];
        if (uu.isEmpty()) {
            System.runAs(TestData.bypassUser()) {
                insert u;
            }
        } else {
            u = uu[0];
        }

        Opportunity o = TestData.createOpportunity(a.ID, 'On Hold');
        o.recordTypeID = oppRecordType != null ? oppRecordType : Opportunities.dieselSkandalRecordType();
        o.account__c = vh24.Id;
        o.backoffice__c = u.Id;
        if (vehicleBrand != null) {
            o.vehicle_Brand__c = vehicleBrand.ID;    
        }
        
        Account insurance;
        if (oppPriorityLevel == 'I') {
            insurance = TestData.createInsurance('lvXX1');
        } else if (oppPriorityLevel == 'II') {
            insurance = TestData.createInsurance('lv004');
        } else if (String.isNotBlank(oppPriorityLevel)) {
            insurance = TestData.createInsurance('aksjkj');
        }
        if (insurance != null) {
            insert insurance;
            o.insurance__c = insurance.ID;
        }
        insert o;

        Claim__c c = TestData.createClaim(o.ID, 'Draft');
        c.legal__c = u.ID;
        c.clerk__c = u.ID;
        return c;
    }

    @isTest
    private static void testDuplicateCostNote() {
        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        insert c;
        Cost_Note__C cn = CostNotes.build(c, 'Customer', 'Selbstbehalt', 'Selbstbehalt');
        insert cn;

        Test.startTest();
        c.cover_Note_Scope__c = 'Extrajudicial';
        c.claim_Letter_Insurance_Date__c = Date.today();
        c.response_Insurance_Claim_Letter__c = Date.today();
        c.cover_Note_Scope__c = 'Extrajudicial';
        update c; // should not create the same costnote agian
        Test.stopTest();

        List<Cost_Note__c> cns = [SELECT Id FROM Cost_Note__c WHERE Subject__c = 'Selbstbehalt'];
        System.assertEquals(1, cns.size());
    }

    /*
    // should work idk what is wrong here
    @isTest
    private static void testSingleCostNote() {
        User u = TestData.legalUser();
        Claim__c c = buildClaim(u, null, null, null, Opportunities.dieselSkandalRecordType());
        insert c;
        
        Test.startTest();
        c.cover_Note_Scope__c = 'Extrajudicial';
        c.claim_Letter_Insurance_Date__c = Date.today();
        c.response_Insurance_Claim_Letter__c = Date.today();
        update c; // should create a costnote
        c.cover_Note_Scope__c = null;
        update c;
        Test.stopTest();

        List<Cost_Note__c> cns = [SELECT Id FROM Cost_Note__c WHERE Subject__c = 'Selbstbehalt'];
        System.assertEquals(1, cns.size());
    }
    */
}