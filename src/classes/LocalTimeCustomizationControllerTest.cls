@IsTest
private class LocalTimeCustomizationControllerTest {

    @IsTest
    public static void testCreateSettingForOpportunity() {
        Test.startTest();

        Opportunity opp = localTimeJF.TestUtil.createTestOpportunity();
        insert opp;
        localTimeJF__Opportunity_Local_Time_Setting__c setting = (localTimeJF__Opportunity_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(opp.Id);

        checkSettingAssignedToOpportunity(opp.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateSettingForLead() {
        Test.startTest();

        Lead l = localTimeJF.TestUtil.createTestLead();
        insert l;

        localTimeJF__Lead_Local_Time_Setting__c setting = (localTimeJF__Lead_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(l.Id);

        checkSettingAssignedToLead(l.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateSettingForAccount() {
        Test.startTest();

        Account acc = localTimeJF.TestUtil.createTestAccount();
        insert acc;

        localTimeJF__Account_Local_Time_Setting__c setting = (localTimeJF__Account_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(acc.Id);

        checkSettingAssignedToAccount(acc.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateSettingForContact() {
        Test.startTest();

        Contact c = localTimeJF.TestUtil.createTestContact();
        insert c;

        localTimeJF__Contact_Local_Time_Setting__c setting = (localTimeJF__Contact_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(c.Id);

        checkSettingAssignedToContact(c.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForOpportunity() {
        Test.startTest();

        localTimeJF__Opportunity_Local_Time_Setting__c expectedSetting
                = new localTimeJF__Opportunity_Local_Time_Setting__c();
        insert expectedSetting;
        Opportunity opp = localTimeJF.TestUtil.createTestOpportunity();
        Id expectedSettingId = expectedSetting.Id;
        opp.localTimeJF__Account_Local_Time_Setting__c = expectedSettingId;
        insert opp;
        localTimeJF__Opportunity_Local_Time_Setting__c actualSetting = (localTimeJF__Opportunity_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(opp.Id);

        checkSettingAssignedToOpportunity(opp.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForLead() {
        Test.startTest();

        localTimeJF__Lead_Local_Time_Setting__c expectedSetting = new localTimeJF__Lead_Local_Time_Setting__c();
        insert expectedSetting;
        Lead l = localTimeJF.TestUtil.createTestLead();
        Id expectedSettingId = expectedSetting.Id;
        l.localTimeJF__Lead_Local_Time_Setting__c = expectedSettingId;
        insert l;

        localTimeJF__Lead_Local_Time_Setting__c actualSetting = (localTimeJF__Lead_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(l.Id);

        checkSettingAssignedToLead(l.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForAccount() {
        Test.startTest();

        localTimeJF__Account_Local_Time_Setting__c expectedSetting = new localTimeJF__Account_Local_Time_Setting__c();
        insert expectedSetting;
        Account acc = localTimeJF.TestUtil.createTestAccount();
        Id expectedSettingId = expectedSetting.Id;
        acc.localTimeJF__Account_Local_Time_Setting__c = expectedSettingId;
        insert acc;

        localTimeJF__Account_Local_Time_Setting__c actualSetting = (localTimeJF__Account_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(acc.Id);

        checkSettingAssignedToAccount(acc.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForContact() {
        Test.startTest();

        localTimeJF__Contact_Local_Time_Setting__c expectedSetting = new localTimeJF__Contact_Local_Time_Setting__c();
        insert expectedSetting;
        Contact c = localTimeJF.TestUtil.createTestContact();
        Id expectedSettingId = expectedSetting.Id;
        c.localTimeJF__Contact_Local_Time_Setting__c = expectedSettingId;
        insert c;

        localTimeJF__Contact_Local_Time_Setting__c actualSetting = (localTimeJF__Contact_Local_Time_Setting__c)
                localTimeJF.LocalTimeCustomizationController.getOrCreateSetting(c.Id);

        checkSettingAssignedToContact(c.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForOpportunity() {
        Test.startTest();

        localTimeJF__Opportunity_Local_Time_Setting__c setting = new localTimeJF__Opportunity_Local_Time_Setting__c();
        setting.localTimeJF__Use_Geolocation__c = true;
        insert setting;

        Account acc = localTimeJF.TestUtil.createTestAccount();
        insert acc;

        Opportunity opp = localTimeJF.TestUtil.createTestOpportunity();
        opp.localTimeJF__Account_Local_Time_Setting__c = setting.Id;
        opp.AccountId = acc.Id;
        insert opp;
        Account result = (Account) localTimeJF.LocalTimeCustomizationController.fetchAndInsertGeoData(opp.Id);
        localTimeJF.TestUtil.checkFields(result);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForLead() {
        Test.startTest();

        localTimeJF__Lead_Local_Time_Setting__c setting = new localTimeJF__Lead_Local_Time_Setting__c();
        setting.localTimeJF__Use_Geolocation__c = true;
        insert setting;

        Lead l = localTimeJF.TestUtil.createTestLead();
        l.localTimeJF__Lead_Local_Time_Setting__c = setting.Id;
        l.Latitude = 50.460225;
        l.Longitude = 30.622090;
        insert l;

        Lead result = (Lead) localTimeJF.LocalTimeCustomizationController.fetchAndInsertGeoData(l.Id);
        localTimeJF.TestUtil.checkFields(result);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForAccount() {
        Test.startTest();

        localTimeJF__Account_Local_Time_Setting__c setting = new localTimeJF__Account_Local_Time_Setting__c();
        setting.localTimeJF__Use_Geolocation__c = true;
        insert setting;

        Account acc = localTimeJF.TestUtil.createTestAccount();
        acc.localTimeJF__Account_Local_Time_Setting__c = setting.Id;
        acc.BillingLatitude = 50.460225;
        acc.BillingLongitude = 30.622090;
        insert acc;

        Account result = (Account) localTimeJF.LocalTimeCustomizationController.fetchAndInsertGeoData(acc.Id);
        localTimeJF.TestUtil.checkFields(result);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForContact() {
        Test.startTest();

        localTimeJF__Contact_Local_Time_Setting__c setting = new localTimeJF__Contact_Local_Time_Setting__c();
        setting.localTimeJF__Use_Geolocation__c = true;
        insert setting;

        Contact c = localTimeJF.TestUtil.createTestContact();
        c.localTimeJF__Contact_Local_Time_Setting__c = setting.Id;
        c.MailingLatitude = 50.460225;
        c.MailingLongitude = 30.622090;
        insert c;

        Contact result = (Contact) localTimeJF.LocalTimeCustomizationController.fetchAndInsertGeoData(c.Id);
        localTimeJF.TestUtil.checkFields(result);

        Test.stopTest();
    }

    private static void checkSettingAssignedToOpportunity(Id opportunityId, Opportunity_Local_Time_Setting__c setting) {
        Opportunity opp = [SELECT localTimeJF__Account_Local_Time_Setting__c FROM Opportunity WHERE Id =: opportunityId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, opp.localTimeJF__Account_Local_Time_Setting__c);
    }

    private static void checkSettingAssignedToLead(Id leadId, Lead_Local_Time_Setting__c setting) {
        Lead l = [SELECT localTimeJF__Lead_Local_Time_Setting__c FROM Lead WHERE Id =: leadId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, l.localTimeJF__Lead_Local_Time_Setting__c);
    }

    private static void checkSettingAssignedToAccount(Id accountId, Account_Local_Time_Setting__c setting) {
        Account acc = [SELECT localTimeJF__Account_Local_Time_Setting__c FROM Account WHERE Id =: accountId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, acc.localTimeJF__Account_Local_Time_Setting__c);
    }

    private static void checkSettingAssignedToContact(Id contactId, Contact_Local_Time_Setting__c setting) {
        Contact c = [SELECT localTimeJF__Contact_Local_Time_Setting__c FROM Contact WHERE Id =: contactId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, c.localTimeJF__Contact_Local_Time_Setting__c);
    }
}