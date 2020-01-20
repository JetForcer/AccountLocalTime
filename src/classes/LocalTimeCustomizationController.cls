public class LocalTimeCustomizationController {

	@AuraEnabled
	public static sObject getOrCreateSetting(Id objectId) {
		ObjectManager manager = ObjectManager.getInstance();

		sObject obj = manager.getOpportunity(objectId);
		if (obj != null) {
			return getOrCreateOpportunitySetting((Opportunity)obj, manager);
		}

		obj = manager.getLead(objectId);
		if (obj != null) {
			return getOrCreateLeadSetting((Lead)obj, manager);
		}

		return null;
	}

	private static Lead_Local_Time_Setting__c getOrCreateLeadSetting(Lead leadVar, ObjectManager manager) {
		Id settingId = leadVar.Lead_Local_Time_Setting__c;
		if (settingId == null) {
			Lead_Local_Time_Setting__c created = new Lead_Local_Time_Setting__c();
			insert created;

			leadVar.Lead_Local_Time_Setting__c = created.Id;
			update leadVar;

			return created;
		}

		return manager.getLeadSetting(settingId);
	}

	private static Opportunity_Local_Time_Setting__c getOrCreateOpportunitySetting(Opportunity opp,
																				  ObjectManager manager) {
		Id settingId = opp.Account_Local_Time_Setting__c;
		if (settingId == null) {
			Opportunity_Local_Time_Setting__c created = new Opportunity_Local_Time_Setting__c();
			insert created;

			opp.Account_Local_Time_Setting__c = created.Id;
			update opp;

			return created;
		}

		return manager.getOpportunitySetting(settingId);
	}

	@AuraEnabled
	public static sObject fetchAndInsertGeoData(Id objectId) {
		ObjectManager manager = ObjectManager.getInstance();
		sObject obj = manager.getOpportunity(objectId);
		if (obj == null) {
			obj = manager.getLead(objectId);
		}

		return TimeUtil.fetchAndInsertData(obj);
	}
}