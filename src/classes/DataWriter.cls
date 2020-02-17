public class DataWriter {

	public static void write(Dom.Document doc, sObject obj) {
		insertGmtOffsetIfPossible(doc, obj);
		insertTimeZoneNameIfPossible(doc, obj);
		insertCountryCodeIfPossible(doc, obj);
	}

	public static void insertCountryCodeIfPossible(Dom.Document doc, sObject obj) {
		String code = getChildText(doc, 'countryCode');
		if (code == null) {
			return;
		}

		if (obj instanceof Account) {
			((Account)obj).localTimeJF__Country_Code__c = code;
		}
		else if (obj instanceof Lead) {
			((Lead)obj).localTimeJF__Country_Code__c = code;
		}
	}

	public static void insertGmtOffsetIfPossible(Dom.Document doc, sObject obj) {
		String gmtOffset = getChildText(doc, 'gmtOffset');
		if (gmtOffset == null) {
			System.debug('Gmt offset does not parsed');
			return;
		}

		Integer offset = Integer.valueOf(gmtOffset) / 3600;

		if (obj instanceof Account) {
			((Account)obj).localTimeJF__GMT_Offset__c = offset;
		}
		else if (obj instanceof Lead) {
			((Lead)obj).localTimeJF__GMT_Offset__c = offset;
		}
	}

	public static void insertTimeZoneNameIfPossible(Dom.Document doc, sObject obj) {
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

		words = words.trim();

		if (obj instanceof Account) {
			((Account)obj).localTimeJF__Time_zone_display_name__c = words;
		}
		else if (obj instanceof Lead) {
			((Lead)obj).localTimeJF__Time_zone_display_name__c = words;
		}
	}

	@TestVisible
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
}