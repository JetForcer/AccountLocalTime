public class GeolocationFetcher {

	private static final String TIMEZONEDB_URL
			= 'https://api.timezonedb.com/v2.1/get-time-zone?key=GUBU1G0FJT8O&format=xml&by=position&lat={0}&lng={1}';

	public static Dom.Document fetch(Account acc) {
		return sendRequestAndGetDocument(formatUrl(acc.BillingLatitude, acc.BillingLongitude));
	}

	public static Dom.Document fetch(Lead leadVar) {
		return sendRequestAndGetDocument(formatUrl(leadVar.Latitude, leadVar.Longitude));
	}

	private static String formatUrl(Decimal latitude, Decimal longitude) {
		return String.format(TIMEZONEDB_URL, new List<Decimal>{latitude, longitude});
	}

	private static Dom.Document sendRequestAndGetDocument(String restUrl) {
		Dom.Document result = null;
		HttpCalloutMock mock = new localTimeJF.HttpCalloutMockImpl();

		HttpRequest req = new HttpRequest();
		req.setEndpoint(restUrl);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'charset=UTF-8');
		req.setTimeout(120000);

		HttpResponse res = null;


		if (Test.isRunningTest()) {
			res = mock.respond(req);
		}
		else {
			Http h = new Http();
			res = h.send(req);
		}

		try {
			result = res.getBodyDocument();
		} catch (XmlException e) {
			System.debug('Xml error has occurred: ' + e.getMessage());
		}

		if (result == null || result.getRootElement() == null) {
			result = new Dom.Document();
		}

		return result;
	}
}