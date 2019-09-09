public class CreateLawsuitPackage {
    private final List<Claim__c> claims;
    private List<SObject> objects;
    public Lawsuit_Package__c parLawsuitPackage{get; set;}
    
    public CreateLawsuitPackage(ApexPages.StandardSetController stdSetController) {
        
        parLawsuitPackage = new Lawsuit_Package__c();
        
        objects = stdSetController.getRecords().clone();
        while (stdSetController.getHasNext()) {
            stdSetController.next();
            objects.addAll(stdSetController.getRecords().clone());
        }
        
        this.claims = [
            
            select Id, CreatedDate 
            from Claim__c 
            where Id IN :objects    
        ];
    }
    
    public PageReference renderPage() {
        
        PageReference pageRef;
        
        Lawsuit_Package__c insertLawsuitPackage = parLawsuitPackage;
        insert insertLawsuitPackage;
        
        List<Lawsuit_Package_Reference__c> insertLawsuitPackageReferencies = new List<Lawsuit_Package_Reference__c>();
        
        for (Claim__c claim : claims){
            insertLawsuitPackageReferencies.add(new Lawsuit_Package_Reference__c(
                Claim__c = claim.Id,
                Lawsuit_Package__c = insertLawsuitPackage.Id
            ));
        }
        
        if (insertLawsuitPackageReferencies.size() > 0) {
            insert insertLawsuitPackageReferencies;
            System.debug('Successfully inserted ' + insertLawsuitPackageReferencies.size() + ' new lawsuit package referencies.');
        }
        
        pageRef = new PageReference('/' + insertLawsuitPackage.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}