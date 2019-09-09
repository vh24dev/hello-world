public inherited sharing class RESTHelper {
    public class TestHelper {
        public RestRequest req = new RestRequest();
        public RestResponse res = new RestResponse();

        public TestHelper() {
            RestContext.request = this.req;
            RestContext.response = this.res;
        }

        public void SetRequestBody(object o) {
            RestContext.request.requestBody = Blob.valueOf(JSON.serialize(o));
        }

        public void SetRequestBody(string s) {
            RestContext.request.requestBody = Blob.valueOf(s);
        }
    }

    public class Error {
        public string error;

        public Error(string e) {
            this.error = e;
        }
    }

    public static void RenderString(string s) {
        RestContext.response.responseBody = Blob.valueOf(s);
    }

    public static void RenderError(string error) {
        RenderJSON(new Error(error));
    }

    public static string RequestBody() {
        blob body = RestContext.request.requestBody;
        return body.toString();
    }

    public static string ResponseBody() {
        return RestContext.response.responseBody.toString();
    }

    public static void SetJSON() {
        RestContext.response.addHeader('Content-Type', 'application/json');
    }

    public static void SetStatus(integer status) {
        RestContext.response.statusCode = status;
    }

    public static void RenderJSON(object o) {
        RenderString(JSON.serialize(o));
    }
}