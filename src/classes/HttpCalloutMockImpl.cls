public with sharing class HttpCalloutMockImpl implements HttpCalloutMock {

    public static final String EXPECTED_BODY = '<?xml version="1.0" encoding="utf-8"?>' +
            '<result>' +
            '<status>OK</status><message/>' +
            '<countryCode>UA</countryCode>' +
            '<countryName>Ukraine</countryName>' +
            '<zoneName>Europe/Kiev</zoneName>' +
            '<abbreviation>EET</abbreviation>' +
            '<gmtOffset>7200</gmtOffset>' +
            '<dst>0</dst>' +
            '<zoneStart>1572138000</zoneStart>' +
            '<zoneEnd>1585443600</zoneEnd>' +
            '<nextAbbreviation>EEST</nextAbbreviation>' +
            '<timestamp>1581424303</timestamp>' +
            '<formatted>2020-02-11 12:31:43</formatted>' +
            '</result>';

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody(EXPECTED_BODY);
        return res;
    }
}