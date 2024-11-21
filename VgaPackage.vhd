LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
 
PACKAGE VgaPackage IS
    
    TYPE ColorT IS RECORD
        R : uint08;
        G : uint08;
        B : uint08;
    END RECORD ColorT;
 
    TYPE VgaCtrlT IS RECORD
        Clk     : uint01;
        Blank   : uint01;
        Sync    : uint01;
        Hsync   : uint01;
        Vsync   : uint01;
    END RECORD VgaCtrlT;
 
    TYPE SvgaDataT IS RECORD
        Display : INTEGER;
        FrontP  : INTEGER;
        Retrace : INTEGER;
        BackP   : INTEGER;
    END RECORD SvgaDataT;
 
    CONSTANT HData : SvgaDataT := (Display => 799 , FrontP => 16, Retrace => 80, BackP => 160);
    CONSTANT VData : SvgaDataT := (Display => 599, FrontP => 1, Retrace => 2, BackP => 21);
 
    TYPE TimeStampT IS RECORD
        Display    : uint11;
        FrontPorch : uint11;
        Retrace    : uint11;
        FullScan   : uint11;
    END RECORD TimeStampT;
 
    CONSTANT HTime : TimeStampT := (Display    => (Int2slv((HData.Display), 11)),
                                    FrontPorch => (Int2slv((HData.Display + HData.FrontP), 11)),
                                    Retrace    => (Int2slv((HData.Display + HData.FrontP + HData.Retrace), 11)),
                                    FullScan   => (Int2slv((HData.Display + 
                                                           HData.FrontP + 
                                                           HData.Retrace + 
                                                           HData.BackP), 11)));
 
    CONSTANT VTime : TimeStampT := (Display    => (Int2slv((VData.Display), 11)),
                                    FrontPorch => (Int2slv((VData.Display + VData.FrontP), 11)),
                                    Retrace    => (Int2slv((VData.Display + VData.FrontP + VData.Retrace), 11)),
                                    FullScan   => (Int2slv((VData.Display + 
                                                           VData.FrontP + 
                                                           VData.Retrace + 
                                                           VData.BackP), 11)));

CONSTANT Peru  : ColorT := (R => x"CD", G => x"85", B => x"3F");
CONSTANT Black : ColorT := (R => x"00", G => x"00", B => x"00");
CONSTANT Green : ColorT := (R => x"B7", G => x"E8", B => x"92");

END PACKAGE VgaPackage;
 
PACKAGE BODY VgaPackage IS
    
END PACKAGE BODY;