global class TasksCreateScheduler implements Schedulable {
	public static String cronExpression = '0 0 1 * * ? *';
	public static String cronName = 'Daily tasks scheduler';

    global void execute(SchedulableContext sc) {
        TasksCreate b = new TasksCreate();
        Database.executeBatch(b);
    }
}