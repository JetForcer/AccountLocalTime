@IsTest
public with sharing class DataWriterTest {

    @IsTest
    public static void testWriteForAccount() {
        Test.startTest();
        Account acc = new Account();
        Dom.Document doc = localTimeJF.GeolocationFetcher.fetch(acc);
        localTimeJF.DataWriter.write(doc, acc);

        TestUtil.checkFields(acc);
        Test.stopTest();
    }

    @IsTest
    public static void testWriteForLead() {
        Test.startTest();
        Lead l = new Lead();
        Dom.Document doc = localTimeJF.GeolocationFetcher.fetch(l);
        localTimeJF.DataWriter.write(doc, l);

        localTimeJF.TestUtil.checkFields(l);
        Test.stopTest();
    }
}