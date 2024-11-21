LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;
USE WORK.ImagePackage.ALL;

-- ENTIDAD PRINCIPAL QUE CONECTA PAINT_OBJECT Y LOS MULTIPLEXORES
ENTITY ColorControl IS
    PORT (
		  Score1Index    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Score2Index    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        POSITION       : IN ObjectT;
        PosX, PosY     : IN uint11;
        VideoON        : IN std_logic;
        RGB            : OUT ColorT -- Salidas RGB finales
    );
END ENTITY ColorControl;

ARCHITECTURE Behavioral OF ColorControl IS
    -- Señal interna para la selección del color
    SIGNAL SEL 					: std_logic; 
	 SIGNAL Imagen   			   : ColorT;
	 SIGNAL Ball	  			   : ColorT;
	 SIGNAL Paddle1				: ColorT;
	 SIGNAL Paddle2				: ColorT;
	 SIGNAL Net						: ColorT;
	 SIGNAL Separator				: ColorT;
	 SIGNAL Separator2			: ColorT;
	 SIGNAL Score1					: ColorT;
	 SIGNAL Score2					: ColorT;
	 SIGNAL BackgroundBar1		: ColorT;
	 SIGNAL BackgroundBar2		: ColorT;
	 SIGNAL BackgroundRed		: ColorT;
	 SIGNAL BackgroundBlue		: ColorT;
	 SIGNAL Num0					: ColorT;
	 SIGNAL Num1					: ColorT;
	 SIGNAL Num2					: ColorT;
	 SIGNAL Num3					: ColorT;
	 SIGNAL Num4					: ColorT;
	 SIGNAL Num5					: ColorT;
	 SIGNAL Num6					: ColorT;
	 SIGNAL Num7					: ColorT;
	 SIGNAL Num0P2					: ColorT;
	 SIGNAL Num1P2					: ColorT;
	 SIGNAL Num2P2					: ColorT;
	 SIGNAL Num3P2					: ColorT;
	 SIGNAL Num4P2					: ColorT;
	 SIGNAL Num5P2					: ColorT;
	 SIGNAL Num6P2					: ColorT;
	 SIGNAL Num7P2					: ColorT;
	 SIGNAL P1wins					: ColorT;
	 SIGNAL P2wins					: ColorT;
	 
