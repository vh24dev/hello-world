trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {
	Logger.debug('>> LeadTrigger');
    new LeadTriggerHandler().run();
    Logger.debug('<< LeadTrigger');
}