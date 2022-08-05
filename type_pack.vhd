library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package type_pack is

constant RAM_DATALENGTH	: INTEGER := 48;
constant RAM_ADDRESS	: INTEGER := 16384;
constant RAM_ADDRESSBIT	: INTEGER := 14;

constant H_POS	: INTEGER := 1920; --4K x size(HDMI IP sends two pixels per clock, so half size)
constant V_POS	: INTEGER := 2160; --4K y size

end package type_pack;
