@IsTest
private class UpdateDstOffsetJobTest {

    @IsTest
    public static void testUpdateForAccount() {
        Test.startTest();

        Account acc = TestUtil.createTestAccount();
        insert acc;
        List<Account> accounts = new List<Account>();
        accounts.add(acc);

        UpdateDstOffsetJob job = new UpdateDstOffsetJob(accounts);
        job.execute(null);

        acc = [SELECT Country_Code__c, GMT_Offset__c, Time_zone_display_name__c FROM Account WHERE Id =: acc.Id];
        TestUtil.checkFields(acc);

        Test.stopTest();
    }

    @IsTest
    public static void testUpdateForLead() {
        Test.startTest();

        Lead l = TestUtil.createTestLead();
        l.Latitude = 50.460225;
        l.Longitude = 30.622090;
        insert l;

        List<Lead> leads = new List<Lead>();
        leads.add(l);

        UpdateDstOffsetJob job = new UpdateDstOffsetJob(leads);
        job.execute(null);

        l = [SELECT Country_Code__c, GMT_Offset__c, Time_zone_display_name__c FROM Lead WHERE Id =: l.Id];
        TestUtil.checkFields(l);

        Test.stopTest();
    }
}