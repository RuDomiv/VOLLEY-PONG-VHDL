LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY PAINT_OBJECT IS
    PORT (
        Xi      : IN  uint11;
        Yi      : IN  uint11;      
        Xf      : IN  uint11;      
        Yf      : IN  uint11;   
        PosX    : IN  uint11;
        PosY    : IN  uint11;
        SEL     : OUT uint03 -- Señal de selección
    );
END ENTITY PAINT_OBJECT;

ARCHITECTURE Behavioral OF PAINT_OBJECT IS
BEGIN
    PROCESS (PosX, PosY, Xi, Yi, Xf, Yf)
    BEGIN
        -- Verificar si la posición actual está dentro del área
        IF (PosX >= Xi) AND (PosX <= Xf) AND 
           (PosY >= Yi) AND (PosY <= Yf) THEN
            SEL <= "001"; 
        ELSE
            SEL <= "111"; -- VERDE (Valor por defecto)
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;
