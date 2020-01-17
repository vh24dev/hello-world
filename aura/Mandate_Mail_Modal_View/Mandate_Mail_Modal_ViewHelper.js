({

  subscribe: function (component, event, helper) {
    const empApi = component.find('empApi');
    const channel = component.get('v.channel');  
    const replayId = -1;
    const callback = function (message) {
      console.log('Event Received : ' + JSON.stringify(message));
      helper.onReceiveNotification(component, message);
    };
    empApi.subscribe(channel, replayId, $A.getCallback(callback)).then($A.getCallback(function (newSubscription) {
      console.log('---------------Subscribed to channel ' + channel);
      component.set('v.subscription', newSubscription);
    }));
  },
  
  unsubscribe: function (component, event, helper) {
    const empApi = component.find('empApi');
    const channel = component.get('v.subscription').channel;
    const callback = function (message) {
      console.log('Unsubscribed from channel ' + message.channel);
    };
    empApi.unsubscribe(component.get('v.subscription'), $A.getCallback(callback));
  },

  onReceiveNotification: function (component, message) {
    var uuid = component.get("v.uuid");
    if(message.data.payload.Mail_Id == uuid ) {  
    	console.log('---------------Received Notification ' + message );
    	const newNotification = {
      	time: $A.localizationService.formatDateTime(
        	message.data.payload.CreatedDate, 'HH:mm'),
      		message: message.data.payload.Result_Message__c
    	};
        var displayType = 'error';
        if(message.data.payload.isSuccess__c == true){
        	displayType = 'success';
        }
        console.log('---------------display type ' + displayType );
    	this.displayToast(component, displayType, newNotification.message);
    }
  },
    
  displayToast: function (component, type, message) {
    const toastEvent = $A.get('e.force:showToast');
    toastEvent.setParams({
      type: type,
      message: message
    });
    toastEvent.fire();
  },
    
  retrieveUuid: function(component) {
   var action = component.get("c.retrieveMailUuid");
	action.setCallback(this, function(response) {
    	var state = response.getState();
        if (state === "SUCCESS") {
        	var uuid = response.getReturnValue();
        	if(uuid!= null){
                component.set("v.mailId",uuid);
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
  },
    
  retrieveMyOppId: function(component) {
  	var action = component.get("c.retrieveOppId");
    action.setParams({
    	"claimId" : component.get("v.recordId")
    });
	action.setCallback(this, function(response) {
    	var state = response.getState();
        if (state === "SUCCESS") {
        	var oppId = response.getReturnValue();
        	if(oppId!= null){
                component.set("v.oppId",oppId);
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
  }
   
})