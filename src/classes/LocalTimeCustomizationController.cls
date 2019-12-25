public class LocalTimeCustomizationController {

	@AuraEnabled
	public static Opportunity_Local_Time_Setting__c getOrCreateSetting(Id opportunityId) {
		Opportunity opp = getOpportunity(opportunityId);
		Id settingId = opp.Account_Local_Time_Setting__c;
		if (settingId == null) {
			Opportunity_Local_Time_Setting__c created = new Opportunity_Local_Time_Setting__c();
			insert created;

			opp.Account_Local_Time_Setting__c = created.Id;
			update opp;

			return created;
		}

		return BillingTimeUtil.getSetting(settingId);
	}

	@AuraEnabled
	public static void fetchAndInsertGeoData(Id opportunityId) {
		BillingTimeUtil.fetchAndInsertData(getOpportunity(opportunityId));
	}

	private static Opportunity getOpportunity(Id opportunityId) {
		return [SELECT Account_Local_Time_Setting__c, AccountId
				FROM Opportunity
				WHERE Id =: opportunityId
				LIMIT 1];
	}
}