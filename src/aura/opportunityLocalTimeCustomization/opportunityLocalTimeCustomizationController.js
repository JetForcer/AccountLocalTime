({
    doInit: function (component) {
        let recordId = component.get("v.recordId");
        let service = component.find('service');
        service.doInit(recordId, 'Opportunity', 'localTimeJF__Opportunity_Local_Time_Setting__c', 'Account local time')
    }
});