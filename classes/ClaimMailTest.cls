@isTest
public class ClaimMailTest {
    @testSetup
    public static void SetupTheThings() {
        TriggerConfiguration.allInactive = true;
        Test.startTest();
        Account a = new Account(Name = 'VH24');
        insert a;
        Contact con = new Contact(
            LastName = 'bar',
            Email = 'foo@bar.baz'
        );
        insert con;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Contact__c = con.Id;
        User u = TestData.legalUser();
        System.runAs(TestData.bypassUser()) {
            insert u;
        }
        o.Legal__c = u.Id;
        o.Backoffice__c = u.Id;
        insert o;
        Test.stopTest();
    }

	private static id setLegal(string legalName, string department) {
        return setLegalX(legalName, department);
    }

    private static id setLegal(string legalName) {
        return setLegalX(legalName, 'Heinrich Jäger - DG & FZ');
    }

    private static id setLegalX(string legalName, string department) {
        TriggerConfiguration.allInactive = true;
        opportunity o = [SELECT ID, Legal__c FROM Opportunity][0];
        Account a = new Account(
            name = legalName,
            Department__c = department
        );
        insert a;
        o.Legal_Account__c = a.Id;
        update o;
        return o.Legal__c;
    }

    /* * * * * * * * *
     * Dieselskandal *
     * * * * * * * * */

    // == On Hold ==

    // Issued

    @isTest
    public static void testDGOnHoldIssuedJCLegal() {
        id uId = setLegal('J & C Anwälte');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uID
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldIssued21Legal() {
        id uId = setLegal('21Legal GmbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uid
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldIssuedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldIssuedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uid
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldIssuedLachmair() {
        id uId = setLegal('Rechtsanwälte Lachmair & Kollegen');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    // Refused

    @isTest
    public static void testDGOnHoldRefusedJCLegal() {
        id uId = setLegal('J & C Anwälte');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldRefused21Legal() {
        id uId = setLegal('21Legal GmbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldRefusedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldRefusedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGOnHoldRefusedLachmair() {
        id uId = setLegal('Rechtsanwälte Lachmair & Kollegen');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    // == Lawsuit ==

    /*
    // TODO: comment this out and fix soql101 in production
    @isTest
    public static void testDGLawsuitIssuedJCLegal() {
        setLegal('J & C Anwälte');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Sent_Mail_Flag_1__c = false
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Submission_Date_Before_Claim_Statement__c = System.today();
        c.Submission_Date_Before_Lawsuit_Date__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
        c.Stage__c = 'Lawsuit';
        c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGLawsuitIssued21Legal() {
        setLegal('21Legal GmbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Sent_Mail_Flag_1__c = false
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Submission_Date_Before_Claim_Statement__c = System.today();
        c.Submission_Date_Before_Lawsuit_Date__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
        c.Stage__c = 'Lawsuit';
        c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGLawsuitIssuedKainz() {
        setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Sent_Mail_Flag_1__c = false
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Submission_Date_Before_Claim_Statement__c = System.today();
        c.Submission_Date_Before_Lawsuit_Date__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
        c.Stage__c = 'Lawsuit';
        c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGLawsuitIssuedLeCom() {
        setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Sent_Mail_Flag_1__c = false
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Submission_Date_Before_Claim_Statement__c = System.today();
        c.Submission_Date_Before_Lawsuit_Date__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
        c.Stage__c = 'Lawsuit';
        c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testDGLawsuitIssuedLachmair() {
        setLegal('Rechtsanwälte Lachmair & Kollegen');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Sent_Mail_Flag_1__c = false
        );
        insert c;
        c.RecordTypeId = Claims.dieselskandalRecordType();
        c.Response_Insurance_Claim_Letter__c = System.today();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Submission_Date_Before_Claim_Statement__c = System.today();
        c.Submission_Date_Before_Lawsuit_Date__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }
	*/

    /* * * * * * * * *
     * Finanzierung  *
     * * * * * * * * */

    // Issued
/*
    @isTest
    public static void testFZLawsuitIssuedJCLegal() {
        id uId = setLegal('J & C Anwälte');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testFZLawsuitIssuedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testFZLawsuitIssuedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    // Refused

    @isTest
    public static void testFZLawsuitRefusedJCLegal() {
        id uId = setLegal('J & C Anwälte');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testFZLawsuitRefusedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testFZLawsuitefusedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.finanzierungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
        c.Submitter_Before_Claim_Statement__c = 'System';
        c.Submitter_Before_Lawsuit_Date__c = 'System';
		c.Stage__c = 'Lawsuit';
		c.Canceled_Next_Court_Date__c = true;
        TriggerConfiguration.allInactive = false;

        update c;
    }
	*/
    /* * * * * * * * * * * *
     * Lebenesversicherung *
     * * * * * * * * * * * */

    // Issued

    @isTest
    public static void testLVOnHoldIssuedJaeger() {
        id uId = setLegal('J & C Anwälte', 'Heinrich Jäger - LV');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldIssued21Legal() {
        id uId = setLegal('21Legal GmbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldIssuedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldIssuedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Issued',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    // Refused

    @isTest
    public static void testLVOnHoldRefusedJaeger() {
        id uId = setLegal('J & C Anwälte', 'Heinrich Jäger - LV');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldRefused21Legal() {
        id uId = setLegal('21Legal GmbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldRefusedLeCom() {
        id uId = setLegal('LeCom - Legal & Compliance Rechtsanwaltsgesellschaft mbH');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }

    @isTest
    public static void testLVOnHoldRefusedKainz() {
        id uId = setLegal('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
        Claim__c c = new Claim__c(
            Opportunity__c = [SELECT ID FROM Opportunity][0].id,
            Cover_Note__c = 'Refused',
            Cover_Note_Scope__c = 'Extrajudicial;Judicial',
            Result__c = 'No Response',
            Clerk__c = uId
        );
        insert c;
        c.RecordTypeId = Claims.lebensversicherungRecordType();
        c.Response_Insurance_Lawsuit__c = System.today();
        c.Response_Insurance_Legal_Opposition__c = System.today();
		c.Stage__c = 'On Hold';
        TriggerConfiguration.allInactive = false;

        update c;
    }
}