@isTest
public class VehicleBrandsTests {
	@isTest
    private static void testVehicleAccounts() {
		Account accAudiAG = new Account(Name = 'Audi AG', Created_Date_Old_Org__c = DateTime.now());
        Account accPorscheAG = new Account(Name = 'Porsche AG', Created_Date_Old_Org__c = DateTime.now());
        Account accTestFahrzeughersteller = new Account(Name = 'TestFahrzeughersteller', Created_Date_Old_Org__c = DateTime.now());
        Account accSsangyongMotorsDeutschlandGmbH = new Account(Name = 'Ssangyong Motors Deutschland GmbH', Created_Date_Old_Org__c = DateTime.now());
        Account accOpelAutomobileGmbH = new Account(Name = 'Opel Automobile GmbH', Created_Date_Old_Org__c = DateTime.now());
        Account accBMWAG = new Account(Name = 'BMW AG', Created_Date_Old_Org__c = DateTime.now());
        Account accVolkswagenAG = new Account(Name = 'Volkswagen AG', Created_Date_Old_Org__c = DateTime.now());
        Account accFahrzeugherstellerTest = new Account(Name = 'FahrzeugherstellerTest', Created_Date_Old_Org__c = DateTime.now());
        Account accJaguarCars = new Account(Name = 'Jaguar Cars', Created_Date_Old_Org__c = DateTime.now());
        Account accMitsubishiMotors = new Account(Name = 'Mitsubishi Motors', Created_Date_Old_Org__c = DateTime.now());
        Account accPeugeot = new Account(Name = 'Peugeot', Created_Date_Old_Org__c = DateTime.now());
        Account accLancia = new Account(Name = 'Lancia', Created_Date_Old_Org__c = DateTime.now());
        Account accVolvo = new Account(Name = 'Volvo', Created_Date_Old_Org__c = DateTime.now());
        Account accChevrolet = new Account(Name = 'Chevrolet', Created_Date_Old_Org__c = DateTime.now());
        Account accSubaru = new Account(Name = 'Subaru', Created_Date_Old_Org__c = DateTime.now());
        Account accLandRover = new Account(Name = 'Land Rover', Created_Date_Old_Org__c = DateTime.now());
        Account accLexus = new Account(Name = 'Lexus', Created_Date_Old_Org__c = DateTime.now());
        Account accLotusCars = new Account(Name = 'Lotus Cars', Created_Date_Old_Org__c = DateTime.now());
        Account accNissan = new Account(Name = 'Nissan', Created_Date_Old_Org__c = DateTime.now());
        Account accFordWerkeGmbH = new Account(Name = 'Ford-Werke GmbH', Created_Date_Old_Org__c = DateTime.now());
        Account accDodge = new Account(Name = 'Dodge', Created_Date_Old_Org__c = DateTime.now());
        Account accFiatSpA = new Account(Name = 'Fiat S.p.A.', Created_Date_Old_Org__c = DateTime.now());
        Account accAlfaRomeo = new Account(Name = 'Alfa Romeo', Created_Date_Old_Org__c = DateTime.now());
        Account accAstonMartin = new Account(Name = 'Aston Martin', Created_Date_Old_Org__c = DateTime.now());
        Account accMini = new Account(Name = 'Mini', Created_Date_Old_Org__c = DateTime.now());
        Account accRenaultDeutschlandAG = new Account(Name = 'Renault Deutschland AG', Created_Date_Old_Org__c = DateTime.now());
        Account accMazda = new Account(Name = 'Mazda', Created_Date_Old_Org__c = DateTime.now());
        Account accCitroen = new Account(Name = 'Citroen', Created_Date_Old_Org__c = DateTime.now());
        Account accSmart = new Account(Name = 'Smart', Created_Date_Old_Org__c = DateTime.now());
        Account accToyota = new Account(Name = 'Toyota', Created_Date_Old_Org__c = DateTime.now());
        Account accChrysler = new Account(Name = 'Chrysler', Created_Date_Old_Org__c = DateTime.now());
        Account accMaybachMotorenbau = new Account(Name = 'Maybach-Motorenbau', Created_Date_Old_Org__c = DateTime.now());
        Account accMaserati = new Account(Name = 'Maserati', Created_Date_Old_Org__c = DateTime.now());
        Account accHonda = new Account(Name = 'Honda', Created_Date_Old_Org__c = DateTime.now());
        Account accKiaMotors = new Account(Name = 'Kia Motors', Created_Date_Old_Org__c = DateTime.now());
        Account accHummer = new Account(Name = 'Hummer', Created_Date_Old_Org__c = DateTime.now());
        Account accHyundaiMotorCompany = new Account(Name = 'Hyundai Motor Company', Created_Date_Old_Org__c = DateTime.now());
        Account accRollsRoyceMotorCars = new Account(Name = 'Rolls-Royce Motor Cars', Created_Date_Old_Org__c = DateTime.now());
        Account accSuzuki = new Account(Name = 'Suzuki', Created_Date_Old_Org__c = DateTime.now());
        Account accAutomobileDacia = new Account(Name = 'Automobile Dacia', Created_Date_Old_Org__c = DateTime.now());
        Account accDaimlerAG = new Account(Name = 'Daimler AG', Created_Date_Old_Org__c = DateTime.now());
        Account accPorscheKFZ = new Account(Name = 'Porsche (KFZW)', Created_Date_Old_Org__c = DateTime.now());

		insert new Account[] {
			accAudiAG,
			accPorscheAG,
			accTestFahrzeughersteller,
			accSsangyongMotorsDeutschlandGmbH,
			accOpelAutomobileGmbH,
			accBMWAG,
			accVolkswagenAG,
			accFahrzeugherstellerTest,
			accJaguarCars,
			accMitsubishiMotors,
			accPeugeot,
			accLancia,
			accVolvo,
			accChevrolet,
			accSubaru,
			accLandRover,
			accLexus,
			accLotusCars,
			accNissan,
			accFordWerkeGmbH,
			accDodge,
			accFiatSpA,
			accAlfaRomeo,
			accAstonMartin,
			accMini,
			accRenaultDeutschlandAG,
			accMazda,
			accCitroen,
			accSmart,
			accToyota,
			accChrysler,
			accMaybachMotorenbau,
			accMaserati,
			accHonda,
			accKiaMotors,
			accHummer,
			accHyundaiMotorCompany,
			accRollsRoyceMotorCars,
			accSuzuki,
			accAutomobileDacia,
			accDaimlerAG,
			accPorscheKFZ
		};

		Account[] acc = [select id, name from account where name = 'Audi AG'];
		System.debug('audi:' + acc);
        System.debug('accAudiAG:' + accAudiAG);

		System.assert(VehicleBrands.isAudiAG(accAudiAG.ID));
		System.assert(!VehicleBrands.isAudiAG(null));
		System.assert(!VehicleBrands.isPorscheAG(accAudiAG.ID));

		System.assert(VehicleBrands.isPorscheAG(accPorscheAG.ID));
		System.assert(!VehicleBrands.isPorscheAG(null));
		System.assert(!VehicleBrands.isAudiAG(accPorscheAG.ID));

		System.assert(VehicleBrands.isTestFahrzeughersteller(accTestFahrzeughersteller.ID));
		System.assert(!VehicleBrands.isTestFahrzeughersteller(null));
		System.assert(!VehicleBrands.isAudiAG(accTestFahrzeughersteller.ID));

		System.assert(VehicleBrands.isSsangyongMotorsDeutschlandGmbH(accSsangyongMotorsDeutschlandGmbH.ID));
		System.assert(!VehicleBrands.isSsangyongMotorsDeutschlandGmbH(null));
		System.assert(!VehicleBrands.isAudiAG(accSsangyongMotorsDeutschlandGmbH.ID));

		System.assert(VehicleBrands.isOpelAutomobileGmbH(accOpelAutomobileGmbH.ID));
		System.assert(!VehicleBrands.isOpelAutomobileGmbH(null));
		System.assert(!VehicleBrands.isAudiAG(accOpelAutomobileGmbH.ID));

		System.assert(VehicleBrands.isBMWAG(accBMWAG.ID));
		System.assert(!VehicleBrands.isBMWAG(null));
		System.assert(!VehicleBrands.isAudiAG(accBMWAG.ID));

		System.assert(VehicleBrands.isVolkswagenAG(accVolkswagenAG.ID));
		System.assert(!VehicleBrands.isVolkswagenAG(null));
		System.assert(!VehicleBrands.isAudiAG(accVolkswagenAG.ID));

		System.assert(VehicleBrands.isFahrzeugherstellerTest(accFahrzeugherstellerTest.ID));
		System.assert(!VehicleBrands.isFahrzeugherstellerTest(null));
		System.assert(!VehicleBrands.isAudiAG(accFahrzeugherstellerTest.ID));

		System.assert(VehicleBrands.isJaguarCars(accJaguarCars.ID));
		System.assert(!VehicleBrands.isJaguarCars(null));
		System.assert(!VehicleBrands.isAudiAG(accJaguarCars.ID));

		System.assert(VehicleBrands.isMitsubishiMotors(accMitsubishiMotors.ID));
		System.assert(!VehicleBrands.isMitsubishiMotors(null));
		System.assert(!VehicleBrands.isAudiAG(accMitsubishiMotors.ID));

		System.assert(VehicleBrands.isPeugeot(accPeugeot.ID));
		System.assert(!VehicleBrands.isPeugeot(null));
		System.assert(!VehicleBrands.isAudiAG(accPeugeot.ID));

		System.assert(VehicleBrands.isLancia(accLancia.ID));
		System.assert(!VehicleBrands.isLancia(null));
		System.assert(!VehicleBrands.isAudiAG(accLancia.ID));

		System.assert(VehicleBrands.isVolvo(accVolvo.ID));
		System.assert(!VehicleBrands.isVolvo(null));
		System.assert(!VehicleBrands.isAudiAG(accVolvo.ID));

		System.assert(VehicleBrands.isChevrolet(accChevrolet.ID));
		System.assert(!VehicleBrands.isChevrolet(null));
		System.assert(!VehicleBrands.isAudiAG(accChevrolet.ID));

		System.assert(VehicleBrands.isSubaru(accSubaru.ID));
		System.assert(!VehicleBrands.isSubaru(null));
		System.assert(!VehicleBrands.isAudiAG(accSubaru.ID));

		System.assert(VehicleBrands.isLandRover(accLandRover.ID));
		System.assert(!VehicleBrands.isLandRover(null));
		System.assert(!VehicleBrands.isAudiAG(accLandRover.ID));

		System.assert(VehicleBrands.isLexus(accLexus.ID));
		System.assert(!VehicleBrands.isLexus(null));
		System.assert(!VehicleBrands.isAudiAG(accLexus.ID));

		System.assert(VehicleBrands.isLotusCars(accLotusCars.ID));
		System.assert(!VehicleBrands.isLotusCars(null));
		System.assert(!VehicleBrands.isAudiAG(accLotusCars.ID));

		System.assert(VehicleBrands.isNissan(accNissan.ID));
		System.assert(!VehicleBrands.isNissan(null));
		System.assert(!VehicleBrands.isAudiAG(accNissan.ID));

		System.assert(VehicleBrands.isFordWerkeGmbH(accFordWerkeGmbH.ID));
		System.assert(!VehicleBrands.isFordWerkeGmbH(null));
		System.assert(!VehicleBrands.isAudiAG(accFordWerkeGmbH.ID));

		System.assert(VehicleBrands.isDodge(accDodge.ID));
		System.assert(!VehicleBrands.isDodge(null));
		System.assert(!VehicleBrands.isAudiAG(accDodge.ID));

		System.assert(VehicleBrands.isFiatSpA(accFiatSpA.ID));
		System.assert(!VehicleBrands.isFiatSpA(null));
		System.assert(!VehicleBrands.isAudiAG(accFiatSpA.ID));

		System.assert(VehicleBrands.isAlfaRomeo(accAlfaRomeo.ID));
		System.assert(!VehicleBrands.isAlfaRomeo(null));
		System.assert(!VehicleBrands.isAudiAG(accAlfaRomeo.ID));

		System.assert(VehicleBrands.isAstonMartin(accAstonMartin.ID));
		System.assert(!VehicleBrands.isAstonMartin(null));
		System.assert(!VehicleBrands.isAudiAG(accAstonMartin.ID));

		System.assert(VehicleBrands.isMini(accMini.ID));
		System.assert(!VehicleBrands.isMini(null));
		System.assert(!VehicleBrands.isAudiAG(accMini.ID));

		System.assert(VehicleBrands.isRenaultDeutschlandAG(accRenaultDeutschlandAG.ID));
		System.assert(!VehicleBrands.isRenaultDeutschlandAG(null));
		System.assert(!VehicleBrands.isAudiAG(accRenaultDeutschlandAG.ID));

		System.assert(VehicleBrands.isMazda(accMazda.ID));
		System.assert(!VehicleBrands.isMazda(null));
		System.assert(!VehicleBrands.isAudiAG(accMazda.ID));

		System.assert(VehicleBrands.isCitroen(accCitroen.ID));
		System.assert(!VehicleBrands.isCitroen(null));
		System.assert(!VehicleBrands.isAudiAG(accCitroen.ID));

		System.assert(VehicleBrands.isSmart(accSmart.ID));
		System.assert(!VehicleBrands.isSmart(null));
		System.assert(!VehicleBrands.isAudiAG(accSmart.ID));

		System.assert(VehicleBrands.isToyota(accToyota.ID));
		System.assert(!VehicleBrands.isToyota(null));
		System.assert(!VehicleBrands.isAudiAG(accToyota.ID));

		System.assert(VehicleBrands.isChrysler(accChrysler.ID));
		System.assert(!VehicleBrands.isChrysler(null));
		System.assert(!VehicleBrands.isAudiAG(accChrysler.ID));

		System.assert(VehicleBrands.isMaybachMotorenbau(accMaybachMotorenbau.ID));
		System.assert(!VehicleBrands.isMaybachMotorenbau(null));
		System.assert(!VehicleBrands.isAudiAG(accMaybachMotorenbau.ID));

		System.assert(VehicleBrands.isMaserati(accMaserati.ID));
		System.assert(!VehicleBrands.isMaserati(null));
		System.assert(!VehicleBrands.isAudiAG(accMaserati.ID));

		System.assert(VehicleBrands.isHonda(accHonda.ID));
		System.assert(!VehicleBrands.isHonda(null));
		System.assert(!VehicleBrands.isAudiAG(accHonda.ID));

		System.assert(VehicleBrands.isKiaMotors(accKiaMotors.ID));
		System.assert(!VehicleBrands.isKiaMotors(null));
		System.assert(!VehicleBrands.isAudiAG(accKiaMotors.ID));

		System.assert(VehicleBrands.isHummer(accHummer.ID));
		System.assert(!VehicleBrands.isHummer(null));
		System.assert(!VehicleBrands.isAudiAG(accHummer.ID));

		System.assert(VehicleBrands.isHyundaiMotorCompany(accHyundaiMotorCompany.ID));
		System.assert(!VehicleBrands.isHyundaiMotorCompany(null));
		System.assert(!VehicleBrands.isAudiAG(accHyundaiMotorCompany.ID));

		System.assert(VehicleBrands.isRollsRoyceMotorCars(accRollsRoyceMotorCars.ID));
		System.assert(!VehicleBrands.isRollsRoyceMotorCars(null));
		System.assert(!VehicleBrands.isAudiAG(accRollsRoyceMotorCars.ID));

		System.assert(VehicleBrands.isSuzuki(accSuzuki.ID));
		System.assert(!VehicleBrands.isSuzuki(null));
		System.assert(!VehicleBrands.isAudiAG(accSuzuki.ID));

		System.assert(VehicleBrands.isAutomobileDacia(accAutomobileDacia.ID));
		System.assert(!VehicleBrands.isAutomobileDacia(null));
		System.assert(!VehicleBrands.isAudiAG(accAutomobileDacia.ID));

		System.assert(VehicleBrands.isDaimlerAG(accDaimlerAG.ID));
		System.assert(!VehicleBrands.isDaimlerAG(null));
		System.assert(!VehicleBrands.isAudiAG(accDaimlerAG.ID));

		System.assert(VehicleBrands.isPorscheKFZ(accPorscheKFZ.ID));
		System.assert(!VehicleBrands.isPorscheKFZ(null));
		System.assert(!VehicleBrands.isAudiAG(accPorscheKFZ.ID));
    }
}