public class API_TestHelper {   
    static {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        
        RestContext.response.statusCode = 200; // default success
    }
    /*    
    public static void start() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
    }
    
    public static integer getStatusCode() {
        return RestContext.response.statusCode;
    }

    public static void setRequest(object o) {
        String s = JSON.serialize(o);
        Blob b = Blob.valueOf(s);
        RestContext.request.requestBody = b;
    }  
    public static void start() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
    }
    */
    public static integer getStatusCode() {
        return RestContext.response.statusCode;
    }
    /*

    public static void setRequest(object o) {
        String s = JSON.serialize(o);
        Blob b = Blob.valueOf(s);
        RestContext.request.requestBody = b;
    }
    public static void start() {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
    }
    
    public static integer getStatusCode() {
        return RestContext.response.statusCode;
    }

    public static void setRequest(object o) {
        String s = JSON.serialize(o);
        Blob b = Blob.valueOf(s);
        RestContext.request.requestBody = b;
    }
    */
    public static void setRequest(string s) {
        Blob b = Blob.valueOf(s);
        RestContext.request.requestBody = b;
    }
    /*
    public static void setHeader(string k, string v) {
        RestContext.request.addHeader(k, v);
    }
    */
    public static void setParam(string k, string v) {
        RestContext.request.addParameter(k, v);
    }
    
    public static Object getResponseObject(System.Type t) {
		Blob b = RestContext.response.responseBody;
        String s = b.toString();
        return JSON.deserialize(s, t);
    }
}