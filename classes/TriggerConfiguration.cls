public class TriggerConfiguration {
    public static Boolean allInactive {get; set;}
    
    static {
        allInactive = Test.isRunningTest() ? false : Settings.DISABLE_ALL_TRIGGERS;
        if (allInactive) {
            System.debug('TriggerConfiguration.allInactive defaulting to TRUE from setting in Custom Metadata Type "General Settings"');
        }
    }
}