BEGIN

    -- Configuración de RGB según el valor de SEL
    WITH VideoOn SELECT
	 RGB <= Imagen WHEN '1',
	        Black  WHEN OTHERS;
			  
	 Imagen <= 	Ball 				WHEN (IsWithinObject(POSITION.Ball, PosX, PosY) = '1')    		 		ELSE
					Paddle1 			WHEN (IsWithinObject(POSITION.Paddle1, PosX, PosY) = '1') 		 		ELSE
					Paddle2 			WHEN (IsWithinObject(POSITION.Paddle2, PosX, PosY) = '1') 		 		ELSE
					Net	 			WHEN (IsWithinObject(POSITION.Net, PosX, PosY) = '1')     		 		ELSE
					Separator	 	WHEN (IsWithinObject(POSITION.Separator, PosX, PosY) = '1')     		ELSE
					Separator2	 	WHEN (IsWithinObject(POSITION.Separator2, PosX, PosY) = '1')    		ELSE
					Score1		 	WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1')     			ELSE
					Score2		 	WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1')    			ELSE
					BackgroundRed  WHEN (IsWithinObject(POSITION.BackgroundRed, PosX, PosY) = '1')    	ELSE
					BackgroundBlue WHEN (IsWithinObject(POSITION.BackgroundBlue, PosX, PosY) = '1')    	ELSE
					BackgroundBar1 WHEN (IsWithinObject(POSITION.BackgroundBar1, PosX, PosY) = '1')    	ELSE
					BackgroundBar2 WHEN (IsWithinObject(POSITION.BackgroundBar2, PosX, PosY) = '1')    	ELSE
					P1wins 			WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1')    			ELSE
					P2wins 			WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1')    			ELSE
					Green;
				
			
	  WITH Score1Index SELECT
	  Score1		<= Num0    WHEN "000", -- 0
						Num1    WHEN "001", -- 1
						Num2    WHEN "010", -- 1
						Num3    WHEN "011", -- 2
					   Num4    WHEN "100", -- 3
						Num5    WHEN "101", -- 4
						Num6    WHEN "110", -- 5
						Num7    WHEN "111", -- 6
					   Ball	  WHEN OTHERS;  -- F
						
	  WITH Score2Index SELECT
	  Score2		<= Num0P2    WHEN "000", -- 0
						Num1P2    WHEN "001", -- 1
						Num2P2    WHEN "010", -- 1
						Num3P2    WHEN "011", -- 2
					   Num4P2    WHEN "100", -- 3
						Num5P2    WHEN "101", -- 4
						Num6P2    WHEN "110", -- 5
						Num7P2    WHEN "111", -- 6
					   Ball	  WHEN OTHERS;  -- F




		-- pepa
		Ball.R <= pokeR(Slv2Int(PosY)-Slv2Int(POSITION.Ball.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Ball.Xi)) WHEN (IsWithinObject(POSITION.Ball, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Ball.G <= pokeG(Slv2Int(PosY)-Slv2Int(POSITION.Ball.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Ball.Xi)) WHEN (IsWithinObject(POSITION.Ball, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Ball.B <= pokeB(Slv2Int(PosY)-Slv2Int(POSITION.Ball.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Ball.Xi)) WHEN (IsWithinObject(POSITION.Ball, PosX, PosY) = '1') ELSE
					Peru.B;
					
					
		-- paddle1		
		Paddle1.R <= player1R(Slv2Int(PosY)-Slv2Int(POSITION.Paddle1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle1.Xi)) WHEN (IsWithinObject(POSITION.Paddle1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Paddle1.G <= player1G(Slv2Int(PosY)-Slv2Int(POSITION.Paddle1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle1.Xi)) WHEN (IsWithinObject(POSITION.Paddle1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Paddle1.B <= player1B(Slv2Int(PosY)-Slv2Int(POSITION.Paddle1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle1.Xi)) WHEN (IsWithinObject(POSITION.Paddle1, PosX, PosY) = '1') ELSE
					Peru.B;
					
		
		-- paddle1 CAMBIAR A AZUL
		Paddle2.R <= Player2R(Slv2Int(PosY)-Slv2Int(POSITION.Paddle2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle2.Xi)) WHEN (IsWithinObject(POSITION.Paddle2, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Paddle2.G <= Player2G(Slv2Int(PosY)-Slv2Int(POSITION.Paddle2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle2.Xi)) WHEN (IsWithinObject(POSITION.Paddle2, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Paddle2.B <= Player2B(Slv2Int(PosY)-Slv2Int(POSITION.Paddle2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Paddle2.Xi)) WHEN (IsWithinObject(POSITION.Paddle2, PosX, PosY) = '1') ELSE
					Peru.B;
		

		-- Net CAMBIAR A AZUL
		Net.R <= NetR(Slv2Int(PosY)-Slv2Int(POSITION.Net.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Net.Xi)) WHEN (IsWithinObject(POSITION.Net, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Net.G <= NetG(Slv2Int(PosY)-Slv2Int(POSITION.Net.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Net.Xi)) WHEN (IsWithinObject(POSITION.Net, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Net.B <= NetB(Slv2Int(PosY)-Slv2Int(POSITION.Net.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Net.Xi)) WHEN (IsWithinObject(POSITION.Net, PosX, PosY) = '1') ELSE
					Peru.B;
					
					
		-- Separator
		Separator.R <= SeparatorR(Slv2Int(PosY)-Slv2Int(POSITION.Separator.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator.Xi)) WHEN (IsWithinObject(POSITION.Separator, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Separator.G <= SeparatorG(Slv2Int(PosY)-Slv2Int(POSITION.Separator.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator.Xi)) WHEN (IsWithinObject(POSITION.Separator, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Separator.B <= SeparatorB(Slv2Int(PosY)-Slv2Int(POSITION.Separator.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator.Xi)) WHEN (IsWithinObject(POSITION.Separator, PosX, PosY) = '1') ELSE
					Peru.B;
					
		-------------------
		
		Separator2.R <= SeparatorR(Slv2Int(PosY)-Slv2Int(POSITION.Separator2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator2.Xi)) WHEN (IsWithinObject(POSITION.Separator2, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Separator2.G <= SeparatorG(Slv2Int(PosY)-Slv2Int(POSITION.Separator2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator2.Xi)) WHEN (IsWithinObject(POSITION.Separator2, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Separator2.B <= SeparatorB(Slv2Int(PosY)-Slv2Int(POSITION.Separator2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Separator2.Xi)) WHEN (IsWithinObject(POSITION.Separator2, PosX, PosY) = '1') ELSE
					Peru.B;
		
					
		--Bars
		BackgroundBar1.R <= BACKGROUNDBAR_R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar1.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		BackgroundBar1.G <= BACKGROUNDBAR_G(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar1.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		BackgroundBar1.B <= BACKGROUNDBAR_B(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar1.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar1, PosX, PosY) = '1') ELSE
					Peru.B;
					
		--------------------
		
		BackgroundBar2.R <= BACKGROUNDBAR_R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar2.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar2, PosX, PosY) = '1') ELSE
					Peru.R;
					
		BackgroundBar2.G <= BACKGROUNDBAR_R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar2.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar2, PosX, PosY) = '1') ELSE
					Peru.G;
					
		BackgroundBar2.B <= BACKGROUNDBAR_R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBar2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBar2.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBar2, PosX, PosY) = '1') ELSE
					Peru.B;

					
		--BoostRed
		BackgroundRed.R <= CARGA_P2R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundRed.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundRed.Xi)) WHEN (IsWithinObject(POSITION.BackgroundRed, PosX, PosY) = '1') ELSE
					Peru.R;
					
		BackgroundRed.G <= CARGA_P2G(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundRed.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundRed.Xi)) WHEN (IsWithinObject(POSITION.BackgroundRed, PosX, PosY) = '1') ELSE
					Peru.G;
					
		BackgroundRed.B <= CARGA_P2B(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundRed.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundRed.Xi)) WHEN (IsWithinObject(POSITION.BackgroundRed, PosX, PosY) = '1') ELSE
					Peru.B;
					
					
		--BoostBlue
		BackgroundBlue.R <= CARGA_P1R(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBlue.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBlue.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBlue, PosX, PosY) = '1') ELSE
					Peru.R;
					
		BackgroundBlue.G <= CARGA_P1G(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBlue.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBlue.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBlue, PosX, PosY) = '1') ELSE
					Peru.G;
					
		BackgroundBlue.B <= CARGA_P1B(Slv2Int(PosY)-Slv2Int(POSITION.BackgroundBlue.Yi), Slv2Int(PosX)-Slv2Int(POSITION.BackgroundBlue.Xi)) WHEN (IsWithinObject(POSITION.BackgroundBlue, PosX, PosY) = '1') ELSE
					Peru.B;
					
		--P1&P2_WINS REAL, DESCOMENTAR LUEGO
		P1wins.R <= P1winsR(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
					Peru.R;
					
		P1wins.G <= P1winsG(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
					Peru.G;
					
		P1wins.B <= P1winsB(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
					Peru.B;
					
						
		P2wins.R <= P2winsR(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
					Peru.R;
					
		P2wins.G <= P2winsG(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
					Peru.G;
					
		P2wins.B <= P2winsB(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
					Peru.B;
					
		--P1&P2_WINS
--		P1wins.R <=  pokeR(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
--					Peru.R;
--					
--		P1wins.G <=  pokeG(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
--					Peru.R;
--					
--		P1wins.B <=  pokeB(Slv2Int(PosY)-Slv2Int(POSITION.P1wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P1wins.Xi)) WHEN (IsWithinObject(POSITION.P1wins, PosX, PosY) = '1') ELSE
--					Peru.R;
--					
--						
--		P2wins.R <=  pokeR(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
--					Peru.R;
--					
--		P2wins.G <=  pokeG(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
--					Peru.R;
--					
--		P2wins.B <=  pokeB(Slv2Int(PosY)-Slv2Int(POSITION.P2wins.Yi), Slv2Int(PosX)-Slv2Int(POSITION.P2wins.Xi)) WHEN (IsWithinObject(POSITION.P2wins, PosX, PosY) = '1') ELSE
--					Peru.R;

	   --Numbers
		Num0.R <= R0(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num0.G <= G0(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num0.B <= B0(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;
					
					
					
		Num1.R <= R1(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num1.G <= G1(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num1.B <= B1(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;


		Num2.R <= R2(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num2.G <= G2(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num2.B <= B2(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;		
					
					
		Num3.R <= R3(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num3.G <= G3(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num3.B <= B3(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;
								
					
		Num4.R <= R4(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num4.G <= G4(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num4.B <= B4(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;
								
					
		Num5.R <= R5(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num5.G <= G5(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num5.B <= B5(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;
								
								
		Num6.R <= R6(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num6.G <= G6(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num6.B <= B6(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;
					
					
		Num7.R <= R7(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.R;
					
		Num7.G <= G7(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.G;
					
		Num7.B <= B7(Slv2Int(PosY)-Slv2Int(POSITION.Score1.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score1.Xi)) WHEN (IsWithinObject(POSITION.Score1, PosX, PosY) = '1') ELSE
					Peru.B;					
---------------------------------------------------------------

    Num0P2.R <= R0(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num0P2.G <= G0(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num0P2.B <= B0(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
                
                
                
    Num1P2.R <= R1(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num1P2.G <= G1(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num1P2.B <= B1(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;


    Num2P2.R <= R2(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num2P2.G <= G2(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num2P2.B <= B2(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;       
                
                
    Num3P2.R <= R3(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num3P2.G <= G3(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num3P2.B <= B3(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
                            
                
    Num4P2.R <= R4(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num4P2.G <= G4(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num4P2.B <= B4(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
                            
                
    Num5P2.R <= R5(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num5P2.G <= G5(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num5P2.B <= B5(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
                            
                            
    Num6P2.R <= R6(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num6P2.G <= G6(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num6P2.B <= B6(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
                
                
    Num7P2.R <= R7(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.R;
                
    Num7P2.G <= G7(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.G;
                
    Num7P2.B <= B7(Slv2Int(PosY)-Slv2Int(POSITION.Score2.Yi), Slv2Int(PosX)-Slv2Int(POSITION.Score2.Xi)) WHEN (IsWithinObject(POSITION.Score2, PosX, PosY) = '1') ELSE
                Peru.B;
				
					
			
END ARCHITECTURE Behavioral;