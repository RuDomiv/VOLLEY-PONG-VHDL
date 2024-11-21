LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY CounterPositions IS
    GENERIC (Nbits : INTEGER := 11); 
    PORT (
        Clk       : IN STD_LOGIC;
        MR        : IN STD_LOGIC;  
        SR        : IN STD_LOGIC;  
        Ena       : IN STD_LOGIC;  
        Up        : IN STD_LOGIC;  
        Dwn       : IN STD_LOGIC;
        Limit     : IN STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0); 
        MaxCount  : OUT STD_LOGIC;
        MinCount  : OUT STD_LOGIC;
        Count     : OUT STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0)
			);
END ENTITY;

ARCHITECTURE rtl OF CounterPositions IS
    CONSTANT ZEROS : UNSIGNED(Nbits-1 DOWNTO 0) := (OTHERS => '0');
	 
    SIGNAL count_s    : UNSIGNED(Nbits-1 DOWNTO 0);
    SIGNAL count_next : UNSIGNED(Nbits-1 DOWNTO 0);
    SIGNAL maxCount_s : STD_LOGIC;
    SIGNAL minCount_s : STD_LOGIC;
BEGIN

    -- Lógica para calcular el siguiente valor del contador
    count_next <= (OTHERS => '0') WHEN SR = '1' ELSE
                  count_s         WHEN (Ena = '1' AND maxCount_s = '1' AND Up  = '1') ELSE
                  count_s         WHEN (Ena = '1' AND minCount_s = '1' AND Dwn = '1') ELSE
                  count_s + 1     WHEN (Ena = '1' AND Up  = '1' 		  AND Dwn = '0') ELSE
                  count_s - 1     WHEN (Ena = '1' AND Dwn = '1' 		  AND Up = '0')  ELSE
                  count_s; -- Si Up y Dwn son ambos 0, el contador no cambia

    PROCESS(Clk, MR)
    BEGIN
        IF (MR = '1') THEN
            count_s <= ZEROS; -- Reset asíncrono
        ELSIF rising_edge(Clk) THEN
            IF (Ena = '1') THEN
                count_s <= count_next;
            END IF;
        END IF;
    END PROCESS;

    -- Asignación de señales de salida
    Count <= STD_LOGIC_VECTOR(count_s);
    maxCount_s <= '1' WHEN count_s = UNSIGNED(Limit) ELSE '0';
    MaxCount   <= maxCount_s;
    minCount_s <= '1' WHEN count_s = ZEROS ELSE '0';
    MinCount   <= minCount_s;

END ARCHITECTURE;