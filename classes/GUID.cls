public class GUID {
    public static string Gen() {
        Blob b = Crypto.GenerateAESKey(128);
        string h = EncodingUtil.ConvertTohex(b);
        string guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
        return guid;
    }
}