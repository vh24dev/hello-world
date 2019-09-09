public class OpportunitiesLegal implements LegalDistributor {
    public class ConfigException extends Exception {}
    public class Config {
        public final Id recType;
        public final Id vhvrAccount;
        public final Map<string, decimal> config;
        public Config(string rt, string la, Map<string, decimal> cfg) {
            List<RecordType> rIds = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = :rt];
            List<Account> aIds = [SELECT Id FROM Account WHERE Name = :la];
            if (aIds.size() == 0) {
                throw new OpportunitiesLegal.ConfigException('Invalid account name');
            }
            if (rIds.size() == 0) {
                throw new OpportunitiesLegal.ConfigException('Invalid recordtype name');
            }
            this.recType = rIds[0].Id;
            this.vhvrAccount = aIds[0].Id;
            this.config = cfg;
        }
    }

    List<Config> cfgs;
    public OpportunitiesLegal(List<Config> configs) {
        this.cfgs = configs;
    }

    // make this private
    public Map<String, Decimal> getDistribution(List<Opportunity> opps, Opportunity opp) {
        Map<String, Decimal> dists = new Map<String, Decimal>();
        decimal JCTotal = 0;
        decimal JHTotal = 0;
        decimal JHeinrichTotal = 0;
        decimal KainzTotal = 0;
        decimal KrutischTotal = 0;
        decimal LachmairTotal = 0;
        for (Opportunity o : opps) {
            if (o.RecordTypeId != opp.RecordTypeId) {
                continue;
            }
            if (o.Account__c != opp.Account__c) {
                continue;
            }

            if (o.Legal__c == Users.JCLegal()) {
                JCTotal++;
            } else if (o.Legal__c == Users.JHLegal()) {
                JHTotal++;
            } else if (o.Legal__c == Users.JHeinrichLegal()) {
                JHeinrichTotal++;
            } else if (o.Legal__c == Users.kainzLegal()) {
                KainzTotal++;
            } else if (o.Legal__c == Users.krutischLegal()) {
                KrutischTotal++;
            } else if (o.Legal__c == Users.lachmairLegal()) {
                LachmairTotal++;
            }
        }
        decimal Total =
            JCTotal +
            JHTotal +
            JHeinrichTotal +
            KainzTotal +
            KrutischTotal +
            LachmairTotal;
        dists.put('Anwälte Jäger', Total == 0 ? -999999999 : (JCTotal / Total));
        dists.put('H. Jäger', Total == 0 ? -999999999 : (JHTotal / Total));
        dists.put('Heinrich Jäger', Total == 0 ? -999999999 : (JHeinrichTotal / Total));
        dists.put('A. Kainz', Total == 0 ? -999999999 : (KainzTotal / Total));
        dists.put('Dominic Krutisch', Total == 0 ? -999999999 : (KrutischTotal / Total));
        dists.put('Wilhelm Lachmair', Total == 0 ? -999999999 : (LachmairTotal / Total));
        return dists;
    }

    // make this private
    public string getHighestDistanceLegal(Map<String, Decimal> cfg, List<Opportunity> opps, Opportunity opp) {
        decimal HighestDistance = -999999999;
        string HighestDistanceLegal = '';
        Map<String, Decimal> distOpps = getDistribution(opps, opp);
        for(String legal : distOpps.keySet()) {
            if (cfg.get(legal) <= 0.0) {
                continue;
            }
            decimal distance = cfg.get(legal) - distOpps.get(legal);
            System.debug(cfg.get(legal) + ' - ' + distOpps.get(legal) + ' = ' + distance);
            if (distance > HighestDistance) {
                HighestDistance = distance;
                HighestDistanceLegal = legal;
            }
        }
        // System.debug('Highest distance=' + HighestDistance + ' legal=' + HighestDistanceLegal);
        return HighestDistanceLegal;
    }

    // make this private
    public id getPriorityLegal(Map<String, Decimal> cfg, List<Opportunity> opps, Opportunity opp) {
        string legalName = getHighestDistanceLegal(cfg, opps, opp);
        id legalId = null;
        legalId = Users.getLegalByName(legalName); // more dynamic but custom metadata labels have to equal account names
        /*
        if (legalName == 'Anwälte Jäger') {
            legalId = Users.JCLegal();
        } else if (legalName == 'H. Jäger') {
            legalId = Users.JHLegal();
        } else if (legalName == 'Heinrich Jäger') {
            legalId = Users.JHeinrichLegal();
        } else if (legalName == 'A. Kainz') {
            legalId = Users.kainzLegal();
        } else if (legalName == 'Dominic Krutisch') {
            legalId = Users.krutischLegal();
        } else if (legalName == 'Wilhelm Lachmair') {
            legalId = Users.lachmairLegal();
        } else {
            Logger.error('SetLegal failed on invalid legalName=' + legalName);
        }
        */
        return legalId;
    }

    public id get(List<Opportunity> opps, Opportunity opp) {
        for (Config c : this.cfgs) {
            if (c.recType == opp.RecordTypeId && c.vhvrAccount == opp.Account__c) {
                return getPriorityLegal(c.config, opps, opp);
            }
        }
        return null;
    }
}