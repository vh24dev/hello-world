public inherited sharing class DefaultFinAPI implements FinAPI {
    private String token;
	private FinAPISettings settings;
    private Log log;
    public DefaultFinAPI(FinAPISettings settings, Log log) {
        this.settings = settings;
        this.log = log;
    	this.token = fetchToken();
    }

    // Queries the FinAPI for the latest transactions.
    public Transaction__c[] fetchTransactions(Date since, Integer fromPage, Integer perPage) {
        //this.log.debug('>> FinAPI :: fetchTransactions (p) :: since: ' + since + ' fromPage: ' + fromPage + ' perPage: ' + perPage);

        // what for?
        updateBankConnections();

        Transaction__c[] tt = fetchTransactions(since, fromPage, perPage, new Transaction__c[]{});
        //this.log.debug('<< FinAPI :: fetchTransactions (p) :: fetched: ' + tt.size());

        return tt;
	}
    
    private Transaction__c[] fetchTransactions(Date since, Integer fromPage, Integer perPage, Transaction__c[] currTransactions) {
        System.debug('>> FinAPI :: fetchTransactions :: since: ' + since + ' fromPage: ' + fromPage + ' perPage: ' + perPage);

        String sinceStr = sinceAsString(since);
        String endpoint = this.settings.baseURL + '/api/v1/transactions?view=bankView&minBankBookingDate=' + sinceStr + '&page=' + fromPage + '&perPage=' + perPage;
        HTTPResponse resp = Utilities.sendHTTPRequest('GET', 'application/json', authHeader(token), endpoint, null, 120000, 2);

        if (resp == null || resp.getStatusCode() != 200) {
            System.debug('FinAPI :: fetchTransactions :: error: ' + resp.getStatusCode() + ': ' + resp.getStatus());
            return currTransactions;
        }
        
        String respBody = resp.getBody();
        if (String.isBlank(respBody)) {
            System.debug('FinAPI :: fetchTransactions :: error: empty body');
            return currTransactions;
        }
        
        System.debug('Got FinAPI response:');
        System.debug(respBody);
        
        CFinApiGetTransactionsResponse transResp = (CFinApiGetTransactionsResponse)JSON.deserialize(respBody, CFinApiGetTransactionsResponse.class);
        if (transResp.transactions == null || transResp.transactions.size() == 0) {
            System.debug('FinAPI :: fetchTransactions :: no transactions found');
            return currTransactions;
        }
        
        for (CFinApiTransaction t: transResp.transactions) {
			Transaction__c tr = buildTransaction(t);
            if (tr != null) {
                currTransactions.add(tr);
            }
		}

        System.debug('FinAPI :: fetchTransactions :: paging.pageCount: ' + transResp.paging.pageCount + ' paging.page: ' + transResp.paging.page);
        if (transResp.paging.pageCount == transResp.paging.page) {
            System.debug('FinAPI :: fetchTransactions :: end of paging :: fetched transactions: ' + currTransactions);
            return currTransactions;
        }
        
		return fetchTransactions(since, fromPage + 1, perPage, currTransactions);
    }

    private static final Map<String, String> knownLawyerAccounts = new Map<String, String>{
        // Note that changes to this mapping should probably also be applied to the Transaction.Bank_Account_Owner__c formula field.

        '1121696'=>'Jäger',
        '1121699'=>'Jäger',
		'1121694'=>'Jäger',
		'1121695'=>'Jäger',
        '1121698'=>'Jäger',
        'A3081216.17'=>'Jäger',
        'A3081216.7'=>'Lachmair',
		'1121697'=>'VR24',
        'A3081216.1'=>'VR24',
        'A3081216.13'=>'VH24'
    };
    private Boolean isKnownAccount(String accID) {
		return knownLawyerAccounts.containsKey(accID);
    }

    private Transaction__c buildTransaction(CFinApiTransaction t) {
        // Some of the transactions fetched have unknown accountID values, what to do about it?

        if (!isKnownAccount(t.accountID)) {
            System.debug('FinAPI :: buildTransaction :: not a know accountID: ' + t.accountID);
            return null;
        }
        
        Transaction__c newT = new Transaction__c();
        if (!String.isBlank(t.purpose)) {
            newT.purpose__c = t.purpose.replace('/n','');
        }
        newT.date__c = Date.valueOf(t.bankBookingDate);
        newT.amount__c = Double.valueOf(t.amount);
        newT.name__c = t.counterpartName;
        newT.external_Id__c = t.ID;
        newT.account_Id__c = t.accountID;
        newT.method__c = 'Bank transfer';

        return newT;
    }

    private String sinceAsString(Date dt) {
        // From legacy code, refactor if necessary
        String year = dt.year().format().replace('.','');
        String month = dt.month().format();
        month = month.leftPad(2, '0');
        
        String day = dt.day().format();
        day = day.leftPad(2, '0');
        return year + '-' + month + '-' + day;
    }
     
    private void updateBankConnections() {
		String endpoint = this.settings.baseURL + '/api/v1/bankConnections';
        HTTPResponse resp = Utilities.sendHTTPRequest('GET', 'application/json', authHeader(token), endpoint, null, 120000, 2);
        
        if (resp == null || resp.getStatusCode() != 200) {
            System.debug('FinAPI :: updateBankConnections :: error: ' + resp.getStatusCode() + ': ' + resp.getStatus());
            return;
        }

        String respBody = resp.getBody();
        if (String.isBlank(respBody)) {
            System.debug('FinAPI :: updateBankConnections :: error: empty body');
            return;
        }
        
        CFinApiBankGetAllConnectionsResponse bankConResp = (CFinApiBankGetAllConnectionsResponse)JSON.deserialize(respBody, CFinApiBankGetAllConnectionsResponse.class);
        if (bankConResp.connections == null || bankConResp.connections.size() == 0) {
            System.debug('FinAPI :: updateBankConnections :: no connections');
            return;
        }

        for (CFinApiConnection con : bankConResp.connections) {
			System.debug('FinAPI :: updateBankConnections :: updating connection: ' + con);
            updateBankConnection(con, token);
        }
	}
    
    private void updateBankConnection(CFinApiConnection con, String token) {
        String endpoint = this.settings.baseURL + '/api/v1/bankConnections/update';
        CFinApiBankUpdateConnectionRequest req = new CFinApiBankUpdateConnectionRequest();
        req.bankConnectionID = con.ID;
            
        String body = JSON.serialize(req);
        HTTPResponse resp = Utilities.sendHTTPRequest('POST', 'application/json', authHeader(token), endpoint, body, 120000, 2);
        
        if (resp == null || resp.getStatusCode() != 200) {
            System.debug('FinAPI :: updateBankConnection :: error: ' + resp.getStatusCode() + ': ' + resp.getStatus() + '. Failed to update connectionID: ' + con.ID);
            return;
        }
        
        String respBody = resp.getBody();
        if (String.isBlank(respBody)) {
            System.debug('FinAPI :: updateBankConnection :: error: empty body');
            return;
        }

		CFinApiBankUpdateConnectionResponse r = (CFinApiBankUpdateConnectionResponse)JSON.deserialize(respBody, CFinApiBankUpdateConnectionResponse.class);
		System.debug('FinAPI :: updateBankConnection :: result: ' + r);        
    }
    
    private String fetchToken() {
        String endpoint = this.settings.baseURL + '/oauth/token';
        String reqBody = 'grant_type=password&client_id=' + this.settings.clientID + '&client_secret=' + this.settings.clientSecret + '&username=' + this.settings.username + '&password=' + this.settings.pwd;
        HTTPResponse resp = Utilities.sendHTTPRequest('POST', null, null, endpoint, reqBody, 120000, 2);
        
        if (resp == null) {
            System.debug('FinAPI :: fetchToken :: error: null HTTPResponse');
            return null;
        }

        if (resp.getStatusCode() != 200) {
            System.debug('FinAPI :: fetchToken :: error: ' + resp.getStatusCode() + ': ' + resp.getStatus());
            return null;
        }
        
        String respBody = resp.getBody();
        if (String.isBlank(respBody)) {
            System.debug('FinAPI :: fetchToken :: error: empty body');
            return null;
        }
        
        CFinApiAuthorizationResponse authResp = (CFinApiAuthorizationResponse)JSON.deserialize(respBody, CFinApiAuthorizationResponse.class);
        String token = authResp.access_token;
        if (String.isBlank(token)) {
            System.debug('FinAPI :: fetchToken :: error: empty token');
            return null;
        }
        
        return token;
	}

    // todo: needed?
    /*
	public void importBankConnection(String bic,String bankingUserId,String bankingPin) {
		//Authenticate
		String accessToken = this.token;//getAccessToken();

		if (accessToken != null) {
			// Update Accounts
			String authenticationHeader = 'Bearer ' + accessToken;
			String endpoint = 'https://live.finapi.io/api/v1/bankConnections/import';

			CFinApiBankImportRequest bankImportRequest = new CFinApiBankImportRequest();
			bankImportRequest.bankId = searchBankByBIC(bic);
			bankImportRequest.bankingUserId = bankingUserId;
			bankImportRequest.bankingPin = bankingPin;
			bankImportRequest.storePin = true;

			String body = JSON.serialize(bankImportRequest);

			HTTPResponse response = Utilities.sendHTTPRequest('POST', 'application/json', authenticationHeader, endpoint, body, 120000, 2);

			if (response != null) {
				// get body
				String jsonResponse = response.getBody();
				// deserialize
				CFinApiBankImportResponse bankImportResponse = (CFinApiBankImportResponse) JSON.deserialize(jsonResponse, CFinApiBankImportResponse.class);

				if (String.valueOf(response.getStatusCode()).startsWith('2')) {
					System.debug('Successfully imported bank.');
				} else if (String.valueOf(response.getStatusCode()).startsWith('451')) {
					System.debug('Webform-URL: ' + response.getHeader('Location'));
				} else {
					if (bankImportResponse.errors != null) {
						for (CFinApiError error : bankImportResponse.errors){
							String errorMessage = 'Error while trying to import bank: ' + error.message + ', ' +  + error.code + ', ' +  + error.type;
							String errorSubject = 'FinApi bank import error';
							// Debug error
							System.debug('Error: ' + errorSubject + ', ' + errorMessage);
							// Queue error mail
							Utilities.sendErrorMail(errorSubject, errorMessage, endpoint, response.getBody(),true);
						}
					}
				}
			}
		}
	}

	// Queries the FinAPI for a Bank with the BIC provided.
    // Returns the first Bank ID found, null if none or error.
	private Integer searchBankByBIC(String bic) {
        if (String.isBlank(bic)) {
            System.debug('FinAPI :: searchBank :: error: bic is blank');
            return null;
        }

        String endpoint = this.settings.baseURL + '/api/v1/banks?search=' + bic;
        HTTPResponse resp = Utilities.sendHTTPRequest('GET', 'application/json', authHeader(token), endpoint, null, 120000, 2);
        
        if (resp == null || resp.getStatusCode() != 200) {
            System.debug('FinAPI :: searchBank :: error: ' + resp.getStatusCode() + ': ' + resp.getStatus());
            return null;
        }
        
        String respBody = resp.getBody();
        if (String.isBlank(respBody)) {
            System.debug('FinAPI :: searchBank :: error: empty body');
            return null;
        }
        
        CFinApiBankSearchResponse bankResp = (CFinApiBankSearchResponse)JSON.deserialize(respBody, CFinApiBankSearchResponse.class);
        if (bankResp.banks == null || bankResp.banks.size() == 0) {
            System.debug('FinAPI :: searchBank :: no bank found for bic: ' + bic);
            return null;
        }

        System.debug('FinAPI :: searchBank :: found banks: ' + bic + bankResp.banks);
		return bankResp.banks[0].ID;
	}
	*/

    // todo: needed?
    /*
	public static void getAllBankConnections() {
		//Authenticate
		String accessToken = this.token;

		if (accessToken != null) {
			// Update Accounts
			String authenticationHeader = 'Bearer ' + accessToken;
			String endpoint = 'https://live.finapi.io/api/v1/bankConnections';

			HTTPResponse response = Utilities.sendHTTPRequest('GET', 'application/json', authenticationHeader, endpoint, null, 120000, 2);

			if (response != null) {
				// get body
				String jsonResponse = response.getBody();
				// deserialize
				CFinApiBankGetAllConnectionsResponse bankGetAllConnectionsResponse = (CFinApiBankGetAllConnectionsResponse) JSON.deserialize(jsonResponse, CFinApiBankGetAllConnectionsResponse.class);
				if (String.valueOf(response.getStatusCode()).startsWith('2')) {
					for (CFinApiConnection connection : bankGetAllConnectionsResponse.connections){
						System.debug('Connection: ' + connection.bank);
					}
				} else {
					if (bankGetAllConnectionsResponse.errors != null) {
						for (CFinApiError error : bankGetAllConnectionsResponse.errors) {
							String errorMessage = 'Error while trying to search bank: ' + error.message + ', ' + +error.code + ', ' + +error.type;
							String errorSubject = 'FinApi bank search error';
							// Debug error
							System.debug('Error: ' + errorSubject + ', ' + errorMessage);
							// Queue error mail
							Utilities.sendErrorMail(errorSubject, errorMessage, endpoint, response.getBody(),true);
						}
					}
				}
			}
		}
	}
	*/

    // todo: needed?
    /*
	public static Decimal getAccountBalance(String accountId) {
		//Authenticate
		String accessToken = getAccessToken();

		if (accessToken != null) {
			// Update Accounts
			String authenticationHeader = 'Bearer ' + accessToken;
			String endpoint = 'https://live.finapi.io/api/v1/accounts/' + accountId;

			HTTPResponse response = Utilities.sendHTTPRequest('GET', 'application/json', authenticationHeader, endpoint, null, 120000, 2);

			if (response != null) {
				// get body
				String jsonResponse = response.getBody();
				// deserialize
				CFinApiGetAccountResponse getAccountResponse = (CFinApiGetAccountResponse) JSON.deserialize(jsonResponse, CFinApiGetAccountResponse.class);

				return getAccountResponse.balance;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	*/

    private static String authHeader(String token) {
        return 'Bearer ' + token;
    }

	//secondary classes
	private class CFinApiAuthorizationResponse {
		private String access_token;
		private String expires_in;
		private String scope;
		private String token_type;
		private List<CFinApiError> errors;
	}

	private class CFinApiBankSearchResponse {
		private List<CFinApiBank> banks;
		private List<CFinApiError> errors;
	}

	private class CFinApiBankImportRequest {
		private Integer bankId;
		private String bankingUserId;
		private String bankingPin;
		private Boolean storePin;
	}

	private class CFinApiBankImportResponse {
		private Integer bank_id;
		private List<CFinApiError> errors;
	}

	private class CFinApiBankGetAllConnectionsResponse {
		private List<CFinApiConnection> connections;
		private List<CFinApiError> errors;
	}

	private class CFinApiBankUpdateConnectionRequest {
		private Integer bankConnectionId;
	}

	private class CFinApiBankUpdateConnectionResponse {
		private Integer id;
		private List<CFinApiError> errors;
	}

	private class CFinApiGetAccountResponse {
		private Decimal balance;
		private List<CFinApiError> errors;
	}

    @testVisible
	private class CFinApiGetTransactionsResponse {
		private Integer id;
		private String accountId;
		private String bankBookingDate;
		private Decimal amount;
		private String purpose;
		private String counterpartName;
		private CFinApiPaging paging;
		private List<CFinApiTransaction> transactions;
		private List<CFinApiError> errors;
	}

	//tertiary classes
	private class CFinApiBank {
		private Integer id;
		private String name;
	}

	private class CFinApiConnection {
		private Integer id;
		private CFinApiBank bank;
	}

	private class CFinApiStatistics {
		private String deposit_max;
		private String deposit_sum;
		private String expense_max;
		private String expense_sum;
	}

	private class CFinApiStatus{
		private String code;
		private String message;
		private String success_timestamp;
		private String sync_timestamp;
	}

	private class CFinApiTransaction{
		private String accountId;
		private String amount;
		private String bankBookingDate;
		private String counterpartName;
		private String purpose;
		private String id;
		private String type;
	}

	private class CFinApiPaging{
		private Integer page;
		private Integer pageCount;
	}

	private class CFinApiError{
		private String message;
		private String code;
		private String type;
	}

}