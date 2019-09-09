// Legacy code

public class Utilities {
	// Anbieter
	public static final Id anbieterVR24 = Accounts.VR24ID;
	public static final Id anbieterVH24 = Accounts.VH24ID;

	// Legal Offices
	public static final Id legalOfficeCLLB = Accounts.CLLBLegalID;
	public static final Id legalOfficeJaegerLv = Accounts.JCLegalLvID;
	public static final Id legalOfficeJaegerDiesel = Accounts.JCLegalID;
	public static final Id legalOfficeLachmair = Accounts.LegalLachmairID;
	public static final Id legalOfficeVortmann = Accounts.LegalVortmannID;
	public static final Id legalOffice21Legal = Accounts.Legal21ID;


	// Variables
	public String parErrorSubject { get; set; }
	public String parErrorMessage { get; set; }

	public static Boolean runInsertTriggers = true;
	public static Boolean runDeleteTriggers = true;
	public static Integer accountActionBeforeInsertRun = 0;
	public static Integer accountActionBeforeUpdateRun = 0;
	public static Integer accountActionAfterInsertRun = 0;
	public static Integer accountActionAfterUpdateRun = 0;
	public static Integer opportunityActionBeforeInsertRun = 0;
	public static Integer opportunityActionBeforeUpdateRun = 0;
	public static Integer opportunityActionAfterInsertRun = 0;
	public static Integer opportunityActionAfterUpdateRun = 0;
    public static Integer authorizationActionBeforeInsertRun = 0;
    public static Integer authorizationActionBeforeUpdateRun = 0;
    public static Integer authorizationActionAfterInsertRun = 0;
    public static Integer authorizationActionAfterUpdateRun = 0;
	public static Integer claimActionBeforeUpdateRun = 0;
	public static Integer claimActionAfterUpdateRun = 0;
    public static Integer contractActionBeforeInsertRun = 0;
    public static Integer contractActionBeforeUpdateRun = 0;
    public static Integer contractActionAfterInsertRun = 0;
    public static Integer contractActionAfterUpdateRun = 0;
    public static Integer correspondenceActionBeforeInsertRun = 0;
    public static Integer correspondenceActionBeforeUpdateRun = 0;
    public static Integer correspondenceActionAfterInsertRun = 0;
    public static Integer correspondenceActionAfterUpdateRun = 0;
    public static Integer invoiceActionBeforeInsertRun = 0;
    public static Integer invoiceActionBeforeUpdateRun = 0;
    public static Integer invoiceActionAfterInsertRun = 0;
    public static Integer invoiceActionAfterUpdateRun = 0;
    public static Integer leadActionBeforeInsertRun = 0;
    public static Integer leadActionBeforeUpdateRun = 0;
    public static Integer leadActionAfterInsertRun = 0;
    public static Integer nonContributoryPeriodActionAfterUpdateRun = 0;
	public static Integer nonContributoryPeriodActionBeforeUpdateRun = 0;
	public static Integer leadActionAfterUpdateRun = 0;
    public static Integer taskActionBeforeUpdateRun = 0;
    public static Integer taskActionAfterUpdateRun = 0;
    public static Integer costNoteActionBeforeUpdateRun = 0;
    public static Integer costNoteActionAfterUpdateRun = 0;
	public static Integer documentActionBeforeInsertRun = 0;
	public static Integer documentActionBeforeUpdateRun = 0;
	public static Integer documentActionAfterInsertRun = 0;
	public static Integer documentActionAfterUpdateRun = 0;
	public static Integer welcomeLetterActionBeforeInsertRun = 0;
	public static Integer welcomeLetterActionBeforeUpdateRun = 0;
	public static Integer welcomeLetterActionAfterInsertRun = 0;
	public static Integer welcomeLetterActionAfterUpdateRun = 0;
	public static Integer attachmentActionBeforeInsertRun = 0;
	public static Integer attachmentActionBeforeUpdateRun = 0;
	public static Integer attachmentActionAfterInsertRun = 0;
	public static Integer attachmentActionAfterUpdateRun = 0;
	public static Integer receiptActionBeforeInsertRun = 0;
	public static Integer receiptActionBeforeUpdateRun = 0;
	public static Integer receiptActionAfterInsertRun = 0;
	public static Integer receiptActionAfterUpdateRun = 0;
	public static Integer costNoteReminderActionBeforeInsertRun = 0;
	public static Integer costNoteReminderActionBeforeUpdateRun = 0;
	public static Integer costNoteReminderActionAfterInsertRun = 0;
	public static Integer costNoteReminderActionAfterUpdateRun = 0;
	public static Integer classActionActionBeforeInsertRun = 0;
	public static Integer classActionActionBeforeUpdateRun = 0;
	public static Integer classActionActionAfterInsertRun = 0;
	public static Integer classActionActionAfterUpdateRun = 0;
	public static Integer invoiceReminderActionBeforeInsertRun = 0;
	public static Integer invoiceReminderActionBeforeUpdateRun = 0;
	public static Integer invoiceReminderActionAfterInsertRun = 0;
	public static Integer invoiceReminderActionAfterUpdateRun = 0;
	public static Integer userReferenceActionBeforeInsertRun = 0;
	public static Integer userReferenceActionBeforeUpdateRun = 0;
	public static Integer userReferenceActionBeforeDeleteRun = 0;
	public static Integer userReferenceActionAfterInsertRun = 0;
	public static Integer userReferenceActionAfterUpdateRun = 0;
	public static Integer userReferenceActionAfterDeleteRun = 0;
	public static Integer deadlineActionBeforeInsertRun = 0;
	public static Integer deadlineActionBeforeUpdateRun = 0;
	public static Integer deadlineActionAfterInsertRun = 0;
	public static Integer deadlineActionAfterUpdateRun = 0;
	public static Integer creditNoteActionBeforeInsertRun = 0;
	public static Integer creditNoteActionBeforeUpdateRun = 0;
	public static Integer creditNoteActionAfterInsertRun = 0;
	public static Integer creditNoteActionAfterUpdateRun = 0;
	public static Integer dateActionBeforeUpdateRun = 0;
	public static Integer dateActionAfterUpdateRun = 0;
	public static Integer commissionActionBeforeUpdateRun = 0;
	public static Integer commissionActionAfterUpdateRun = 0;
	public static Integer costNotePaymentActionBeforeUpdateRun = 0;
	public static Integer costNotePaymentActionAfterUpdateRun = 0;
	public static Integer contactActionBeforeUpdateRun = 0;
	public static Integer contactActionAfterUpdateRun = 0;
	public static Integer cancellationActionBeforeUpdateRun = 0;
	public static Integer cancellationActionAfterUpdateRun = 0;
	public static Integer testCaseActionBeforeUpdateRun = 0;
	public static Integer testCaseActionAfterUpdateRun = 0;
	public static Integer opportunityCorrespondenceActionBeforeUpdateRun = 0;
	public static Integer opportunityCorrespondenceActionAfterUpdateRun = 0;

