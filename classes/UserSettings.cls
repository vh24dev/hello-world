public inherited sharing class UserSettings {
    
    public static boolean DISABLE_ALL_TRIGGERS;
    public static boolean DISABLE_AUTO_EMAIL_SENDING;
    
	static {
    	User currentUser = [
            SELECT Disable_Trigger__c, Disable_Auto_Email_Sending__c
            FROM User
            where Id = :UserInfo.getUserId()];
        DISABLE_ALL_TRIGGERS = currentUser.Disable_Trigger__c;
        DISABLE_AUTO_EMAIL_SENDING = currentUser.Disable_Auto_Email_Sending__c;
    }
}