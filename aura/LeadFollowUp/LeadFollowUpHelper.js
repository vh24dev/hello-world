({
	followUpOnLead: function(component) {
        console.log('>> followUpOnLead');
        
        var leadID = component.get('v.recordId');
        console.log('followUpOnLead :: leadID: ' + leadID);
        
        var action = component.get('c.followUpOnLead');
        action.setParams({leadID: leadID});
        action.setCallback(this, function(resp) {
            var state = resp.getState();
            console.log('followUpOnLead :: callback :: resp: ' + resp);
            if (state !== "SUCCESS") {
                console.log("Failed to FollowUp. State: " + state);
                this.showToastMessage("Failed to FollowUp", false);
                $A.get("e.force:closeQuickAction").fire();
                return;
            }
            
            this.showToastMessage("FollowUp action executed.", true);
            $A.get("e.force:closeQuickAction").fire();
        });
        
        $A.enqueueAction(action);
        console.log('<< followUpOnLead');
	},
	showToastMessage: function(text, isSuccess) {
       	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": isSuccess ? "Success" : "Error",
            "type": isSuccess ? "success" : "error",
            "message": text
        });
        toastEvent.fire();
    },
})