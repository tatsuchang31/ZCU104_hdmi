----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/05/25 20:56:03
-- Design Name: 
-- Module Name: datagen - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datagen is
      generic(
      h_pixel :integer:=1920;
      v_pixel :integer:=1080;
      all_pixel :integer:=1920*1080
      );
	  Port (
	    i_clk                 : in std_logic;
	    i_reset_n             : in std_logic;
	    i_data_ready        : in std_logic;
        o_sof        : out std_logic;
        o_eol        : out std_logic ;
        o_data_valid        : out std_logic ;
        o_data               : out std_logic_vector(24*2-1 downto 0)
        );
end datagen;

architecture Behavioral of datagen is

  type GEN_STATE is(IDLE,SEND_DATA,END_LINE);
  signal G_STATE:GEN_STATE :=IDLE;
 
  signal linePixelCounter : unsigned(20-1 downto 0) := (others=>'0');
  signal dataCounter : unsigned(20-1 downto 0) := (others=>'0');

begin

     o_data <= "00000000"&"00000000"&"11111111"&"00000000"&"00000000"&"11111111" when(linePixelCounter >= 0 and linePixelCounter < 640) 
          else "00000000"&"11111111"&"00000000"&"00000000"&"11111111"&"00000000" when(linePixelCounter >= 640 and linePixelCounter < 1280)
          else "11111111"&"00000000"&"00000000"&"11111111"&"00010000"&"00010000";

	process(i_clk) begin
	    if(i_reset_n='0')then
	      G_STATE <= IDLE;
		elsif(i_clk'event and i_clk='1')then
			case G_STATE is
				when IDLE =>
                  o_sof <= '1';
                  o_data_valid <= '1';
                  G_STATE <= SEND_DATA;

				when SEND_DATA =>
				     if(i_data_ready='1')then
				       o_sof <= '0';
				       linePixelCounter <= linePixelCounter+1;
				       dataCounter <= dataCounter+1;
				     end if;
				     if(linePixelCounter=h_pixel-2)then
				       o_eol <= '1';
				       G_STATE <= END_LINE;
				     end if;
				
				when END_LINE =>
					 if(i_data_ready='1')then
					   o_eol <= '0';
					   linePixelCounter <= (others=>'0');
					    dataCounter <= dataCounter+1; 
					 end if;
					 
					 if(dataCounter=all_pixel-1)then
					   G_STATE <= IDLE;
					   o_data_valid <= '0';
					   dataCounter<=(others=>'0');
					 else
					   G_STATE <= SEND_DATA;
					 end if;
				when others =>
			end case;
		end if;
	end process;  

end Behavioral;
