public class UserReferences {
    // Legacy code, todo: refactor
	public static void setUserInfo(List<User_Reference__c> userReferences,Map<Id,User_Reference__c> oldUserReferences,Boolean isInsert) {
		List<Id> accountIds = new List<Id>();
		List<Id> userIds = new List<Id>();

		for (User_Reference__c userReference : userReferences) {
			if(userReference.Account__c != null){
				accountIds.add(userReference.Account__c);
			}
			if(userReference.User__c != null){
				userIds.add(userReference.User__c);
			}
		}

		Map<Id, Account> accounts = new Map<Id, Account>([select Id,Name,ShippingStreet,ShippingPostalCode,ShippingCity,ShippingCountry from Account where Id in :accountIds]);
		Map<Id, User> users = new Map<Id, User>([select Id,CompanyName,Account_Id__c,Street,PostalCode,City,Country from User where Id in :userIds]);

		List<User> updateUsers = new List<User>();

		for (User_Reference__c userReference : userReferences) {
			User user = users.get(userReference.User__c);
			Account account = accounts.get(userReference.Account__c);

			if ((user != null) && (account != null)) {
				if ((isInsert == true) || (((user.Id != oldUserReferences.get(userReference.Id).User__c) || (account.id != oldUserReferences.get(userReference.Id).Account__c)))) {
					user.CompanyName = account.Name;
					user.Account_Id__c = account.Id;
					user.Street = account.ShippingStreet;
					user.PostalCode = account.ShippingPostalCode;
					user.City = account.ShippingCity;
					user.Country = account.ShippingCountry;
					updateUsers.add(user);
				}
			}
		}

		if (!updateUsers.isEmpty()) {
			update updateUsers;
		}
	}
}