	// Configuration parameters
	public static Boolean configurationCached = false;
	public static Boolean deactivateEmail = false;
	public static Boolean deactivateTrigger = false;
	public static Boolean deactivateAutoFollowUps = false;
	public static Boolean sendEmailViaAPI = false;
    public static Boolean deactivateTaskCreation = false;
	public static Boolean deactivateAutosendWelcomeLetter = false;
	public static Boolean deactivateAutosendAuthorization = false;
	public static Boolean deactivateAutosendCostNoteReminder = false;
	public static Boolean deactivateAutosendInvoiceReminder = false;
	public static Boolean deactivateTransactionReceival = false;
	public static Boolean deactivateTransactionMapping = false;
	public static Boolean disableQueueableChaining = false;
	public static Boolean deactivateAutoLoss = false;
	public static Id dieselgateDefaultLegalUser = null;
	public static Boolean deactivateDropboxUpload = false;
	public static Boolean deactivateSyncTo21legal = false;
	public static Id deactivateEmailUser;
	public static Id deactivateTriggerUser;

    // Queue of error emails to be sent at the end
    public static List<Messaging.SingleEmailMessage> errorMails = new List<Messaging.SingleEmailMessage>();

	// Constructor
	public Utilities() {
		if (ApexPages.currentPage().getParameters().get('errorSubject') != null){
			parErrorSubject = String.valueOf(ApexPages.currentPage().getParameters().get('errorSubject'));
		}
		if (ApexPages.currentPage().getParameters().get('errorMessage') != null){
			parErrorMessage = String.valueOf(ApexPages.currentPage().getParameters().get('errorMessage'));
		}
	}

