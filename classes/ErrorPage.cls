// used for public pages
public class ErrorPage {
    public string errorHeader {get; set;}
    public string errorBody {get; set;}

    public ErrorPage() {
        string h = ApexPages.currentPage().getParameters().get('h');
        string b = ApexPages.currentPage().getParameters().get('b');
        errorHeader = (h == null) ? 'Fehler!' : h;
        errorBody = (b == null) ? 'Fehler!' : b;
    }
}