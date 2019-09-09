public class SObjectIntrospection {
    public static List<PicklistEntry> getUnsortedOptions(SObject obj, string fld) {
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();

        Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();

        return fieldMap.get(fld).getDescribe().getPickListValues();
    }

    public static List<SelectOption> getSelectOptions(SObject obj, string fld) {
      List<SelectOption> opts = getUnsortedSelectOptions(obj, fld);
      opts.sort();
      return opts;
    }
    
    public static List<SelectOption> getUnsortedSelectOptions(SObject obj, string fld) {
        List<SelectOption> opts = new List<SelectOption>();

      for(PicklistEntry val : getUnsortedOptions(obj, fld)) {
        opts.add(new SelectOption(val.getValue(), val.getLabel()));
      }

      return opts;
    }
}