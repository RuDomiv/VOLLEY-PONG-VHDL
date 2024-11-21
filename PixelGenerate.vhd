--INUTILLLLLLLLLLLL

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY PixelGenerate IS
    PORT (
        ImageData : IN ObjectT;   -- Datos de la imagen con componentes R, G y B
        PosX      : IN uint11;      -- Coordenada X del píxel
        PosY      : IN uint11;      -- Coordenada Y del píxel
        VideoOn   : IN uint01;   -- Señal que indica si el video está activo
        RGB       : OUT ColorT      -- Salida con el color del píxel
    );
END ENTITY PixelGenerate;

ARCHITECTURE Behavioral OF PixelGenerate IS
BEGIN
    PROCESS (VideoOn) --PROCESS (ImageData, PosX, PosY, VideoOn)
    BEGIN
        IF VideoOn = '1' THEN
            -- Asignamos blanco puro a los componentes RGB
            RGB.R <= X"FF";  -- Máximo valor en rojo
            RGB.G <= X"FF";  -- Máximo valor en verde
            RGB.B <= X"FF";  -- Máximo valor en azul
        ELSE
            -- Si VideoOn está en '0', apagamos los colores
            RGB.R <= X"00";
            RGB.G <= X"00";
            RGB.B <= X"00";
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;