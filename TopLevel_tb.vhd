LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;

-- Declaración del testbench
ENTITY tb_ImageSync IS
END ENTITY tb_ImageSync;

ARCHITECTURE behavior OF tb_ImageSync IS

    -- Component declaration para el DUT (Device Under Test)
    COMPONENT ImageSync
        PORT (
            Reset   : IN  STD_LOGIC;
            SyncClk : IN  STD_LOGIC;
            HSync   : OUT uint01;
            VSync   : OUT uint01;
            VideoOn : OUT uint01;
            PixelX  : OUT uint11;
            PixelY  : OUT uint11
        );
    END COMPONENT;

    -- Señales internas del testbench
    SIGNAL Reset   : uint01 := '1';
    SIGNAL SyncClk : uint01 := '0';
    SIGNAL HSync   : uint01;
    SIGNAL VSync   : uint01;
    SIGNAL VideoOn : uint01;
    SIGNAL PixelX  : uint11;
    SIGNAL PixelY  : uint11;

BEGIN

    -- Instancia del DUT
    uut: ImageSync PORT MAP (
        Reset   => Reset,
        SyncClk => SyncClk,
        HSync   => HSync,
        VSync   => VSync,
        VideoOn => VideoOn,
        PixelX  => PixelX,
        PixelY  => PixelY
    );

    Reset <= '0' AFTER 20 ns;
	 
	 SyncClk <= NOT SyncClk AFTER 10 ns;

END ARCHITECTURE behavior;