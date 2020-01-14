({
    doInit: function (component) {
        let recordId = component.get("v.recordId");
        let service = component.find('service');
        service.doInit(recordId, 'Lead', 'Lead_Local_Time_Setting__c', 'Local time')
    }
});