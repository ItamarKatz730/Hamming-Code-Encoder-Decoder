# Hamming-Code-Encoder-Decoder
Hamming code Encoder And Decoder And a Test bench for them.

**1. hamming_enc.vhdl:**
   
   This file defines a VHDL module responsible for implementing a Hamming encoder. The encoder takes in 8-bit data and adds redundancy in the form of parity bits to create a 12-bit encoded codeword. It ensures data integrity by calculating parity bits based on the input data's bit positions. The module features processes that manage signal transitions for the clock, reset, and enable signals. Additionally, separate processes calculate the parity bits and construct the encoded 12-bit codeword. The output signals include a validity indicator (`valid`) that signals whether the codeword is ready and the encoded codeword itself (`codeword`).

**2. hamming_dec.vhdl:**
   
   This VHDL file defines a module for a Hamming decoder, forming the counterpart to the Hamming encoder. The decoder is designed to receive a 12-bit encoded codeword along with validity and clock signals. It performs the inverse operations of the encoder, checking and correcting errors introduced during transmission. The module includes processes that manage signal transitions for the clock, reset, and validity signals. The main process calculates the error positions by comparing the received parity bits with the calculated ones and corrects the codeword as needed. The decoded 8-bit data (`codeword`), a validity indicator (`valid_out`), and an error signal (`error`) are provided as output.

**3. hamming_tb.vhdl:**
   
   This VHDL testbench file is designed to verify the functionality and reliability of the Hamming encoder and decoder modules. It simulates the system by generating clock pulses, stimulating the encoder with different input data, and analyzing the decoder's output. The testbench features component instantiations for both the encoder and decoder modules. It manages signal transitions for the clock and reset signals and provides stimulus by simulating different scenarios for encoding and decoding. The testbench includes a clock generation process to create the clock signal, a stimulus process to simulate different input sequences, and error injection to simulate error scenarios in the received data. The goal is to thoroughly test the system's behavior under various conditions and assess its error detection and correction capabilities.

Together, these three files create a complete system that implements a Hamming encoder and decoder and ensures their functionality through simulation using the provided testbench. The encoder enhances data integrity through the addition of parity bits, and the decoder detects and corrects errors in the received data, effectively enabling reliable data transmission and reception. The testbench verifies the system's performance by simulating different scenarios and assessing its error handling capabilities.
