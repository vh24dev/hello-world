global class MissingDocumentsMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setHeader('Location', 'https://location.url');
        res.setBody('{"id":"test"}');
        res.setStatusCode(200);
        return res;
    }
}