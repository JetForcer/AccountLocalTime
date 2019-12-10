public class LocalTimeConfigurationController {

	@AuraEnabled
	public static Boolean isUseGeolocation(Id opportunityId) {
		Opportunity opp = getOpportunity(opportunityId);
		return opp == null ? false : opp.Use_Geolocation__c;
	}

	@AuraEnabled
	public static Boolean isUse12HoursFormat(Id opportunityId) {
		Opportunity opp = getOpportunity(opportunityId);
		return opp == null ? false : opp.Use_12_Hour_Format__c;
	}

	@AuraEnabled
	public static void initData(Id opportunityId) {
		BillingTimeUtil.fetchAndInsertData(getOpportunity(opportunityId));
	}

	@AuraEnabled
	public static Opportunity updateOpportunityRecord(Id opportunityId,
													  Boolean useGeolocation,
													  Boolean use12HoursFormat) {
		Opportunity opp = getOpportunity(opportunityId);
		opp.Use_Geolocation__c = useGeolocation;
		opp.Use_12_Hour_Format__c = use12HoursFormat;

		update opp;
		return opp;
	}

	@TestVisible
	private static Opportunity getOpportunity(Id opportunityId) {
		return [SELECT Use_Geolocation__c, Use_12_Hour_Format__c, AccountId FROM Opportunity WHERE Id =: opportunityId LIMIT 1];
	}
}