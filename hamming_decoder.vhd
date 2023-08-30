entity hamming_dec is
-- Hamming Decoder entity definition
-- Inputs:
--   clk: Clock signal
--   rst: Reset signal
--   valid_in: Input valid signal
--   data_in: 12-bit encoded data input
-- Outputs:
--   valid_out: Output valid signal
--   codeword: Decoded 8-bit data output
--   error: Error signal indicating a detected error
port (
    clk : in std_logic;
    rst : in std_logic;
    valid_in : in std_logic;
    data_in : in std_logic_vector(11 downto 0);
    valid_out : out std_logic;
    codeword : out std_logic_vector(7 downto 0);
    error : out std_logic
);
end entity hamming_dec;

architecture Arch_hamming_dec of hamming_dec is
    -- Internal signal to hold the received 12-bit encoded data
    signal data_12_sig : std_logic_vector(11 downto 0);
    -- Internal signal to hold the corrected 12-bit data
    signal data_12_sig_correct : std_logic_vector(11 downto 0);
    -- Internal signal to hold the valid signal
    signal valid_sig : std_logic;
    -- Parity bits
    signal p : std_logic_vector(3 downto 0);
    -- Error signal
    signal error_sig : std_logic;

begin
    -- Process to flip data_12_sig and valid_sig based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            data_12_sig <= (others => '0');
            valid_sig <= '0';
        elsif rising_edge(clk) then
            if valid_in = '1' then
                valid_sig <= valid_in;
                data_12_sig <= data_in;
            else
                valid_sig <= '0';
            end if;
        end if;
    end process;

    -- Calculate parity bits
    p(0) <= data_12_sig(2) xor data_12_sig(4) xor data_12_sig(6) xor data_12_sig(8) xor data_12_sig(10);
    p(1) <= data_12_sig(2) xor data_12_sig(5) xor data_12_sig(6) xor data_12_sig(9) xor data_12_sig(10);
    p(2) <= data_12_sig(4) xor data_12_sig(5) xor data_12_sig(6) xor data_12_sig(11);
    p(3) <= data_12_sig(8) xor data_12_sig(9) xor data_12_sig(10) xor data_12_sig(11);

    -- Process to perform error check and correction
    process (p) is
        variable error_position : integer;
    begin
        error_sig <= '0';
        error_position := 0;
        data_12_sig_correct <= data_12_sig;
        
        for i in 0 to 3 loop
            if p(i) /= data_12_sig_correct(2**i - 1) then
                error_position := error_position + 2**i;
            end if;
        end loop;
        
        if error_position /= 0 then
            if error_position > 12 then
                error_sig <= '1';
            else
                data_12_sig_correct(error_position - 1) <= not data_12_sig_correct(error_position - 1);
                error_sig <= '0';
            end if;
        end if;
    end process;

    -- Process to flip data_12_sig_correct to codeword based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            codeword <= (others => '0');
            valid_out <= '0';
        elsif rising_edge(clk) then
            codeword(0) <= data_12_sig_correct(2);
            codeword(1) <= data_12_sig_correct(4);
            codeword(2) <= data_12_sig_correct(5);
            codeword(3) <= data_12_sig_correct(6);
            codeword(4) <= data_12_sig_correct(8);
            codeword(5) <= data_12_sig_correct(9);
            codeword(6) <= data_12_sig_correct(10);
            codeword(7) <= data_12_sig_correct(11);
            valid_out <= valid_sig;
        end if;
    end process;

    -- Process to flip error signal based on clock and reset
    process (clk, rst) is
    begin
        if rst = '1' then
            error <= '0';
        elsif rising_edge(clk) then
            error <= error_sig;
        end if;
    end process;

end architecture Arch_hamming_dec;
