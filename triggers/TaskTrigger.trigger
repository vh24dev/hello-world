trigger TaskTrigger on Task (before insert) {
	Logger.debug('>> TaskTrigger');
    new TaskTriggerHandler().run();
    Logger.debug('<< TaskTrigger');
}