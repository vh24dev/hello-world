@isTest(seeAllData=true) 
public class CloudworxTemplatesTest {
    @isTest
    public static void dynName() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.name.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.name.values()[i]) == null) {
                missings.add(CloudworxTemplates.name.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDG21Legal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.DG21Legal.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.values()[i]) == null) {
                missings.add(CloudworxTemplates.DG21Legal.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDGJaeger() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.DGJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGJaeger.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDGKainz() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.DGKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGKainz.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDGLachmair() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.DGLachmair.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGLachmair.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynDGLeCom() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.DGLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGLeCom.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynFZJaeger() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.FZJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZJaeger.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynFZKainz() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.FZKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZKainz.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynFZLeCom() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.FZLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZLeCom.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLV21Legal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.LV21Legal.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.values()[i]) == null) {
                missings.add(CloudworxTemplates.LV21Legal.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLVJaeger() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.LVJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVJaeger.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLVKainz() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.LVKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVKainz.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynLVLeCom() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.LVLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVLeCom.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }

    @isTest
    public static void dynTotal() {
        List<string> missings = new List<string>();
        for(Integer i = 0; i < CloudworxTemplates.name.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.name.values()[i]) == null) {
                missings.add(CloudworxTemplates.name.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.DG21Legal.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DG21Legal.values()[i]) == null) {
                missings.add(CloudworxTemplates.DG21Legal.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.DGJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGJaeger.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.DGKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGKainz.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.DGLachmair.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGLachmair.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGLachmair.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.DGLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.DGLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.DGLeCom.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.FZJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZJaeger.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.FZKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZKainz.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.FZLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.FZLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.FZLeCom.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.LV21Legal.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LV21Legal.values()[i]) == null) {
                missings.add(CloudworxTemplates.LV21Legal.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.LVJaeger.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVJaeger.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVJaeger.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.LVKainz.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVKainz.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVKainz.values()[i].name());
            }
        }
        for(Integer i = 0; i < CloudworxTemplates.LVLeCom.values().size(); i++) {
            if (CloudworxTemplates.idOf(CloudworxTemplates.LVLeCom.values()[i]) == null) {
                missings.add(CloudworxTemplates.LVLeCom.values()[i].name());
            }
        }
        System.assertEquals(0, missings.size(), 'missing tpls: ' + missings);
    }
}