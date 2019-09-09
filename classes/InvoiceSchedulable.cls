global class InvoiceSchedulable implements Schedulable {
	public static String cronExpression = '0 0 1 * * ? *';
	public static String cronName = 'Daily invoice scheduler';

    /*
	// Static method used to schedule the autoqueueing of Invoice emails
	global static List<String> scheduleIt() {
		List<String> cronIds = new List<String>();
		InvoiceSchedulable InvoiceSchedulable = new InvoiceSchedulable();
		cronIds.add(System.schedule(cronName, cronExpression, InvoiceSchedulable));
		return cronIds;
	}
	*/

	global void execute(SchedulableContext sc) {
		InvoiceReminders.autoCreateInvoiceReminders();
	}
}