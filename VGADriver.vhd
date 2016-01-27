----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/17/2015 05:32:04 PM
-- Design Name: 
-- Module Name: VGADriver - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Provides VGA signal for 1280x1024 monitor.
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

entity VGADriver is
    Port ( VGA_HS : out STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           pixel_row : out STD_LOGIC_VECTOR (10 downto 0);
           pixel_col : out STD_LOGIC_VECTOR (10 downto 0);
           enable : out STD_LOGIC;
           clk_VGA : in STD_LOGIC;
           reset : in STD_LOGIC);
end VGADriver;

architecture Behavioral of VGADriver is

--signal h_count : unsigned(10 downto 0) := (others => '0');
--signal v_count : unsigned(10 downto 0) := (others => '0');

constant H_DISP_AREA : integer := 640;
constant H_FP_END : integer := H_DISP_AREA + 16;
constant H_SYNC_END : integer := H_FP_END + 96;
constant H_BP_END : integer := H_SYNC_END + 48;

constant V_DISP_AREA : integer := 480;
constant V_FP_END : integer := V_DISP_AREA + 10;
constant V_SYNC_END : integer := V_FP_END + 2;
constant V_BP_END : integer := V_SYNC_END + 33;

begin

process(clk_VGA)
variable h_count : integer range 0 to H_BP_END-1 := 0;
variable v_count : integer range 0 to V_BP_END-1 := 0;
begin
    if rising_edge(clk_VGA) then
        if reset = '1' then
            h_count := 0;
            v_count := 0;
            pixel_col <= (others => '0');
            pixel_row <= (others => '0');
            VGA_VS <= '1';
            VGA_HS <= '1';
            enable <= '0';
        else
            if h_count < H_BP_END-1 then
                h_count := h_count + 1;
            else
                h_count := 0;
                if v_count < V_BP_END-1 then
                    v_count := v_count + 1;
                else
                    v_count := 0;
                end if;
            end if;

            if h_count < H_DISP_AREA then
                pixel_col <= std_logic_vector(to_unsigned(h_count,11));
            end if;
            if v_count < V_DISP_AREA then
                pixel_row <= std_logic_vector(to_unsigned(v_count,11));
            end if;
            
            if h_count > H_FP_END and h_count < H_SYNC_END then
                VGA_HS <= '0';
            else
                VGA_HS <= '1';
            end if;
            
            if v_count > V_FP_END and v_count < V_SYNC_END then
                VGA_VS <= '0';
            else
                VGA_VS <= '1';
            end if;
            
            if h_count < H_DISP_AREA and v_count < V_DISP_AREA then
                enable <= '1';
            else
                enable <= '0';
            end if;
        end if;
    end if;
end process;


end Behavioral;
