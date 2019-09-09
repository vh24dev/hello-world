@isTest(seeAllData=true)
public class EmailTemplatesTests {
    @isTest
    public static void dynName() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.name.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.name.values()[i]) == null) {
                missings.add(EmailTemplates.name.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLvBackoffice() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LvBackoffice.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LvBackoffice.values()[i]) == null) {
                missings.add(EmailTemplates.LvBackoffice.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDocumentsComplete() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.DocumentsComplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsComplete.values()[i]) == null) {
                missings.add(EmailTemplates.DocumentsComplete.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDocumentsIncomplete() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.DocumentsIncomplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.values()[i]) == null) {
                missings.add(EmailTemplates.DocumentsIncomplete.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynClaims() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.Claims.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Claims.values()[i]) == null) {
                missings.add(EmailTemplates.Claims.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynGeneralRefusal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.GeneralRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.GeneralRefusal.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLegalRefusal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.LegalRefusal.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynGeneral() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.General.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.General.values()[i]) == null) {
                missings.add(EmailTemplates.General.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLegalCorrespondence() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LegalCorrespondence.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalCorrespondence.values()[i]) == null) {
                missings.add(EmailTemplates.LegalCorrespondence.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLegalDate() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LegalDate.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalDate.values()[i]) == null) {
                missings.add(EmailTemplates.LegalDate.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynGeneralTestCase() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.GeneralTestCase.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralTestCase.values()[i]) == null) {
                missings.add(EmailTemplates.GeneralTestCase.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynRequestOwnership() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.RequestOwnership.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.RequestOwnership.values()[i]) == null) {
                missings.add(EmailTemplates.RequestOwnership.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynClaimComparison() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.ClaimComparison.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ClaimComparison.values()[i]) == null) {
                missings.add(EmailTemplates.ClaimComparison.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynCancellation() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.Cancellation.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Cancellation.values()[i]) == null) {
                missings.add(EmailTemplates.Cancellation.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynReceiveAuthorization() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.ReceiveAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.values()[i]) == null) {
                missings.add(EmailTemplates.ReceiveAuthorization.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynAntwortBeimKunden() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.AntwortBeimKunden.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.values()[i]) == null) {
                missings.add(EmailTemplates.AntwortBeimKunden.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynCreditNote() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.CreditNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CreditNote.values()[i]) == null) {
                missings.add(EmailTemplates.CreditNote.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynCostNote() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.CostNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CostNote.values()[i]) == null) {
                missings.add(EmailTemplates.CostNote.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLeComLegalRefusal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LeComLegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LeComLegalRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.LeComLegalRefusal.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLegalAuthorization() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.LegalAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalAuthorization.values()[i]) == null) {
                missings.add(EmailTemplates.LegalAuthorization.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynTotal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < EmailTemplates.name.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.name.values()[i]) == null) {
                missings.add(EmailTemplates.name.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.Claims.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Claims.values()[i]) == null) {
                missings.add(EmailTemplates.Claims.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.GeneralRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.GeneralRefusal.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.LegalRefusal.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.General.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.General.values()[i]) == null) {
                missings.add(EmailTemplates.General.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalCorrespondence.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalCorrespondence.values()[i]) == null) {
                missings.add(EmailTemplates.LegalCorrespondence.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalDate.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalDate.values()[i]) == null) {
                missings.add(EmailTemplates.LegalDate.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.GeneralTestCase.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralTestCase.values()[i]) == null) {
                missings.add(EmailTemplates.GeneralTestCase.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.RequestOwnership.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.RequestOwnership.values()[i]) == null) {
                missings.add(EmailTemplates.RequestOwnership.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.ClaimComparison.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ClaimComparison.values()[i]) == null) {
                missings.add(EmailTemplates.ClaimComparison.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.Cancellation.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Cancellation.values()[i]) == null) {
                missings.add(EmailTemplates.Cancellation.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.ReceiveAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.values()[i]) == null) {
                missings.add(EmailTemplates.ReceiveAuthorization.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.AntwortBeimKunden.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.values()[i]) == null) {
                missings.add(EmailTemplates.AntwortBeimKunden.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.CreditNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CreditNote.values()[i]) == null) {
                missings.add(EmailTemplates.CreditNote.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.CostNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CostNote.values()[i]) == null) {
                missings.add(EmailTemplates.CostNote.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LeComLegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LeComLegalRefusal.values()[i]) == null) {
                missings.add(EmailTemplates.LeComLegalRefusal.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalAuthorization.values()[i]) == null) {
                missings.add(EmailTemplates.LegalAuthorization.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.DocumentsComplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsComplete.values()[i]) == null) {
                missings.add(EmailTemplates.DocumentsComplete.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.DocumentsIncomplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.values()[i]) == null) {
                missings.add(EmailTemplates.DocumentsIncomplete.values()[i].name());
            }
        }
        for(Integer i = 0; i < EmailTemplates.LvBackoffice.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LvBackoffice.values()[i]) == null) {
                missings.add(EmailTemplates.LvBackoffice.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void testBody() {
        List<ID> tplIDs = new List<ID>();
        for(Integer i = 0; i < EmailTemplates.name.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.name.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.name.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.Claims.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Claims.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.Claims.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.GeneralRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralRefusal.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.GeneralRefusal.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalRefusal.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LegalRefusal.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.General.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.General.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.General.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalCorrespondence.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalCorrespondence.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LegalCorrespondence.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalDate.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalDate.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LegalDate.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.GeneralTestCase.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.GeneralTestCase.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.GeneralTestCase.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.RequestOwnership.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.RequestOwnership.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.RequestOwnership.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.ClaimComparison.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ClaimComparison.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.ClaimComparison.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.Cancellation.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.Cancellation.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.Cancellation.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.ReceiveAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.ReceiveAuthorization.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.AntwortBeimKunden.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.AntwortBeimKunden.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.CreditNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CreditNote.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.CreditNote.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.CostNote.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.CostNote.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.CostNote.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LeComLegalRefusal.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LeComLegalRefusal.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LeComLegalRefusal.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LegalAuthorization.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LegalAuthorization.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LegalAuthorization.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.DocumentsComplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsComplete.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.DocumentsComplete.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.DocumentsIncomplete.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.DocumentsIncomplete.values()[i]));
            }
        }
        for(Integer i = 0; i < EmailTemplates.LvBackoffice.values().size(); i++) {
            if (EmailTemplates.idOf(EmailTemplates.LvBackoffice.values()[i]) != null) {
                tplIds.add(EmailTemplates.idOf(EmailTemplates.LvBackoffice.values()[i]));
            }
        }
        List<EmailTemplate> tpls = [
            SELECT ID, Body, DeveloperName
            FROM EmailTemplate
            WHERE ID IN :tplIDs
        ];
        List<string> missing = new List<string>();
        for (EmailTemplate t : tpls) {
            if (t.body == null || t.body == '') {
                missing.add(t.developername);
            }
        }
        System.assertEquals(0, missing.size(), 'bodyless templates: ' + missing);
    }
}