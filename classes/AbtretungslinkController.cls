public class AbtretungslinkController {
    public Test_Case__c tc {get; set;}
    public PageReference init() {
        this.tc = getMFK();
        if (this.tc == null) {
            return new PageReference('/NotFound');
        }
        this.tc.Assignment_Revocation_Date__c = Datetime.now();
        update this.tc;
        return null;
    }

    public Test_Case__c getMFK() {
        string mfkId = ApexPages.currentPage().getParameters().get('token');
        if (mfkId == null) {
            return null;
        }
        List<Test_Case__c> tcs = [
            SELECT Id
            FROM Test_Case__c
            WHERE Token__c = :mfkId
        ];
        if (tcs.size() != 1) {
            return null;
        }
        return tcs[0];
    }
}