	public static void activateTriggers(){
		runInsertTriggers = true;
	    runDeleteTriggers = true;
		accountActionBeforeInsertRun = 0;
		accountActionBeforeUpdateRun = 0;
		accountActionAfterInsertRun = 0;
		accountActionAfterUpdateRun = 0;
		opportunityActionBeforeInsertRun = 0;
		opportunityActionBeforeUpdateRun = 0;
		opportunityActionAfterInsertRun = 0;
		opportunityActionAfterUpdateRun = 0;
        authorizationActionBeforeInsertRun = 0;
        authorizationActionBeforeUpdateRun = 0;
        authorizationActionAfterInsertRun = 0;
        authorizationActionAfterUpdateRun = 0;
		claimActionBeforeUpdateRun = 0;
		claimActionAfterUpdateRun = 0;
        contractActionBeforeInsertRun = 0;
        contractActionBeforeUpdateRun = 0;
        contractActionAfterInsertRun = 0;
        contractActionAfterUpdateRun = 0;
        correspondenceActionBeforeInsertRun = 0;
        correspondenceActionBeforeUpdateRun = 0;
        correspondenceActionAfterInsertRun = 0;
        correspondenceActionAfterUpdateRun = 0;
        invoiceActionBeforeInsertRun = 0;
        invoiceActionBeforeUpdateRun = 0;
        invoiceActionAfterInsertRun = 0;
        invoiceActionAfterUpdateRun = 0;
        leadActionBeforeInsertRun = 0;
        leadActionBeforeUpdateRun = 0;
        leadActionAfterInsertRun = 0;
        leadActionAfterUpdateRun = 0;
		nonContributoryPeriodActionBeforeUpdateRun = 0;
		nonContributoryPeriodActionAfterUpdateRun = 0;
		taskActionBeforeUpdateRun = 0;
    	taskActionAfterUpdateRun = 0;
		costNoteActionBeforeUpdateRun = 0;
    	costNoteActionAfterUpdateRun = 0;
		documentActionBeforeInsertRun = 0;
		documentActionBeforeUpdateRun = 0;
		documentActionAfterInsertRun = 0;
		documentActionAfterUpdateRun = 0;
		welcomeLetterActionBeforeInsertRun = 0;
		welcomeLetterActionBeforeUpdateRun = 0;
		welcomeLetterActionAfterInsertRun = 0;
		welcomeLetterActionAfterUpdateRun = 0;
		attachmentActionBeforeInsertRun = 0;
		attachmentActionBeforeUpdateRun = 0;
		attachmentActionAfterInsertRun = 0;
		attachmentActionAfterUpdateRun = 0;
		receiptActionBeforeInsertRun = 0;
		receiptActionBeforeUpdateRun = 0;
		receiptActionAfterInsertRun = 0;
		receiptActionAfterUpdateRun = 0;
		costNoteReminderActionBeforeInsertRun = 0;
		costNoteReminderActionBeforeUpdateRun = 0;
		costNoteReminderActionAfterInsertRun = 0;
		costNoteReminderActionAfterUpdateRun = 0;
		classActionActionBeforeInsertRun = 0;
		classActionActionBeforeUpdateRun = 0;
		classActionActionAfterInsertRun = 0;
		classActionActionAfterUpdateRun = 0;
	    invoiceReminderActionBeforeInsertRun = 0;
	    invoiceReminderActionBeforeUpdateRun = 0;
	    invoiceReminderActionAfterInsertRun = 0;
	    invoiceReminderActionAfterUpdateRun = 0;
	    userReferenceActionBeforeInsertRun = 0;
	    userReferenceActionBeforeUpdateRun = 0;
	    userReferenceActionBeforeDeleteRun = 0;
	    userReferenceActionAfterInsertRun = 0;
	    userReferenceActionAfterUpdateRun = 0;
	    userReferenceActionAfterDeleteRun = 0;
		deadlineActionBeforeInsertRun = 0;
		deadlineActionBeforeUpdateRun = 0;
		deadlineActionAfterInsertRun = 0;
		deadlineActionAfterUpdateRun = 0;
		creditNoteActionBeforeInsertRun = 0;
		creditNoteActionBeforeUpdateRun = 0;
		creditNoteActionAfterInsertRun = 0;
		creditNoteActionAfterUpdateRun = 0;
		dateActionBeforeUpdateRun = 0;
		dateActionAfterUpdateRun = 0;
	    commissionActionBeforeUpdateRun = 0;
	    commissionActionAfterUpdateRun = 0;
	    costNotePaymentActionBeforeUpdateRun = 0;
	    costNotePaymentActionAfterUpdateRun = 0;
		contactActionBeforeUpdateRun = 0;
		contactActionAfterUpdateRun = 0;
		cancellationActionBeforeUpdateRun = 0;
		cancellationActionAfterUpdateRun = 0;
		testCaseActionBeforeUpdateRun = 0;
		testCaseActionAfterUpdateRun = 0;
		opportunityCorrespondenceActionBeforeUpdateRun = 0;
		opportunityCorrespondenceActionAfterUpdateRun = 0;
    }

    // Use OpportunityRevenue.calculate instead. Extracted from here to later get rid of this class.
	public static Decimal calculateRevenue(Id accountId, Decimal value, Id recordTypeId, String assignmentType){
		Decimal amount;
		if (Opportunities.isDieselSkandal(recordTypeId)) { // 0120Y000000W0CY
			// DG
			if (assignmentType == 'Share'){
				amount = value * 0.25;
				System.debug(amount*1.19);
				if ((amount * 1.19) > 2900){
					amount = (2900 / 1.19).setScale(2,System.RoundingMode.HALF_UP);
				}
			} else {
				amount = 0;
			}
		} else {
			// LV
			if (Accounts.isVH24(accountId)){ // 0010Y00000eCUS9
				// VH24
				if (assignmentType == 'Share'){
					if (value <= 50000){
						amount = value * 0.4 * 1.19;
					} else if (value <= 75000){
						amount = value * 0.37 * 1.19;
					} else if (value <= 100000){
						amount = value * 0.34 * 1.19;
					} else {
						amount = value * 0.3 * 1.19;
					}
				} else if (assignmentType == 'RSV'){
					amount = (value * 0.2 * 1.19) + 89.0;
				} else {
					amount = 0;
				}
			} else {
				// VR24
				if (assignmentType == 'Share'){
					if (value <= 50000){
						amount = value * 0.5;
					} else if (value <= 75000){
						amount = value * 0.45;
					} else if (value <= 100000){
						amount = value * 0.4;
					} else {
						amount = value * 0.35;
					}
				} else if (assignmentType == 'RSV'){
					amount = value * 0.2;
				} else {
					amount = 0;
				}
			}
		}
		return amount;
	}

    public static List<Task> closeTasks(String subject, sObject parentObject){
        List<Task> closeTasks = new List<Task>();
        for (Task task : parentObject.getSObjects('Tasks')){
            if ((task.Subject.contains(subject)) && (task.Status != 'Completed')){
                task.Status = 'Completed';
                closeTasks.add(task);
            }
        }
        return closeTasks;
    }
    
