public class TimeUtil {

	public static void fetchAndInsertData(sObject obj) {
		if (getLatitude(obj) == null || getLongitude(obj) == null) {
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

	public static Boolean isGeocodesChanged(List<sObject> oldObjects, List<sObject> newObjects) {
		if (oldObjects == null) {
			return false;
		}

		Iterator<SObject> oldObjectsIterator = oldObjects.iterator();
		Iterator<SObject> newObjectsIterator = newObjects.iterator();

		while (oldObjectsIterator.hasNext() && newObjectsIterator.hasNext()) {
			sObject oldObject = oldObjectsIterator.next();
			SObject newObject = newObjectsIterator.next();

			if (getLatitude(oldObject) != getLatitude(newObject)
					|| getLongitude(oldObject) != getLongitude(newObject)) {
				return true;
			}
		}

		return false;
	}

	private static Decimal getLatitude(sObject obj) {
		if (obj instanceof Account) {
			return ((Account)obj).BillingLatitude;
		} else if (obj instanceof Lead) {
			return ((Lead)obj).Latitude;
		}

		return null;
	}

	private static Decimal getLongitude(sObject obj) {
		if (obj instanceof Account) {
			return ((Account)obj).BillingLongitude;
		} else if (obj instanceof Lead) {
			return ((Lead)obj).Longitude;
		}

		return null;
	}
}