public inherited sharing class FinAPISettings {
    public class FinAPISettingsException extends Exception {}

    public String baseURL;
    public Integer timeframe;
	public Integer batchSize;
	public String clientID;
	public String clientSecret;
	public String username;
	public String pwd;
    public Integer mapLastN;
    public Date mapLastNBeforeDate;

    public FinAPISettings() {
        loadSettings();
    }
    
    private void loadSettings() {
		FinAPI_Settings__mdt[] s = [
            SELECT 	Base_URL__c,
            		Timeframe__c,
            		Batch_Size__c,
            		Map_last_N__c,
            		Map_last_N_before_date__c,
            		Client_ID__c,
            		Client_Secret__c,
            		Username__c,
            		Pwd__c
            FROM FinAPI_Settings__mdt
            WHERE Is_Active__c = true
        ];

        if (Test.isRunningTest()) {
            s = new FinAPI_Settings__mdt[]{fakeSettings()};
        }

        if (s.size() == 0) {
           throw new FinAPISettings.FinAPISettingsException('No FinAPI settings found. Please create them in Setup -> Custom Metadata Types -> FinAPI Settings -> Manage Records');
        }
        if (s.size() > 1) {
           throw new FinAPISettings.FinAPISettingsException('More than one active FinAPI settings found. Please set only one record as active in Setup -> Custom Metadata Types -> FinAPI Settings -> Manage Records');
        }

        this.baseURL = s[0].Base_URL__c;
        this.timeframe = s[0].Timeframe__c.intValue();
        this.batchSize = s[0].Batch_Size__c.intValue();
        this.mapLastN = s[0].Map_last_N__c.intValue();
        this.mapLastNBeforeDate = s[0].Map_last_N_before_date__c;
        this.clientID = s[0].Client_ID__c;
        this.clientSecret = s[0].Client_Secret__c;
        this.username = s[0].Username__c;
        this.pwd = s[0].Pwd__c;        
    }

    private static FinAPI_Settings__mdt fakeSettings() {
        return new FinAPI_Settings__mdt(
            Base_URL__c = 'https://test',
            Timeframe__c = 20,
            Batch_Size__c = 1000,
            Map_last_N__c = 250,
            Map_last_N_before_date__c = Date.today(),
            Client_ID__c = 'cid',
            Client_Secret__c = 'cs',
            Username__c = 'u',
            Pwd__c = 'p'
        );
    }
}