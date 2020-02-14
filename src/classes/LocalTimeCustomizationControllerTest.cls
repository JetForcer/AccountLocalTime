@IsTest
private class LocalTimeCustomizationControllerTest {

    @IsTest
    public static void testCreateSettingForOpportunity() {
        Test.startTest();

        Opportunity opp = TestUtil.createTestOpportunity();
        insert opp;
        Opportunity_Local_Time_Setting__c setting
                = (Opportunity_Local_Time_Setting__c) LocalTimeCustomizationController.getOrCreateSetting(opp.Id);

        checkSettingAssignedToOpportunity(opp.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testCreateSettingForLead() {
        Test.startTest();

        Lead l = TestUtil.createTestLead();
        insert l;

        Lead_Local_Time_Setting__c setting
                = (Lead_Local_Time_Setting__c) LocalTimeCustomizationController.getOrCreateSetting(l.Id);

        checkSettingAssignedToLead(l.Id, setting);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForOpportunity() {
        Test.startTest();

        Opportunity_Local_Time_Setting__c expectedSetting = new Opportunity_Local_Time_Setting__c();
        insert expectedSetting;
        Opportunity opp = TestUtil.createTestOpportunity();
        Id expectedSettingId = expectedSetting.Id;
        opp.Account_Local_Time_Setting__c = expectedSettingId;
        insert opp;
        Opportunity_Local_Time_Setting__c actualSetting
                = (Opportunity_Local_Time_Setting__c) LocalTimeCustomizationController.getOrCreateSetting(opp.Id);

        checkSettingAssignedToOpportunity(opp.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testGetSettingForLead() {
        Test.startTest();

        Lead_Local_Time_Setting__c expectedSetting = new Lead_Local_Time_Setting__c();
        insert expectedSetting;
        Lead l = TestUtil.createTestLead();
        Id expectedSettingId = expectedSetting.Id;
        l.Lead_Local_Time_Setting__c = expectedSettingId;
        insert l;

        Lead_Local_Time_Setting__c actualSetting
                = (Lead_Local_Time_Setting__c) LocalTimeCustomizationController.getOrCreateSetting(l.Id);

        checkSettingAssignedToLead(l.Id, actualSetting);
        System.assertEquals(expectedSettingId, actualSetting.Id);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForOpportunity() {
        Test.startTest();

        Opportunity_Local_Time_Setting__c setting = new Opportunity_Local_Time_Setting__c();
        setting.Use_Geolocation__c = true;
        insert setting;

        Account acc = TestUtil.createTestAccount();
        insert acc;

        Opportunity opp = TestUtil.createTestOpportunity();
        opp.Account_Local_Time_Setting__c = setting.Id;
        opp.AccountId = acc.Id;
        insert opp;
        Account result = (Account) LocalTimeCustomizationController.fetchAndInsertGeoData(opp.Id);
        TestUtil.checkFields(result);

        Test.stopTest();
    }

    @IsTest
    public static void testFetchAndInsertGeoDataForLead() {
        Test.startTest();

        Lead_Local_Time_Setting__c setting = new Lead_Local_Time_Setting__c();
        setting.Use_Geolocation__c = true;
        insert setting;

        Lead l = TestUtil.createTestLead();
        l.Lead_Local_Time_Setting__c = setting.Id;
        l.Latitude = 50.460225;
        l.Longitude = 30.622090;
        insert l;

        Lead result = (Lead) LocalTimeCustomizationController.fetchAndInsertGeoData(l.Id);
        TestUtil.checkFields(result);

        Test.stopTest();
    }

    private static void checkSettingAssignedToOpportunity(Id opportunityId, Opportunity_Local_Time_Setting__c setting) {
        Opportunity opp = [SELECT Account_Local_Time_Setting__c FROM Opportunity WHERE Id =: opportunityId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, opp.Account_Local_Time_Setting__c);
    }

    private static void checkSettingAssignedToLead(Id leadId, Lead_Local_Time_Setting__c setting) {
        Lead l = [SELECT Lead_Local_Time_Setting__c FROM Lead WHERE Id =: leadId];
        System.assert(setting != null);
        System.assert(setting.Id != null);
        System.assertEquals(setting.Id, l.Lead_Local_Time_Setting__c);
    }
}