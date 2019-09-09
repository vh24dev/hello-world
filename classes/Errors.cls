public class Errors {
    public static PageReference page(String title, String message) {
		return new PageReference('/apex/error?t=' + title + '&m=' + message);
    }
    
    public static PageReference page(String message) {
		return page(null, message);
    }
}