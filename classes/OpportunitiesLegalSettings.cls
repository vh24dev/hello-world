public inherited sharing class OpportunitiesLegalSettings {
    public class SettingsException extends Exception {}

    public static List<OpportunitiesLegal.Config> CONFIGS;
    private static Integer MAX_SETTINGS;
    static {
        CONFIGS = new List<OpportunitiesLegal.Config>();
        MAX_SETTINGS = 6;
        if (Test.isRunningTest()) {
           return;
        }

        Legal_Assignment_Setting__mdt[] setts = [
            SELECT
            Legal_Account__c,
            Record_Type__c,
            JC_Legal__c,
            JH_Legal__c,
            JHeinrich_Legal__c,
            Kainz_Legal__c,
            Krutisch_Legal__c,
            Lachmair_Legal__c
            FROM Legal_Assignment_Setting__mdt  
            WHERE Is_Active__c = true
        ];
        if (setts.size() == 0) {
           throw new OpportunitiesLegalSettings.SettingsException('No settings found. Please create them in Setup -> Custom Metadata Types -> Legal Assignment Setting -> Manage Records');
        }
        if (setts.size() > MAX_SETTINGS) {
           throw new OpportunitiesLegalSettings.SettingsException('More than ' + MAX_SETTINGS + ' active settings found. Please set ' + MAX_SETTINGS + ' records as active in Setup -> Custom Metadata Types -> Legal Assignment Setting -> Manage Records');
        }
        if (setts.size() < MAX_SETTINGS) {
           throw new OpportunitiesLegalSettings.SettingsException('Less than ' + MAX_SETTINGS + ' active settings found. Please set ' + MAX_SETTINGS + ' records as active in Setup -> Custom Metadata Types -> Legal Assignment Setting -> Manage Records');
        }

        for (Legal_Assignment_Setting__mdt s : setts) {
            Map<string, decimal> cfg = new Map<string, decimal>();
            // TODO: replace it with hardcoded lawyer names
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('JC_Legal__c').getDescribe().getLabel(),			s.JC_Legal__c * 0.01);
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('JH_Legal__c').getDescribe().getLabel(),			s.JH_Legal__c * 0.01);
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('JHeinrich_Legal__c').getDescribe().getLabel(),	s.JHeinrich_Legal__c * 0.01);
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('Kainz_Legal__c').getDescribe().getLabel(),		s.Kainz_Legal__c * 0.01);
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('Krutisch_Legal__c').getDescribe().getLabel(),	s.Krutisch_Legal__c * 0.01);
            cfg.put(Schema.getGlobalDescribe().get('Legal_Assignment_Setting__mdt').getDescribe().fields.getMap().get('Lachmair_Legal__c').getDescribe().getLabel(),	s.Lachmair_Legal__c * 0.01);

            OpportunitiesLegal.Config completeConf = new OpportunitiesLegal.Config(s.Record_Type__c, s.Legal_Account__c, cfg);
            CONFIGS.add(completeConf);
        }
    }
}