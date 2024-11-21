LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY BoostCounter IS
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

ARCHITECTURE rtl OF BoostCounter IS
    CONSTANT ZEROS : UNSIGNED(Nbits-1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL count_s : UNSIGNED(Nbits-1 DOWNTO 0);
    SIGNAL count_next : UNSIGNED(Nbits-1 DOWNTO 0);
BEGIN

    count_next <= (OTHERS => '0') WHEN MR = '1' ELSE
                  (OTHERS => '0') WHEN SR = '1' ELSE
                  count_s + 1     WHEN (Ena = '1' AND Up = '1' AND count_s < UNSIGNED(Limit)) ELSE
                  count_s - 1     WHEN (Ena = '1' AND Up = '0' AND count_s > ZEROS)          ELSE
                  count_s;

    PROCESS(Clk)
    BEGIN
        IF rising_edge(Clk) THEN
            count_s <= count_next;
        END IF;
    END PROCESS;

    Count    <= STD_LOGIC_VECTOR(count_s);
    MaxCount <= '1' WHEN count_s = UNSIGNED(Limit) ELSE '0';
    MinCount <= '1' WHEN count_s = ZEROS ELSE '0';

END ARCHITECTURE;
