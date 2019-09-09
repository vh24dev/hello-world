public class GenericQueueable implements Queueable, Database.AllowsCallouts {
    private final Runnable runnable;

    public GenericQueueable(Runnable r) {
        this.runnable = r;
    }

    public void execute(QueueableContext SC) {
        Logger.debug('>> GenericQueueable :: execute');
		this.runnable.run();
        Logger.debug('<< GenericQueueable :: execute');
    }
    
    public static ID enqueue(Runnable r) {
        return System.enqueueJob(new GenericQueueable(r));
    }
}