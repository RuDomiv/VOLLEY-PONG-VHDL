LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;

ENTITY ScoreLogic IS
    PORT (
        Clk		        : IN   uint01;  
        Reset          : IN   uint01;  
        Player1_Scored : IN   uint01; 
        Player2_Scored : IN   uint01;   
        P1wins		     : OUT  uint01;
        P2wins    	  : OUT  uint01;
        Score1Index    : OUT  uint03;
        Score2Index    : OUT  uint03
    );
END ENTITY ScoreLogic;

ARCHITECTURE Behavioral OF ScoreLogic IS
    SIGNAL Score1, Score2 							 : uint03;
    SIGNAL Sel1, Sel2 								 : uint01;
    SIGNAL NextScorePlayer1, NextScorePlayer2 : uint03;
	 SIGNAL MaxCountP1, MaxCountP2				 : uint01;
	 
    -- Señales para manejar pulsos únicos
    SIGNAL Prev_Player1_Scored, Prev_Player2_Scored : uint01;
    SIGNAL Pulse_Player1, Pulse_Player2 				 : uint01;

BEGIN

    -- Generar pulso único para Player1_Scored
    PROCESS(Clk, Reset)
    BEGIN
        IF Reset = '1' THEN
            Prev_Player1_Scored <= '0';
            Pulse_Player1 <= '0';
        ELSIF rising_edge(Clk) THEN
            IF (Player1_Scored = '1' AND Prev_Player1_Scored = '0') THEN
                Pulse_Player1 <= '1';
            ELSE
                Pulse_Player1 <= '0';
            END IF;
            Prev_Player1_Scored <= Player1_Scored;
        END IF;
    END PROCESS;

    -- Generar pulso único para Player2_Scored
    PROCESS(Clk, Reset)
    BEGIN
        IF Reset = '1' THEN
            Prev_Player2_Scored <= '0';
            Pulse_Player2 <= '0';
        ELSIF rising_edge(Clk) THEN
            IF (Player2_Scored = '1' AND Prev_Player2_Scored = '0') THEN
                Pulse_Player2 <= '1';
            ELSE
                Pulse_Player2 <= '0';
            END IF;
            Prev_Player2_Scored <= Player2_Scored;
        END IF;
    END PROCESS;

    -- Lógica de selección para incrementar el puntaje
    Sel1 <= '1' WHEN (Pulse_Player1 = '1') AND (Slv2Int(Score1) < 7) ELSE '0';
    Sel2 <= '1' WHEN (Pulse_Player2 = '1') AND (Slv2Int(Score2) < 7) ELSE '0';

    -- Lógica de cálculo de puntaje
    WITH Sel1 SELECT 
        NextScorePlayer1 <= Int2slv((Slv2Int(Score1)+1), 3) WHEN '1',
                              Score1                        WHEN OTHERS;

    WITH Sel2 SELECT 
        NextScorePlayer2 <= Int2slv((Slv2Int(Score2)+1), 3) WHEN '1',
                              Score2                        WHEN OTHERS;

    -- Registro para puntaje de Player 1
    PROCESS(Clk, Reset)
    BEGIN
        IF Reset = '1' THEN
            Score1 <= "000";
        ELSIF rising_edge(Clk) THEN
            Score1 <= NextScorePlayer1;
        END IF;
    END PROCESS;

    -- Registro para puntaje de Player 2
    PROCESS(Clk, Reset)
    BEGIN
        IF Reset = '1' THEN
            Score2 <= "000";
        ELSIF rising_edge(Clk) THEN
            Score2 <= NextScorePlayer2;
        END IF;
    END PROCESS;

    MaxCountP1 <= '1' WHEN (Slv2Int(Score1) = 7) ELSE '0';
    MaxCountP2 <= '1' WHEN (Slv2Int(Score2) = 7) ELSE '0';

    -- Salidas de puntaje
    Score1Index <= Score1;
    Score2Index <= Score2;

    -- Indicador de ganador
    P1wins <= MaxCountP1;
    P2wins <= MaxCountP2;

END ARCHITECTURE Behavioral;
