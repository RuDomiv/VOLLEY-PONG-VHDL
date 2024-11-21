LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY ImageSync IS
    PORT (
        Reset   : IN  STD_LOGIC;
        SyncClk : IN  STD_LOGIC;
        HSync   : OUT uint01;
        VSync   : OUT uint01;
        VideoOn : OUT uint01;
        PixelX  : OUT uint11;  -- Coordenada X del píxel
        PixelY  : OUT uint11   -- Coordenada Y del píxel
    );
END ENTITY ImageSync;

ARCHITECTURE MainArch OF ImageSync IS
    CONSTANT Zero : uint11 := (OTHERS => '0'); -- Asegurar que Zero sea de 11 bits
    
    SIGNAL VEnable : uint01;
    SIGNAL HCount  : uint11;  -- 11 bits
    SIGNAL VCount  : uint11;  -- 11 bits
    SIGNAL VideoVon : uint01;
    SIGNAL VideoHon : uint01;
    SIGNAL TmpVideoOn : uint01;
    SIGNAL TmpHS1 : uint01;
    SIGNAL TmpHS2 : uint01;
    SIGNAL TmpVS1 : uint01;
    SIGNAL TmpVS2 : uint01;
    
BEGIN

    -- Get the Video On signal
    TmpVideoOn <= VideoVon AND VideoHon;
    VideoOn <= TmpVideoOn;
    
    -- Asignaciones aseguradas
    VideoHon <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.Display)) ELSE '0';
    VideoVon <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.Display)) ELSE '0';
    
    -- Route PixelX and PixelY
    WITH TmpVideoOn SELECT
        PixelX <= HCount WHEN '1', 
		  Zero WHEN OTHERS;  
    
    WITH TmpVideoOn SELECT
        PixelY <= VCount WHEN '1', 
		  Zero WHEN OTHERS;  
    
    -- HSync and VSync logic
    TmpHS1 <= '1' WHEN (UNSIGNED(HCount) <= UNSIGNED(HTime.FrontPorch)) ELSE '0';
    TmpHS2 <= '1' WHEN (UNSIGNED(HCount) > UNSIGNED(HTime.Retrace)) ELSE '0';
    TmpVS1 <= '1' WHEN (UNSIGNED(VCount) <= UNSIGNED(VTime.FrontPorch)) ELSE '0';
    TmpVS2 <= '1' WHEN (UNSIGNED(VCount) > UNSIGNED(VTime.Retrace)) ELSE '0';
    
    HSync <= TmpHS1 OR TmpHS2;
    VSync <= TmpVS1 OR TmpVS2;
    
    -- Counters for timing
    HCounter: ENTITY WORK.GralLimCounter(rtl)
    GENERIC MAP (Nbits => 11)
    PORT MAP (
        Clk => SyncClk,
		  MR => Reset,
		  SR => '0',
		  Ena => '1', 
        Up => '1',
		  Dwn => '0',
		  Limit => HTime.FullScan, 
        MaxCount => VEnable, 
		  MinCount => OPEN,
		  Count => HCount
    );
    
    VCounter: ENTITY WORK.GralLimCounter(rtl)
    GENERIC MAP (Nbits => 11)
    PORT MAP (
        Clk => SyncClk,
		  MR => Reset,
		  SR => '0',
		  Ena => VEnable, 
        Up => '1',
		  Dwn => '0',
		  Limit => VTime.FullScan, 
        MaxCount => OPEN,
		  MinCount => OPEN,
		  Count => VCount
    );
    
END ARCHITECTURE;