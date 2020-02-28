public class ObjectManager {

	private static final ObjectManager INSTANCE = new ObjectManager();

	public static ObjectManager getInstance() {
		return INSTANCE;
	}

	public Account getAccount(Id accountId) {
		List<Account> accounts = [SELECT Id, Account_Local_Time_Setting__c, BillingLatitude, BillingLongitude
								  FROM Account
								  WHERE Id =: accountId
								  LIMIT 1];

		if (accounts.size() == 1) {
			return accounts.get(0);
		}

		return null;
	}

	public Opportunity getOpportunity(Id opportunityId) {
		List<Opportunity> opportunities = [SELECT localTimeJF__Account_Local_Time_Setting__c, AccountId
										   FROM Opportunity
										   WHERE Id =: opportunityId
										   LIMIT 1];
		if (opportunities.size() == 1) {
			return opportunities.get(0);
		}

		return null;
	}

	public Lead getLead(Id leadId) {
		List<Lead> leads = [SELECT localTimeJF__Lead_Local_Time_Setting__c, Latitude, Longitude
							FROM Lead
							WHERE Id =: leadId
							LIMIT 1];
		if (leads.size() == 1) {
			return leads.get(0);
		}

		return null;
	}

	public Contact getContact(Id contactId) {
		List<Contact> contacts = [SELECT localTimeJF__Contact_Local_Time_Setting__c, MailingLatitude, MailingLongitude
								  FROM Contact
								  WHERE Id =: contactId
								  LIMIT 1];
		if (contacts.size() == 1) {
			return contacts.get(0);
		}

		return null;
	}

	public Opportunity_Local_Time_Setting__c getOpportunitySetting(Id settingId) {
		return [SELECT localTimeJF__Use_12_Hour_Format__c, localTimeJF__Use_Geolocation__c
				FROM localTimeJF__Opportunity_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}

	public Lead_Local_Time_Setting__c getLeadSetting(Id settingId) {
		return [SELECT localTimeJF__Use_12_Hour_Format__c, localTimeJF__Use_Geolocation__c
				FROM localTimeJF__Lead_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}

	public Account_Local_Time_Setting__c getAccountSetting(Id settingId) {
		return [SELECT localTimeJF__Use_12_Hour_Format__c, localTimeJF__Use_Geolocation__c
				FROM localTimeJF__Account_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}

	public Contact_Local_Time_Setting__c getContactSetting(Id settingId) {
		return [SELECT localTimeJF__Use_12_Hour_Format__c, localTimeJF__Use_Geolocation__c
				FROM Contact_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}
}