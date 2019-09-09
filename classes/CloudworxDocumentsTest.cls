@isTest
public class CloudworxDocumentsTest {
    /* * * * * * * *
     * UNIT TESTS  *
     * * * * * * * */

    @isTest
    public static void testSpaces() {
        cloudworx_document_template__c c = new cloudworx_document_template__c(
            Label__c = 'foo bar baz'
        );
        System.assertEquals(null, c.developername__c);
        CloudworxDocuments.setDeveloperName(new cloudworx_document_template__c[]{c});
        System.assertEquals('foobarbaz', c.developername__c);
    }

    @isTest
    public static void testNumbers() {
        cloudworx_document_template__c c = new cloudworx_document_template__c(
            Label__c = 'foo2bar2baz'
        );
        System.assertEquals(null, c.developername__c);
        CloudworxDocuments.setDeveloperName(new cloudworx_document_template__c[]{c});
        System.assertEquals('foo2bar2baz', c.developername__c);
    }

    @isTest
    public static void testSpecialchars() {
        cloudworx_document_template__c c = new cloudworx_document_template__c(
            Label__c = 'foo-/bar-/baz'
        );
        System.assertEquals(null, c.developername__c);
        CloudworxDocuments.setDeveloperName(new cloudworx_document_template__c[]{c});
        System.assertEquals('foobarbaz', c.developername__c);
    }

    /* * * * * * * * * * *
     * INTEGRATION TESTS *
     * * * * * * * * * * */

	@isTest
    private static void testIdByNameName() {
		cloudworx_document_template__c tpl = new cloudworx_document_template__c(
        	Label__c = 'LV - Gutschrift',
            DeveloperName__c = 'LVGutschrift'
        );
        insert tpl;
        cloudworx_document_template__c et = [
            SELECT ID
			FROM cloudworx_document_template__c
            WHERE DeveloperName__c = 'LVGutschrift'
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals(et.ID, CloudworxTemplates.idOf(CloudworxTemplates.Name.LVGutschrift));
    }

	@isTest
    private static void testIdByNameFZKainz() {
		cloudworx_document_template__c tpl = new cloudworx_document_template__c(
        	Label__c = 'FZ///////////Kainz A n w a lt s / w i/ d e /rs/pruch',
            DeveloperName__c = 'FZKainzAnwaltswiderspruch'
        );
        insert tpl;
        cloudworx_document_template__c et = [
            SELECT ID
			FROM cloudworx_document_template__c
            WHERE DeveloperName__c = 'FZKainzAnwaltswiderspruch'
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals(et.ID, CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.FZKainzAnwaltswiderspruch));
    }

	@isTest
    private static void testTriggerSetDevName() {
        // normal
		cloudworx_document_template__c tpl = new cloudworx_document_template__c(
        	Label__c = 'FZ - Vollmacht'
        );
        insert tpl;
        cloudworx_document_template__c et = [
            SELECT ID, DeveloperName__c
			FROM cloudworx_document_template__c
            WHERE Id = :tpl.Id
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals('FZVollmacht', et.DeveloperName__c);
        // ä
		tpl = new cloudworx_document_template__c(
        	Label__c = 'FZ - Vollmächt'
        );
        insert tpl;
        et = [
            SELECT ID, DeveloperName__c
			FROM cloudworx_document_template__c
            WHERE Id = :tpl.Id
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals('FZVollmaecht', et.DeveloperName__c);
        // ü ö
		tpl = new cloudworx_document_template__c(
        	Label__c = 'FZ - Vüllmöcht'
        );
        insert tpl;
        et = [
            SELECT ID, DeveloperName__c
			FROM cloudworx_document_template__c
            WHERE Id = :tpl.Id
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals('FZVuellmoecht', et.DeveloperName__c);
        // ß
		tpl = new cloudworx_document_template__c(
        	Label__c = 'FZ - Voßmacht'
        );
        insert tpl;
        et = [
            SELECT ID, DeveloperName__c
			FROM cloudworx_document_template__c
            WHERE Id = :tpl.Id
        ];
        System.assertNotEquals(null, et.ID);
        System.assertEquals('FZVossmacht', et.DeveloperName__c);
    }
}