public class GeolocationFetcher {

	/*
	 * Callout to the API that will correctly return a 401 error code when the session has expired,
	 * so 'Timezonedb' Named Credential will refresh the OAuth access_token
	 */
	private static final String TIMEZONEDB_URL
			= 'callout:Timezonedb?key=GUBU1G0FJT8O&format=xml&by=position&lat={0}&lng={1}';

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

		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(restUrl);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'charset=UTF-8');
		req.setTimeout(120000);
		HttpResponse res = h.send(req);

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