    // Use Correspondences.build instead
    public static Correspondence__c createCorrespondence(Claim__c claim, String partner, String type, String stage, String textModules){
        // Create object
        Correspondence__c correspondence = new Correspondence__c(
        	Claim__c = claim.Id,
            Partner__c = partner,
            Type__c = type,
            Stage__c = stage,
            Text_Modules__c = textModules
        );

		// Check for duplicates
        Integer correspondenceCount = 0;
        for (Correspondence__c existingCorrespondence : claim.Correspondencies__r){
            if ((correspondence.Type__c == existingCorrespondence.Type__c) && (correspondence.Description__c == existingCorrespondence.Description__c)){
                correspondenceCount++;
            }
        }

        // Return object
        if (correspondenceCount == 0){
	        return correspondence;
        } else {
        	return null;
        }
    }
    
	public static String createHash(){
		Blob randomBlob = Crypto.GenerateAESKey(128);
		String randomHex = EncodingUtil.ConvertTohex(randomBlob);
		String hash = randomHex.SubString(0,8)+ '-' + randomHex.SubString(8,12) + '-' + randomHex.SubString(12,16) + '-' + randomHex.SubString(16,20) + '-' + randomHex.substring(20);		
		return hash;
	}

    public static Task createTask(String subject, String description, sObject parentObject, User owner, Date activityDate, Boolean checkExisting, Boolean isFollowUpTask){
        getConfiguration();

        if ((owner != null) && (owner.isActive == true) && (deactivateTaskCreation == false)){
            Task task = New Task(
                OwnerId = owner.Id,
                Subject = subject,
                WhatId = parentObject.Id,
                ActivityDate = activityDate,
                Status = 'Open',
                Priority = 'Normal',
                Type = 'Task',
                Description = description,
	            Follow_Up_Task__c = isFollowUpTask
            );



            Boolean addTask = true;
            for (Task oldtask : parentObject.getSObjects('Tasks')){
                if (oldtask.Subject == task.Subject){
                    addTask = false;
                }
            }
            
            if ((checkExisting == false) || (addTask == true)){  
	            return task;		
            } else {
                return null;
            }

        } else {
            return null;
        }
    }    

    public static void deactivateTriggers(){
		runInsertTriggers = false;
	    runDeleteTriggers = false;
		accountActionBeforeInsertRun = 2;
		accountActionBeforeUpdateRun = 2;
		accountActionAfterInsertRun = 2;
		accountActionAfterUpdateRun = 2;
		opportunityActionBeforeInsertRun = 2;
		opportunityActionBeforeUpdateRun = 2;
		opportunityActionAfterInsertRun = 2;
		opportunityActionAfterUpdateRun = 2;
        authorizationActionBeforeInsertRun = 2;
        authorizationActionBeforeUpdateRun = 2;
        authorizationActionAfterInsertRun = 2;
        authorizationActionAfterUpdateRun = 2;
		claimActionBeforeUpdateRun = 2;
		claimActionAfterUpdateRun = 2;
        contractActionBeforeInsertRun = 2;
        contractActionBeforeUpdateRun = 2;
        contractActionAfterInsertRun = 2;
        contractActionAfterUpdateRun = 2;
        correspondenceActionBeforeInsertRun = 2;
        correspondenceActionBeforeUpdateRun = 2;
        correspondenceActionAfterInsertRun = 2;
        correspondenceActionAfterUpdateRun = 2;
        invoiceActionBeforeInsertRun = 2;
        invoiceActionBeforeUpdateRun = 2;
        invoiceActionAfterInsertRun = 2;
        invoiceActionAfterUpdateRun = 2;
        leadActionBeforeInsertRun = 2;
        leadActionBeforeUpdateRun = 2;
        leadActionAfterInsertRun = 2;
        leadActionAfterUpdateRun = 2;
		nonContributoryPeriodActionBeforeUpdateRun = 2;
		nonContributoryPeriodActionAfterUpdateRun = 2;
		taskActionBeforeUpdateRun = 2;
    	taskActionAfterUpdateRun = 2;
		costNoteActionBeforeUpdateRun = 2;
    	costNoteActionAfterUpdateRun = 2;
		documentActionBeforeInsertRun = 2;
		documentActionBeforeUpdateRun = 2;
		documentActionAfterInsertRun = 2;
		documentActionAfterUpdateRun = 2;
		welcomeLetterActionBeforeInsertRun = 2;
		welcomeLetterActionBeforeUpdateRun = 2;
		welcomeLetterActionAfterInsertRun = 2;
		welcomeLetterActionAfterUpdateRun = 2;
		attachmentActionBeforeInsertRun = 2;
		attachmentActionBeforeUpdateRun = 2;
		attachmentActionAfterInsertRun = 2;
		attachmentActionAfterUpdateRun = 2;
		receiptActionBeforeInsertRun = 2;
		receiptActionBeforeUpdateRun = 2;
		receiptActionAfterInsertRun = 2;
		receiptActionAfterUpdateRun = 2;
		costNoteReminderActionBeforeInsertRun = 2;
		costNoteReminderActionBeforeUpdateRun = 2;
		costNoteReminderActionAfterInsertRun = 2;
		costNoteReminderActionAfterUpdateRun = 2;
		classActionActionBeforeInsertRun = 2;
		classActionActionBeforeUpdateRun = 2;
		classActionActionAfterInsertRun = 2;
		classActionActionAfterUpdateRun = 2;
	    invoiceReminderActionBeforeInsertRun = 2;
	    invoiceReminderActionBeforeUpdateRun = 2;
	    invoiceReminderActionAfterInsertRun = 2;
	    invoiceReminderActionAfterUpdateRun = 2;
	    userReferenceActionBeforeInsertRun = 2;
	    userReferenceActionBeforeUpdateRun = 2;
	    userReferenceActionBeforeDeleteRun = 2;
	    userReferenceActionAfterInsertRun = 2;
	    userReferenceActionAfterUpdateRun = 2;
	    userReferenceActionAfterDeleteRun = 2;
		deadlineActionBeforeInsertRun = 2;
		deadlineActionBeforeUpdateRun = 2;
		deadlineActionAfterInsertRun = 2;
		deadlineActionAfterUpdateRun = 2;
		creditNoteActionBeforeInsertRun = 2;
		creditNoteActionBeforeUpdateRun = 2;
		creditNoteActionAfterInsertRun = 2;
		creditNoteActionAfterUpdateRun = 2;
		dateActionBeforeUpdateRun = 2;
		dateActionAfterUpdateRun = 2;
	    commissionActionBeforeUpdateRun = 2;
	    commissionActionAfterUpdateRun = 2;
	    costNotePaymentActionBeforeUpdateRun = 2;
	    costNotePaymentActionAfterUpdateRun = 2;
		contactActionBeforeUpdateRun = 2;
		contactActionAfterUpdateRun = 2;
		cancellationActionBeforeUpdateRun = 2;
		cancellationActionAfterUpdateRun = 2;
		testCaseActionBeforeUpdateRun = 2;
		testCaseActionAfterUpdateRun = 2;
		opportunityCorrespondenceActionBeforeUpdateRun = 2;
		opportunityCorrespondenceActionAfterUpdateRun = 2;
    }

