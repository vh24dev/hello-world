@isTest
public class OpportunitiesLegalTest {
	@isTest
    public static void testDistribution() {
        Opportunity o = new Opportunity();
        o.Legal__c = Users.JHLegal();
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(o);
        Map<String, Decimal> dists = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getDistribution(opps, o);
        System.assertEquals(1, dists.get('H. Jäger'));
        System.assertEquals(0, dists.get('A. Kainz'));
        System.assertEquals(0, dists.get('Dominic Krutisch'));
    }

	@isTest
    public static void testDistribution2() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<String, Decimal> dists = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getDistribution(opps, opps[0]);
        System.assertEquals(0.5, dists.get('H. Jäger'));
        System.assertEquals(0.5, dists.get('A. Kainz'));
        System.assertEquals(0, dists.get('Dominic Krutisch'));
    }

	@isTest
    public static void testDistributionZero() {
        Account a = TestData.createAccount();
        insert a;
        List<Opportunity> opps = new List<Opportunity>{ // list of opps without legals -> zero division
            new Opportunity(
                Legal__c = a.Id,
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = a.Id,
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<String, Decimal> dists = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getDistribution(opps, opps[0]);
        System.assertEquals(-999999999, dists.get('H. Jäger'));
        System.assertEquals(-999999999, dists.get('A. Kainz'));
        System.assertEquals(-999999999, dists.get('Dominic Krutisch'));
    }

	@isTest
    public static void testDistanceJaeger() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.9);			// has=  0.5 dist=  0.4
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.5);			// has=  0.5 dist=  0.0
        cfg.put('Dominic Krutisch', 0.2);	// has=  0.0 dist=  0.2
		cfg.put('Wilhelm Lachmair', 0.0);

        string legal = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getHighestDistanceLegal(cfg, opps, opps[0]);
        System.assertEquals('H. Jäger', legal);
    }

	@isTest
    public static void testDistanceKainz() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.0);			// has=  0.5 dist= -5.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.7);			// has=  0.5 dist=  0.2
        cfg.put('Dominic Krutisch', 0.1);	// has=  0.0 dist=  0.1
		cfg.put('Wilhelm Lachmair', 0.0);

        string legal = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getHighestDistanceLegal(cfg, opps, opps[0]);
        System.assertEquals('A. Kainz', legal);
    }

	@isTest
    public static void testDistanceKrutisch() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.5);			// has=  0.5 dist=  0.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.9);			// has=  0.5 dist=  0.4
        cfg.put('Dominic Krutisch', 0.6);	// has=  0.0 dist=  0.6
		cfg.put('Wilhelm Lachmair', 0.0);

        string legal = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getHighestDistanceLegal(cfg, opps, opps[0]);
        System.assertEquals('Dominic Krutisch', legal);
    }

	@isTest
    public static void testPriorityKrutisch() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.5);			// has=  0.5 dist=  0.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.9);			// has=  0.5 dist=  0.4
        cfg.put('Dominic Krutisch', 0.6);	// has=  0.0 dist=  0.6
		cfg.put('Wilhelm Lachmair', 0.0);

        id legal = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getPriorityLegal(cfg, opps, opps[0]);
        System.assertEquals(Users.krutischLegal(), legal);
    }

	@isTest
    public static void testZeroPriority() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.1);			// has=  0.85 dist= -0.75
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.0);			// has=  0.14 dist=  NONE because wanted is 0
        cfg.put('Dominic Krutisch', 0.0);	// has=  0.0  dist=  NONE because wanted is 0
		cfg.put('Wilhelm Lachmair', 0.0);

        id legal = new OpportunitiesLegal(new List<OpportunitiesLegal.Config>()).getPriorityLegal(cfg, opps, opps[0]);
        System.assertEquals(Users.JHLegal(), legal);
    }

	@isTest
    public static void testApiMethodException() {
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.5);			// has=  0.5 dist=  0.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.9);			// has=  0.5 dist=  0.4
        cfg.put('Dominic Krutisch', 0.6);	// has=  0.0 dist=  0.6
		cfg.put('Wilhelm Lachmair', 0.0);

        OpportunitiesLegal.Config config;
        boolean isException = false;
        try {
            config = new OpportunitiesLegal.Config('Dieselskandal', 'VH24', cfg);
        } catch (OpportunitiesLegal.ConfigException e) {
			isException = true;
        }
        System.assert(isException);
    }

	@isTest
    public static void testApiMethodSuccess() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;
        List<Opportunity> opps = new List<Opportunity>{
            new Opportunity(
                Account__c = Accounts.VH24ID,
                Legal__c = Users.JHLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            ),
            new Opportunity(
                Account__c = Accounts.VH24ID,
                Legal__c = Users.kainzLegal(),
                RecordTypeId = Opportunities.dieselSkandalRecordType()
            )
        };
        System.assertNotEquals(null, opps[0].Account__c);
        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.5);			// has=  0.5 dist=  0.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.9);			// has=  0.5 dist=  0.4
        cfg.put('Dominic Krutisch', 0.6);	// has=  0.0 dist=  0.6
		cfg.put('Wilhelm Lachmair', 0.0);

        OpportunitiesLegal.Config config = new OpportunitiesLegal.Config('Dieselskandal', 'VH24', cfg);
        List<OpportunitiesLegal.Config> configs = new List<OpportunitiesLegal.Config>();
        configs.add(config);
		OpportunitiesLegal ol = new OpportunitiesLegal(configs);

        id legal = ol.get(opps, opps[0]);
        System.assertEquals(Users.krutischLegal(), legal);
    }

    @isTest
    public static void testOppInsertPassInCfg() {
        Account a = TestData.createAccount();
        a.name = 'VH24';
        insert a;

        Map<string, decimal> cfg = new Map<string,decimal>();
        cfg.put('Anwälte Jäger', 0.0);
        cfg.put('H. Jäger', 0.5);			// has=  0.0 dist=  0.0
        cfg.put('Heinrich Jäger', 0.0);
        cfg.put('A. Kainz', 0.9);			// has=  0.0 dist=  0.9
        cfg.put('Dominic Krutisch', 0.6);	// has=  0.0 dist=  0.6
        cfg.put('Wilhelm Lachmair', 0.0);

        OpportunitiesLegal.Config config = new OpportunitiesLegal.Config('Dieselskandal', 'VH24', cfg);
        List<OpportunitiesLegal.Config> configs = new List<OpportunitiesLegal.Config>();
        configs.add(config);
        OpportunitiesLegalSettings.CONFIGS = configs;

        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.Account__c = Accounts.VH24ID;
        o.Legal__c = Users.JHLegal();
        o.RecordTypeId = Opportunities.dieselSkandalRecordType();
        insert o;

        o = [SELECT Id, Account__c, Legal__c FROM Opportunity WHERE Id = :o.Id];
        id legal = o.Legal__c;
        System.assertEquals(Users.kainzLegal(), legal);
    }

	// TODO: test not passing in a config
	/*
	@isTest
    public static void testOppInsert() {
        Account a = TestData.createAccount();
        a.Name = 'VH24';
		insert a;
        Opportunity o = TestData.createOpportunity(a.Id, 'On Hold');
        o.RecordTypeId = Opportunities.dieselskandalRecordType();
        insert o;
        o = [SELECT Id, Legal_Account__c, Legal__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(null, o.Legal__c);
        System.assertNotEquals(null, o.Legal__c);
    }
	*/
}