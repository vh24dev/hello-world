@isTest
global class FinAPIMock implements HTTPCalloutMock {
    public DefaultFinAPI.CFinApiGetTransactionsResponse response;

    global HTTPResponse respond(HTTPRequest req) {
        String s = req.getEndpoint();
        if (s.endsWithIgnoreCase('/oauth/token')) {
            return token(req);
        }
        
        if (s.endsWithIgnoreCase('bankConnections')) {
            return updateBankConnections(req);
        }
        
        if (s.containsIgnoreCase('/transactions')) {
            return fetchTransactions(req);
        }

        return new HTTPResponse();
    }
    
    private HTTPResponse token(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setBody('{"access_token": "qw9asaskjas"}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
    
    private HTTPResponse updateBankConnections(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setBody('{"connections": [{"id": 1234, "bank": {"id": 4321, "name": "testbank"}}]}');
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
    
    private HTTPResponse fetchTransactions(HTTPRequest req) {
        if (this.response != null) {
            HTTPResponse res = new HTTPResponse();
            res.setBody(JSON.serialize(this.response));
            res.setStatusCode(200);
            res.setStatus('OK');
            return res;
        }
        
        String ps = req.getEndpoint().substringBetween('page=', '&'); // Assuming order in query string params
        Integer p = Integer.valueOf(ps);

        String fileName = 'FinAPI_testdata_page' + p + '_json';
        StaticResource[] pageRes = [SELECT Body FROM StaticResource WHERE Name = :fileName LIMIT 1];
        HTTPResponse res = new HTTPResponse();
        if (pageRes.size() == 0) {
            System.debug('FinAPIMock :: respond :: found no data for page ' + p);
            res.setBody('{}');
        } else {
			res.setBody(pageRes[0].body.toString());            
        }

        res.setStatusCode(200);
        res.setStatus('OK');

        return res;
    }
}