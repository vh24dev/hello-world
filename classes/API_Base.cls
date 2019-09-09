public virtual class API_Base { 
    public static void setResponseObject(object o) {
        string s = objToJSON(o);
        blob b = Blob.valueOf(s);
        setResponse(b);
    }
    
    public static void setJSON() {
        setHeader('Content-Type', 'application/json');
    }
    
    private static void setHeader(string k, string v) {
        RestContext.response.addHeader(k ,v);
    }
    
    public static void setResponse(blob b) {
        RestContext.response.responseBody = b;
    }
    
    public static string objToJSON(object o) {
        return JSON.serialize(o);
    }
    
    public static string getParam(string param) {
       return RestContext.request.params.get(param);
    }
    
    public static string requestBody() {
        blob body = RestContext.request.requestBody;
        return body.toString();
    }

    public static Object loadRequest(System.Type classType) {
        string b = requestBody();
        return JSON.deserialize(b, classType);
    }
}