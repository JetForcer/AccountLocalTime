public class ObjectManager {

	private static final ObjectManager INSTANCE = new ObjectManager();

	public static ObjectManager getInstance() {
		return INSTANCE;
	}

	public Account getAccount(Id accountId) {
		return [SELECT Id, BillingLatitude, BillingLongitude FROM Account WHERE Id = : accountId LIMIT 1];
	}

	public Opportunity getOpportunity(Id opportunityId) {
		List<Opportunity> opportunities = [SELECT Account_Local_Time_Setting__c, AccountId
										   FROM Opportunity
										   WHERE Id =: opportunityId
										   LIMIT 1];
		if (opportunities.size() == 1) {
			return opportunities.get(0);
		}

		return null;
	}

	public Lead getLead(Id leadId) {
		List<Lead> leads = [SELECT Lead_Local_Time_Setting__c, Latitude, Longitude
							FROM Lead
							WHERE Id =: leadId
							LIMIT 1];
		if (leads.size() == 1) {
			return leads.get(0);
		}

		return null;
	}

	public Opportunity_Local_Time_Setting__c getOpportunitySetting(Id settingId) {
		return [SELECT Use_12_Hour_Format__c, Use_Geolocation__c
				FROM Opportunity_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}

	public Lead_Local_Time_Setting__c getLeadSetting(Id settingId) {
		return [SELECT Use_12_Hour_Format__c, Use_Geolocation__c
				FROM Lead_Local_Time_Setting__c
				WHERE Id =: settingId
				LIMIT 1];
	}
}