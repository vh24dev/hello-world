public class ConfirmAppointmentController {
    private Date__c app;
    public boolean isError {get; set;}
    public string errorMsg {get; set;}
    public PageReference init() {
        isError = false;
        errorMsg = '';
        app = getAppointment();
        if (this.app == null) {
            errorMsg = 'Der Termin wurde nicht gefunden.';
        }
        if (this.app.Date_confirmed__c == true) {
            errorMsg = 'Der Termin wurde bereits bestätigt.';
        }
        if (errorMsg != '') {
            isError = true;
            return null;
        }
        ConfirmApp();
        return null;
    }

    public void ConfirmApp() {
		this.app.Date_confirmed__c = true;
		this.app.Representative_Confirmation_Date__c = Datetime.now();
		update this.app;
    }

    private Date__c getAppointment() {
        string appId = getToken();
        if (appId == null) {
            return null;
        }
        List<Date__c> apps = [
            SELECT Id,
            Token__c,
            Date_confirmed__c
            FROM Date__c
            WHERE Token__c = :appId
        ];
        if (apps.size() != 1) {
            return null;
        }
        return apps[0];
    }

    private string getToken() {
        return ApexPages.currentPage().getParameters().get('token');
    }
}