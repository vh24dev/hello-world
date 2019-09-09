@isTest
public class BaseTriggerHandlerTests {
    @isTest
    private static void testGeneral() {
        BaseTriggerHandler.overrideSetContext = true;
        TestBaseTriggerHandler b = new TestBaseTriggerHandler();

        try {
            b.setTriggerContext(BaseTriggerHandler.TriggerContextType.AFTER_UPDATE);
            b.run();
            System.assert(false);
        } catch (BaseTriggerHandler.TriggerHandlerException e) {
            System.assert(true);
        }
        
        b.overrideCanRun = true;
        b.run();
        System.assert(b.didCall('au'));
        
        System.assert(!b.canRun());

        b.setTriggerContext(BaseTriggerHandler.TriggerContextType.BEFORE_UPDATE);
        b.run();
        System.assert(b.didCall('bu'));
        
        TriggerConfiguration.allInactive = true;
        b.setTriggerContext(BaseTriggerHandler.TriggerContextType.BEFORE_DELETE);
        b.run();
        System.assert(!b.didCall('bd'));
        
        TriggerConfiguration.allInactive = false;
        b.run();
        System.assert(b.didCall('bd'));
    }
    
    private class TestBaseTriggerHandler extends BaseTriggerHandler {
        private Set<String> calledMethods = new Set<String>();
        
        private Boolean didCall(String methodTag) { return this.calledMethods.contains(methodTag); }

        protected override void beforeInsert(){ this.calledMethods.add('bi'); }
        protected override void afterInsert(){ this.calledMethods.add('ai'); }
        protected override void beforeUpdate(){ this.calledMethods.add('bu'); }
        protected override void afterUpdate(){ this.calledMethods.add('au'); }
        protected override void beforeDelete(){ this.calledMethods.add('bd'); }
        protected override void afterDelete(){ this.calledMethods.add('ad'); }
        protected override void beforeUndelete(){ this.calledMethods.add('bu'); }
        protected override void afterUndelete(){ this.calledMethods.add('au'); }
        
        protected override Boolean shoulStopRecursiveCallForContext(String ctx) { return true; }
    }
}