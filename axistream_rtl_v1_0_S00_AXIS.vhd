library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.type_pack.all;

entity axistream_rtl_v1_0_S00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 48
	);
		port (
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TUSER	: in std_logic_vector(0 downto 0);
		S_AXIS_TKEEP	: in std_logic_vector(5 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic;
		S_AXIS_TDEST    : in std_logic_vector(0 downto 0);
		S_AXIS_TID     : in std_logic_vector(0 downto 0);
		S_AXIS_TSTRB     : in std_logic_vector(5 downto 0);
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TUSER	: out std_logic_vector(0 downto 0);
		M_AXIS_TKEEP	: out std_logic_vector(5 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic;
		M_AXIS_TDEST    : out std_logic_vector(0 downto 0);
		M_AXIS_TID     : out std_logic_vector(0 downto 0);
		M_AXIS_TSTRB     : out std_logic_vector(5 downto 0)
		);
end axistream_rtl_v1_0_S00_AXIS;

architecture arch_imp of axistream_rtl_v1_0_S00_AXIS is

    component BRAM is
    Port (
        --rsta                 : in std_logic;          
        clka                 : in std_logic;                       
        dina           : in std_logic_vector(RAM_DATALENGTH-1 downto 0);   
        douta              : out std_logic_vector(RAM_DATALENGTH-1 downto 0);
        addra          : in std_logic_vector(RAM_ADDRESSBIT-1 downto 0);
        wea            : in std_logic_vector(0 downto 0);   
        clkb                 : in std_logic;                       
        dinb           : in std_logic_vector(RAM_DATALENGTH-1 downto 0);   
        doutb              : out std_logic_vector(RAM_DATALENGTH-1 downto 0);
        addrb          : in std_logic_vector(RAM_ADDRESSBIT-1 downto 0);
        web            : in std_logic_vector(0 downto 0)
        );
    end component;

     component ila_0
    Port ( CLK : in  STD_LOGIC;
         probe0 : in STD_LOGIC_VECTOR (11 downto 0);
         probe1 : in STD_LOGIC_VECTOR (11 downto 0);
         probe2 : in STD_LOGIC_VECTOR (0 downto 0);
         probe3 : in STD_LOGIC_VECTOR (13 downto 0);
         probe4 : in STD_LOGIC_VECTOR (0 downto 0);
         probe5 : in STD_LOGIC_VECTOR (0 downto 0);
         probe6 : in STD_LOGIC_VECTOR (0 downto 0);
         probe7 : in STD_LOGIC_VECTOR (0 downto 0);
         probe8 : in STD_LOGIC_VECTOR (0 downto 0);
         probe9 : in STD_LOGIC_VECTOR (0 downto 0);
         probe10 : in STD_LOGIC_VECTOR (0 downto 0);
         probe11 : in STD_LOGIC_VECTOR (0 downto 0);
         probe12 : in STD_LOGIC_VECTOR (0 downto 0);
         probe13 : in STD_LOGIC_VECTOR (20 downto 0)
        );
   end component;
	
    --BRAM
    signal inputRAM_A : std_logic_vector(RAM_DATALENGTH-1 downto 0) := (others=>'0');
    signal inputRAM_B : std_logic_vector(RAM_DATALENGTH-1 downto 0) := (others=>'0');
    signal outputRAM_A : std_logic_vector(RAM_DATALENGTH-1 downto 0) := (others=>'0');
    signal outputRAM_B : std_logic_vector(RAM_DATALENGTH-1 downto 0) := (others=>'0');
    signal addressRAM_A : std_logic_vector(RAM_ADDRESSBIT-1 downto 0) := (others=>'0');
    signal addressRAM_B : std_logic_vector(RAM_ADDRESSBIT-1 downto 0) := (others=>'0');
    signal address_A : unsigned(RAM_ADDRESSBIT-1 downto 0) := (others=>'0');
    signal RW_A : std_logic_vector(0 downto 0) := (others=>'0');
    signal RW_B : std_logic_vector(0 downto 0) := (others=>'0');
    
    --座標カウント
    type RAM_STATE is(IDLE, DATA_IN, DATA_OUT);
    signal RAM_Q: RAM_STATE:= IDLE; 
    signal count_x : unsigned(12-1 downto 0) := (others=>'0');
    signal count_y : unsigned(12-1 downto 0) := (others=>'0');
    signal wren : std_logic:='0';
    --flip
    signal D_flip : unsigned(1 downto 0) := (others=>'0');
    signal add_en : std_logic:='0';
    signal m_valid : std_logic:='0';
    signal m_last : std_logic:='0';
    signal counter : unsigned(20 downto 0) := (others => '0');  
    
signal probe0 : std_logic_vector(11 downto 0) := (others => '0');
signal probe1 : std_logic_vector(11 downto 0) := (others => '0');
signal probe2 : std_logic_vector(0 downto 0) := (others => '0');
signal probe3 : std_logic_vector(13 downto 0) := (others => '0');
signal probe4 : std_logic_vector(0 downto 0) := (others => '0');
signal probe5 : std_logic_vector(0 downto 0) := (others => '0');
signal probe6 : std_logic_vector(0 downto 0) := (others => '0');
signal probe7 : std_logic_vector(0 downto 0) := (others => '0');
signal probe8 : std_logic_vector(0 downto 0) := (others => '0');
signal probe9 : std_logic_vector(0 downto 0) := (others => '0');    
signal probe10 : std_logic_vector(0 downto 0) := (others => '0');  
signal probe11 : std_logic_vector(0 downto 0) := (others => '0');    
signal probe12 : std_logic_vector(0 downto 0) := (others => '0');  
signal probe13 :std_logic_vector(20 downto 0) := (others => '0');  

begin
	-- I/O Connections assignments
   ram_unit : BRAM
	port map (
	    clka      => S_AXIS_ACLK,
		dina  		=> inputRAM_A,
		addra       => addressRAM_A,
		douta     	=> outputRAM_A,
		wea     =>  RW_A,
	    clkb		    => S_AXIS_ACLK,
		dinb  		=> inputRAM_B,
		addrb       => addressRAM_B,
		doutb     	=> outputRAM_B,
		web     => RW_B
     );
     
   ila : ila_0 PORT MAP(
    clk => S_AXIS_ACLK,
    probe0 => probe0,
    probe1 => probe1,
    probe2 => probe2,
    probe3 => probe3,
    probe4 => probe4,
    probe5 => probe5,
    probe6 => probe6,
    probe7 => probe7,
    probe8 => probe8,
    probe9 => probe9,
    probe10 => probe10,
    probe11 => probe11,
    probe12 => probe12,
    probe13 => probe13          
   );
   probe0 <= std_logic_vector(count_x);
   probe1 <= std_logic_vector(count_y);
   probe2 <= "1" when(RAM_Q=DATA_IN) else "0";
   probe3 <= std_logic_vector(address_A);
   probe4 <="1" when(count_x>=1792/2 and count_x<2048/2 and count_y>=952/2 and count_y<1208/2 and S_AXIS_TVALID = '1' and RAM_Q=DATA_IN) else "0";
   probe5 <= "1" when(S_AXIS_TVALID='1') else "0";
   probe6 <= "1" when(S_AXIS_TUSER="1") else "0";
   probe7 <= "1" when(S_AXIS_TLAST='1') else "0";
   probe8<= "1" when(M_AXIS_TREADY='1') else "0";
   probe9<=  "1" when(RAM_Q=DATA_OUT and M_AXIS_TREADY='1' and m_valid = '1') else "0";
   probe10<= "1" when(count_x=H_POS-1 and RAM_Q=DATA_OUT) else "0";
   probe11<= "1" when(count_y=0 and count_x=0 and RAM_Q=DATA_OUT) else "0";
   probe12 <= "1" when(RAM_Q=DATA_OUT) else "0";
   probe13  <= std_logic_vector(counter);
   
	--readyが立っていたら、いつでもウェルカムよって感じ
    S_AXIS_TREADY <= '1' when (RAM_Q = DATA_IN or RAM_Q = IDLE) else '0';
	
	-- Add user logic here
	--input
	--RAM
	RW_A <= "1" when(count_x>=1792/2 and count_x<2048/2 and count_y>=952/2 and count_y<1208/2 and S_AXIS_TVALID = '1' and RAM_Q=DATA_IN) else "0";
	wren <= '1' when(count_x>=1792/2 and count_x<2048/2 and count_y>=952/2 and count_y<1208/2 and S_AXIS_TVALID = '1' and RAM_Q=DATA_IN) else '0';
	addressRAM_A <= std_logic_vector(address_A);
	inputRAM_A <= S_AXIS_TDATA(47 downto 0);
	
	--output
	process(S_AXIS_ACLK) begin
	  if(rising_edge (S_AXIS_ACLK))then
	     if(S_AXIS_ARESETN = '0') then
	       M_AXIS_TVALID <= '0';
	       m_valid <=  '0';
	     else
             if(RAM_Q=DATA_OUT and M_AXIS_TREADY='1')then
               M_AXIS_TVALID <= '1';
               m_valid <=  '1';
             else
               M_AXIS_TVALID <= '0';
                m_valid <=  '0';
             end if;
         end if;
	  end if;
    end process;
	--M_AXIS_TVALID <= '1'  when(RAM_Q=DATA_OUT and M_AXIS_TREADY='1') else '0';
	--m_valid <= '1' when(RAM_Q=DATA_OUT and M_AXIS_TREADY='1') else '0';
	M_AXIS_TLAST <= '1' when(count_x=H_POS-1 and RAM_Q=DATA_OUT) else '0';
	m_last <=  '1' when(count_x=H_POS-1 and RAM_Q=DATA_OUT) else '0';
	M_AXIS_TUSER <= "1" when(count_y=0 and count_x=0 and RAM_Q=DATA_OUT) else "0";
	M_AXIS_TDATA <= outputRAM_A when(count_x>=1792/2 and count_x<2048/2 and count_y>=952/2 and count_y<1208/2 and RAM_Q=DATA_OUT)
	                else (others=>'1');
	M_AXIS_TKEEP <= "111111";
	M_AXIS_TDEST <="0";
	M_AXIS_TID <="0";
	M_AXIS_TSTRB <="000000";

--    M_AXIS_TVALID <= S_AXIS_TVALID;
--	M_AXIS_TLAST <= S_AXIS_TLAST;
--	M_AXIS_TUSER <= S_AXIS_TUSER;
--	M_AXIS_TDATA <= S_AXIS_TDATA;
--	M_AXIS_TKEEP <= S_AXIS_TKEEP ;
--	M_AXIS_TDEST <= S_AXIS_TDEST;
--	M_AXIS_TID <= S_AXIS_TID;
--	M_AXIS_TSTRB <= S_AXIS_TSTRB;
--	S_AXIS_TREADY <= M_AXIS_TREADY;
	
	
	--ram address
	process(S_AXIS_ACLK)
	begin
	  if (rising_edge (S_AXIS_ACLK)) then
	    if(S_AXIS_ARESETN = '0') then
	      -- Synchronous reset (active low)
	      address_A <= (others=>'0');
	    else
	      if(RAM_Q=IDLE)then
	        address_A <= (others=>'0');
	      elsif(RAM_Q=DATA_IN)then
	        if(count_x=H_POS-1 and count_y=V_POS-1)then
	           address_A <= (others=>'0');
	        elsif(wren='1')then
	          address_A <= address_A + 1;
	        end if;
	      elsif(RAM_Q=DATA_OUT)then
	        if(count_x=H_POS-1 and count_y=V_POS-1 and M_AXIS_TREADY='1' and m_valid = '1')then
	          address_A <= (others=>'0');
	        elsif(count_x>=1792/2-2 and count_x<2048/2-2 and count_y>=952/2 and count_y<1208/2 and M_AXIS_TREADY='1' and m_valid = '1')then  --output delay(x,-2)
	           address_A <= address_A + 1;
	        end if;
	      end if;
	    end if;
	  end if;
	end process;
	
	--count up and state machine
 	process(S_AXIS_ACLK)
	begin
	  if (rising_edge (S_AXIS_ACLK)) then
	    if(S_AXIS_ARESETN = '0') then
	      -- Synchronous reset (active low)
	       --RAM_Q  <= IDLE;
--	    elsif(S_AXIS_TUSER ="1")then
--	      RAM_Q  <= DATA_IN;
--	      count_x <= "000000000001";
--	      count_y <= "000000000000";
	    else
	      case (RAM_Q) is
	        when IDLE     => --tuser => 1 flame start
	          if (S_AXIS_TUSER ="1" and S_AXIS_TVALID = '1')then
	            RAM_Q  <= DATA_IN;
	            count_x <= count_x + 1;
	          end if;
	      
	        when DATA_IN =>
	          if(S_AXIS_TUSER ="1" and count_x/=0 and count_y/=0)then 
	            count_x <= (others=>'0');
	            count_y <= (others=>'0');	            
	          elsif(S_AXIS_TLAST='1' and count_y=V_POS-1 and count_x=H_POS-1)then
	            count_x <= (others=>'0');
	            count_y <= (others=>'0');
	            RAM_Q  <= DATA_OUT; 
	          else
	           if(S_AXIS_TVALID='1')then
	              if(count_x=H_POS-1)then
	                  count_y <= count_y + 1;
	                  count_x <= (others=>'0');
	               else
	                  count_x <= count_x + 1;
	               end if; 
	           end if;
	          end if;
	        
	        when DATA_OUT =>
               if(m_last='1' and count_y=V_POS-1 and M_AXIS_TREADY='1' and  m_valid = '1')then
                 count_x <= (others=>'0');
                 count_y <= (others=>'0');
                 RAM_Q  <= IDLE;
                 counter <= counter + 1;
               elsif(M_AXIS_TREADY='1' and m_valid = '1')then
                   if(count_x=H_POS-1)then
                     count_y <= count_y + 1;
                     count_x <= (others=>'0');
                   else
                     count_x <= count_x + 1;
                   end if; 
               end if;	          
              
	        when others    => 
	           RAM_Q <= IDLE;	        
	      end case;
	    end if;  
	  end if;
	end process;   
	-- User logic ends

end arch_imp;