    // Use Decimals.decimalToCurrency instead so that we can get rid of this class in the future
	public static String decimalToCurrency(Decimal inputDecimal){
		String outputString;
		if (inputDecimal != null){
			outputString = Math.floor(inputDecimal).format();
			if (Math.mod((Long)(inputDecimal*100),100) > 0){
				outputString = outputString + ',' + Math.mod((Long)(Math.floor(inputDecimal*100)),100).format().rightPad(2,'0') + ' €';
			} else {
				outputString = outputString + ',00 €';
			}
		}
		return outputString;
	}

    public static Integer flushMailQueue() {
        if (Limits.getEmailInvocations() <= Limits.getLimitEmailInvocations()) {
            // Limit exception cannot be caught, so we use Limits.
            
            // Limits docs say "Total number of sendEmail methods allowed: 10", so invoking
            // sendMail with a list should only increase the limit by 1
            
            Messaging.SendEmailResult[] r = Messaging.sendEmail(errorMails, false);
            
            // Check result of sending operation and reset mail queue if no errors
            Boolean sendSuccess = true;
            for (Messaging.SendEmailResult result : r) {
                if (result.isSuccess() == false) {
                    sendSuccess = false;
                    break;
	            }
            }
            if (sendSuccess == true) {
                errorMails = new List<Messaging.SingleEmailMessage>();
            }
        }
        
        // Amount of error emails that were send/were created during the transaction
        return errorMails.size();
	}

    public static void getConfiguration(){

	    /*if (configurationCached == false) {
		    List<cloudworx_Management_Console__c> configs = [select Id, Deactivate_Email_User__c, Deactivate_Trigger_User__c, Deactivate_Trigger__c, Deactivate_Auto_Loss__c, Deactivate_Email__c, Deactivate_Auto_Follow_ups__c, Send_Email_Via_API__c, Deactivate_Task_Creation__c, Disable_Queueable_Chaining__c, Deactivate_Autosend_Welcome_Letter__c, Deactivate_Autosend_Authorization__c, Deactivate_Autosend_Cost_Note_Reminder__c, Deactivate_Autosend_Invoice_Reminder__c, Deactivate_Transaction_Receival__c, Deactivate_Transaction_Mapping__c, Deactivate_Dropbox_Upload__c, Deactivate_Sync_To_21legal__c from cloudworx_Management_Console__c];
		    for (cloudworx_Management_Console__c config : configs) {*/
			    deactivateEmail = false;//config.Deactivate_Email__c;
				deactivateTrigger = false;//config.Deactivate_Trigger__c;
			    deactivateAutoFollowUps = false;//config.Deactivate_Auto_Follow_ups__c;
			    sendEmailViaAPI = false;//config.Send_Email_Via_API__c;
			    deactivateTaskCreation = false;//config.Deactivate_Task_Creation__c;
			    deactivateAutosendWelcomeLetter = false;//config.Deactivate_Autosend_Welcome_Letter__c;
				deactivateAutosendAuthorization = false;//config.Deactivate_Autosend_Authorization__c;
			    deactivateAutosendCostNoteReminder = false;//config.Deactivate_Autosend_Cost_Note_Reminder__c;
			    deactivateAutosendInvoiceReminder = false;//config.Deactivate_Autosend_Invoice_Reminder__c;
			    deactivateTransactionReceival = false;//config.Deactivate_Transaction_Receival__c;
			    deactivateTransactionMapping = false;//config.Deactivate_Transaction_Mapping__c;
			    deactivateAutoLoss = false;//config.Deactivate_Auto_Loss__c;
			    disableQueueableChaining = false;//config.Disable_Queueable_Chaining__c;
			    deactivateDropboxUpload = false;//config.Deactivate_Dropbox_Upload__c;
			    deactivateSyncTo21legal = false;//config.Deactivate_Sync_To_21legal__c;
				deactivateEmailUser = null;//config.Deactivate_Email_User__c;
				deactivateTriggerUser = null;//config.Deactivate_Trigger_User__c;
          /*}
		    configurationCached = true;
	    }*/
    }

