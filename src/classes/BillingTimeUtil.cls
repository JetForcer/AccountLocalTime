public class BillingTimeUtil {

	@TestVisible
	public static Opportunity fetchAndInsertData(Opportunity opp) {
		if (opp.Use_Geolocation__c) {
			Account acc = getAccount(opp.AccountId);
			fetchAndInsertData(acc.Id);
		}
		return opp;
	}

	/*
	 * The reason why sObjects can’t be passed as arguments to future methods is because the sObject might change between the time you call
	 * the method and the time it executes.
	 */
	@future(callout = true)
	public static void fetchAndInsertData(Id accountId) {
		Account acc = getAccount(accountId);
		if (acc.BillingLatitude == null || acc.BillingLongitude == null) {
			System.debug('latitude or longitude null');
			return;
		}

		Dom.Document result = fetchGeolocation(acc);
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

		acc.GMT_Offset__c = Integer.valueOf(gmtOffset);
	}

	public static void insertTimeZoneNameIfPossible(Dom.Document doc, Account acc) {
		String timeZoneId = getChildText(doc, 'timezoneId');
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
		for (Dom.XmlNode node : result.getRootElement().getChildElements()) {
			for (Dom.XmlNode childNode : node.getChildElements()) {
				String name = childNode.getName();
				if (!childName.equals(name)) {
					continue;
				}

				return childNode.getText();
			}
		}

		return null;
	}

	private static Account getAccount(Id accountId) {
		List<Account> accs = [SELECT Id, BillingLatitude, BillingLongitude FROM Account WHERE Id = : accountId LIMIT 1];
		System.debug('accounts: ' + accs);
		return accs[0];
	}

	private static Dom.Document fetchGeolocation(Account acc) {
		String restUrl =
				'http://api.geonames.org/timezone?lat=' + acc.BillingLatitude + '&lng=' + acc.BillingLongitude +
				'&username=jetforcer';

		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(restUrl);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'charset=UTF-8');
		HttpResponse res = h.send(req);
		Dom.Document body = res.getBodyDocument();
		System.debug(res.getBody());

		return body;
	}
}