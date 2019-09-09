public class DGen_Request {
    public Blob b64File;
    // For logging purposes on the server
    public ID templateID;
    public String sourceDocType; // todo: enum
    public String destinationDocType; // todo: enum
    public String destinationDocName;
    // The record to which the resulting doc shall be attached to
    public String attachToRecordID;
    public DGen_MergeField[] mergefields;
    public Map<String, String[]> customFields;
    // todo: what for?
    public String[] calculatedFields;
    public Map<String, String> imagesMeta;
    // todo: what for?
    public DGen_Attachment[] attachments;
}