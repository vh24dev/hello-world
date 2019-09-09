public virtual class BaseTriggerHandler {
    // The current context type of the trigger, e.g. before insert, after update.
    // Dictates which virtual method will be called.
    @testVisible
    private TriggerContextType context;
    
    @testVisible
    private Boolean overrideCanRun = false;
    @testVisible
    private static Boolean overrideSetContext = false;

    // Keeps track of which Handler/Context pair already ran in the current transaction,
    // to prevent unwanted recursive calls.
    private static final Set<String> contextsRunInTransaction = new Set<String>();

    public BaseTriggerHandler() {
        if (!overrideSetContext) {
        	this.setTriggerContext();   
        }
    }
    
    // Run calls the method matching the current trigger context.
    // Run should be called by consumers of any of the handler classes extending this class.
    public void run() {
        Logger.debug('>> BaseTriggerHandler :: run');
        
        if (!canRun()) {
            Logger.debug('BaseTriggerHandler :: run :: canRun returned false, exiting');
            return;
        }

        Logger.debug('BaseTriggerHandler :: run :: handlername: ' + handlerName() + ' context: ' + this.context);
        
        switch on this.context {
            when BEFORE_INSERT {
				this.beforeInsert();
            }
            when AFTER_INSERT {
				this.afterInsert();
            }
            when BEFORE_UPDATE {
				this.beforeUpdate();
            }
            when AFTER_UPDATE {
				this.afterUpdate();
            }
            when BEFORE_DELETE {
				this.beforeDelete();
            }
            when AFTER_DELETE {
				this.afterDelete();
            }
            when BEFORE_UNDELETE {
				this.beforeUndelete();
            }
            when AFTER_UNDELETE {
				this.afterUndelete();
            }
        }
    }

    private void setTriggerContext() {
        this.setTriggerContext(null);
    }

    @testVisible
    private void setTriggerContext(TriggerContextType testContext) {
        if (testContext != null) {
            this.context = testContext;
            return;
        }

        if (Trigger.isExecuting == null) {
            return;
        }

        // insert
        if (Trigger.isBefore && Trigger.isInsert) {
            this.context = TriggerContextType.BEFORE_INSERT;
            return;
        }

        if (Trigger.isAfter && Trigger.isInsert) {
            this.context = TriggerContextType.AFTER_INSERT;
            return;
        }
        
        // update
        if (Trigger.isBefore && Trigger.isUpdate) {
            this.context = TriggerContextType.BEFORE_UPDATE;
            return;
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            this.context = TriggerContextType.AFTER_UPDATE;
            return;
        }

        // delete
        if (Trigger.isBefore && Trigger.isDelete) {
            this.context = TriggerContextType.BEFORE_DELETE;
            return;
        }

        if (Trigger.isAfter && Trigger.isDelete) {
            this.context = TriggerContextType.AFTER_DELETE;
            return;
        }

        // undelete
        if (Trigger.isBefore && Trigger.isUndelete) {
            this.context = TriggerContextType.BEFORE_UNDELETE;
            return;
        }

        if (Trigger.isAfter && Trigger.isUndelete) {
            this.context = TriggerContextType.AFTER_UNDELETE;
            return;
        }
    }

    // Make sure this trigger should continue to run.
    @testVisible
    private Boolean canRun() {
        Logger.debug('>> BaseTriggerHandler :: canRun :: ' + uniqueNameForRun());
        
        if (TriggerConfiguration.allInactive) {
            Logger.debug('>> BaseTriggerHandler :: canRun :: TriggerConfiguration.allInactive true, exit');
            return false;
        }

        if (preventFromRunning()) {
            Logger.debug('>> BaseTriggerHandler :: canRun :: preventFromRunning true, exit');
            return false;
        }
        
        if ((this.context == null || !Trigger.isExecuting) && !overrideCanRun) {
           throw new TriggerHandlerException('Trigger handler called outside of Trigger execution, no context found.');
        }

        // Exit if this Handler/Context pair already ran for this transaction,
        // and the Handler did not specify otherwise.
        if (contextsRunInTransaction.contains(uniqueNameForRun())
            && shoulStopRecursiveCallForContext(uniqueNameForRun())) {
            Logger.debug('BaseTriggerHandler :: canRun :: already ran in this transaction for: ' + uniqueNameForRun() + ', exit');
            return false;
        }

        contextsRunInTransaction.add(uniqueNameForRun());
        return true;
    }

    private String uniqueNameForRun() {
		return handlerName() + this.context.name();         // todo: solve nunll pointer when no context
    }

    @testVisible
    private String handlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    // By default prevents recursive calls for every context.
    // Override it to set custom behaviour.
    protected virtual Boolean shoulStopRecursiveCallForContext(String ctx) {
        if (Test.isRunningTest()) {
            return false;
        }
        
        return true;
    }

    @testVisible
    protected virtual Boolean preventFromRunning() { return false; }
    
    // Context-specific methods to be overridden
    @testVisible
    protected virtual void beforeInsert(){}
    @testVisible
    protected virtual void afterInsert(){}
    @testVisible
    protected virtual void beforeUpdate(){}
    @testVisible
    protected virtual void afterUpdate(){}
    @testVisible
    protected virtual void beforeDelete(){}
    @testVisible
    protected virtual void afterDelete(){}
    @testVisible
    protected virtual void beforeUndelete(){}
    @testVisible
    protected virtual void afterUndelete(){}
    
    @testVisible
    private enum TriggerContextType {
        BEFORE_INSERT, AFTER_INSERT,
        BEFORE_UPDATE, AFTER_UPDATE,
		BEFORE_DELETE, AFTER_DELETE,
        BEFORE_UNDELETE, AFTER_UNDELETE
    }

    public class TriggerHandlerException extends Exception {}
}