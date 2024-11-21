LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY BallControl IS
    PORT (
        Clk            : IN uint01;
        Reset          : IN uint01;
        Odd            : IN uint01;
        Paddle1_Pos    : IN PositionT;
        Paddle2_Pos    : IN PositionT;
        Separator1_Pos : IN PositionT;
        Separator2_Pos : IN PositionT;
        Net_Pos        : IN PositionT;
        P1BoostActive  : IN std_logic; -- Señal de boost activo para jugador 1
        P2BoostActive  : IN std_logic; -- Señal de boost activo para jugador 2
        Ball_Pos       : OUT PositionT;
        Player1Scored  : OUT uint01;
        Player2Scored  : OUT uint01;
        P1BoostUsed    : OUT std_logic; -- Señal de boost usado por jugador 1
        P2BoostUsed    : OUT std_logic  -- Señal de boost usado por jugador 2
    );
END ENTITY BallControl;

ARCHITECTURE Behavioral OF BallControl IS
    SIGNAL Ball_VelX : INTEGER;
    SIGNAL Ball_VelY : INTEGER;
    SIGNAL Odd_s     : uint01;

    SIGNAL BallCounter_MaxCount  : STD_LOGIC;
    SIGNAL BallCounter_Count     : STD_LOGIC_VECTOR(23 - 1 DOWNTO 0);

    CONSTANT Gravity             : INTEGER := 2;
    CONSTANT Restitution_Scaled  : INTEGER := 1000;
    CONSTANT MinBounceSpeed      : INTEGER := 3;
    CONSTANT Paddle_Width        : INTEGER := 100;
    CONSTANT Ball_Width          : INTEGER := 39;
    CONSTANT MaxHorizontalSpeed  : INTEGER := 5;
    CONSTANT ScaleFactor         : INTEGER := 1000;

    -- Factores de boost
    CONSTANT BoostMultiplier     : INTEGER := 1150; -- Aumenta la velocidad en un 15%
    CONSTANT BoostDivisor        : INTEGER := 1000;

    -- Señales internas para indicar si el boost ha sido usado
    SIGNAL P1BoostUsed_s : std_logic := '0';
    SIGNAL P2BoostUsed_s : std_logic := '0';

