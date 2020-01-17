({
    handleInit: function(component) {
    	console.log('>> handleInit');
        this.initRequest(component, component.get('v.recordId'), null, null);
        console.log('<< handleInit');
	},
    handleCancel: function(component) {
        console.log('>> handleCancel');
        $A.get("e.force:closeQuickAction").fire();
        console.log('<< handleCancel');
    },
	handleOK: function(component) {
        console.log('>> handleOK');

        var reached = component.get('v.customerReached');
        if (!reached) {
            console.log('handleOK :: reached undefined: ' + reached);
            this.showError(component, "Bitte wählen Sie nur eine der folgenden Optionen aus um fortzufahren.");
            return;
        }

        var notes = component.get('v.customerNotes');
        if (!notes) {
            console.log('handleOK :: notes undefined: ' + notes);
            this.showError(component, "Bitte hinterlegen Sie einen Kommentar.");
            return;
        }

        var leadID = component.get('v.recordId');
        console.log('handleOK :: leadID: ' + leadID + ' reached:' + reached + ' notes: ' + notes);

        this.agbRequest(component, leadID, reached, notes);

        console.log('<< handleOK');
	},
    initRequest: function(component, leadID) {
        var action = component.get('c.init');
        action.setParams({leadID: leadID});
        action.setCallback(this, function(resp) {
            this.processResponse(component, resp, true);
        });
        
        $A.enqueueAction(action);
    },
    agbRequest: function(component, leadID, reached, notes) {
        var action = component.get('c.agbRequest');
        action.setParams({leadID: leadID, customerReached: reached, notes: notes});
        action.setCallback(this, function(resp) {
            this.processResponse(component, resp, false);
        });
        
        $A.enqueueAction(action);
    },
    processResponse: function(component, resp, isInit) {
        var state = resp.getState();
        console.log('processResponse :: callback :: isInit: ' + isInit + 'resp: ' + resp);

        if (state !== "SUCCESS") {
            console.log("Failed to perform action. State: " + state + ' Error: ' + resp.getError());
            if (isInit) {
            	$A.get("e.force:closeQuickAction").fire();
                this.showToastMessage('Ein unerwarteter Fehler ist aufgetreten, bitte wenden Sie sich an den technischen Support, wenn der Fehler weiterhin besteht.', false);
                return;
        	}

            this.showError(component, "Ein unerwarteter Fehler ist aufgetreten, bitte wenden Sie sich an den technischen Support, wenn der Fehler weiterhin besteht.");
            return;
        }
        
        var res = resp.getReturnValue();
        console.log('res.openURL:' + res.openURL + ' res.errorMsg: ' + res.errorMsg);
        if (res.errorMsg) {
            if (isInit) {
            	$A.get("e.force:closeQuickAction").fire();
                this.showToastMessage(res.errorMsg, false);
                return;
        	}

            this.showError(component, res.errorMsg);
            return;
        }
        
        if (!isInit) {
            this.showToastMessage("Die Anfrage wurde erfolgreich ausgeführt.", true);
        }
        
        if (res.openURL) {
            window.open(res.openURL, '_blank');
            if (!isInit) {
         	   $A.get("e.force:closeQuickAction").fire();
        	}
        }
    },
    showError: function(component, text) {
        if (component) {
        	component.set('v.errors', text);   
        }
        this.showToastMessage(text, false);
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