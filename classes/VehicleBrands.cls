public class VehicleBrands {
    public static ID AudiAGID;
    public static ID PorscheAGID;
    public static ID TestFahrzeugherstellerID;
    public static ID SsangyongMotorsDeutschlandGmbHID;
    public static ID OpelAutomobileGmbHID;
    public static ID BMWAGID;
    public static ID VolkswagenAGID;
    public static ID FahrzeugherstellerTestID;
    public static ID JaguarCarsID;
    public static ID MitsubishiMotorsID;
    public static ID PeugeotID;
    public static ID LanciaID;
    public static ID VolvoID;
    public static ID ChevroletID;
    public static ID SubaruID;
    public static ID LandRoverID;
    public static ID LexusID;
    public static ID LotusCarsID;
    public static ID NissanID;
    public static ID FordWerkeGmbHID;
    public static ID DodgeID;
    public static ID FiatSpAID;
    public static ID AlfaRomeoID;
    public static ID AstonMartinID;
    public static ID MiniID;
    public static ID RenaultDeutschlandAGID;
    public static ID MazdaID;
    public static ID CitroenID;
    public static ID SmartID;
    public static ID ToyotaID;
    public static ID ChryslerID;
    public static ID MaybachMotorenbauID;
    public static ID MaseratiID;
    public static ID HondaID;
    public static ID KiaMotorsID;
    public static ID HummerID;
    public static ID HyundaiMotorCompanyID;
    public static ID RollsRoyceMotorCarsID;
    public static ID SuzukiID;
    public static ID AutomobileDaciaID;
    public static ID DaimlerAGID;
    public static ID PorscheKFZID;
    public static final String AudiAG = 'Audi AG';
    public static final String PorscheAG = 'Porsche AG';
    public static final String TestFahrzeughersteller = 'TestFahrzeughersteller';
    public static final String SsangyongMotorsDeutschlandGmbH = 'Ssangyong Motors Deutschland GmbH';
    public static final String OpelAutomobileGmbH = 'Opel Automobile GmbH';
    public static final String BMWAG = 'BMW AG';
    public static final String VolkswagenAG = 'Volkswagen AG';
    public static final String FahrzeugherstellerTest = 'FahrzeugherstellerTest';
    public static final String JaguarCars = 'Jaguar Cars';
    public static final String MitsubishiMotors = 'Mitsubishi Motors';
    public static final String Peugeot = 'Peugeot';
    public static final String Lancia = 'Lancia';
    public static final String Volvo = 'Volvo';
    public static final String Chevrolet = 'Chevrolet';
    public static final String Subaru = 'Subaru';
    public static final String LandRover = 'Land Rover';
    public static final String Lexus = 'Lexus';
    public static final String LotusCars = 'Lotus Cars';
    public static final String Nissan = 'Nissan';
    public static final String FordWerkeGmbH = 'Ford-Werke GmbH';
    public static final String Dodge = 'Dodge';
    public static final String FiatSpA = 'Fiat S.p.A.';
    public static final String AlfaRomeo = 'Alfa Romeo';
    public static final String AstonMartin = 'Aston Martin';
    public static final String Mini = 'Mini';
    public static final String RenaultDeutschlandAG = 'Renault Deutschland AG';
    public static final String Mazda = 'Mazda';
    public static final String Citroen = 'Citroen';
    public static final String Smart = 'Smart';
    public static final String Toyota = 'Toyota';
    public static final String Chrysler = 'Chrysler';
    public static final String MaybachMotorenbau = 'Maybach-Motorenbau';
    public static final String Maserati = 'Maserati';
    public static final String Honda = 'Honda';
    public static final String KiaMotors = 'Kia Motors';
    public static final String Hummer = 'Hummer';
    public static final String HyundaiMotorCompany = 'Hyundai Motor Company';
    public static final String RollsRoyceMotorCars = 'Rolls-Royce Motor Cars';
    public static final String Suzuki = 'Suzuki';
    public static final String AutomobileDacia = 'Automobile Dacia';
    public static final String DaimlerAG = 'Daimler AG';
    public static final String PorscheKFZ = 'Porsche (KFZW)';
    static {
        // Saving on SOQL queries for the same transaction.
        Account[] accs = [
            SELECT ID, Name
            FROM Account
            WHERE Created_Date_Old_Org__c != null AND
            (Name = :AudiAG
            OR Name = :PorscheAG
            OR Name = :TestFahrzeughersteller
            OR Name = :SsangyongMotorsDeutschlandGmbH
            OR Name = :OpelAutomobileGmbH
            OR Name = :BMWAG
            OR Name = :VolkswagenAG
            OR Name = :FahrzeugherstellerTest
            OR Name = :JaguarCars
            OR Name = :MitsubishiMotors
            OR Name = :Peugeot
            OR Name = :Lancia
            OR Name = :Volvo
            OR Name = :Chevrolet
            OR Name = :Subaru
            OR Name = :LandRover
            OR Name = :Lexus
            OR Name = :LotusCars
            OR Name = :Nissan
            OR Name = :FordWerkeGmbH
            OR Name = :Dodge
            OR Name = :FiatSpA
            OR Name = :AlfaRomeo
            OR Name = :AstonMartin
            OR Name = :Mini
            OR Name = :RenaultDeutschlandAG
            OR Name = :Mazda
            OR Name = :Citroen
            OR Name = :Smart
            OR Name = :Toyota
            OR Name = :Chrysler
            OR Name = :MaybachMotorenbau
            OR Name = :Maserati
            OR Name = :Honda
            OR Name = :KiaMotors
            OR Name = :Hummer
            OR Name = :HyundaiMotorCompany
            OR Name = :RollsRoyceMotorCars
            OR Name = :Suzuki
            OR Name = :AutomobileDacia
            OR Name = :DaimlerAG
            OR Name = :PorscheKFZ)
            ORDER BY LastModifiedDate ASC // Last modified account remains, if more than one with the same name
        ];
        for (Account acc : accs) {
            if (acc.name == AudiAG) {
                AudiAGID = acc.ID;
                continue;
            }
            if (acc.name == PorscheAG) {
                PorscheAGID = acc.ID;
                continue;
            }
            if (acc.name == TestFahrzeughersteller) {
                TestFahrzeugherstellerID = acc.ID;
                continue;
            }
            if (acc.name == SsangyongMotorsDeutschlandGmbH) {
                SsangyongMotorsDeutschlandGmbHID = acc.ID;
                continue;
            }
            if (acc.name == OpelAutomobileGmbH) {
                OpelAutomobileGmbHID = acc.ID;
                continue;
            }
            if (acc.name == BMWAG) {
                BMWAGID = acc.ID;
                continue;
            }
            if (acc.name == VolkswagenAG) {
                VolkswagenAGID = acc.ID;
                continue;
            }
            if (acc.name == FahrzeugherstellerTest) {
                FahrzeugherstellerTestID = acc.ID;
                continue;
            }
            if (acc.name == JaguarCars) {
                JaguarCarsID = acc.ID;
                continue;
            }
            if (acc.name == MitsubishiMotors) {
                MitsubishiMotorsID = acc.ID;
                continue;
            }
            if (acc.name == Peugeot) {
                PeugeotID = acc.ID;
                continue;
            }
            if (acc.name == Lancia) {
                LanciaID = acc.ID;
                continue;
            }
            if (acc.name == Volvo) {
                VolvoID = acc.ID;
                continue;
            }
            if (acc.name == Chevrolet) {
                ChevroletID = acc.ID;
                continue;
            }
            if (acc.name == Subaru) {
                SubaruID = acc.ID;
                continue;
            }
            if (acc.name == LandRover) {
                LandRoverID = acc.ID;
                continue;
            }
            if (acc.name == Lexus) {
                LexusID = acc.ID;
                continue;
            }
            if (acc.name == LotusCars) {
                LotusCarsID = acc.ID;
                continue;
            }
            if (acc.name == Nissan) {
                NissanID = acc.ID;
                continue;
            }
            if (acc.name == FordWerkeGmbH) {
                FordWerkeGmbHID = acc.ID;
                continue;
            }
            if (acc.name == Dodge) {
                DodgeID = acc.ID;
                continue;
            }
            if (acc.name == FiatSpA) {
                FiatSpAID = acc.ID;
                continue;
            }
            if (acc.name == AlfaRomeo) {
                AlfaRomeoID = acc.ID;
                continue;
            }
            if (acc.name == AstonMartin) {
                AstonMartinID = acc.ID;
                continue;
            }
            if (acc.name == Mini) {
                MiniID = acc.ID;
                continue;
            }
            if (acc.name == RenaultDeutschlandAG) {
                RenaultDeutschlandAGID = acc.ID;
                continue;
            }
            if (acc.name == Mazda) {
                MazdaID = acc.ID;
                continue;
            }
            if (acc.name == Citroen) {
                CitroenID = acc.ID;
                continue;
            }
            if (acc.name == Smart) {
                SmartID = acc.ID;
                continue;
            }
            if (acc.name == Toyota) {
                ToyotaID = acc.ID;
                continue;
            }
            if (acc.name == Chrysler) {
                ChryslerID = acc.ID;
                continue;
            }
            if (acc.name == MaybachMotorenbau) {
                MaybachMotorenbauID = acc.ID;
                continue;
            }
            if (acc.name == Maserati) {
                MaseratiID = acc.ID;
                continue;
            }
            if (acc.name == Honda) {
                HondaID = acc.ID;
                continue;
            }
            if (acc.name == KiaMotors) {
                KiaMotorsID = acc.ID;
                continue;
            }
            if (acc.name == Hummer) {
                HummerID = acc.ID;
                continue;
            }
            if (acc.name == HyundaiMotorCompany) {
                HyundaiMotorCompanyID = acc.ID;
                continue;
            }
            if (acc.name == RollsRoyceMotorCars) {
                RollsRoyceMotorCarsID = acc.ID;
                continue;
            }
            if (acc.name == Suzuki) {
                SuzukiID = acc.ID;
                continue;
            }
            if (acc.name == AutomobileDacia) {
                AutomobileDaciaID = acc.ID;
                continue;
            }
            if (acc.name == DaimlerAG) {
                DaimlerAGID = acc.ID;
                continue;
            }
            if (acc.name == PorscheKFZ) {
                PorscheKFZID = acc.ID;
                continue;
            }
        }
    }

    public static Boolean isAudiAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AudiAGID;
    }

    public static Boolean isPorscheAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == PorscheAGID;
    }

    public static Boolean isTestFahrzeughersteller(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == TestFahrzeugherstellerID;
    }

    public static Boolean isSsangyongMotorsDeutschlandGmbH(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == SsangyongMotorsDeutschlandGmbHID;
    }

    public static Boolean isOpelAutomobileGmbH(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == OpelAutomobileGmbHID;
    }

    public static Boolean isBMWAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == BMWAGID;
    }

    public static Boolean isVolkswagenAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == VolkswagenAGID;
    }

    public static Boolean isFahrzeugherstellerTest(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == FahrzeugherstellerTestID;
    }

    public static Boolean isJaguarCars(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == JaguarCarsID;
    }

    public static Boolean isMitsubishiMotors(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == MitsubishiMotorsID;
    }

    public static Boolean isPeugeot(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == PeugeotID;
    }

    public static Boolean isLancia(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LanciaID;
    }

    public static Boolean isVolvo(ID accountID) {
        System.debug('isVolvo: ' + accountID);
        if (accountID == null) {
            return false;
        }
        System.debug('VolvoID: ' + VolvoID);
        return accountID == VolvoID;
    }

    public static Boolean isChevrolet(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ChevroletID;
    }

    public static Boolean isSubaru(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == SubaruID;
    }

    public static Boolean isLandRover(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LandRoverID;
    }

    public static Boolean isLexus(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LexusID;
    }

    public static Boolean isLotusCars(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == LotusCarsID;
    }

    public static Boolean isNissan(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == NissanID;
    }

    public static Boolean isFordWerkeGmbH(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == FordWerkeGmbHID;
    }

    public static Boolean isDodge(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == DodgeID;
    }

    public static Boolean isFiatSpA(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == FiatSpAID;
    }

    public static Boolean isAlfaRomeo(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AlfaRomeoID;
    }

    public static Boolean isAstonMartin(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AstonMartinID;
    }

    public static Boolean isMini(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == MiniID;
    }

    public static Boolean isRenaultDeutschlandAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == RenaultDeutschlandAGID;
    }

    public static Boolean isMazda(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == MazdaID;
    }

    public static Boolean isCitroen(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == CitroenID;
    }

    public static Boolean isSmart(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == SmartID;
    }

    public static Boolean isToyota(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ToyotaID;
    }

    public static Boolean isChrysler(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == ChryslerID;
    }

    public static Boolean isMaybachMotorenbau(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == MaybachMotorenbauID;
    }

    public static Boolean isMaserati(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == MaseratiID;
    }

    public static Boolean isHonda(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == HondaID;
    }

    public static Boolean isKiaMotors(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == KiaMotorsID;
    }

    public static Boolean isHummer(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == HummerID;
    }

    public static Boolean isHyundaiMotorCompany(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == HyundaiMotorCompanyID;
    }

    public static Boolean isRollsRoyceMotorCars(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == RollsRoyceMotorCarsID;
    }

    public static Boolean isSuzuki(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == SuzukiID;
    }

    public static Boolean isAutomobileDacia(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == AutomobileDaciaID;
    }

    public static Boolean isDaimlerAG(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == DaimlerAGID;
    }

    public static Boolean isPorscheKFZ(ID accountID) {
        if (accountID == null) {
            return false;
        }
        return accountID == PorscheKFZID;
    }
}