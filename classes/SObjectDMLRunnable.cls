public class SObjectDMLRunnable implements Runnable {
    public enum DMLOp {INS, UPD, UPS, DEL}

    private final SObject[] objs;
    private final DMLOp op;
    public SObjectDMLRunnable(SObject[] objs, DMLOp op) {
        this.objs = objs;
        this.op = op;
    }
    
    public void run() {
        Logger.debug('SObjectDMLRunnable :: run :: on: ' + this.objs.size());
        switch on this.op {
            when INS {
                insert this.objs;
            }
            when UPD {
                update this.objs;
            }
            when UPS {
                upsert this.objs;
            }
            when DEL {
                delete this.objs;
            }
        }
    }
}