	public static Decimal getCourtCost(Decimal amount, Decimal factor){
		if (amount <= 500){
			return (Decimal)35.00 * factor;
		} else if (amount <= 1000){
			return (Decimal)53.00 * factor;
		} else if (amount <= 1500){
			return (Decimal)71.00 * factor;
		} else if (amount <= 2000){
			return (Decimal)89.00 * factor;
		} else if (amount <= 3000){
			return (Decimal)108.00 * factor;
		} else if (amount <= 4000){
			return (Decimal)127.00 * factor;
		} else if (amount <= 5000){
			return (Decimal)146.00 * factor;
		} else if (amount <= 6000){
			return (Decimal)165.00 * factor;
		} else if (amount <= 7000){
			return (Decimal)184.00 * factor;
		} else if (amount <= 8000){
			return (Decimal)203.00 * factor;
		} else if (amount <= 9000){
			return (Decimal)222.00 * factor;
		} else if (amount <= 10000){
			return (Decimal)241.00 * factor;
		} else if (amount <= 13000){
			return (Decimal)267.00 * factor;
		} else if (amount <= 16000){
			return (Decimal)293.00 * factor;
		} else if (amount <= 19000){
			return (Decimal)319.00 * factor;
		} else if (amount <= 22000){
			return (Decimal)345.00 * factor;
		} else if (amount <= 25000){
			return (Decimal)371.00 * factor;
		} else if (amount <= 30000){
			return (Decimal)406.00 * factor;
		} else if (amount <= 35000){
			return (Decimal)441.00 * factor;
		} else if (amount <= 40000){
			return (Decimal)476.00 * factor;
		} else if (amount <= 45000){
			return (Decimal)511.00 * factor;
		} else if (amount <= 50000){
			return (Decimal)546.00 * factor;
		} else if (amount <= 65000){
			return (Decimal)666.00 * factor;
		} else if (amount <= 80000){
			return (Decimal)786.00 * factor;
		} else if (amount <= 95000){
			return (Decimal)906.00 * factor;
		} else if (amount <= 110000){
			return (Decimal)1026.00 * factor;
		} else if (amount <= 125000){
			return (Decimal)1146.00 * factor;
		} else if (amount <= 140000){
			return (Decimal)1266.00 * factor;
		} else if (amount <= 155000){
			return (Decimal)1386.00 * factor;
		} else if (amount <= 170000){
			return (Decimal)1506.00 * factor;
		} else if (amount <= 185000){
			return (Decimal)1626.00 * factor;
		} else if (amount <= 200000){
			return (Decimal)1746.00 * factor;
		} else if (amount <= 230000){
			return (Decimal)1925.00 * factor;
		} else if (amount <= 260000){
			return (Decimal)2104.00 * factor;
		} else if (amount <= 290000){
			return (Decimal)2283.00 * factor;
		} else if (amount <= 320000){
			return (Decimal)2462.00 * factor;
		} else if (amount <= 350000){
			return (Decimal)2641.00 * factor;
		} else if (amount <= 380000){
			return (Decimal)2820.00 * factor;
		} else if (amount <= 410000){
			return (Decimal)2999.00 * factor;
		} else if (amount <= 440000){
			return (Decimal)3178.00 * factor;
		} else if (amount <= 470000){
			return (Decimal)3357.00 * factor;
		} else if (amount <= 500000){
			return (Decimal)3536.00 * factor;
		} else if (amount <= 550000){
			return (Decimal)3716.00 * factor;
		} else if (amount <= 600000){
			return (Decimal)3896.00 * factor;
		} else if (amount <= 650000){
			return (Decimal)4076.00 * factor;
		} else if (amount <= 700000){
			return (Decimal)4256.00 * factor;
		} else if (amount <= 750000){
			return (Decimal)4436.00 * factor;
		} else if (amount <= 800000){
			return (Decimal)4616.00 * factor;
		} else if (amount <= 850000){
			return (Decimal)4796.00 * factor;
		} else if (amount <= 900000){
			return (Decimal)4976.00 * factor;
		} else if (amount <= 950000){
			return (Decimal)5156.00 * factor;
		} else if (amount <= 1000000){
			return (Decimal)5336.00 * factor;
		} else {
			return null;
		}
	}

