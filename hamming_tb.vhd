library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;

entity hamming_tb is
-- Testbench entity definition
end entity hamming_tb;

architecture test of hamming_tb is

    -- Component declarations
    component hamming_enc
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            en       : in std_logic;
            data     : in std_logic_vector (7 downto 0);
            valid    : out std_logic;
            codeword : out std_logic_vector (11 downto 0)
        );
    end component;

    component hamming_dec
        port (
            clk        : in std_logic;
            rst        : in std_logic;
            valid_in   : in std_logic;
            data_in    : in std_logic_vector (11 downto 0);
            valid_out  : out std_logic;
            codeword   : out std_logic_vector (7 downto 0);
            error      : out std_logic
        );
    end component;

    -- Test signals
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal en         : std_logic := '0';
    signal data       : std_logic_vector(7 downto 0) := "10011010";
    signal valid_enc  : std_logic;
    signal codeword   : std_logic_vector(11 downto 0);
    signal data_to_recv   : std_logic_vector(11 downto 0);
    signal valid_dec  : std_logic;
    signal data_out   : std_logic_vector(7 downto 0);
    signal error      : std_logic;
begin

    -- Instantiate the DUT
    uut_enc : hamming_enc
        port map (
            clk      => clk,
            rst      => rst,
            en       => en,
            data     => data,
            valid    => valid_enc,
            codeword => codeword
        );

    uut_dec : hamming_dec
        port map (
            clk       => clk,
            rst       => rst,
            valid_in  => valid_enc,
            data_in   => codeword,
            valid_out => valid_dec,
            codeword  => data_out,
            error     => error
        );

    -- Clock generation process
    process
    begin
        clk <= '1';
        wait for 10 ns;  -- Adjust the clock period as needed
        clk <= '0';
        wait for 10 ns;  -- Adjust the clock period as needed
    end process;

    -- Stimulus process
stim_proc : process
    variable seed1        : integer                                  := 100;
    variable seed2        : integer                                  := 105;
    variable rand_v       : real;
    variable bit_position : integer range data_to_recv'high downto 0 := 0;
begin
    rst <= '1';
    en <= '0';
    wait for 20 ns;
    rst <= '0';
    en <= '1';
    wait for 20 ns;
    en <= '0';
    wait for 20 ns;
    en <= '1';
    data <= "01011001";
    wait for 20 ns;
    en <= '0';
    wait for 100 ns;
    en <= '1';
    data <= x"3E";
    wait until rising_edge(clk);
    wait for 5 ns;
    wait until rising_edge(clk);
    data_to_recv <= codeword;
    data_to_recv(3) <= not codeword(3);
    wait until rising_edge(clk);
    wait for 10 ns;
    wait;
end process;

end architecture test;
