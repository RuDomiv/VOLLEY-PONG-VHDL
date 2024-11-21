LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.BasicPackage.ALL;
USE WORK.VgaPackage.ALL;

ENTITY TopLevel IS
    PORT (
        Reset          : IN  uint01;
        BoostButtonP1  : IN  uint01; -- Botón de boost para jugador 1
        BoostButtonP2  : IN  uint01; -- Botón de boost para jugador 2
        SyncClk        : IN  uint01;
        Right_jst      : IN  uint01;
        Left_jst       : IN  uint01;
        LeftP2_jst     : IN  uint01;
        RightP2_jst    : IN  uint01;
        RGB            : OUT ColorT;
        VgaCtrl        : OUT VgaCtrlT
    );
END ENTITY TopLevel;

ARCHITECTURE Behavioral OF TopLevel IS
    -- Señales para la sincronización de video
    SIGNAL VideoOn     : uint01;
    SIGNAL PixelX      : uint11;
    SIGNAL PixelY      : uint11;
    SIGNAL ImageData   : ObjectT;

    -- Señal para las posiciones de los objetos
    SIGNAL POSITION    : ObjectT;

    -- Señales para los controles de los paddles
    SIGNAL Real_Right  : uint01;
    SIGNAL Real_Left   : uint01;
    SIGNAL Real_Right2 : uint01;
    SIGNAL Real_Left2  : uint01;
    SIGNAL MaxCount_s  : uint01;

    -- Señales para los contadores de posición
    SIGNAL Paddle2_xi  : uint11;
    SIGNAL Net_yi      : uint11;

    -- Señales para la pelota
    SIGNAL Ball_Pos    : PositionT;

    -- OTROS
    SIGNAL Player1Scored  : uint01;
    SIGNAL Player2Scored  : uint01;
    SIGNAL P1wins_s       : uint01;
    SIGNAL P2wins_s       : uint01;
    SIGNAL Score1Index    : uint03;
    SIGNAL Score2Index    : uint03;
    SIGNAL OddFlag_s      : uint01;

    -- Boost Signals
    SIGNAL P1BoostMaxCount_s    : uint01;
    SIGNAL P2BoostMaxCount_s    : uint01;

    SIGNAL P1BoostLevel         : uint32;
    SIGNAL P2BoostLevel         : uint32;

    -- Señales para indicar si el boost está activo
    SIGNAL P1BoostActive        : std_logic := '0';
    SIGNAL P2BoostActive        : std_logic := '0';
    SIGNAL P1BoostUsed          : std_logic;
    SIGNAL P2BoostUsed          : std_logic;

    -- Señales para detección de flancos
    SIGNAL Prev_P1BoostUsed     : std_logic := '0';
    SIGNAL Prev_P2BoostUsed     : std_logic := '0';
    SIGNAL Prev_BoostButtonP1   : std_logic := '0';
    SIGNAL Prev_BoostButtonP2   : std_logic := '0';

    -- Señales para reiniciar el contador de boost
    SIGNAL P1BoostCounterReset  : std_logic := '0';
    SIGNAL P2BoostCounterReset  : std_logic := '0';