BEGIN
    BallCounter_inst : ENTITY WORK.GralLimCounter
    GENERIC MAP (Nbits => 23)
    PORT MAP (
        Clk       => Clk,
        MR        => Reset,
        SR        => '0',
        Ena       => '1',
        Up        => '1',
        Dwn       => '0',
        Limit     => Int2Slv(1000000, 23),
        MaxCount  => BallCounter_MaxCount,
        MinCount  => OPEN,
        Count     => BallCounter_Count
    );

    Odd_s <= Odd;

    PROCESS(Clk, Reset)
        VARIABLE Ball_Xi_int              : INTEGER;
        VARIABLE Ball_Yi_int              : INTEGER;
        VARIABLE Ball_Xf_int              : INTEGER;
        VARIABLE Ball_Yf_int              : INTEGER;
        VARIABLE Paddle1_Center           : INTEGER;
        VARIABLE Paddle2_Center           : INTEGER;
        VARIABLE Net_Center               : INTEGER;
        VARIABLE Net_Width                : INTEGER;
        VARIABLE ImpactPoint              : INTEGER;
        VARIABLE RelativeImpact_Scaled    : INTEGER;
    BEGIN
        IF Reset = '1' THEN
            Ball_Xi_int := 35;
            Ball_Yi_int := ScreenHeight / 2;
            Ball_VelX <= 0;
            Ball_VelY <= -15;
            P1BoostUsed_s <= '0';
            P2BoostUsed_s <= '0';
        ELSIF rising_edge(Clk) THEN
            IF BallCounter_MaxCount = '1' THEN
                Ball_VelY <= Ball_VelY + Gravity;
                Ball_Xi_int := Ball_Xi_int + Ball_VelX;
                Ball_Yi_int := Ball_Yi_int + Ball_VelY;
                Ball_Xf_int := Ball_Xi_int + Ball_Width;
                Ball_Yf_int := Ball_Yi_int + Ball_Width;

                -- Colisión con bordes izquierdo y derecho
                IF Ball_Xi_int <= 0 THEN
                    Ball_Xi_int := 0;
                    Ball_VelX <= -Ball_VelX;
                ELSIF Ball_Xf_int >= ScreenWidth THEN
                    Ball_Xi_int := ScreenWidth - Ball_Width;
                    Ball_VelX <= -Ball_VelX;
                END IF;

                -- Colisión con el suelo (punto para jugador 1)
                IF (Ball_Yf_int >= ScreenHeight AND Ball_Xi_int > Slv2Int(Net_Pos.Xf)) THEN
                    -- Restablecer posición inicial de la pelota
                    IF Odd_s = '1' THEN
                        Ball_Xi_int := ScreenWidth / 4; -- Posición inicial horizontal
                        Ball_Yi_int := ScreenHeight / 2; -- Posición inicial vertical
                        Player1Scored <= '1';
                    ELSIF Odd_s = '0' THEN
                        Ball_Xi_int := ScreenWidth - 200; -- Posición inicial horizontal
                        Ball_Yi_int := ScreenHeight / 2; -- Posición inicial vertical
                        Player1Scored <= '1';
                    END IF;

                    -- Restablecer velocidad inicial
                    Ball_VelX <= 0; -- Velocidad horizontal inicial
                    Ball_VelY <= -15; -- Velocidad vertical inicial
                ELSE
                    Player1Scored <= '0';
                END IF;

                -- Colisión con el suelo (punto para jugador 2)
                IF (Ball_Yf_int >= ScreenHeight AND Ball_Xf_int < Slv2Int(Net_Pos.Xi)) THEN
                    -- Restablecer posición inicial de la pelota
                    IF Odd_s = '1' THEN
                        Ball_Xi_int := ScreenWidth / 4; -- Posición inicial horizontal
                        Ball_Yi_int := ScreenHeight / 2; -- Posición inicial vertical
                        Player2Scored <= '1';
                    ELSIF Odd_s = '0' THEN
                        Ball_Xi_int := ScreenWidth - 200; -- Posición inicial horizontal
                        Ball_Yi_int := ScreenHeight / 2; -- Posición inicial vertical
                        Player2Scored <= '1';
                    END IF;

                    -- Restablecer velocidad inicial
                    Ball_VelX <= 0; -- Velocidad horizontal inicial
                    Ball_VelY <= -15; -- Velocidad vertical inicial
                ELSE
                    Player2Scored <= '0';
                END IF;

                -- Colisión con el techo (Separator1)
                IF Ball_Yi_int <= Slv2Int(Separator1_Pos.Yf) THEN
                    Ball_Yi_int := Slv2Int(Separator1_Pos.Yf);
                    Ball_VelY <= -((Ball_VelY * Restitution_Scaled) / ScaleFactor);
                    IF ABS(Ball_VelY) < MinBounceSpeed THEN
                        Ball_VelY <= MinBounceSpeed;
                    END IF;
                END IF;

                -- Colisión con Paddle1
                IF (Ball_Yf_int >= Slv2Int(Paddle1_Pos.Yi) AND Ball_Yi_int <= Slv2Int(Paddle1_Pos.Yf)) AND
                   (Ball_Xf_int >= Slv2Int(Paddle1_Pos.Xi) AND Ball_Xi_int <= Slv2Int(Paddle1_Pos.Xf)) THEN
                    Ball_Yi_int := Slv2Int(Paddle1_Pos.Yi) - Ball_Width;
                    IF P1BoostActive = '1' THEN
                        -- Aplicar boost
                        Ball_VelY <= -((Ball_VelY * Restitution_Scaled * BoostMultiplier) / (ScaleFactor * BoostDivisor));
                        P1BoostUsed_s <= '1';
                    ELSE
                        -- Comportamiento normal
                        Ball_VelY <= -((Ball_VelY * Restitution_Scaled) / ScaleFactor);
                        P1BoostUsed_s <= '0';
                    END IF;
                    IF ABS(Ball_VelY) < MinBounceSpeed THEN
                        Ball_VelY <= -MinBounceSpeed;
                    END IF;

                    Paddle1_Center := Slv2Int(Paddle1_Pos.Xi) + (Paddle_Width / 2);
                    ImpactPoint := (Ball_Xi_int + (Ball_Width / 2)) - Paddle1_Center;
                    RelativeImpact_Scaled := (ImpactPoint * ScaleFactor) / (Paddle_Width / 2);
                    IF RelativeImpact_Scaled > ScaleFactor THEN
                        RelativeImpact_Scaled := ScaleFactor;
                    ELSIF RelativeImpact_Scaled < -ScaleFactor THEN
                        RelativeImpact_Scaled := -ScaleFactor;
                    END IF;
                    Ball_VelX <= (RelativeImpact_Scaled * MaxHorizontalSpeed) / ScaleFactor;
                ELSE
                    P1BoostUsed_s <= '0';
                END IF;

                -- Colisión con Paddle2
                IF (Ball_Yf_int >= Slv2Int(Paddle2_Pos.Yi) AND Ball_Yi_int <= Slv2Int(Paddle2_Pos.Yf)) AND
                   (Ball_Xf_int >= Slv2Int(Paddle2_Pos.Xi) AND Ball_Xi_int <= Slv2Int(Paddle2_Pos.Xf)) THEN
                    Ball_Yi_int := Slv2Int(Paddle2_Pos.Yi) - Ball_Width;
                    IF P2BoostActive = '1' THEN
                        -- Aplicar boost
                        Ball_VelY <= -((Ball_VelY * Restitution_Scaled * BoostMultiplier) / (ScaleFactor * BoostDivisor));
                        P2BoostUsed_s <= '1';
                    ELSE
                        -- Comportamiento normal
                        Ball_VelY <= -((Ball_VelY * Restitution_Scaled) / ScaleFactor);
                        P2BoostUsed_s <= '0';
                    END IF;
                    IF ABS(Ball_VelY) < MinBounceSpeed THEN
                        Ball_VelY <= -MinBounceSpeed;
                    END IF;

                    Paddle2_Center := Slv2Int(Paddle2_Pos.Xi) + (Paddle_Width / 2);
                    ImpactPoint := (Ball_Xi_int + (Ball_Width / 2)) - Paddle2_Center;
                    RelativeImpact_Scaled := (ImpactPoint * ScaleFactor) / (Paddle_Width / 2);
                    IF RelativeImpact_Scaled > ScaleFactor THEN
                        RelativeImpact_Scaled := ScaleFactor;
                    ELSIF RelativeImpact_Scaled < -ScaleFactor THEN
                        RelativeImpact_Scaled := -ScaleFactor;
                    END IF;
                    Ball_VelX <= (RelativeImpact_Scaled * MaxHorizontalSpeed) / ScaleFactor;
                ELSE
                    P2BoostUsed_s <= '0';
                END IF;

                -- Colisión con la malla (Net)
                IF (Ball_Yf_int >= Slv2Int(Net_Pos.Yi) AND Ball_Yi_int <= Slv2Int(Net_Pos.Yf)) AND
                   (Ball_Xf_int >= Slv2Int(Net_Pos.Xi) AND Ball_Xi_int <= Slv2Int(Net_Pos.Xf)) THEN

                    -- Determinar si la colisión es con la parte superior o los lados
                    IF (Ball_Yf_int - Ball_VelY) <= Slv2Int(Net_Pos.Yi) THEN
                        -- Colisión con la parte superior de la malla

                        -- Ajuste de posición para evitar atascos
                        Ball_Yi_int := Slv2Int(Net_Pos.Yi) - Ball_Width - 1;

                        -- Invertir velocidad vertical
                        Ball_VelY <= -((Ball_VelY * Restitution_Scaled) / ScaleFactor);
                        IF ABS(Ball_VelY) < MinBounceSpeed THEN
                            Ball_VelY <= -MinBounceSpeed;
                        END IF;

                        -- Calcular punto de impacto relativo en la malla
                        Net_Center := Slv2Int(Net_Pos.Xi) + ((Slv2Int(Net_Pos.Xf) - Slv2Int(Net_Pos.Xi)) / 2);
                        Net_Width := Slv2Int(Net_Pos.Xf) - Slv2Int(Net_Pos.Xi);
                        ImpactPoint := (Ball_Xi_int + (Ball_Width / 2)) - Net_Center;
                        RelativeImpact_Scaled := (ImpactPoint * ScaleFactor) / (Net_Width / 2);
								
                        IF RelativeImpact_Scaled > ScaleFactor THEN
                            RelativeImpact_Scaled := ScaleFactor;
                        ELSIF RelativeImpact_Scaled < -ScaleFactor THEN
                            RelativeImpact_Scaled := -ScaleFactor;
                        END IF;

                        -- Ajustar velocidad horizontal basada en el punto de impacto
                        Ball_VelX <= Ball_VelX + (RelativeImpact_Scaled * MaxHorizontalSpeed) / ScaleFactor;

                    ELSE
                        -- Colisión con los lados de la malla

                        -- Invertimos la velocidad horizontal
                        Ball_VelX <= -Ball_VelX;

                        -- Ajustamos la posición para evitar que la pelota quede dentro de la malla
                        IF Ball_VelX > 0 THEN
                            -- La pelota se moverá hacia la derecha
                            Ball_Xi_int := Slv2Int(Net_Pos.Xi) - Ball_Width - 1;
                        ELSE
                            -- La pelota se moverá hacia la izquierda
                            Ball_Xi_int := Slv2Int(Net_Pos.Xf) + 1;
                        END IF;
                    END IF;

                    -- Recalcular posiciones finales
                    Ball_Xf_int := Ball_Xi_int + Ball_Width;
                    Ball_Yf_int := Ball_Yi_int + Ball_Width;
                END IF;

                -- Actualizar las posiciones finales
                Ball_Xf_int := Ball_Xi_int + Ball_Width;
                Ball_Yf_int := Ball_Yi_int + Ball_Width;

                -- Actualizar la señal de posición de la pelota
                Ball_Pos.Xi <= Int2Slv(Ball_Xi_int, 11);
                Ball_Pos.Yi <= Int2Slv(Ball_Yi_int, 11);
                Ball_Pos.Xf <= Int2Slv(Ball_Xf_int, 11);
                Ball_Pos.Yf <= Int2Slv(Ball_Yf_int, 11);

                -- Asignar las señales de salida de boost usado
                P1BoostUsed <= P1BoostUsed_s;
                P2BoostUsed <= P2BoostUsed_s;

            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE Behavioral;
