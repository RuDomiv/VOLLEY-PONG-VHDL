LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

PACKAGE BasicPackage IS
    -- Declaración de la función Int2slv
    PURE FUNCTION Int2slv (input : INTEGER; size : INTEGER) RETURN STD_LOGIC_VECTOR;
	 PURE FUNCTION Slv2int (input : STD_LOGIC_VECTOR) RETURN INTEGER;
	 -- Declaración del tipo ObjectT
    TYPE PositionT IS RECORD
		  Xi		: STD_LOGIC_VECTOR(10 DOWNTO 0);
		  Yi   	: STD_LOGIC_VECTOR(10 DOWNTO 0);
		  Xf		: STD_LOGIC_VECTOR(10 DOWNTO 0);
		  Yf   	: STD_LOGIC_VECTOR(10 DOWNTO 0);
    END RECORD PositionT;
	 
	 TYPE ObjectT IS RECORD
		  Ball  					:  PositionT;
		  Paddle1  				:  PositionT;
		  Paddle2  				:  PositionT;
		  Net						:  PositionT;
		  Separator				:  PositionT;
		  Separator2			:  PositionT;
		  Score1					:  PositionT;
		  Score2					:  PositionT;
		  BackgroundBar1		:  PositionT;
		  BackgroundBar2		:  PositionT;
		  BackgroundRed		:  PositionT;
		  BackgroundBlue		:  PositionT;
		  Num0					:  PositionT;
		  Num1					:  PositionT;
		  Num2					:  PositionT;
		  Num3					:  PositionT;
		  Num4					:  PositionT;
		  Num5					:  PositionT;
		  Num6					:  PositionT;
		  Num7					:  PositionT;
		  Num0P2					:  PositionT;
		  Num1P2					:  PositionT;
		  Num2P2					:  PositionT;
		  Num3P2					:  PositionT;
		  Num4P2					:  PositionT;
		  Num5P2					:  PositionT;
		  Num6P2					:  PositionT;
		  Num7P2					:  PositionT;
		  P1wins					:  PositionT;
		  P2wins					:  PositionT;
    END RECORD ObjectT;
	 
	 -- Definición de la función que retorna datos de tipo STD_LOGIC (booleano) según la entrada (Xi, Yi, Xf, Yf) y PosX y PosY
	 PURE FUNCTION IsWithinObject (input : PositionT; PosX : STD_LOGIC_VECTOR; PosY : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
	 --Preguntar si está bien la entrada y el tamaño, tanto como el retorno

    -- Definición de subtipos para vectores
    SUBTYPE uint01 IS STD_LOGIC;
    SUBTYPE uint02 IS STD_LOGIC_VECTOR(1 DOWNTO 0);
    SUBTYPE uint03 IS STD_LOGIC_VECTOR(2 DOWNTO 0);
    SUBTYPE uint04 IS STD_LOGIC_VECTOR(3 DOWNTO 0);
    SUBTYPE uint05 IS STD_LOGIC_VECTOR(4 DOWNTO 0);
    SUBTYPE uint06 IS STD_LOGIC_VECTOR(5 DOWNTO 0);
    SUBTYPE uint07 IS STD_LOGIC_VECTOR(6 DOWNTO 0);
    SUBTYPE uint08 IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    SUBTYPE uint09 IS STD_LOGIC_VECTOR(8 DOWNTO 0);
    SUBTYPE uint10 IS STD_LOGIC_VECTOR(9 DOWNTO 0);
    SUBTYPE uint11 IS STD_LOGIC_VECTOR(10 DOWNTO 0);
	 SUBTYPE uint26 IS STD_LOGIC_VECTOR(25 DOWNTO 0);
	 SUBTYPE uint27 IS STD_LOGIC_VECTOR(26 DOWNTO 0);
	 SUBTYPE uint28 IS STD_LOGIC_VECTOR(27 DOWNTO 0);
	 SUBTYPE uint32 IS STD_LOGIC_VECTOR(31 DOWNTO 0);


	 -- Parámetros de la pantalla
    CONSTANT ScreenWidth  : INTEGER := 800;
    CONSTANT ScreenHeight : INTEGER := 600;

END BasicPackage;

PACKAGE BODY BasicPackage IS

    -- Definición de la función Int2slv
    PURE FUNCTION Int2slv (input : INTEGER; size : INTEGER) RETURN STD_LOGIC_VECTOR IS
    BEGIN
        RETURN STD_LOGIC_VECTOR(TO_UNSIGNED(input, size));
    END Int2slv;
	 
	 -- Definición de la función Slv2int
	 PURE FUNCTION Slv2int (input : STD_LOGIC_VECTOR) RETURN INTEGER IS 
    BEGIN
        RETURN TO_INTEGER(UNSIGNED(input));
    END Slv2int;
	 
	 -- Definición de la función IsWithinObject
	 PURE FUNCTION IsWithinObject (input : PositionT; PosX : STD_LOGIC_VECTOR; PosY : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
    BEGIN
        -- Verificar si la posición actual está dentro del área
        IF  (((PosX >= input.Xi) AND (PosX <= input.Xf)) AND
             ((PosY >= input.Yi) AND (PosY <= input.Yf))) THEN
             return '1'; -- TRUE
        ELSE
             return '0'; -- FALSE
        END IF;
    END IsWithinObject;
	 
	 
END PACKAGE BODY;
