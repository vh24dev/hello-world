public class WelcomeLetterTriggerHandler extends BaseTriggerHandler {
    public override void afterInsert() {
        Logger.debug('>> WelcomeLetterTriggerHandler :: afterInsert :: new welcomeletters: ' + Trigger.new + ' old welcomeletters: ' + Trigger.old);

        WelcomeLetters.autoCreateDocuments(Trigger.newMap.keySet());

        Logger.debug('<< WelcomeLetterTriggerHandler :: afterInsert');
    }
}