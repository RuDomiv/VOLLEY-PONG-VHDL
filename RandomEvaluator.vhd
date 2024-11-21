LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RandomEvaluator IS
    PORT (
        SyncClk    : IN  STD_LOGIC; -- Reloj de sincronización
        Reset      : IN  STD_LOGIC; -- Señal de reinicio
        OddFlag    : OUT STD_LOGIC -- Bandera para número impar
    );
END ENTITY;

ARCHITECTURE rtl OF RandomE	valuator IS
    COMPONENT GralLimCounter
        GENERIC (
            Nbits : INTEGER := 23
        );
        PORT (
            Clk       : IN  STD_LOGIC;
            MR        : IN  STD_LOGIC;
            SR        : IN  STD_LOGIC;
            Ena       : IN  STD_LOGIC;
            Up        : IN  STD_LOGIC;
            Dwn       : IN  STD_LOGIC;
            Limit     : IN  STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0);
            MinCount  : OUT STD_LOGIC;
            Count     : OUT STD_LOGIC_VECTOR(Nbits-1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL random_s : STD_LOGIC_VECTOR(22 DOWNTO 0);

BEGIN

    -- Instancia del contador general
    RANDOM_COUNTER_inst : ENTITY WORK.GralLimCounter
        GENERIC MAP (
            Nbits => 23
        )
        PORT MAP (
            Clk       => SyncClk,
            MR        => Reset,
            SR        => '0',
            Ena       => '1',
            Up        => '1',
            Dwn       => '0',
            Limit     => STD_LOGIC_VECTOR(TO_UNSIGNED(100000, 23)),
            MinCount  => OPEN,
            Count     => random_s
        );

    -- Proceso para evaluar paridad directamente desde random_s
    PROCESS(SyncClk, Reset)
    BEGIN
        IF Reset = '1' THEN
            OddFlag <= '0';
        ELSIF rising_edge(SyncClk) THEN
            IF random_s(0) = '1' THEN -- Si el bit menos significativo es 1, es impar
                OddFlag <= '1';
            ELSE -- Si el bit menos significativo es 0, es par
                OddFlag <= '0';
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;
