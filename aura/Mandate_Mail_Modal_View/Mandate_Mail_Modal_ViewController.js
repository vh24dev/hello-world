({
    doInit : function(component, event, helper) {
    // call apex method to fetch list view dynamically 
    var action = component.get("c.init");
    action.setParams({
    	"claimId" : component.get("v.recordId")
    });
	action.setCallback(this, function(response) {
    	var state = response.getState();
        if (state === "SUCCESS") {
        	var returnValue = response.getReturnValue();
            if(returnValue == 'disabled'){
                component.set("v.disabled",true);
                component.set("v.enabled",false);
            } else if(returnValue != null){
                component.set("v.disabled",false);
                component.set("v.enabled",true);
                component.set("v.mailAdress",returnValue);
           	}            
        } else if (state === "INCOMPLETE") {
        } else if (state === "ERROR") {
        	var errors = response.getError();
            if (errors) {
            	if (errors[0] && errors[0].message) {
                	console.log("Error message: " + 
                    	errors[0].message);
                    }
                } else {
                	console.log("Unknown error");
                }
            }
        });
    $A.enqueueAction(action);
    const empApi = component.find('empApi');
    const errorHandler = function (message) {
      console.error('Received error ', JSON.stringify(message));
    };    
    empApi.onError($A.getCallback(errorHandler));
    helper.retrieveUuid(component);
        helper.retrieveMyOppId(component);
    helper.subscribe(component, event, helper);
    },
    
	sendMailFrontend : function(component, event, helper) {
        var action = component.get("c.sendMail");
        action.setParams({
            "oppId" : component.get("v.oppId"),
            "mailAddress" : component.get("v.mailAdress"),
            "mailId" : component.get("v.mailId")
        });

     	action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                $A.get("e.force:closeQuickAction").fire();
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
            	var errors = response.getError();
                if (errors) {
                	if (errors[0] && errors[0].message) {
                    	console.log("Error message: " + 
                        errors[0].message);
                    }
                } else {
                    	console.log("Unknown error");
                }
         	}
           
        });
    	$A.enqueueAction(action);   
    }
})