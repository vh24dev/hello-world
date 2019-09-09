public class ErrorController {
    public String title {get; set;}
    public String message {get; set;}
    public ErrorController() {
		this.title = ApexPages.currentPage().getParameters().get('t');
        if (String.isBlank(this.title) || this.title == 'null') {
            this.title = 'Fehler!';
        }
        this.message = ApexPages.currentPage().getParameters().get('m');
        if (String.isBlank(this.message) || this.message == 'null') {
            this.title = 'We were unable to perform the operation you\'ve requested.'; // todo: translate
        }        
    }
    
    public ErrorController(ApexPages.StandardController stdCtl) {
    	this();
    }
}