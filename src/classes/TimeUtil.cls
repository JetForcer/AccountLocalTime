public class TimeUtil {

	public static sObject fetchAndInsertData(sObject obj) {
		localTimeJF.ObjectManager manager = ObjectManager.getInstance();

		if (obj instanceof Opportunity) {
			Opportunity opp = (Opportunity)obj;
			Id settingId = opp.localTimeJF__Account_Local_Time_Setting__c;
			localTimeJF__Opportunity_Local_Time_Setting__c setting = manager.getOpportunitySetting(settingId);
			Id accountId = opp.AccountId;

			if (setting != null && setting.localTimeJF__Use_Geolocation__c && accountId != null) {
				Account acc = manager.getAccount(accountId);
				if (getLatitude(acc) == null || getLongitude(acc) == null) {
					return null;
				}

				return fetchAndInsertAccountData(acc.Id);
			}
		} else if (obj instanceof Lead) {
			Lead leadVar = (Lead)obj;
			if (getLatitude(leadVar) == null || getLongitude(leadVar) == null) {
				return null;
			}

			localTimeJF__Lead_Local_Time_Setting__c setting
					= manager.getLeadSetting(leadVar.localTimeJF__Lead_Local_Time_Setting__c);

			if (setting != null && setting.localTimeJF__Use_Geolocation__c) {
				return fetchAndInsertLeadData(leadVar.Id);
			}
		}

		return null;
	}

	public static Account fetchAndInsertAccountData(Id accountId) {
		Account acc = localTimeJF.ObjectManager.getInstance().getAccount(accountId);
		Dom.Document result = localTimeJF.GeolocationFetcher.fetch(acc);
		localTimeJF.DataWriter.write(result, acc);
		update acc;
		return acc;
	}

	public static Lead fetchAndInsertLeadData(Id leadId) {
		Lead leadVar = localTimeJF.ObjectManager.getInstance().getLead(leadId);
		Dom.Document result = localTimeJF.GeolocationFetcher.fetch(leadVar);
		localTimeJF.DataWriter.write(result, leadVar);
		update leadVar;
		return leadVar;
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