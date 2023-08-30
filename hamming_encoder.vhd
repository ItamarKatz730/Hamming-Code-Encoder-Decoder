entity hamming_enc is
-- Hamming Encoder entity definition
-- Inputs:
--   clk: Clock signal
--   rst: Reset signal
--   en: Enable signal
--   data: 8-bit data input
-- Outputs:
--   valid: Valid signal indicating when codeword is valid
--   codeword: 12-bit encoded codeword
port (
    clk : in std_logic;
    rst : in std_logic;
    en : in std_logic;
    data : in std_logic_vector(7 downto 0);
    valid : out std_logic;
    codeword : out std_logic_vector(11 downto 0)
);
end entity hamming_enc;

architecture Arch_hamming_enc of hamming_enc is
    -- Internal signal to hold the 8-bit data
    signal data_8_sig : std_logic_vector(7 downto 0);
    -- Internal signal to hold the 12-bit encoded data
    signal data_12_sig : std_logic_vector(11 downto 0);
    -- Internal signal to hold the enable signal
    signal en_sig : std_logic;
    -- Parity bits
    signal p : std_logic_vector(3 downto 0);

begin
    -- Process to flip data based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            data_8_sig <= (others => '0');
        elsif rising_edge(clk) then
            data_8_sig <= data;
        end if;
    end process;

    -- Process to flip enable signal based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            en_sig <= '0';
        elsif rising_edge(clk) then
            en_sig <= en;
        end if;
    end process;

    -- Calculate parity bits
    p(0) <= data_8_sig(0) xor data_8_sig(1) xor data_8_sig(3) xor data_8_sig(4) xor data_8_sig(6);
    p(1) <= data_8_sig(0) xor data_8_sig(2) xor data_8_sig(3) xor data_8_sig(5) xor data_8_sig(6);
    p(2) <= data_8_sig(1) xor data_8_sig(2) xor data_8_sig(3) xor data_8_sig(7);
    p(3) <= data_8_sig(4) xor data_8_sig(5) xor data_8_sig(6) xor data_8_sig(7);

    -- Construct the 12-bit encoded data with parity bits
    data_12_sig(0) <= p(0);
    data_12_sig(1) <= p(1);
    data_12_sig(2) <= data_8_sig(0);
    data_12_sig(3) <= p(2);
    data_12_sig(4) <= data_8_sig(1);
    data_12_sig(5) <= data_8_sig(2);
    data_12_sig(6) <= data_8_sig(3);
    data_12_sig(7) <= p(3);
    data_12_sig(8) <= data_8_sig(4);
    data_12_sig(9) <= data_8_sig(5);
    data_12_sig(10) <= data_8_sig(6);
    data_12_sig(11) <= data_8_sig(7);

    -- Process to flip data_12_sig to codeword based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            codeword <= (others => '0');
        elsif rising_edge(clk) then
            codeword <= data_12_sig;
        end if;
    end process;

    -- Process to flip enable signal valid based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            valid <= '0';
        elsif rising_edge(clk) then
            valid <= en_sig;
        end if;
    end process;

end architecture Arch_hamming_enc;
