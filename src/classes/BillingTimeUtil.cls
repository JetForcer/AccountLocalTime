public class BillingTimeUtil {

	private static final String API_KEY = 'GUBU1G0FJT8O';

	public static void fetchAndInsertData(Opportunity opp) {
		Id accountId = opp.AccountId;
		Opportunity_Local_Time_Setting__c setting = getSetting(opp.Account_Local_Time_Setting__c);
		if (setting != null && setting.Use_Geolocation__c && accountId != null) {
			Account acc = getAccount(accountId);
			fetchAndInsertData(acc.Id);
		}
	}

	/*
	 * The reason why sObjects can’t be passed as arguments to future methods is because the sObject might change
	 * between the time you call the method, and the time it executes.
	 */
	@future(callout = true)
	public static void fetchAndInsertData(Id accountId) {
		Account acc = getAccount(accountId);
		if (acc.BillingLatitude == null || acc.BillingLongitude == null) {
			return;
		}

		Dom.Document result = fetchGeolocation(acc);
		if (result.getRootElement() == null) {
			return;
		}

		insertGmtOffsetIfPossible(result, acc);
		insertTimeZoneNameIfPossible(result, acc);
		insertCountryCodeIfPossible(result, acc);

		update acc;
	}

	private static void insertCountryCodeIfPossible(Dom.Document doc, Account acc) {
		String code = getChildText(doc, 'countryCode');
		if (code == null) {
			return;
		}

		acc.Country_Code__c = code;
	}

	public static void insertGmtOffsetIfPossible(Dom.Document doc, Account acc) {
		String gmtOffset = getChildText(doc, 'gmtOffset');
		if (gmtOffset == null) {
			System.debug('Gmt offset does not parsed');
			return;
		}

		acc.GMT_Offset__c = Integer.valueOf(gmtOffset) / 3600;
	}

	public static void insertTimeZoneNameIfPossible(Dom.Document doc, Account acc) {
		String timeZoneId = getChildText(doc, 'zoneName');
		if (timeZoneId == null) {
			System.debug('Time zone id does not parsed');
			return;
		}

		TimeZone timeZone = TimeZone.getTimeZone(timeZoneId);
		if (timeZone == null) {
			return;
		}

		//example: (GMT-08:00) Pacific Standard Time (America/Los_Angeles)
		String displayName = timeZone.getDisplayName();
		List<String> parts = displayName.split(' ');
		String words = '';
		for (String part : parts) {
			if (part.startsWith('(')) {
				continue;
			}

			words += part + ' ';
		}

		if (words.length() == 0) {
			return;
		}

		acc.Time_zone_display_name__c = words;
	}

	private static String getChildText(Dom.Document result, String childName) {
		Dom.XmlNode root = result.getRootElement();
		if (root == null) {
			return null;
		}

		for (Dom.XmlNode node : root.getChildElements()) {
			String name = node.getName();
				if (!childName.equals(name)) {
					continue;
				}

			return node.getText();
		}

		return null;
	}

	private static Account getAccount(Id accountId) {
		return [SELECT Id, BillingLatitude, BillingLongitude FROM Account WHERE Id = : accountId LIMIT 1];
	}

	public static Opportunity_Local_Time_Setting__c getSetting(Id settingId) {
		return [SELECT Use_12_Hour_Format__c, Use_Geolocation__c
		FROM Opportunity_Local_Time_Setting__c
		WHERE Id =: settingId
		LIMIT 1];
	}

	private static Dom.Document fetchGeolocation(Account acc) {
		// callout to the API that will correctly return a 401 error code when the session has expired,
		//so 'Timezonedb' Named Credential will refresh the OAuth access_token
		String restUrl
				= 'callout:Timezonedb?key=' + API_KEY + '&format=xml&by=position&lat='
				+ acc.BillingLatitude
				+ '&lng='
				+ acc.BillingLongitude;

		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(restUrl);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'charset=UTF-8');
		HttpResponse res = h.send(req);

		try{
			return res.getBodyDocument();
		}
		catch (XmlException e) {
			System.debug('Xml error has occurred: ' + e.getMessage());
		}

		//empty by default
		return new Dom.Document();
	}
}