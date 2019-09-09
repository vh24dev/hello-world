public class TaskTriggerHandler extends BaseTriggerHandler {
    public override void beforeInsert() {
		TaskRelatedOpportunity.setOn(Trigger.new);
    }
}