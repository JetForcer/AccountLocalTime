@IsTest
public with sharing class DataWriterTest {

    @IsTest
    public static void testWriteForAccount() {
        Test.startTest();
        Account acc = new Account();
        Dom.Document doc = GeolocationFetcher.fetch(acc);
        DataWriter.write(doc, acc);

        TestUtil.checkFields(acc);
        Test.stopTest();
    }

    @IsTest
    public static void testWriteForLead() {
        Test.startTest();
        Lead l = new Lead();
        Dom.Document doc = GeolocationFetcher.fetch(l);
        DataWriter.write(doc, l);

        TestUtil.checkFields(l);
        Test.stopTest();
    }
}