BEGIN
    -- Asignación de señales de control VGA
    VgaCtrl.Clk   <= SyncClk;
    VgaCtrl.Blank <= '1';
    VgaCtrl.Sync  <= '0';

    -- Señales de movimiento real de los paddles
    Real_Right   <= Right_jst AND MaxCount_s;
    Real_Left    <= Left_jst AND MaxCount_s;
    Real_Right2  <= LeftP2_jst AND MaxCount_s;
    Real_Left2   <= RightP2_jst AND MaxCount_s;

    -- Instancia de ImageSync
    ImageSync_inst : ENTITY WORK.ImageSync
    PORT MAP (
        Reset   => Reset,
        SyncClk => SyncClk,
        HSync   => VgaCtrl.HSync,
        VSync   => VgaCtrl.VSync,
        VideoOn => VideoOn,
        PixelX  => PixelX,
        PixelY  => PixelY
    );

    -- Puntajes
    ScoreLogic_P1andP2 : ENTITY WORK.ScoreLogic
    PORT MAP (
        Clk            => SyncClk,
        Reset          => Reset,
        Player1_Scored => Player1Scored,
        Player2_Scored => Player2Scored,
        P1wins         => P1wins_s,
        P2wins         => P2wins_s,
        Score1Index    => Score1Index,
        Score2Index    => Score2Index
    );

    -- Instancia de ColorControl
    ColorControl_inst : ENTITY WORK.ColorControl
    PORT MAP (
        Score1Index => Score1Index,
        Score2Index => Score2Index,
        POSITION    => POSITION,
        PosX        => PixelX,
        PosY        => PixelY,
        VideoON     => VideoOn,
        RGB         => RGB
    );

    -- Contador general para la velocidad de movimiento de los paddles
    JSTCK_COUNTER_inst : ENTITY WORK.GralLimCounter
    GENERIC MAP (Nbits => 23)
    PORT MAP (
        Clk      => SyncClk,
        MR       => Reset,
        SR       => '0',
        Ena      => '1',
        Up       => '1',
        Dwn      => '0',
        Limit    => Int2Slv(100000,23),
        MaxCount => MaxCount_s,
        MinCount => OPEN,
        Count    => OPEN
    );

    -- Contadores de Boost para cada jugador
    BoostTimeP1_COUNTER_inst : ENTITY WORK.BoostCounter
    GENERIC MAP (Nbits => 32)
    PORT MAP (
        Clk      => SyncClk,
        MR       => P1BoostCounterReset,
        SR       => '0',
        Ena      => '1',
        Up       => '1',
        Dwn      => '0',
        Limit    => Int2Slv(400000000, 32),
        MaxCount => P1BoostMaxCount_s,
        MinCount => OPEN,
        Count    => P1BoostLevel
    );

    BoostTimeP2_COUNTER_inst : ENTITY WORK.BoostCounter
    GENERIC MAP (Nbits => 32)
    PORT MAP (
        Clk      => SyncClk,
        MR       => P2BoostCounterReset,
        SR       => '0',
        Ena      => '1',
        Up       => '1',
        Dwn      => '0',
        Limit    => Int2Slv(400000000, 32),
        MaxCount => P2BoostMaxCount_s,
        MinCount => OPEN,
        Count    => P2BoostLevel
    );

    -- Contador de posición para Paddle1 (Jugador 1)
    PadelCounterPositionsxi_inst : ENTITY WORK.CounterPositions
    PORT MAP (
        Clk      => SyncClk,
        MR       => Reset,
        SR       => '0',
        Ena      => '1',
        Up       => Real_Right,
        Dwn      => Real_Left,
        Limit    => Int2Slv(383-100,11),
        MaxCount => OPEN,
        MinCount => OPEN,
        Count    => POSITION.Paddle1.xi
    );

    -- Contador de posición para Paddle2 (Jugador 2)
    Padel2CounterPositionsxi_inst : ENTITY WORK.CounterPositions
    PORT MAP (
        Clk      => SyncClk,
        MR       => Reset,
        SR       => '0',
        Ena      => '1',
        Up       => Real_Right2,
        Dwn      => Real_Left2,
        Limit    => Int2Slv(800-516,11),
        MaxCount => OPEN,
        MinCount => OPEN,
        Count    => Paddle2_xi
    );

    -- Contador de posición para Net (Red)
    NetCounterPositionsyi_inst : ENTITY WORK.CounterPositions
    PORT MAP (
        Clk      => SyncClk,
        MR       => Reset,
        SR       => '0',
        Ena      => '1',
        Up       => '1', -- Cambiar a '1' para movimiento si es necesario
        Dwn      => '0',
        Limit    => Int2Slv(599-381,11),
        MaxCount => OPEN,
        MinCount => OPEN,
        Count    => Net_yi
    );

    -- Generador de número aleatorio
    Random_number : ENTITY WORK.RandomEvaluator
    PORT MAP (
        SyncClk => SyncClk,
        Reset   => Reset,
        OddFlag => OddFlag_s
    );

    -- Instancia del módulo BallControl
    BallControl_inst : ENTITY WORK.BallControl
    PORT MAP (
        Clk            => SyncClk,
        Reset          => Reset,
        Odd            => OddFlag_s,
        Paddle1_Pos    => POSITION.Paddle1,
        Paddle2_Pos    => POSITION.Paddle2,
        Separator1_Pos => POSITION.Separator,
        Separator2_Pos => POSITION.Separator2,
        Net_Pos        => POSITION.Net,
        P1BoostActive  => P1BoostActive,
        P2BoostActive  => P2BoostActive,
        Ball_Pos       => Ball_Pos,
        Player1Scored  => Player1Scored,
        Player2Scored  => Player2Scored,
        P1BoostUsed    => P1BoostUsed,
        P2BoostUsed    => P2BoostUsed
    );

    -- Proceso para gestionar el boost del jugador 1
    PROCESS(SyncClk, Reset)
    BEGIN
        IF Reset = '1' THEN
            P1BoostActive       <= '0';
            P1BoostCounterReset <= '0';
            Prev_P1BoostUsed    <= '0';
            Prev_BoostButtonP1  <= '0';
        ELSIF rising_edge(SyncClk) THEN
            -- Detección de flanco ascendente del botón de boost
            IF (BoostButtonP1 = '1' AND Prev_BoostButtonP1 = '0') THEN
                IF P1BoostMaxCount_s = '1' THEN
                    P1BoostActive <= '1';
                END IF;
            END IF;
            Prev_BoostButtonP1 <= BoostButtonP1;

            -- Detección de flanco ascendente de P1BoostUsed
            IF (P1BoostUsed = '1' AND Prev_P1BoostUsed = '0') THEN
                P1BoostActive       <= '0';
                P1BoostCounterReset <= '1';
            ELSE
                P1BoostCounterReset <= '0';
            END IF;
            Prev_P1BoostUsed <= P1BoostUsed;
        END IF;
    END PROCESS;

    -- Proceso para gestionar el boost del jugador 2
    PROCESS(SyncClk, Reset)
    BEGIN
        IF Reset = '1' THEN
            P2BoostActive       <= '0';
            P2BoostCounterReset <= '0';
            Prev_P2BoostUsed    <= '0';
            Prev_BoostButtonP2  <= '0';
        ELSIF rising_edge(SyncClk) THEN
            -- Detección de flanco ascendente del botón de boost
            IF (BoostButtonP2 = '1' AND Prev_BoostButtonP2 = '0') THEN
                IF P2BoostMaxCount_s = '1' THEN
                    P2BoostActive <= '1';
                END IF;
            END IF;
            Prev_BoostButtonP2 <= BoostButtonP2;

            -- Detección de flanco ascendente de P2BoostUsed
            IF (P2BoostUsed = '1' AND Prev_P2BoostUsed = '0') THEN
                P2BoostActive       <= '0';
                P2BoostCounterReset <= '1';
            ELSE
                P2BoostCounterReset <= '0';
            END IF;
            Prev_P2BoostUsed <= P2BoostUsed;
        END IF;
    END PROCESS;

    -- Posiciones fijas de los objetos
    -- Separador superior
    POSITION.Separator.xi <= "00000000000";
    POSITION.Separator.yi <= "00000111100";
    POSITION.Separator.xf <= Int2Slv(Slv2int(POSITION.Separator.xi)+800,11);
    POSITION.Separator.yf <= Int2Slv(Slv2int(POSITION.Separator.yi)+5,11);

    -- Separador inferior
    POSITION.Separator2.xi <= "00000000000";
    POSITION.Separator2.yi <= "01001001001"; -- 585
    POSITION.Separator2.xf <= Int2Slv(Slv2int(POSITION.Separator2.xi)+800,11);
    POSITION.Separator2.yf <= Int2Slv(Slv2int(POSITION.Separator2.yi)+5,11);

    -- Jugador 1
    POSITION.Score1.xi <= "00011100101";
    POSITION.Score1.yi <= "00000001010";
    POSITION.Score1.xf <= Int2Slv(Slv2int(POSITION.Score1.xi)+29,11);
    POSITION.Score1.yf <= Int2Slv(Slv2int(POSITION.Score1.yi)+39,11);

    POSITION.BackgroundBar1.xi <= "00000010111"; -- 23
    POSITION.BackgroundBar1.yi <= "00000001111";
    POSITION.BackgroundBar1.xf <= Int2Slv(Slv2int(POSITION.BackgroundBar1.xi)+186,11);
    POSITION.BackgroundBar1.yf <= Int2Slv(Slv2int(POSITION.BackgroundBar1.yi)+24,11);

    POSITION.BackgroundBlue.xi <= "00000011010"; -- 26
    POSITION.BackgroundBlue.yi <= "00000010010";
    POSITION.BackgroundBlue.xf <= Int2Slv(Slv2int(POSITION.BackgroundBlue.xi) + (Slv2int(P1BoostLevel(31 DOWNTO 24)) * 2000) / 256, 11);
    POSITION.BackgroundBlue.yf <= Int2Slv(Slv2int(POSITION.BackgroundBlue.yi)+19,11);

    POSITION.P1wins.xi <= "00100101100";
    POSITION.P1wins.yi <= "00001111000";
    POSITION.P1wins.xf <= Int2Slv(Slv2Int(POSITION.P1wins.xi) + 199, 11) WHEN (P1wins_s = '1') ELSE
                            ("00100101100");
    POSITION.P1wins.yf <= Int2Slv(Slv2Int(POSITION.P1wins.yi) + 99, 11) WHEN (P1wins_s = '1') ELSE
                            ("00001111000");

    -- Jugador 2
    POSITION.Score2.xi <= "01000011101"; -- 541
    POSITION.Score2.yi <= "00000001010";
    POSITION.Score2.xf <= Int2Slv(Slv2int(POSITION.Score2.xi)+29,11);
    POSITION.Score2.yf <= Int2Slv(Slv2int(POSITION.Score2.yi)+39,11);

    POSITION.BackgroundBar2.xi <= "01001001110"; -- 590
    POSITION.BackgroundBar2.yi <= "00000001111";
    POSITION.BackgroundBar2.xf <= Int2Slv(Slv2int(POSITION.BackgroundBar2.xi)+186,11);
    POSITION.BackgroundBar2.yf <= Int2Slv(Slv2int(POSITION.BackgroundBar2.yi)+24,11);

    POSITION.BackgroundRed.xi <= "01001010001"; -- 593
    POSITION.BackgroundRed.yi <= "00000010010";
    POSITION.BackgroundRed.xf <= Int2Slv(Slv2int(POSITION.BackgroundRed.xi) + (Slv2int(P2BoostLevel(31 DOWNTO 24)) * 2000) / 256, 11);
    POSITION.BackgroundRed.yf <= Int2Slv(Slv2int(POSITION.BackgroundRed.yi)+19,11);

    POSITION.P2wins.xi <= "00100101100"; -- 300
    POSITION.P2wins.yi <= "00001111000"; -- 120
    POSITION.P2wins.xf <= Int2Slv(Slv2Int(POSITION.P2wins.xi) + 199, 11) WHEN (P2wins_s = '1') ELSE
                            ("00100101100");
    POSITION.P2wins.yf <= Int2Slv(Slv2Int(POSITION.P2wins.yi) + 99, 11) WHEN (P2wins_s = '1') ELSE
                            ("00001111000");

    -- Net (Red) 200 x 100
    POSITION.Net.xi <= "00110000001"; -- 385
    POSITION.Net.yi <= Int2Slv(Slv2int(Net_yi)+116,11);
    POSITION.Net.xf <= Int2Slv(Slv2int(POSITION.Net.xi)+30,11);
    POSITION.Net.yf <= Int2Slv(Slv2int(POSITION.Net.yi)+250,11);

    -- Posiciones que se mueven
    -- Paddle1 (Jugador 1)
    POSITION.Paddle1.yi <= "01000101111"; -- 559
    POSITION.Paddle1.xf <= Int2Slv(Slv2int(POSITION.Paddle1.xi)+100,11);
    POSITION.Paddle1.yf <= Int2Slv(Slv2int(POSITION.Paddle1.yi)+25,11);

    -- Paddle2 (Jugador 2)
    POSITION.Paddle2.yi <= "01000101111"; -- 559
    POSITION.Paddle2.xi <= Int2Slv(Slv2int(Paddle2_xi)+416,11);
    POSITION.Paddle2.xf <= Int2Slv(Slv2int(POSITION.Paddle2.xi)+100,11);
    POSITION.Paddle2.yf <= Int2Slv(Slv2int(POSITION.Paddle2.yi)+25,11);

    -- Pelota
    POSITION.Ball.xi <= Ball_Pos.Xi;
    POSITION.Ball.yi <= Ball_Pos.Yi;
    POSITION.Ball.xf <= Int2Slv(Slv2Int(POSITION.Ball.xi) + 39, 11);
    POSITION.Ball.yf <= Int2Slv(Slv2Int(POSITION.Ball.yi) + 39, 11);

END ARCHITECTURE;
