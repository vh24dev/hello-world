@isTest
public class DGen_DocumenTemplatesTest {
    @isTest
    public static void TestSortingExcel() {
        List<string> realWorld = new List<string>();  
        
        // Note when dates are present and no version number is included, you should add a character before the file extension,
        // otherwise the last part of the date will be taken as version number.
        realWorld.add('vorlage_potentialberechnung_25_05_2017_.xlsx');
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (1.1).xlsx');
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (0.1).xlsx');
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (0.3).xlsx');
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (2.1).xlsx');
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (0.1).xlsx');
                
        string output = DGen_DocumentTemplates.latest(realWorld);      
        System.assertEquals('vorlage_potentialberechnung_11_09_2018 (2.1).xlsx', output);
        
        realWorld.add('vorlage_potentialberechnung_11_09_2018 (2.1.2).xlsx');
        System.assertEquals('vorlage_potentialberechnung_11_09_2018 (2.1.2).xlsx', DGen_DocumentTemplates.latest(realWorld));
    }
    
    @isTest
    public static void TestSortingDocx() {
        String[] realWorld = new String[]{
			'DG_krutisch_anspruchschreiben_vw 1.5 .docx',
			'DG_krutisch_anspruchschreiben_vw (1.0).docx',
            'DG_krutisch_anspruchschreiben_vw 1.4.docx'
        };
        System.assertEquals('DG_krutisch_anspruchschreiben_vw 1.5 .docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw (1.7) .docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw (1.7) .docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw (1.6.2).docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw (1.7) .docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw(1.7.1).docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw(1.7.1).docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw (1.7.2)  .docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw (1.7.2)  .docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw    (1.8).docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw    (1.8).docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw 2.docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw 2.docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw 2.0.4.docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw 2.0.4.docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('DG_krutisch_anspruchschreiben_vw (4).docx');
		System.assertEquals('DG_krutisch_anspruchschreiben_vw (4).docx', DGen_DocumentTemplates.latest(realWorld));
        
        realWorld.add('klageschrift_vw_neu_DE (4.3).docx');
		System.assertEquals('klageschrift_vw_neu_DE (4.3).docx', DGen_DocumentTemplates.latest(realWorld));
    }
}