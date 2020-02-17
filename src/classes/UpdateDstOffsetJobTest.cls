@IsTest
private class UpdateDstOffsetJobTest {

    @IsTest
    public static void testUpdateForAccount() {
        Test.startTest();

        Account acc = localTimeJF.TestUtil.createTestAccount();
        insert acc;
        List<Account> accounts = new List<Account>();
        accounts.add(acc);

        localTimeJF.UpdateDstOffsetJob job = new localTimeJF.UpdateDstOffsetJob(accounts);
        job.execute(null);

        acc = [SELECT localTimeJF__Country_Code__c, localTimeJF__GMT_Offset__c, localTimeJF__Time_zone_display_name__c
               FROM Account
               WHERE Id =: acc.Id];

        localTimeJF.TestUtil.checkFields(acc);

        Test.stopTest();
    }

    @IsTest
    public static void testUpdateForLead() {
        Test.startTest();

        Lead l = localTimeJF.TestUtil.createTestLead();
        l.Latitude = 50.460225;
        l.Longitude = 30.622090;
        insert l;

        List<Lead> leads = new List<Lead>();
        leads.add(l);

        localTimeJF.UpdateDstOffsetJob job = new localTimeJF.UpdateDstOffsetJob(leads);
        job.execute(null);

        l = [SELECT localTimeJF__Country_Code__c, localTimeJF__GMT_Offset__c, localTimeJF__Time_zone_display_name__c
             FROM Lead
             WHERE Id =: l.Id];

        localTimeJF.TestUtil.checkFields(l);

        Test.stopTest();
    }
}