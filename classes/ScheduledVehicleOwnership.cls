global class ScheduledVehicleOwnership implements Schedulable {
   global void execute(SchedulableContext sc) {
      UpdateVehicleOwnership b = new UpdateVehicleOwnership();
      Database.executeBatch(b);
   }
}