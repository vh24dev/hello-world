public class DGen_APIWebServiceError {
    public enum ErrorType {UNKNOWN, FAILED_PARSING_REQUEST, BAD_INPUT_VALUES, DOCGEN_TIMEOUT}
    
    // Message
    public String message;
    
    // Error code
    public Integer code;    
    
    public String userFriendlyMessage() {
        String msgPrefix = 'Doc gen Web Service failed to calculate lease/contract.';
        String unknownErrorMsg = msgPrefix + ' Unknown error.  Please contact technical support.';
        if (errorType() == ErrorType.UNKNOWN) { return unknownErrorMsg; }
        if (errorType() == ErrorType.FAILED_PARSING_REQUEST) { return msgPrefix + ' The request is malformed. Please contact technical support.'; }
        if (errorType() == ErrorType.BAD_INPUT_VALUES) { return msgPrefix + ' Doc gen request input values are invalid: ' + this.message; }

        return unknownErrorMsg;
    }
    
    public ErrorType errorType() {
        if (code == 0) { return ErrorType.UNKNOWN; }
        if (code == 1) { return ErrorType.FAILED_PARSING_REQUEST; }
        if (code == 2) { return ErrorType.BAD_INPUT_VALUES; }
        
        return ErrorType.UNKNOWN;
    }
}