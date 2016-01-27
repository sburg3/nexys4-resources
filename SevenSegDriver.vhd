----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/16/2015 03:47:44 PM
-- Design Name: 
-- Module Name: SevenSegDriver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Displays two 4-digit hex numbers on the seven segment display.
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegDriver is
    Port ( clock_100 : in STD_LOGIC;
           reset : in STD_LOGIC;
           leftword : in STD_LOGIC_VECTOR (15 downto 0);
           rightword : in STD_LOGIC_VECTOR (15 downto 0);
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC_VECTOR (6 downto 0));
end SevenSegDriver;

architecture Behavioral of SevenSegDriver is

signal clk_count : unsigned(13 downto 0) := "00000000000000";
signal clk_div : std_logic := '0';

type LUT is array(15 downto 0) of std_logic_vector(6 downto 0);
constant constLUT : LUT := ("0111000", "0110000", "1000010", "0110001", "1100000", 
                            "0001000", "0000100", "0000000", "0001111", "0100000", 
                            "0100100", "1001100", "0000110", "0010010", "1001111", 
                            "0000001");
signal LUTout : std_logic_vector(6 downto 0);

signal ANselect : integer range 0 to 7;

begin

process(clock_100)
begin
    if rising_edge(clock_100) then
        if reset = '1' then
            clk_count <= "00000000000000";
            clk_div <= '0';
        else
            clk_div <= std_logic(clk_count(13));
            if clk_count = 16383 then
                clk_count <= "00000000000000";
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end if;
end process;

DP <= '1';
CA <= LUTout(6);
CB <= LUTout(5);
CC <= LUTout(4);
CD <= LUTout(3);
CE <= LUTout(2);
CF <= LUTout(1);
CG <= LUTout(0);

process(clk_div, reset)
begin
    if reset = '1' then
        AN <= x"FF";
        LUTout <= "1111111";
    else
        if rising_edge(clk_div) then
            case ANselect is
                when 0 => LUTout <= constLUT(to_integer(unsigned(rightword(3 downto 0))));
                          AN <= "11111110";
                when 1 => LUTout <= constLUT(to_integer(unsigned(rightword(7 downto 4))));
                          AN <= "11111101";
                when 2 => LUTout <= constLUT(to_integer(unsigned(rightword(11 downto 8))));
                          AN <= "11111011";
                when 3 => LUTout <= constLUT(to_integer(unsigned(rightword(15 downto 12))));
                          AN <= "11110111";
                when 4 => LUTout <= constLUT(to_integer(unsigned(leftword(3 downto 0))));
                          AN <= "11101111";
                when 5 => LUTout <= constLUT(to_integer(unsigned(leftword(7 downto 4))));
                          AN <= "11011111";
                when 6 => LUTout <= constLUT(to_integer(unsigned(leftword(11 downto 8))));
                          AN <= "10111111";
                when 7 => LUTout <= constLUT(to_integer(unsigned(leftword(15 downto 12))));
                          AN <= "01111111";
            end case;
            if ANselect = 7 then
                ANselect <= 0;
            else
                ANselect <= ANselect + 1;
            end if;
        end if;
   end if;
end process;
            

end Behavioral;
