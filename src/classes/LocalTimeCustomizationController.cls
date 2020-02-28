public class LocalTimeCustomizationController {

	@AuraEnabled
	public static sObject getOrCreateSetting(Id objectId) {
		localTimeJF.ObjectManager manager = localTimeJF.ObjectManager.getInstance();

		sObject obj = manager.getOpportunity(objectId);
		if (obj != null) {
			return getOrCreateOpportunitySetting((Opportunity)obj, manager);
		}

		obj = manager.getLead(objectId);
		if (obj != null) {
			return getOrCreateLeadSetting((Lead)obj, manager);
		}

		obj = manager.getAccount(objectId);
		if (obj != null) {
			return getOrCreateAccountSetting((Account)obj, manager);
		}

		obj = manager.getContact(objectId);
		if (obj != null) {
			return getOrCreateContactSetting((Contact)obj, manager);
		}

		return null;
	}

	private static localTimeJF__Account_Local_Time_Setting__c getOrCreateAccountSetting(Account acc,
																						ObjectManager manager) {
		Id settingId = acc.localTimeJF__Account_Local_Time_Setting__c;
		if (settingId == null) {
			localTimeJF__Account_Local_Time_Setting__c created = new localTimeJF__Account_Local_Time_Setting__c();
			insert created;

			acc.localTimeJF__Account_Local_Time_Setting__c = created.Id;
			update acc;

			return created;
		}

		return manager.getAccountSetting(settingId);
	}

	private static localTimeJF__Lead_Local_Time_Setting__c getOrCreateLeadSetting(Lead leadVar,
																				  localTimeJF.ObjectManager manager) {
		Id settingId = leadVar.localTimeJF__Lead_Local_Time_Setting__c;
		if (settingId == null) {
			localTimeJF__Lead_Local_Time_Setting__c created = new localTimeJF__Lead_Local_Time_Setting__c();
			insert created;

			leadVar.localTimeJF__Lead_Local_Time_Setting__c = created.Id;
			update leadVar;

			return created;
		}

		return manager.getLeadSetting(settingId);
	}

	private static localTimeJF__Opportunity_Local_Time_Setting__c getOrCreateOpportunitySetting(Opportunity opp,
			localTimeJF.ObjectManager manager) {

		Id settingId = opp.localTimeJF__Account_Local_Time_Setting__c;
		if (settingId == null) {
			localTimeJF__Opportunity_Local_Time_Setting__c created
					= new localTimeJF__Opportunity_Local_Time_Setting__c();
			insert created;

			opp.localTimeJF__Account_Local_Time_Setting__c = created.Id;
			update opp;

			return created;
		}

		return manager.getOpportunitySetting(settingId);
	}

	private static localTimeJF__Contact_Local_Time_Setting__c getOrCreateContactSetting(Contact c,
			localTimeJF.ObjectManager manager) {

		Id settingId = c.localTimeJF__Contact_Local_Time_Setting__c;
		if (settingId == null) {
			localTimeJF__Contact_Local_Time_Setting__c created
					= new localTimeJF__Contact_Local_Time_Setting__c();
			insert created;

			c.localTimeJF__Contact_Local_Time_Setting__c = created.Id;
			update c;

			return created;
		}

		return manager.getContactSetting(settingId);
	}

	@AuraEnabled
	public static sObject fetchAndInsertGeoData(Id objectId) {
		localTimeJF.ObjectManager manager = localTimeJF.ObjectManager.getInstance();
		sObject obj = manager.getOpportunity(objectId);
		if (obj == null) {
			obj = manager.getLead(objectId);
		}
		if (obj == null) {
			obj = manager.getAccount(objectId);
		}
		if (obj == null) {
			obj = manager.getContact(objectId);
		}

		return localTimeJF.TimeUtil.fetchAndInsertData(obj);
	}
}