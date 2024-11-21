-- INÚTIL

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Bin2_7dec is
    Port ( 
        bin_input    : in  STD_LOGIC_VECTOR (4 downto 0);
        dec_decenas  : out STD_LOGIC_VECTOR (4 downto 0);
        dec_unidades : out STD_LOGIC_VECTOR (4 downto 0)
    );
end Bin2_7dec;

architecture Behavioral of Bin2_7dec is
    signal temp_value  : STD_LOGIC_VECTOR (4 downto 0);
    signal decenas     : STD_LOGIC_VECTOR (4 downto 0) := (others => '0');
    signal unidades    : STD_LOGIC_VECTOR (4 downto 0);
    constant BIN_10    : STD_LOGIC_VECTOR (4 downto 0) := "01010"; -- Valor binario de 10
    constant BIN_20    : STD_LOGIC_VECTOR (4 downto 0) := "10100"; -- Valor binario de 20
    constant BIN_30    : STD_LOGIC_VECTOR (4 downto 0) := "11110"; -- Valor binario de 30
begin

process(bin_input)
begin
    -- Inicializar las señales
    temp_value <= bin_input;
    decenas <= "00000";

    -- Evaluar el número de decenas
    if bin_input >= BIN_30 then
        temp_value <= bin_input - BIN_30;
        decenas <= "00011"; -- 3 decenas
    elsif bin_input >= BIN_20 then
        temp_value <= bin_input - BIN_20;
        decenas <= "00010"; -- 2 decenas
    elsif bin_input >= BIN_10 then
        temp_value <= bin_input - BIN_10;
        decenas <= "00001"; -- 1 decena
    else
        temp_value <= bin_input;
        decenas <= "00000"; -- 0 decenas
    end if;

    -- Asegurar que las unidades están correctamente calculadas
    if temp_value >= BIN_10 then
        unidades <= temp_value - BIN_10;
    else
        unidades <= temp_value;
    end if;

    -- Asignar salidas
    dec_decenas <= decenas;
    dec_unidades <= unidades;
end process;

end Behavioral;