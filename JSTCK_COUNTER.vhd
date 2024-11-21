--obsoleto no me mires porfa xd


LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY JSTCK_COUNTER IS
    GENERIC (Nbits : INTEGER := 23); -- 23 por cinco millones 
    PORT (
        Clk       : IN STD_LOGIC;
        MR        : IN STD_LOGIC;  
        SR        : IN STD_LOGIC;  
        Ena       : IN STD_LOGIC;  
        JST		   : IN STD_LOGIC;
		  Limit     : IN STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0);
		  MaxCount  : OUT STD_LOGIC;
		  Count     : OUT STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0)
			);
END ENTITY;

ARCHITECTURE rtl OF JSTCK_COUNTER IS
    CONSTANT ZEROS : UNSIGNED(Nbits-1 DOWNTO 0) := (OTHERS => '0');
	 
    SIGNAL count_s    : UNSIGNED(Nbits-1 DOWNTO 0);
    SIGNAL count_next : UNSIGNED(Nbits-1 DOWNTO 0);
	 SIGNAL MaxCount_s : STD_LOGIC;
	 

BEGIN
	-- LIMIT DEBE LLEGAR A "4C4B40" QUE ES 5.000.000 para que maxcount bla bla
	 
    count_next <= (OTHERS => '0') WHEN SR = '1' ELSE
                  count_s + 1     WHEN (Ena = '1' AND JST  = '1' AND maxCount_s  = '1') ELSE
                  count_s;

   PROCESS(Clk, MR)
    BEGIN
        IF (MR = '1') THEN
            count_s <= ZEROS;
        ELSIF rising_edge(Clk) THEN
            IF (Ena = '1') THEN
                count_s <= count_next;
            END IF;
        END IF;
    END PROCESS;

    Count <= STD_LOGIC_VECTOR(count_s);
    maxCount_s <= '1' WHEN count_s = UNSIGNED(Limit) ELSE '0';
    MaxCount   <= maxCount_s;

END ARCHITECTURE;