	public static Decimal getLegalCost(Decimal amount, Decimal factor){
		if (amount <= 500){
			return (Decimal)45.00 * factor;
		} else if (amount <= 1000){
			return (Decimal)80.00 * factor;
		} else if (amount <= 1500){
			return (Decimal)115.00 * factor;
		} else if (amount <= 2000){
			return (Decimal)150.00 * factor;
		} else if (amount <= 3000){
			return (Decimal)201.00 * factor;
		} else if (amount <= 4000){
			return (Decimal)252.00 * factor;
		} else if (amount <= 5000){
			return (Decimal)303.00 * factor;
		} else if (amount <= 6000){
			return (Decimal)354.00 * factor;
		} else if (amount <= 7000){
			return (Decimal)405.00 * factor;
		} else if (amount <= 8000){
			return (Decimal)456.00 * factor;
		} else if (amount <= 9000){
			return (Decimal)507.00 * factor;
		} else if (amount <= 10000){
			return (Decimal)558.00 * factor;
		} else if (amount <= 13000){
			return (Decimal)604.00 * factor;
		} else if (amount <= 16000){
			return (Decimal)650.00 * factor;
		} else if (amount <= 19000){
			return (Decimal)696.00 * factor;
		} else if (amount <= 22000){
			return (Decimal)742.00 * factor;
		} else if (amount <= 25000){
			return (Decimal)788.00 * factor;
		} else if (amount <= 30000){
			return (Decimal)863.00 * factor;
		} else if (amount <= 35000){
			return (Decimal)938.00 * factor;
		} else if (amount <= 40000){
			return (Decimal)1013.00 * factor;
		} else if (amount <= 45000){
			return (Decimal)1088.00 * factor;
		} else if (amount <= 50000){
			return (Decimal)1163.00 * factor;
		} else if (amount <= 65000){
			return (Decimal)1248.00 * factor;
		} else if (amount <= 80000){
			return (Decimal)1333.00 * factor;
		} else if (amount <= 95000){
			return (Decimal)1418.00 * factor;
		} else if (amount <= 110000){
			return (Decimal)1503.00 * factor;
		} else if (amount <= 125000){
			return (Decimal)1588.00 * factor;
		} else if (amount <= 140000){
			return (Decimal)1673.00 * factor;
		} else if (amount <= 155000){
			return (Decimal)1758.00 * factor;
		} else if (amount <= 170000){
			return (Decimal)1843.00 * factor;
		} else if (amount <= 185000){
			return (Decimal)1928.00 * factor;
		} else if (amount <= 200000){
			return (Decimal)2013.00 * factor;
		} else if (amount <= 230000){
			return (Decimal)2133.00 * factor;
		} else if (amount <= 260000){
			return (Decimal)2253.00 * factor;
		} else if (amount <= 290000){
			return (Decimal)2373.00 * factor;
		} else if (amount <= 320000){
			return (Decimal)2493.00 * factor;
		} else if (amount <= 350000){
			return (Decimal)2613.00 * factor;
		} else if (amount <= 380000){
			return (Decimal)2733.00 * factor;
		} else if (amount <= 410000){
			return (Decimal)2853.00 * factor;
		} else if (amount <= 440000){
			return (Decimal)2973.00 * factor;
		} else if (amount <= 470000){
			return (Decimal)3093.00 * factor;
		} else if (amount <= 500000){
			return (Decimal)3213.00 * factor;
		} else if (amount <= 550000){
			return (Decimal)3363.00 * factor;
		} else if (amount <= 600000){
			return (Decimal)3513.00 * factor;
		} else if (amount <= 650000){
			return (Decimal)3663.00 * factor;
		} else if (amount <= 700000){
			return (Decimal)3813.00 * factor;
		} else if (amount <= 750000){
			return (Decimal)3963.00 * factor;
		} else if (amount <= 800000){
			return (Decimal)4113.00 * factor;
		} else if (amount <= 850000){
			return (Decimal)4263.00 * factor;
		} else if (amount <= 900000){
			return (Decimal)4413.00 * factor;
		} else if (amount <= 950000){
			return (Decimal)4563.00 * factor;
		} else if (amount <= 1000000){
			return (Decimal)4713.00 * factor;
		} else {
			return null;
		}
	}

	public static String mergeText(String text, Map<Id,String> scopes) {
        List<String> mrgflds = new List<String>();
        
        Map<String,String> queryObjects = new Map<String,String>();

		if (text != null){
	        for (String splt : text.split('\\{')){
	            
	            mrgflds.add(splt.split('\\}')[0].removeStart('!'));
	            
	        }
	        mrgflds.remove(0);
        }
        
        for (String splts : mrgflds){
            Integer i = 0;
            String obj = '';
			String fld = '';
            for (String split : splts.split('\\.')){
                if (i == 0){
                    obj = split;
                } else if (i == 1){
                    fld = fld + split;
                } else {
                    fld = fld + '.' + split;
                }
                i++;
            }
            
			if (queryObjects.get(obj) == null){
				queryObjects.put(obj,fld);
			} else {
				Set<String> queryFields = new Set<String>();
				queryFields.addAll(queryObjects.get(obj).split(','));
				if (!queryFields.contains(fld)){
					queryObjects.put(obj,queryObjects.get(obj) + ',' + fld);
				}
			}
        }
        
		for (String queryObject : queryObjects.keySet()){

			for (Id objectId : scopes.keySet()){
				String objid = '';
				if (objectId != null){
					String alias = scopes.get(objectId);

					if (queryObject == alias){
						objid = objectId;
					}

					if (objid != ''){
						System.debug('Query: ' + 'SELECT ' + queryObjects.get(queryObject) + ' FROM ' + Id.valueOf(objid).getSObjectType().getDescribe().getName() + ' where Id = :objid');
						List<SObject> objects = Database.query('SELECT ' + queryObjects.get(queryObject) + ' FROM ' + Id.valueOf(objid).getSObjectType().getDescribe().getName() + ' where Id = :objid');

						if (objects.size() > 0) {
							for (String fieldName : queryObjects.get(queryObject).split(',')) {

								String srch = '{!' + queryObject + '.' + fieldName + '}';
								String srchWithout = '{' + queryObject + '.' + fieldName + '}';
								String repl;

								if (fieldName.split('\\.').Size() == 1) {
									repl = String.valueOf(objects[0].get(fieldName));
								} else if (fieldName.split('\\.').Size() == 2) {
									SObject level2object = objects[0].getSObject(fieldName.split('\\.')[0]);
									if (level2object != null) {
										repl = String.valueOf(level2object.get(fieldName.split('\\.')[1]));
									}
								} else if (fieldName.split('\\.').Size() == 3) {
									SObject level2object = objects[0].getSObject(fieldName.split('\\.')[0]);
									if (level2object != null) {
										SObject level3object = level2object.getSObject(fieldName.split('\\.')[1]);
										if (level3object != null) {
											repl = String.valueOf(level3object.get(fieldName.split('\\.')[2]));
										}
									}
								}

								if (repl == null) {
									repl = '';
								}

								text = text.replace(srch, repl);
								text = text.replace(srchWithout, repl);
							}
						}
					}
				}
			}
		}

		// Remove not merged fields
		for (String queryObject : queryObjects.keySet()){
			for (String fieldName : queryObjects.get(queryObject).split(',')) {

				String srch = '{!' + queryObject + '.' + fieldName + '}';
				String srchWithout = '{' + queryObject + '.' + fieldName + '}';
				text = text.replace(srch, '');
				text = text.replace(srchWithout, '');
			}
		}

		return text;
    }

