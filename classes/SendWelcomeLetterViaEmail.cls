// Welcome_Letter__c "Per Email versenden" Button
// Begrüßungsschreiben "Per Email versenden" Button
public class SendWelcomeLetterViaEmail {
    private final Welcome_Letter__c welcomeletter;
    private final Opportunity opp;
    public string errorMsg {get; set;}

    public SendWelcomeLetterViaEmail(ApexPages.Standardcontroller stdCtl) {
        errorMsg = '';
        this.welcomeletter = [
            SELECT ID,
            Opportunity__c
            FROM Welcome_Letter__c
            WHERE ID = :stdCtl.getId()
        ];
        this.opp = [
            SELECT ID,
            RecordTypeID,
            Legal_Account__c,
            Contact__c
            FROM Opportunity
            WHERE Id = :this.welcomeletter.Opportunity__c
        ];
    }

    public PageReference renderPage() {
        if (this.opp.contact__c == null) {
            errorMsg = 'einen Kontakt auf dem Feld "Kunde" der Anfrage';
        }
        if (errorMsg != '') {
            return Null;
        }
        string url = page.SendMail.getUrl() + createUrl();
        System.debug('url: ' +  url);
        return new PageReference(url);
    }

    private string getTpl() {
        if (Accounts.isJCLegal(this.opp.Legal_Account__c)) { // 0010Y000011MYHW
            return EmailTemplates.idOf(EmailTemplates.name.DieselJaegerBackofficeSendWelcomeLetter);
        }
        if (Accounts.isLegal21(this.opp.Legal_Account__c)) { // 0010Y000013yLnP
            return EmailTemplates.idOf(EmailTemplates.name.Diesel21LegalBackofficeSendWelcomeLetter);
        }
        if (Accounts.isCLLBLegal(this.opp.Legal_Account__c)) { // 0010Y000010COcm
            return EmailTemplates.idOf(EmailTemplates.name.DieselKainzBackofficeSendWelcomeLetter);
        }
        /* TODO: missing tpl
        if (Accounts.isLegalLeCom(this.opp.Legal_Account__c)) {
        	return EmailTemplates.idOf(EmailTemplates.name.DieselLeComBackofficeSendWelcomeLetter);
        }
		*/
        return EmailTemplates.idOf(EmailTemplates.name.DieselLachmairBackofficeSendWelcomeLetter);
    }

    private string createUrl() {
        return
            '?id=' + welcomeletter.Id +
            '&tpl=' + getTpl() +
            '&recipient=' + this.opp.contact__c + 
            '&hdl="Begrüßungsschreiben versenden."' +
            '&attreq=true';
    }
}

// /apex/SendMail?id={!Welcome_Letter__c.Id}
// &tpl={!IF(Opportunity.Legal_AccountId__c = '0010Y000011MYHW','00X0Y000000dmV0',IF(Opportunity.Legal_AccountId__c = '0010Y000013yLnP','00X0Y000000yAcB',IF(Opportunity.Legal_AccountId__c = '0010Y000010COcm','00X0Y000001ab14','00X0Y000000s2gv')))}
// &recipient={!Opportunity.ContactId__c}
// &hdl="Begrüßungsschreiben versenden."
// &attreq=true