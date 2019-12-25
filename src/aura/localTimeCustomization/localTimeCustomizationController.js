({
    doInit: function(component) {
        let saveSetting = component.get('c.getOrCreateSetting');
        saveSetting.setParams({"opportunityId": component.get("v.recordId")});
        saveSetting.setCallback(self, function(a) {
            component.set("v.settingRecord", a.getReturnValue())
        });
        $A.enqueueAction(saveSetting);
    },

    handleLoad: function(component) {
        component.set('v.showSpinner', false);
    },

    handleSubmit: function(component) {
        component.set('v.disabled', true);
        component.set('v.showSpinner', true);

        let fetchAndInsert = component.get('c.fetchAndInsertGeoData');
        fetchAndInsert.setParams({"opportunityId": component.get("v.recordId")});
        $A.enqueueAction(fetchAndInsert);

        $A.get("e.force:closeQuickAction").fire();
    },

    handleError: function(component) {
        component.set('v.showSpinner', false);

        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "The unknown problem."
        });
        toastEvent.fire();
    },

    handleSuccess: function(component) {
        component.set('v.showSpinner', false);

        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "The customization Saved!",
            "message": "The Account local time customization has been Saved successfully."
        });
        toastEvent.fire();
    },

    handleCancel: function (component) {
        $A.get("e.force:closeQuickAction").fire();
    }
});