public class Decimals {
    // Legacy code, extracted from Utilities
	public static String toCurrency(Decimal inputDecimal){
        if (inputDecimal == null) {
            return null;
        }
        
        String o = Math.floor(inputDecimal).format();
        if (Math.mod((Long)(inputDecimal*100),100) > 0){
            return o + ',' + Math.mod((Long)(Math.floor(inputDecimal*100)),100).format().rightPad(2,'0') + ' €';
        }
        
        return o + ',00 €';
	}
}