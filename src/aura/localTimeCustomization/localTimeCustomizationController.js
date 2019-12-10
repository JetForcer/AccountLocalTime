({
    doInit: function (component) {
        function initUseGeolocation() {
            let action = component.get('c.isUseGeolocation');
            action.setParams({"opportunityId": component.get("v.recordId")});
            action.setCallback(this, function (response) {
                let returnValue = response.getReturnValue();
                component.set("v.useGeolocation", returnValue);
            });
            $A.enqueueAction(action);
        }

        initUseGeolocation.call(this);

        function initUse12HoursFormat() {
            let action = component.get('c.isUse12HoursFormat');
            action.setParams({"opportunityId": component.get("v.recordId")});
            action.setCallback(this, function (response) {
                let returnValue = response.getReturnValue();
                component.set("v.use12HoursFormat", returnValue);
            });
            $A.enqueueAction(action);
        }

        initUse12HoursFormat.call(this);

        function initData() {
            let action = component.get('c.initData');
            action.setParams({"opportunityId": component.get("v.recordId")});
            $A.enqueueAction(action);
        }

        initData.call(this);
    },

    handleCancel: function (component) {
        $A.get("e.force:closeQuickAction").fire();
    },

    saveOpportunity: function (component) {
        let action = component.get("c.updateOpportunityRecord");
        action.setParams({
            "opportunityId": component.get("v.recordId"),
            "useGeolocation": component.get("v.useGeolocation"),
            "use12HoursFormat": component.get("v.use12HoursFormat")
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            let error = response.getError();

            if (state === "SUCCESS" || state === "DRAFT") {
                component.set("v.opportunityRecord", response.getReturnValue());

                // Success! Prepare a toast UI message
                let resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "The customization Saved",
                    "message": "The Account local time field customization successfully saved."
                });

                // Update the UI: close panel, show toast, refresh account page
                $A.get("e.force:closeQuickAction").fire();
                resultsToast.fire();

                // Reload the view so components not using force:recordData
                // are updated
                $A.get("e.force:refreshView").fire();
            } else if (state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (state === "ERROR") {
                console.log('Problem saving contact, error: ' + JSON.stringify(error));
            } else {
                console.log('The unknown problem, state: ' + state + ', error: ' + JSON.stringify(error));
            }
        });

        $A.enqueueAction(action);
    }
})