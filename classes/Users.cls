public class Users {
    // TODO: fetch this info from Configuration, allowing an Admin to set the names for certain roles
    private static List<User> users;
    private static Map<String, Id> usersByName;
    private static Map<String, Id> usersByNameAndEmail;

    static {
        users = [
            SELECT Id, Email, Name
            FROM User
        ];
        
        usersByName = new Map<String, Id>();
        usersByNameAndEmail = new Map<String, Id>();
        
        for (User u : users) {
            usersByName.put(u.name, u.Id);
            usersByNameAndEmail.put(u.name + '|' + u.email, u.Id);
        }
    }   

    private static Id fetchUserId(string name) {
        return usersByName.get(name);
    }

    private static Id fetchUserId(string name, string email) {
        return usersByNameAndEmail.get(name + '|' + email);
    }

    // not sure about this function (created for OpportunitiesLegal.apxc)
    // and it actually seems to break things because the role is not set idk why
    public static Id getLegalByName(string name) {
        return fetchUserId(name);
    }

    public static Id vh24Lv() { // old 0050Y000003848TQAQ
        return fetchUserId('Verbraucherhilfe24', 'lebensversicherung@verbraucherhilfe24.de');
    }

    public static Id vh24Diesel() { // old 0050Y0000038FcUQAU
        return fetchUserId('Verbraucherhilfe24', 'auto@verbraucherhilfe24.de');
    }

    public static Id vh24Darlehen() { // old 0050Y0000047SKaQAM
        return fetchUserId('Verbraucherhilfe24', 'darlehen@verbraucherhilfe24.de');
    }

    public static Id vh24pixel() { // old 0050Y000004h2Gx
        return fetchUserId('Pixelletter VH24');
    }

    public static Id vr24() { // old 0050Y000001hkmz
        return fetchUserId('Verbraucherrechte24', 'service@verbraucherrechte24.de');
    }

    public static Id vr24diesel() { // old 0050Y000002lVLq
        return fetchUserId('Verbraucherrechte24', 'diesel-schaden@verbraucherrechte24.de');
    }

    public static Id potentialCheck() {
        return fetchUserId('Martin Braun');
    }

    public static Id consultant() {
        return fetchUserId('Stefanie Hoffmann');
    }

    public static Id clerkAppeal() {
        return fetchUserId('Vanessa Majewski');
    }

    public static Id CarmenHornung() {
        return fetchUserId('Carmen Hornung' );
    }

    public static Id MariaGorzna() { // old 0050Y000001ISWf
        return fetchUserId('Maria Gorzna' );
    }

    public static Id NinaHoyer() { // 0051t000002EzLf
        return fetchUserId('Nina Hoyer');
    }

    public static Id cllbClerk() {
        return fetchUserId('Henning Leitz');
    }

    // Legals

    public static Id JCLegal() { // Finanzierung
        return fetchUserId('Anwälte Jäger'); // (old) 0050Y000004hLE3QAM
    }

    public static Id JHLegal() { // Dieselskandal
        return fetchUserId('H. Jäger'); // (old) 0050Y000002lsDfQAI
    }

    public static Id JHeinrichLegal() { // Lebensversicherung
        return fetchUserId('Heinrich Jäger'); // (old) 0050Y000001Hwz4QAC
    }

    public static Id JAndCLegal() {
        return fetchUserId('J&C Anwälte'); // (old) 0050Y00000384Dd
    }

    public static Id kainzLegal() {
        return fetchUserId('A. Kainz'); // (old) 0050Y000003dTRYQA2
    }

    public static Id krutischLegal() {
        return fetchUserId('Dominic Krutisch'); // new lawyer
    }

    public static Id lachmairLegal() {
        return fetchUserId('Wilhelm Lachmair'); // (old) 0050Y000002Fq9MQAS
    }

    public static Id legal21() {
        return fetchUserId('Rechtsanwälte Lachmair & Kollegen');
    }

    public static Id cllbLegal() {
        return fetchUserId('CLLB Rechtsanwälte Cocron, Liebl, Leitz, Braun, Kainz, Sittner Partnerschaft mbB');
    }
}