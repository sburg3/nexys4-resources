----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/30/2015 05:34:54 PM
-- Design Name: 
-- Module Name: UARTTransmitter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTTransmitter is
    Generic ( baud : integer := 9600);
    Port ( CLK100MHZ : in STD_LOGIC;
           UART_RXD_OUT : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           uart_tx : in STD_LOGIC;
           uart_rdy : out STD_LOGIC);
end UARTTransmitter;

architecture Behavioral of UARTTransmitter is

signal data_packet : std_logic_vector(9 downto 0) := "0000000000";
signal bit_cnt : integer range 0 to 9 := 0;
signal rxd : std_logic := '0';

constant BIT_PD : integer := integer(100000000 / baud);
signal clk_cnt : integer range 0 to BIT_PD := 0;

type statetype is (ready, transmit);
signal state : statetype := ready;

begin

UART_RXD_OUT <= rxd;

process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        case state is
            when ready =>
                uart_rdy <= '1';
                rxd <= '1';
                clk_cnt <= 0;
                bit_cnt <= 0;
                data_packet <= "0000000000";
                if uart_tx = '1' then
                    uart_rdy <= '0';
                    state <= transmit;
                    data_packet <= '1' & data_in & '0';
                end if;
            when transmit =>
                rxd <= data_packet(bit_cnt);
                if clk_cnt < BIT_PD then
                    clk_cnt <= clk_cnt + 1;
                else
                    clk_cnt <= 0;
                    if bit_cnt <= 8 then
                        bit_cnt <= bit_cnt + 1;
                    else
                        state <= ready;
                    end if;
                end if;
        end case;
    end if;
end process;
end Behavioral;
