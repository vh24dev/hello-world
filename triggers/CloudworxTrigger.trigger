trigger CloudworxTrigger on cloudworx_Document_Template__c (before insert) {
	Logger.debug('>> CloudworxTrigger');
    new CloudworxTriggerHandler().run();
    Logger.debug('<< CloudworxTrigger');
}