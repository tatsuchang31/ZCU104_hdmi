----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2022/01/20 16:06:21
-- Design Name: 
-- Module Name: fft_tb - Behavioral
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

library work;
use work.type_pack.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datagen_tb is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 48;
		C_M00_AXIS_START_COUNT	: integer	:= 32;

		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 48
	);
end datagen_tb;

architecture Behavioral of datagen_tb is
	component axistream_rtl_v1_0
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 48;
		C_M00_AXIS_START_COUNT	: integer	:= 32;

		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 48
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tuser	: out std_logic_vector(0 downto 0);
		m00_axis_tkeep	: out std_logic_vector(5 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tdest	: out std_logic_vector(0 downto 0);
		m00_axis_tid	: out std_logic_vector(0 downto 0);
		m00_axis_tstrb	: out std_logic_vector(5 downto 0);
		m00_axis_tready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tuser	: in std_logic_vector(0 downto 0);
		s00_axis_tkeep	: in std_logic_vector(5 downto 0);
		s00_axis_tdest	: in std_logic_vector(0 downto 0);
		s00_axis_tid	: in std_logic_vector(0 downto 0);
		s00_axis_tstrb	: in std_logic_vector(5 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic
	);
	end component;	

   signal CLK                : std_logic := '0';
   signal rst                : std_logic := '1';   	  
  type GEN_STATE is(IDLE,SEND_DATA,END_LINE);
  signal G_STATE:GEN_STATE :=IDLE;
 
  signal linePixelCounter : unsigned(20-1 downto 0) := (others=>'0');
  signal dataCounter : unsigned(20-1 downto 0) := (others=>'0');
  signal s00_axis_tready      : std_logic := '0';
  signal  s00_axis_tlast       : std_logic := '0';     
  signal  s00_axis_tvalid       : std_logic := '0';     
  signal s00_axis_tdata : std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0) := (others=>'0');
  signal s00_axis_tuser : std_logic_vector(0 downto 0) := (others=>'0');
  signal s00_axis_tdest : std_logic_vector(0 downto 0) := (others=>'0');
  signal s00_axis_tid : std_logic_vector(0 downto 0) := (others=>'0');
  signal s00_axis_tstrb : std_logic_vector(5 downto 0) := (others=>'0');  
  signal s00_axis_tkeep : std_logic_vector(5 downto 0) := (others=>'0');  
  signal m00_axis_tdata : std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others=>'0');
  signal m00_axis_tready      : std_logic := '1';
  signal m00_axis_tlast       : std_logic := '0';     
  signal m00_axis_tvalid       : std_logic := '0';     
  signal m00_axis_tuser : std_logic_vector(0 downto 0) := (others=>'0');
  signal m00_axis_tdest : std_logic_vector(0 downto 0) := (others=>'0');
  signal m00_axis_tid : std_logic_vector(0 downto 0) := (others=>'0');
  signal m00_axis_tstrb : std_logic_vector(5 downto 0) := (others=>'0');  
  signal m00_axis_tkeep : std_logic_vector(5 downto 0) := (others=>'0');
  
begin

 datagen_unit : axistream_rtl_v1_0
	port map (
	    s00_axis_aclk => CLK,
        s00_axis_aresetn   =>   rst,
        s00_axis_tready => s00_axis_tready,
        s00_axis_tdata => s00_axis_tdata,
        s00_axis_tuser => s00_axis_tuser,
        s00_axis_tlast => s00_axis_tlast,
        s00_axis_tvalid	 => s00_axis_tvalid	,
        m00_axis_tdest => m00_axis_tdest,
        m00_axis_tid => m00_axis_tid,
        m00_axis_tstrb => m00_axis_tstrb,
        m00_axis_tkeep => m00_axis_tkeep,
        s00_axis_tdest => s00_axis_tdest,
        s00_axis_tid => s00_axis_tid,
        s00_axis_tstrb => s00_axis_tstrb,   
        s00_axis_tkeep => s00_axis_tkeep,    
        m00_axis_tvalid => m00_axis_tvalid,
        m00_axis_tready => m00_axis_tready,
        m00_axis_tdata => m00_axis_tdata,
        m00_axis_tuser => m00_axis_tuser,
        m00_axis_tlast => m00_axis_tlast        
    );
    
    --s00_axis_tuser<= "1";
    
--    s00_axis_tdata <= "00000000"&"00000000"&"11111111" when(linePixelCounter >= 0 and linePixelCounter < 640) 
--          else "00000000"&"11111111"&"00000000" when(linePixelCounter >= 640 and linePixelCounter < 1280)
--          else "11111111"&"00000000"&"00000000";
    s00_axis_tdata <= "0000"&std_logic_vector(linePixelCounter)&"0000"&std_logic_vector(linePixelCounter);
          
	process(clk) begin
		if(clk'event and clk='1')then
			case G_STATE is
				when IDLE =>
				if(s00_axis_tready='1')then
                  s00_axis_tvalid <= '1';
                  G_STATE <= SEND_DATA;
                  s00_axis_tuser <="1";
                end if;

				when SEND_DATA =>
				     s00_axis_tuser <="0";
				     if(s00_axis_tready='1')then
				       linePixelCounter <= linePixelCounter+1;
				       dataCounter <= dataCounter+1;
				     end if;
				     if(linePixelCounter=H_POS-2)then
				        s00_axis_tlast <= '1';
				       G_STATE <= END_LINE;
				     end if;
				
				when END_LINE =>
					 if(s00_axis_tready='1')then
					    linePixelCounter <= (others=>'0');
					     s00_axis_tlast <= '0';
					   if(dataCounter=(H_POS)*(V_POS)-1)then
					      dataCounter<=(others=>'0');
					      G_STATE <= IDLE;
					      s00_axis_tvalid <= '0';					      
					   else
					      G_STATE <= SEND_DATA;
					      dataCounter <= dataCounter+1;
					   end if; 
					 end if;
				when others =>
			end case;
		end if;
	end process;  
	   
 process begin
    for i in 0 to 8000000 loop
        CLK<='0';
        wait for 2 ns;
        CLK <= '1';
        wait for 2 ns;
    end loop;
    CLK<='0';
    wait for 2 ns;
    CLK <= '1';
    wait;  
 end process; 
end Behavioral;
