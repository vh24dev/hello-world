public class CreateClassAction {
    private final List<Claim__c> claims;
    private List<SObject> objects;
    public Class_Action__c parClassAction{get; set;}
    
    public CreateClassAction(ApexPages.StandardSetController stdSetController) {
        parClassAction = new Class_Action__c();

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

        List<Claim__c> claims = [select Id, CreatedDate from Claim__c where Id IN :objects];

        Class_Action__c insertClassAction = parClassAction;
        insert insertClassAction;

        List<Class_Action_Reference__c> insertClassActionReferencies = new List<Class_Action_Reference__c>();

        for (Claim__c claim : claims){
            insertClassActionReferencies.add(new Class_Action_Reference__c(
                Claim__c = claim.Id,
                Class_Action__c = insertClassAction.Id
            ));
        }

        if (insertClassActionReferencies.size() > 0){
            insert insertClassActionReferencies;
            System.debug('Successfully inserted ' + insertClassActionReferencies.size() + ' new class action referencies.');
        }

        pageRef = new PageReference('/' + insertClassAction.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}