public class OrgWideEmailAddresses {
    public static ID vollmachtSender(ID oppRecTypeID) {
        if (Opportunities.isDieselSkandal(oppRecTypeID)) {
            if(String.isBlank(OrgWideEmailSettings.DG_VOLLMACHT_SENDER)) {
                Logger.debug('OrgWideAddresses :: vollmachtSender :: is diesel but no OrgWideEmailSettings.DG_VOLLMACHT_SENDER set');
                return null;
            }
            
            OrgWideEmailAddress[] oweas = [SELECT ID FROM OrgWideEmailAddress WHERE Address = :OrgWideEmailSettings.DG_VOLLMACHT_SENDER];
            if (oweas.size() == 0) {
                Logger.debug('OrgWideAddresses :: vollmachtSender :: is diesel but no orgwide email address found with email (OrgWideEmailSettings.DG_VOLLMACHT_SENDER): ' + OrgWideEmailSettings.DG_VOLLMACHT_SENDER);
                return null;
            }
            
            return oweas[0].ID;
        }
        
        if (Opportunities.isLebensversicherung(oppRecTypeID)) {
            if(String.isBlank(OrgWideEmailSettings.LV_VOLLMACHT_SENDER)) {
                Logger.debug('OrgWideAddresses :: vollmachtSender :: is lv but no OrgWideEmailSettings.LV_VOLLMACHT_SENDER set');
                return null;
            }

            OrgWideEmailAddress[] oweas = [SELECT ID FROM OrgWideEmailAddress WHERE Address = :OrgWideEmailSettings.LV_VOLLMACHT_SENDER];
            if (oweas.size() == 0) {
                Logger.debug('OrgWideAddresses :: vollmachtSender :: is lv but no orgwide email address found with email (OrgWideEmailSettings.LV_VOLLMACHT_SENDER): ' + OrgWideEmailSettings.LV_VOLLMACHT_SENDER);
                return null;
            }

            return oweas[0].ID;
        }

		Logger.debug('OrgWideAddresses :: vollmachtSender :: unexpected recordID: ' + oppRecTypeID);
        return null;
    }

}