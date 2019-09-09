@isTest
public class InvoiceSchedulableTest {
    @isTest
    public static void testCover() {
        String jobId = System.schedule('Invoice Reminder', '0 0 0 3 9 ? 2099', new InvoiceSchedulable());
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