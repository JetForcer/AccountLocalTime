@IsTest
public with sharing class GeolocationFetcherTest {

    @IsTest
    public static void testFetchForAccount() {
        Test.startTest();
        Dom.Document result = GeolocationFetcher.fetch(new Account());
        checkChildsExists(result);
        Test.stopTest();
    }

    @IsTest
    public static void testFetchForLead() {
        Test.startTest();
        Dom.Document result = GeolocationFetcher.fetch(new Lead());
        checkChildsExists(result);
        Test.stopTest();
    }

    private static void checkChildsExists(Dom.Document doc) {
        String countryCode = DataWriter.getChildText(doc, 'countryCode');
        System.assertEquals('UA', countryCode);

        String zoneName = DataWriter.getChildText(doc, 'zoneName');
        System.assertEquals('Europe/Kiev', zoneName);

        String gmtOffset = DataWriter.getChildText(doc, 'gmtOffset');
        System.assertEquals('7200', gmtOffset);
    }
}