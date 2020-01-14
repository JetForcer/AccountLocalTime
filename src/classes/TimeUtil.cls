public class TimeUtil {

	public static void fetchAndInsertData(sObject obj) {
		if (!isContainLatitudeAndLongitude(obj)) {
			return;
		}

		ObjectManager manager = ObjectManager.getInstance();

		if (obj instanceof Opportunity) {
			Opportunity opp = (Opportunity)obj;
			Id settingId = opp.Account_Local_Time_Setting__c;
			Opportunity_Local_Time_Setting__c setting = manager.getOpportunitySetting(settingId);
			Id accountId = opp.AccountId;

			if (setting != null && setting.Use_Geolocation__c && accountId != null) {
				Account acc = manager.getAccount(accountId);
				fetchAndInsertAccountData(acc.Id);
			}
		} else if (obj instanceof Lead) {
			Lead leadVar = (Lead)obj;
			Lead_Local_Time_Setting__c setting = manager.getLeadSetting(leadVar.Lead_Local_Time_Setting__c);

			if (setting != null && setting.Use_Geolocation__c) {
				fetchAndInsertLeadData(leadVar.Id);
			}
		}
	}

	/*
	 * The reason why sObjects can’t be passed as arguments to future methods is because the sObject might change
	 * between the time you call the method, and the time it executes.
	 */
	@future(callout = true)
	public static void fetchAndInsertAccountData(Id accountId) {
		Account acc = ObjectManager.getInstance().getAccount(accountId);
		Dom.Document result = GeolocationFetcher.fetch(acc);
		DataWriter.write(result, acc);
		update acc;
	}

	@future(callout = true)
	public static void fetchAndInsertLeadData(Id leadId) {
		Lead leadVar = ObjectManager.getInstance().getLead(leadId);
		Dom.Document result = GeolocationFetcher.fetch(leadVar);
		DataWriter.write(result, leadVar);
		update leadVar;
	}

	public static Boolean isContainLatitudeAndLongitude(SObject obj) {
		if (obj instanceof Account) {
			Account acc = (Account)obj;
			return acc.BillingLatitude != null && acc.BillingLongitude != null;
		}
		else if (obj instanceof Lead) {
			Lead leadVar = (Lead)obj;
			return leadVar.Latitude != null && leadVar.Longitude != null;
		}

		return false;
	}
}