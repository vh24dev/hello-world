public class SDocsPoC {
    public static void createTestTemplate() {
        // Inserts new S-Docs Template with DOCX as the Template Fromat
        //SDTemplate__c newTemplate = SDFileUpload.createNewSDocTemplate('DOCX Filename', 'My_Base_Object__c');
        SDOC__SDTemplate__c t = SDOC.SDFileUpload.createNewSDocTemplate(
            'Vollmacht 21legal VW',
            'Opportunity');
        System.debug('t: ' + t);

        // Use true for legacy syntax (e.g. {{!Opportunity.Name}} ) and false for currently supported DOCX syntax (e.g. [{{!Opportunity.Name}}] )
        SDOC.SDFileUpload.preprocessDocxTemplateAsync(t.Id, false);
    }
}