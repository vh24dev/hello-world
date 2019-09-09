@isTest
public class TasksCreateSchedulerTest {
    @isTest
    public static void testCover() {
        String jobId = System.schedule('Vehicle Ownership', '0 0 0 3 9 ? 2099', new TasksCreateScheduler());
        CronTrigger ct = [
            SELECT Id,
            CronExpression,
            TimesTriggered,
            NextFireTime
            FROM CronTrigger WHERE id = :jobId
        ];
        System.assertEquals(0, ct.TimesTriggered);
    }
}