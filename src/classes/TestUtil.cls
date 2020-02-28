public with sharing class TestUtil {

    public static void checkFields(Account acc) {
        System.assertEquals('UA', acc.localTimeJF__Country_Code__c);
        System.assertEquals(2, acc.localTimeJF__GMT_Offset__c);
        System.assertEquals('Eastern European Standard Time', acc.localTimeJF__Time_zone_display_name__c);
    }

    public static void checkFields(Lead l) {
        System.assertEquals('UA', l.localTimeJF__Country_Code__c);
        System.assertEquals(2, l.localTimeJF__GMT_Offset__c);
        System.assertEquals('Eastern European Standard Time', l.localTimeJF__Time_zone_display_name__c);
    }

    public static void checkFields(Contact c) {
        System.assertEquals('UA', c.localTimeJF__Country_Code__c);
        System.assertEquals(2, c.localTimeJF__GMT_Offset__c);
        System.assertEquals('Eastern European Standard Time', c.localTimeJF__Time_zone_display_name__c);
    }

    public static Account createTestAccount() {
        return new Account(Name='Test account', BillingLatitude=50.460225, BillingLongitude=30.622090);
    }

    public static Opportunity createTestOpportunity() {
        return new Opportunity(Name='Test Opportunity',
                StageName='Qualification',
                CloseDate=Date.newInstance(2030, 12, 31));
    }

    public static Lead createTestLead() {
        return new Lead(LastName='Test Lead', Company='Test company');
    }

    public static Contact createTestContact() {
        return new Contact(LastName='Test Contact', MailingLatitude=50.460225, MailingLongitude=30.622090);
    }
}