    public static void sendErrorMail(String errorSubject, String error, String requestUrl, String response, Boolean queued) {
        // Get an merge template
        string tplID = EmailTemplates.idOf(EmailTemplates.name.ErrorNotification); // 00X0Y000000N0mf
        EmailTemplate template = [select Id, Subject, Body from EmailTemplate where Id = :tplID];
        String mailSubject;
        String mailBody;
        
        mailSubject = template.Subject;
        mailBody = template.Body;
		mailSubject = mailSubject.replace('{!error_subject}', errorSubject);
        mailBody = mailBody.replace('{!error}', error);
        mailBody = mailBody.replace('{!request}', requestUrl);
        if (!String.isBlank(response)) {
            mailBody = mailBody.replace('{!response}', response);
        }

        // Creates the mail and sets the paramaters
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        List<String> toadds = new List<String>();
        toadds.add('verbraucherhilfe24@salesfive.com');
        email.setToAddresses(toadds);
        email.setSubject(mailSubject);
        email.setPlainTextBody(mailBody);

        errorMails.add(email);

		if (queued == false) {
		    // Make sure, priority or single mails that were not meant to be
		    // queued are sent immediately.
		    flushMailQueue();
		}
	}

	public static HTTPResponse sendHTTPRequest(String method, String contentType, String authenticationHeader, String endpoint, String body, Integer timeout, Integer retries) {
		String error;
		String errorSubject;

		// Debug request body
		System.debug('API request endpoint: ' + endpoint);
		System.debug('API request body: ' + body);

		// create an HTTPrequest object
		HttpRequest req = new HttpRequest();

		// set up the HTTP request with a method, endpoint, header, and body
		req.setMethod(method);
		if (contentType != null) {
			req.setHeader('Content-type', contentType);
		}
		if (authenticationHeader != null){
			req.setHeader('Authorization', authenticationHeader);
		}
		req.setEndpoint(endpoint);
		if (body != null){
			req.setBody(body);
		}
		req.setTimeout(timeout);

		// create a new HTTP object
		Http http = new Http();
		HTTPResponse res = new HTTPResponse();

		// create a new HTTP response for receiving the remote response
		// then use it to send the configured HTTPrequest
		Integer retryCount = 0;
		Boolean salesforceException = false;
		do {
			try {
				res = http.send(req);
				salesforceException = false;
				// Debug response body
				System.debug('API response: ' + res.getBody().abbreviate(1000));
				retryCount++;
			} catch (Exception e){
				salesforceException = true;
				error = 'Error while trying to send HTTP-Request (' + req.getEndpoint() + '): ' + e.getMessage();
				errorSubject = 'HTTP-Request salesforce exception';
				retryCount++;
			}
		} while ((retryCount <= retries) && ((salesforceException == true) || (String.valueOf(res.getStatusCode()).startsWith('5'))));

		// Return request or send queue error mail
		if (salesforceException == false){
			if (!String.valueOf(res.getStatusCode()).startsWith('2')) {
				error = 'Error while trying to send HTTP-Request (' + req.getEndpoint() + '): ' + res.getStatusCode() + ' ' + res.getStatus();
				errorSubject = 'HTTP-Request connection error';
				// Debug error
				System.debug('Error: ' + errorSubject + ', ' + error);
				// Queue error mail
				if (body != null){
					sendErrorMail(errorSubject, error, body, res.getBody(), true);
				} else {
					sendErrorMail(errorSubject, error, endpoint, res.getBody(), true);
				}
				return res;
			} else {
				return res;
			}
		} else {
			// Debug error
			System.debug('Error: ' + errorSubject + ', ' + error);
			// Queue error mail
			if (body != null){
				sendErrorMail(errorSubject, error, body, 'No response received.', true);
			} else {
				sendErrorMail(errorSubject, error, endpoint, 'No response received.', true);
			}
			// Return null
			return null;
		}
	}
}