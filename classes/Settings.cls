public class Settings {
    /* Wrapper  for shadowing UserSettings and GeneralSettings */
    public static boolean DISABLE_AUTO_EMAIL_SENDING;
    public static boolean DISABLE_ALL_TRIGGERS;
    
    static {
       DISABLE_ALL_TRIGGERS = UserSettings.DISABLE_ALL_TRIGGERS || GeneralSettings.DISABLE_ALL_TRIGGERS;
       DISABLE_AUTO_EMAIL_SENDING =  UserSettings.DISABLE_AUTO_EMAIL_SENDING || GeneralSettings.DISABLE_AUTO_EMAIL_SENDING;
    }

}