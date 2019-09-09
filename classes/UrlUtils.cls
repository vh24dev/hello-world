public class UrlUtils {
    public static string getAgbFromLead(Lead l) {
        if (l == null) {
            return 'https://www.verbraucherhilfe24.de/error';
        }
		/*
		https://trello.com/c/ZGg02YOU/472-wrong-agb
        Dieselskandal:
        https://www.verbraucherhilfe24.de/agb/dg/AGB_VH24_mitRSV.pdf
        https://www.verbraucherhilfe24.de/agb/dg/AGB_VH24_ohneRSV.pdf
        Lebensversicherung:
        https://www.verbraucherhilfe24.de/agb/lv/AGB_VH24_ohneRSV.pdf
        https://www.verbraucherhilfe24.de/agb/lv/AGB_VH24_mitRSV.pdf
		*/
        string rsv = l.Has_Legal_Protection_Insurance__c ? 'mit' : 'ohne';
        string rt = Leads.isDieselskandal(l.recordtypeid) ? 'dg' : 'lv';
        return 'https://www.verbraucherhilfe24.de/agb/' + rt + '/AGB_VH24_' + rsv + 'RSV.pdf';
    }

    private static string arg(string url, string arg) {
        if (url == null || arg == null
            || url == '' || arg == '') {
            return '';
        }
        return new PageReference(url).getParameters().get(arg);
    }

    public static Lead setLeadFields(Lead l) {
        string url = Apexpages.currentPage().getUrl();
        return setLeadFields(url, l);
    }

    public static Lead setLeadFields(string url, Lead l) {
        System.debug('url=' + url);
        if (l == null) {
            return null;
        }
        // https://trello.com/c/ouOSoed8/467-query-string-for-links
        string a;
        a = arg(url, 'utm_Source');
        if (a != '') {
            l.AdWords_Source__c = a;
        }
        a = arg(url, 'utm_Medium');
        if (a != '') {
            l.AdWords_Medium__c = a;
        }
        a = arg(url, 'utm_Campaign');
        if (a != '') {
            l.AdWords_Campaign__c = a;
        }
        a = arg(url, 'utm_Term');
        if (a != '') {
            l.AdWords_Term__c = a;
        }
        a = arg(url, 'utm_Content');
        if (a != '') {
            l.AdWords_Content__c = a;
        }
        a = arg(url, 'UniqueId');
        if (a != '') {
            l.Unique_Id__c = a;
        }
        a = arg(url, 'FormularId');
        if (a != '') {
            l.Form_Id__c = a;
        }
        a = arg(url, 'Kampagne');
        if (a != '') {
            l.Campaign__c = a;
        }
        a = arg(url, 'Referrer');
        if (a != '') {
            l.Referrer__c = a;
        }
        return l;
    }
}