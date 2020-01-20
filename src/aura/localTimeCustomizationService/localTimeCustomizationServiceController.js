({
    doInit: function (component, event) {
        let params = event.getParam('arguments');
        if (!params) {
            return;
        }

        component.set('v.objectRecordId', params.recordId);
        component.set('v.objectApiName', params.objectApiName);
        component.set('v.settingObjectApiName', params.settingObjectApiName);
        component.set('v.fieldName', params.fieldName);

        let saveSetting = component.get('c.getOrCreateSetting');
        saveSetting.setParams({"objectId": params.recordId});
        saveSetting.setCallback(self, function(a) {
            let settingRecord = a.getReturnValue();
            component.set('v.settingRecordId', settingRecord.Id);
            component.set('v.showSpinner', false);
        });
        $A.enqueueAction(saveSetting);
    },

    handleLoad: function(component) {
    },

    handleSubmit: function(component) {
        component.set('v.disabled', true);
        component.set('v.showSpinner', true);

        let fetchAndInsert = component.get('c.fetchAndInsertGeoData');
        fetchAndInsert.setCallback(this, function(response) {

            let state = response.getState();
            if (state === 'SUCCESS') {
                $A.get("e.force:refreshView").fire();

                let fieldName = component.get('v.fieldName');
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                        "title": "The customization Saved!",
                        "message": "The " + fieldName + " customization has been Saved successfully."
                });
                toastEvent.fire();

                $A.get("e.force:closeQuickAction").fire();
            }
        });
        fetchAndInsert.setParams({"objectId": component.get("v.objectRecordId")});
        $A.enqueueAction(fetchAndInsert);
    },

    handleError: function(component) {
        cmp.set("v.showSpinner", false);

        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "The unknown problem."
        });
        toastEvent.fire();

        $A.get("e.force:closeQuickAction").fire();
    },

    handleSuccess: function(component) {

    },

    handleCancel: function (component) {
        $A.get("e.force:closeQuickAction").fire();
    }
});